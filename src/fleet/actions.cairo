use nogame::data::types::{Fleet, Position, SimulationResult, Defences, Debris};

#[starknet::interface]
trait IFleetActions<TState> {
    fn send_fleet(
        ref self: TState,
        fleet: Fleet,
        destination: Position,
        mission_type: u8,
        speed_modifier: u32,
        colony_id: u8,
    );
    fn attack_planet(ref self: TState, mission_id: usize);
    fn recall_fleet(ref self: TState, mission_id: usize);
    fn dock_fleet(ref self: TState, mission_id: usize);
    fn collect_debris(ref self: TState, mission_id: usize);
    fn simulate_attack(
        self: @TState, attacker_fleet: Fleet, defender_fleet: Fleet, defences: Defences
    ) -> SimulationResult;
}

#[dojo::contract]
mod fleetactions {
    use nogame::data::types::{
        Fleet, Position, SimulationResult, Defences, Debris, Mission, MissionCategory, ERC20s,
        IncomingMission
    };
    use nogame::colony::models::{ColonyOwner, ColonyShips};
    use nogame::colony::actions::colonyactions;
    use nogame::dockyard::models::{PlanetShips};
    use nogame::fleet::library as fleet;
    use nogame::libraries::{constants, names::Names};
    use nogame::game::models::{GamePlanet};
    use nogame::planet::models::{
        PlanetPosition, PlanetResourcesSpent, PlanetDebrisField, PositionToPlanet, LastActive
    };
    use nogame::fleet::models::{
        ActiveMissionLen, ActiveMission, IncomingMissions, IncomingMissionLen
    };
    use nogame::libraries::shared;
    use starknet::{get_caller_address, get_block_timestamp};

    #[abi(embed_v0)]
    impl FleetActionsImpl of super::IFleetActions<ContractState> {
        fn send_fleet(
            ref self: ContractState,
            fleet: Fleet,
            destination: Position,
            mission_type: u8,
            speed_modifier: u32,
            colony_id: u8,
        ) {
            let world = self.world_dispatcher.read();
            let destination_id = get!(world, destination, PositionToPlanet).planet_id;
            assert(!destination_id.is_zero(), 'no planet at destination');
            let caller = get_caller_address();
            let sender_mother_planet_id = get!(world, caller, GamePlanet).planet_id;
            let origin_id = if colony_id.is_zero() {
                sender_mother_planet_id
            } else {
                (sender_mother_planet_id * 1000) + colony_id.into()
            };

            if mission_type == MissionCategory::ATTACK {
                if destination_id > 500 {
                    assert!(
                        !(get!(world, origin_id, ColonyOwner).planet_id == sender_mother_planet_id),
                        "Fleet: cannot attack own planet"
                    );
                } else {
                    assert!(
                        destination_id != sender_mother_planet_id, "Fleet: cannot attack own planet"
                    );
                }
            }
            let time_now = get_block_timestamp();

            check_enough_ships(world, origin_id, colony_id, fleet);
            // Calculate distance
            let distance = fleet::get_distance(
                get!(world, origin_id, PlanetPosition).position, destination
            );

            // Calculate time
            let techs = shared::get_tech_levels(world, sender_mother_planet_id);
            let speed = fleet::get_fleet_speed(fleet, techs);
            let travel_time = fleet::get_flight_time(speed, distance, speed_modifier);

            // Check numeber of mission
            let active_missions_len = get!(world, sender_mother_planet_id, ActiveMissionLen).lenght;
            assert!(
                active_missions_len < techs.digital.into() + 1,
                "Fleet: too many active missions, upgrade digital tech to send more"
            );

            // Pay for fuel
            let consumption = fleet::get_fuel_consumption(fleet, distance, speed_modifier);
            let mut cost: ERC20s = Default::default();
            cost.tritium = consumption;

            if colony_id.is_zero() {
                assert!(
                    shared::get_resources_available(world, sender_mother_planet_id)
                        .tritium >= consumption,
                    "Fleet: not enough tritium for mission"
                );
                let available = colonyactions::get_colony_resources(
                    world, sender_mother_planet_id, colony_id
                );
                colonyactions::pay_resources(
                    world, sender_mother_planet_id, colony_id, available, cost
                );
            } else {
                assert!(
                    colonyactions::get_colony_resources(world, sender_mother_planet_id, colony_id)
                        .tritium >= consumption,
                    "Fleet: not enough tritium for mission"
                );
            }

            // Write mission
            let mut mission: Mission = Default::default();
            mission.time_start = time_now;
            mission.origin = origin_id;
            mission.destination = get!(world, destination, PositionToPlanet).planet_id;
            mission.time_arrival = time_now + travel_time;
            mission.fleet = fleet;

            if mission_type == MissionCategory::DEBRIS {
                assert!(
                    !get!(world, destination_id, PlanetDebrisField).debris.is_zero(),
                    "Fleet: no debris at destination"
                );
                assert!(fleet.scraper >= 1, "Fleet: no scraper ships in fleet");
                mission.category = MissionCategory::DEBRIS;
                add_active_mission(world, sender_mother_planet_id, mission);
            } else if mission_type == MissionCategory::TRANSPORT {
                mission.category = MissionCategory::TRANSPORT;
                add_active_mission(world, sender_mother_planet_id, mission);
            } else {
                let is_inactive = time_now
                    - get!(world, sender_mother_planet_id, LastActive).time > constants::WEEK;
                if !is_inactive {
                    assert!(
                        get_is_noob_protected(world, sender_mother_planet_id, destination_id),
                        "Fleet: noob protection active between planet {} and {}",
                        sender_mother_planet_id,
                        destination_id
                    );
                }
                mission.category = MissionCategory::ATTACK;
                let id = add_active_mission(world, sender_mother_planet_id, mission);
                let mut hostile_mission: IncomingMission = Default::default();
                hostile_mission.origin = origin_id;
                hostile_mission.id_at_origin = id;
                hostile_mission.time_arrival = mission.time_arrival;
                hostile_mission
                    .number_of_ships = fleet::calculate_number_of_ships(fleet, Zeroable::zero());
                hostile_mission.destination = destination_id;
                let is_colony = mission.destination > 500;
                let target_planet = if is_colony {
                    get!(world, mission.destination, ColonyOwner).planet_id
                } else {
                    mission.destination
                };
                add_incoming_mission(world, target_planet, hostile_mission);
            }
            set!(world, LastActive { planet_id: sender_mother_planet_id, time: time_now });
            fleet_leave_planet(world, origin_id, fleet);
        }

        fn attack_planet(ref self: ContractState, mission_id: usize) {}

        fn recall_fleet(ref self: ContractState, mission_id: usize) {}

        fn dock_fleet(ref self: ContractState, mission_id: usize) {}

        fn collect_debris(ref self: ContractState, mission_id: usize) {}

        fn simulate_attack(
            self: @ContractState, attacker_fleet: Fleet, defender_fleet: Fleet, defences: Defences
        ) -> SimulationResult {
            Default::default()
        }
    }

    fn check_enough_ships(world: IWorldDispatcher, planet_id: u32, colony_id: u8, fleet: Fleet) {
        if colony_id == 0 {
            let ships_levels = shared::get_ships_levels(world, planet_id);
            assert!(ships_levels >= fleet, "Fleet: not enough ships for mission");
        } else {
            let ships_levels = colonyactions::get_colony_ships(world, planet_id, colony_id);
            assert!(ships_levels >= fleet, "Fleet: not enough ships for mission");
        }
    }

    fn add_active_mission(world: IWorldDispatcher, planet_id: u32, mut mission: Mission) -> usize {
        let len = get!(world, planet_id, ActiveMissionLen).lenght;
        let mut i = 1;
        loop {
            if i > len {
                mission.id = i.try_into().expect('add active mission fail');
                set!(world, ActiveMission { planet_id, mission_id: i, mission });
                set!(world, ActiveMissionLen { planet_id, lenght: i });
                break;
            }
            let read_mission = get!(world, (planet_id, i), ActiveMission).mission;
            if read_mission.is_zero() {
                mission.id = i.try_into().expect('add active mission fail');
                set!(world, ActiveMission { planet_id, mission_id: i, mission });
                break;
            }
            i += 1;
        };
        i
    }

    fn add_incoming_mission(world: IWorldDispatcher, planet_id: u32, mission: IncomingMission) {
        let len = get!(world, planet_id, IncomingMissionLen).lenght;
        let mut i = 1;
        loop {
            if i > len {
                set!(world, IncomingMissions { planet_id, mission_id: i, mission });
                set!(world, IncomingMissionLen { planet_id, lenght: i });
                break;
            }
            let read_mission = get!(world, (planet_id, i), IncomingMissions).mission;
            if read_mission.is_zero() {
                set!(world, IncomingMissions { planet_id, mission_id: i, mission });
                break;
            }
            i += 1;
        };
    }

    fn get_is_noob_protected(world: IWorldDispatcher, planet1_id: u32, planet2_id: u32) -> bool {
        let p1_points = get!(world, planet1_id, PlanetResourcesSpent).spent;
        let p2_points = get!(world, planet2_id, PlanetResourcesSpent).spent;
        if p1_points > p2_points {
            return p1_points > p2_points * 5;
        } else {
            return p2_points > p1_points * 5;
        }
    }

    fn fleet_leave_planet(world: IWorldDispatcher, planet_id: u32, fleet: Fleet) {
        if planet_id > 500 {
            let planet_id = planet_id / 1000;
            let colony_id: u8 = (planet_id % 1000).try_into().expect('fleet leave planet fail');
            let fleet_levels = colonyactions::get_colony_ships(world, planet_id, colony_id);
            if fleet.carrier > 0 {
                set!(
                    world,
                    ColonyShips {
                        planet_id,
                        colony_id,
                        name: Names::Fleet::CARRIER,
                        count: fleet_levels.carrier - fleet.carrier
                    }
                );
            }
            if fleet.scraper > 0 {
                set!(
                    world,
                    ColonyShips {
                        planet_id,
                        colony_id,
                        name: Names::Fleet::SCRAPER,
                        count: fleet_levels.scraper - fleet.scraper
                    }
                );
            }
            if fleet.sparrow > 0 {
                set!(
                    world,
                    ColonyShips {
                        planet_id,
                        colony_id,
                        name: Names::Fleet::SPARROW,
                        count: fleet_levels.sparrow - fleet.sparrow
                    }
                );
            }
            if fleet.frigate > 0 {
                set!(
                    world,
                    ColonyShips {
                        planet_id,
                        colony_id,
                        name: Names::Fleet::FRIGATE,
                        count: fleet_levels.frigate - fleet.frigate
                    }
                );
            }
            if fleet.armade > 0 {
                set!(
                    world,
                    ColonyShips {
                        planet_id,
                        colony_id,
                        name: Names::Fleet::ARMADE,
                        count: fleet_levels.armade - fleet.armade
                    }
                );
            }
        } else {
            let fleet_levels = shared::get_ships_levels(world, planet_id);
            if fleet.carrier > 0 {
                set!(
                    world,
                    PlanetShips {
                        planet_id,
                        name: Names::Fleet::CARRIER,
                        count: fleet_levels.carrier - fleet.carrier
                    }
                );
            }
            if fleet.scraper > 0 {
                set!(
                    world,
                    PlanetShips {
                        planet_id,
                        name: Names::Fleet::SCRAPER,
                        count: fleet_levels.scraper - fleet.scraper
                    }
                );
            }
            if fleet.sparrow > 0 {
                set!(
                    world,
                    PlanetShips {
                        planet_id,
                        name: Names::Fleet::SPARROW,
                        count: fleet_levels.sparrow - fleet.sparrow
                    }
                );
            }
            if fleet.frigate > 0 {
                set!(
                    world,
                    PlanetShips {
                        planet_id,
                        name: Names::Fleet::FRIGATE,
                        count: fleet_levels.frigate - fleet.frigate
                    }
                );
                if fleet.armade > 0 {
                    set!(
                        world,
                        PlanetShips {
                            planet_id,
                            name: Names::Fleet::ARMADE,
                            count: fleet_levels.armade - fleet.armade
                        }
                    );
                }
            }
        }
    }
}
