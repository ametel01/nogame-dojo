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
        IncomingMission, TechLevels
    };
    use nogame::colony::models::{ColonyOwner, ColonyShips, ColonyResourceTimer};
    use nogame::colony::actions::colonyactions;
    use nogame::defence::models::{PlanetDefences};
    use nogame::defence::library as defence;
    use nogame::dockyard::models::{PlanetShips};
    use nogame::dockyard::library as dockyard;
    use nogame::fleet::library as fleet;
    use nogame::libraries::{constants, names::Names};
    use nogame::game::models::{GamePlanet, GameSetup};
    use nogame::planet::models::{
        PlanetPosition, PlanetResourcesSpent, PlanetDebrisField, PositionToPlanet, LastActive,
        PlanetResourceTimer
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
            let game_speed = get!(world, constants::GAME_ID, GameSetup).speed;
            let techs = shared::get_tech_levels(world, sender_mother_planet_id);
            let speed = fleet::get_fleet_speed(fleet, techs) * game_speed;
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
                let available = shared::get_resources_available(world, sender_mother_planet_id);
                assert!(available.tritium >= consumption, "Fleet: not enough tritium for mission");
                shared::pay_resources(world, sender_mother_planet_id, available, cost);
            } else {
                let available = colonyactions::get_colony_resources(
                    world, sender_mother_planet_id, colony_id
                );
                assert!(available.tritium >= consumption, "Fleet: not enough tritium for mission");
                colonyactions::pay_resources(
                    world, sender_mother_planet_id, colony_id, available, cost
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
                        !get_is_noob_protected(world, sender_mother_planet_id, destination_id),
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

        fn attack_planet(ref self: ContractState, mission_id: usize) {
            let world = self.world_dispatcher.read();
            let caller = get_caller_address();
            let origin = get!(world, caller, GamePlanet).planet_id;
            let mut mission = get!(world, (origin, mission_id), ActiveMission).mission;
            assert!(!mission.is_zero(), "Fleet: mission not found");
            assert!(mission.category == MissionCategory::ATTACK, "Fleet: not an attack mission");
            let time_now = get_block_timestamp();
            assert!(time_now >= mission.time_arrival, "Fleet: mission not arrived yet");
            let is_colony = mission.destination > 500;
            let colony_mother_planet = if is_colony {
                get!(world, mission.destination, ColonyOwner).planet_id
            } else {
                0
            };
            let colony_id = if is_colony {
                (mission.destination - colony_mother_planet * 1000).try_into().unwrap()
            } else {
                0
            };

            let mut t1 = shared::get_tech_levels(world, origin);
            let (defender_fleet, defences, t2) = get_fleet_and_defences_before_battle(
                world, mission.destination
            );

            let time_since_arrived = time_now - mission.time_arrival;
            let mut attacker_fleet: Fleet = mission.fleet;

            if time_since_arrived > (2 * constants::HOUR) {
                let decay_amount = fleet::calculate_fleet_loss(
                    time_since_arrived - (2 * constants::HOUR)
                );
                attacker_fleet = fleet::decay_fleet(mission.fleet, decay_amount);
            }

            let (f1, f2, d) = fleet::war(attacker_fleet, t1, defender_fleet, defences, t2);

            // calculate debris and update field
            let debris1 = fleet::get_debris(mission.fleet, f1, 0);
            let debris2 = fleet::get_debris(defender_fleet, f2, defences.celestia - d.celestia);
            let total_debris = debris1 + debris2;
            let current_debries_field = get!(world, mission.destination, PlanetDebrisField).debris;
            set!(
                world,
                PlanetDebrisField {
                    planet_id: mission.destination, debris: current_debries_field + total_debris
                }
            );

            update_defender_fleet_levels_after_attack(world, mission.destination, f2);
            update_defences_after_attack(world, mission.destination, d);

            let loot = calculate_loot_amount(world, mission.destination, f1);
            receive_loot(world, mission.origin, loot);
            process_loot_payment(world, mission.destination, loot);

            if is_colony {
                set!(
                    world,
                    ColonyResourceTimer {
                        planet_id: colony_mother_planet, colony_id, last_collection: time_now
                    }
                );
            } else {
                set!(
                    world,
                    PlanetResourceTimer {
                        planet_id: mission.destination, last_collection: time_now
                    }
                );
            }
            fleet_return_planet(world, mission.origin, f1);
            set!(world, ActiveMission { planet_id: origin, mission_id, mission: Zeroable::zero() });
            // set!(
            //     world, PlanetResourcesSpent { planet_id: mission.origin, spent: Zeroable::zero() }
            // );

            remove_incoming_mission(world, mission.destination, mission_id);

            let attacker_loss = calculate_fleet_loss(mission.fleet, f1);
            let defender_loss = calculate_fleet_loss(defender_fleet, f2);
            let defences_loss = calculate_defences_loss(defences, d);

            update_points_after_attack(world, mission.origin, attacker_loss, Zeroable::zero());
            update_points_after_attack(world, mission.destination, defender_loss, defences_loss);
            set!(world, LastActive { planet_id: mission.origin, time: time_now });
        }

        fn recall_fleet(ref self: ContractState, mission_id: usize) {
            let world = self.world_dispatcher.read();
            let origin = get!(world, get_caller_address(), GamePlanet).planet_id;
            let mut mission = get!(world, (origin, mission_id), ActiveMission).mission;
            assert!(!mission.is_zero(), "Fleet: mission not found");
            fleet_return_planet(world, mission.origin, mission.fleet);
            set!(world, ActiveMission { planet_id: origin, mission_id, mission: Zeroable::zero() });
            remove_incoming_mission(world, mission.destination, mission_id);
            set!(world, LastActive { planet_id: mission.origin, time: get_block_timestamp() });
        }

        fn dock_fleet(ref self: ContractState, mission_id: usize) {
            let world = self.world_dispatcher.read();
            let origin = get!(world, get_caller_address(), GamePlanet).planet_id;
            let mut mission = get!(world, (origin, mission_id), ActiveMission).mission;
            assert!(!mission.is_zero(), "Fleet: mission not found");
            assert!(
                mission.category == MissionCategory::TRANSPORT, "Fleet: not a transport mission"
            );
            fleet_return_planet(world, mission.destination, mission.fleet);
            set!(world, ActiveMission { planet_id: origin, mission_id, mission: Zeroable::zero() });
            set!(world, LastActive { planet_id: mission.origin, time: get_block_timestamp() });
        }

        fn collect_debris(ref self: ContractState, mission_id: usize) {
            let world = self.world_dispatcher.read();
            let origin = get!(world, get_caller_address(), GamePlanet).planet_id;
            let mut mission = get!(world, (origin, mission_id), ActiveMission).mission;
            assert!(!mission.is_zero(), "Fleet: mission not found");
            assert!(mission.category == MissionCategory::DEBRIS, "Fleet: not a debris mission");

            let time_now = get_block_timestamp();
            assert!(time_now >= mission.time_arrival, "Fleet: mission not arrived yet");

            let time_since_arrived = time_now - mission.time_arrival;
            let mut collector_fleet: Fleet = mission.fleet;

            if time_since_arrived > (2 * constants::HOUR) {
                let decay_amount = fleet::calculate_fleet_loss(
                    time_since_arrived - (2 * constants::HOUR)
                );
                collector_fleet = fleet::decay_fleet(mission.fleet, decay_amount);
            }

            let debris = get!(world, mission.destination, PlanetDebrisField).debris;
            let storage = fleet::get_fleet_cargo_capacity(collector_fleet);
            let collectible_debris = fleet::get_collectible_debris(storage, debris);
            let new_debris = Debris {
                steel: debris.steel - collectible_debris.steel,
                quartz: debris.quartz - collectible_debris.quartz
            };

            set!(world, PlanetDebrisField { planet_id: mission.destination, debris: new_debris });

            let collection = ERC20s {
                steel: collectible_debris.steel,
                quartz: collectible_debris.quartz,
                tritium: Zeroable::zero()
            };

            if mission.origin > 500 {
                let mother_planet = mission.origin / 1000;
                let colony_id: u8 = (mission.origin % 1000)
                    .try_into()
                    .expect('collect debris fail');
                let available = colonyactions::get_colony_resources(
                    world, mother_planet, colony_id
                );
                colonyactions::receive_resources(
                    world, mother_planet, colony_id, available, collection
                );
            } else {
                let available = shared::get_resources_available(world, mission.origin);
                shared::receive_resources(world, mission.origin, available, collection);
            }

            fleet_return_planet(world, mission.origin, collector_fleet);
            set!(world, ActiveMission { planet_id: origin, mission_id, mission: Zeroable::zero() });
            set!(world, LastActive { planet_id: mission.origin, time: time_now });
        }

        fn simulate_attack(
            self: @ContractState, attacker_fleet: Fleet, defender_fleet: Fleet, defences: Defences
        ) -> SimulationResult {
            let techs: TechLevels = Default::default();
            let (f1, f2, d) = fleet::war(attacker_fleet, techs, defender_fleet, defences, techs);
            let attacker_loss = calculate_fleet_loss(attacker_fleet, f1);
            let defender_loss = calculate_fleet_loss(defender_fleet, f2);
            let defences_loss = calculate_defences_loss(defences, d);
            SimulationResult {
                attacker_carrier: attacker_loss.carrier,
                attacker_scraper: attacker_loss.scraper,
                attacker_sparrow: attacker_loss.sparrow,
                attacker_frigate: attacker_loss.frigate,
                attacker_armade: attacker_loss.armade,
                defender_carrier: defender_loss.carrier,
                defender_scraper: defender_loss.scraper,
                defender_sparrow: defender_loss.sparrow,
                defender_frigate: defender_loss.frigate,
                defender_armade: defender_loss.armade,
                celestia: defences_loss.celestia,
                blaster: defences_loss.blaster,
                beam: defences_loss.beam,
                astral: defences_loss.astral,
                plasma: defences_loss.plasma
            }
        }
    }

    fn update_points_after_attack(
        world: IWorldDispatcher, planet_id: u32, fleet: Fleet, defences: Defences
    ) {
        let actual_id = if planet_id > 500 {
            planet_id / 1000
        } else {
            planet_id
        };

        if fleet.is_zero() && defences.is_zero() {
            return;
        }
        let ships_cost = dockyard::get_ships_unit_cost();
        let ships_points = fleet.carrier.into()
            * (ships_cost.carrier.steel + ships_cost.carrier.quartz)
            + fleet.scraper.into() * (ships_cost.scraper.steel + ships_cost.scraper.quartz)
            + fleet.sparrow.into() * (ships_cost.sparrow.steel + ships_cost.sparrow.quartz)
            + fleet.frigate.into() * (ships_cost.frigate.steel + ships_cost.frigate.quartz)
            + fleet.armade.into() * (ships_cost.armade.steel + ships_cost.armade.quartz);

        let defences_cost = defence::get_defences_unit_cost();
        let defences_points = defences.celestia.into() * 2000
            + defences.blaster.into() * (defences_cost.blaster.steel + defences_cost.blaster.quartz)
            + defences.beam.into() * (defences_cost.beam.steel + defences_cost.beam.quartz)
            + defences.astral.into() * (defences_cost.astral.steel + defences_cost.astral.quartz)
            + defences.plasma.into() * (defences_cost.plasma.steel + defences_cost.plasma.quartz);
        let current_spent = get!(world, actual_id, PlanetResourcesSpent).spent;
        set!(
            world,
            PlanetResourcesSpent {
                planet_id: actual_id, spent: current_spent - (ships_points + defences_points)
            }
        )
    }

    fn calculate_fleet_loss(a: Fleet, b: Fleet) -> Fleet {
        Fleet {
            carrier: a.carrier - b.carrier,
            scraper: a.scraper - b.scraper,
            sparrow: a.sparrow - b.sparrow,
            frigate: a.frigate - b.frigate,
            armade: a.armade - b.armade,
        }
    }

    fn calculate_defences_loss(a: Defences, b: Defences) -> Defences {
        Defences {
            celestia: a.celestia - b.celestia,
            blaster: a.blaster - b.blaster,
            beam: a.beam - b.beam,
            astral: a.astral - b.astral,
            plasma: a.plasma - b.plasma,
        }
    }

    fn remove_incoming_mission(world: IWorldDispatcher, planet_id: u32, id_to_remove: usize) {
        let mut actual_id = planet_id;
        if planet_id > 500 {
            actual_id = planet_id / 1000;
        }
        let len = get!(world, actual_id, IncomingMissionLen).lenght;
        let mut i = 1;
        loop {
            if i > len {
                break;
            }
            let mission = get!(world, (actual_id, i), IncomingMissions).mission;
            if mission.id_at_origin == id_to_remove {
                set!(
                    world,
                    IncomingMissions {
                        planet_id: actual_id, mission_id: i, mission: Zeroable::zero()
                    }
                );
                break;
            }
            i += 1;
        }
    }

    fn fleet_return_planet(world: IWorldDispatcher, planet_id: u32, fleet: Fleet) {
        if planet_id > 500 {
            let mother_planet = planet_id / 1000;
            let colony_id: u8 = (planet_id % 1000).try_into().expect('fleet return planet fail');
            let fleet_levels = colonyactions::get_colony_ships(world, mother_planet, colony_id);
            if fleet.carrier > 0 {
                set!(
                    world,
                    ColonyShips {
                        planet_id: mother_planet,
                        colony_id,
                        name: Names::Fleet::CARRIER,
                        count: fleet_levels.carrier + fleet.carrier
                    }
                );
            }
            if fleet.scraper > 0 {
                set!(
                    world,
                    ColonyShips {
                        planet_id: mother_planet,
                        colony_id,
                        name: Names::Fleet::SCRAPER,
                        count: fleet_levels.scraper + fleet.scraper
                    }
                );
            }
            if fleet.sparrow > 0 {
                set!(
                    world,
                    ColonyShips {
                        planet_id: mother_planet,
                        colony_id,
                        name: Names::Fleet::SPARROW,
                        count: fleet_levels.sparrow + fleet.sparrow
                    }
                );
            }
            if fleet.frigate > 0 {
                set!(
                    world,
                    ColonyShips {
                        planet_id: mother_planet,
                        colony_id,
                        name: Names::Fleet::FRIGATE,
                        count: fleet_levels.frigate + fleet.frigate
                    }
                );
            }
            if fleet.armade > 0 {
                set!(
                    world,
                    ColonyShips {
                        planet_id: mother_planet,
                        colony_id,
                        name: Names::Fleet::ARMADE,
                        count: fleet_levels.armade + fleet.armade
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
                        count: fleet_levels.carrier + fleet.carrier
                    }
                );
            }
            if fleet.scraper > 0 {
                set!(
                    world,
                    PlanetShips {
                        planet_id,
                        name: Names::Fleet::SCRAPER,
                        count: fleet_levels.scraper + fleet.scraper
                    }
                );
            }
            if fleet.sparrow > 0 {
                set!(
                    world,
                    PlanetShips {
                        planet_id,
                        name: Names::Fleet::SPARROW,
                        count: fleet_levels.sparrow + fleet.sparrow
                    }
                );
            }
            if fleet.frigate > 0 {
                set!(
                    world,
                    PlanetShips {
                        planet_id,
                        name: Names::Fleet::FRIGATE,
                        count: fleet_levels.frigate + fleet.frigate
                    }
                );
            }
            if fleet.armade > 0 {
                set!(
                    world,
                    PlanetShips {
                        planet_id,
                        name: Names::Fleet::ARMADE,
                        count: fleet_levels.armade + fleet.armade
                    }
                );
            }
        }
    }


    fn receive_loot(world: IWorldDispatcher, origin: u32, loot: ERC20s) {
        if origin > 500 {
            let mother_planet = origin / 1000;
            let colony_id: u8 = (origin % 1000).try_into().expect('receive loot fail');
            let available = colonyactions::get_colony_resources(world, mother_planet, colony_id);
            colonyactions::receive_resources(world, mother_planet, colony_id, available, loot);
        } else {
            let available = shared::get_resources_available(world, origin);
            shared::receive_resources(world, origin, available, loot);
        }
    }

    fn process_loot_payment(world: IWorldDispatcher, destination_id: u32, loot: ERC20s,) {
        if destination_id > 500 {
            let mother_planet = destination_id / 1000;
            let colony_id: u8 = (destination_id % 1000).try_into().expect('process loot fail');
            let available = colonyactions::get_colony_resources(world, mother_planet, colony_id);
            colonyactions::pay_resources(world, mother_planet, colony_id, available, loot);
        } else {
            let available = shared::get_resources_available(world, destination_id);
            shared::pay_resources(world, destination_id, available, loot);
        }
    }

    fn calculate_loot_amount(
        world: IWorldDispatcher, destination_id: u32, attacker_fleet: Fleet
    ) -> ERC20s {
        let mut loot: ERC20s = Default::default();
        let mut storage = fleet::get_fleet_cargo_capacity(attacker_fleet);
        let mut available: ERC20s = Default::default();

        if destination_id > 500 {
            let mother_planet = destination_id / 1000;
            let colony_id: u8 = (destination_id % 1000).try_into().expect('calculate loot fail');
            available = colonyactions::get_colony_resources(world, mother_planet, colony_id);
            let compounds = colonyactions::get_colony_compounds(world, mother_planet, colony_id);
            colonyactions::collect(world, mother_planet, colony_id, compounds);
        } else {
            let compounds = shared::get_compound_levels(world, destination_id);
            shared::collect(world, destination_id, compounds);
            available = shared::get_resources_available(world, destination_id);
        }

        if !available.is_zero() {
            loot.steel = available.steel / 2;
            loot.quartz = available.quartz / 2;
            loot.tritium = available.tritium / 2;
        }
        fleet::load_resources(loot, storage)
    }

    fn update_defender_fleet_levels_after_attack(
        world: IWorldDispatcher, planet_id: u32, fleet: Fleet
    ) {
        if planet_id > 500 {
            let planet_id = planet_id / 1000;
            let colony_id: u8 = (planet_id % 1000).try_into().unwrap();
            set!(
                world,
                ColonyShips {
                    planet_id, colony_id, name: Names::Fleet::CARRIER, count: fleet.carrier
                }
            );
            set!(
                world,
                ColonyShips {
                    planet_id, colony_id, name: Names::Fleet::SCRAPER, count: fleet.scraper
                }
            );
            set!(
                world,
                ColonyShips {
                    planet_id, colony_id, name: Names::Fleet::SPARROW, count: fleet.sparrow
                }
            );
            set!(
                world,
                ColonyShips {
                    planet_id, colony_id, name: Names::Fleet::FRIGATE, count: fleet.frigate
                }
            );
            set!(
                world,
                ColonyShips {
                    planet_id, colony_id, name: Names::Fleet::ARMADE, count: fleet.armade
                }
            );
        } else {
            set!(
                world, PlanetShips { planet_id, name: Names::Fleet::CARRIER, count: fleet.carrier }
            );
            set!(
                world, PlanetShips { planet_id, name: Names::Fleet::SCRAPER, count: fleet.scraper }
            );
            set!(
                world, PlanetShips { planet_id, name: Names::Fleet::SPARROW, count: fleet.sparrow }
            );
            set!(
                world, PlanetShips { planet_id, name: Names::Fleet::FRIGATE, count: fleet.frigate }
            );
            set!(world, PlanetShips { planet_id, name: Names::Fleet::ARMADE, count: fleet.armade });
        }
    }

    fn update_defences_after_attack(world: IWorldDispatcher, planet_id: u32, defences: Defences) {
        set!(
            world,
            PlanetDefences { planet_id, name: Names::Defence::CELESTIA, count: defences.celestia }
        );
        set!(
            world,
            PlanetDefences { planet_id, name: Names::Defence::BLASTER, count: defences.blaster }
        );
        set!(world, PlanetDefences { planet_id, name: Names::Defence::BEAM, count: defences.beam });
        set!(
            world,
            PlanetDefences { planet_id, name: Names::Defence::ASTRAL, count: defences.astral }
        );
        set!(
            world,
            PlanetDefences { planet_id, name: Names::Defence::PLASMA, count: defences.plasma }
        );
    }

    fn get_fleet_and_defences_before_battle(
        world: IWorldDispatcher, planet_id: u32
    ) -> (Fleet, Defences, TechLevels) {
        let mut fleet: Fleet = Default::default();
        let mut defences: Defences = Default::default();
        let mut techs: TechLevels = Default::default();
        let mut celestia = 0;
        if planet_id > 500 {
            let colony_id = (planet_id % 1000).try_into().unwrap();
            let colony_mother_planet = planet_id / 1000;
            fleet = colonyactions::get_colony_ships(world, colony_mother_planet, colony_id);
            defences = colonyactions::get_colony_defences(world, colony_mother_planet, colony_id);
            techs = shared::get_tech_levels(world, colony_mother_planet);
        } else {
            fleet = shared::get_ships_levels(world, planet_id);
            defences = shared::get_defences_levels(world, planet_id);
            techs = shared::get_tech_levels(world, planet_id);
        }
        (fleet, defences, techs)
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

#[cfg(test)]
mod test {
    use starknet::testing::{set_contract_address, set_block_timestamp};
    use starknet::{get_block_timestamp};
    use dojo::world::{IWorldDispatcherTrait, IWorldDispatcher};
    use nogame::colony::actions::{IColonyActionsDispatcher, IColonyActionsDispatcherTrait};
    use nogame::colony::models::{
        ColonyOwner, ColonyPosition, ColonyCount, ColonyResourceTimer, PlanetColoniesCount,
        ColonyResource, ColonyShips, ColonyDefences, ColonyCompounds
    };
    use nogame::libraries::{constants};
    use nogame::data::types::{
        MissionCategory, Position, ShipBuildType, CompoundUpgradeType, Fleet, DefenceBuildType,
        Debris
    };
    use nogame::libraries::names::Names;
    use nogame::compound::models::{PlanetCompounds};
    use nogame::fleet::actions::{IFleetActionsDispatcher, IFleetActionsDispatcherTrait};
    use nogame::fleet::models::{ActiveMission, IncomingMission};
    use nogame::game::models::{GameSetup, GamePlanetCount};
    use nogame::planet::models::{
        PlanetPosition, PositionToPlanet, PlanetResource, PlanetDebrisField
    };
    use nogame::utils::test_utils::{
        setup_world, OWNER, GAME_SPEED, ACCOUNT_1, ACCOUNT_2, ACCOUNT_3, ACCOUNT_4, ACCOUNT_5, DAY
    };
    use nogame::game::actions::{IGameActionsDispatcher, IGameActionsDispatcherTrait};
    use nogame::planet::actions::{IPlanetActionsDispatcher, IPlanetActionsDispatcherTrait};
    use nogame::dockyard::actions::{IDockyardActionsDispatcher, IDockyardActionsDispatcherTrait};
    use nogame::tech::models::{PlanetTechs};
    use nogame::dockyard::models::{PlanetShips};
    use debug::PrintTrait;

    #[test]
    fn test_send_fleet() {
        let (world, actions) = setup_world();
        actions.game.spawn(GAME_SPEED);

        set_contract_address(ACCOUNT_1());
        actions.planet.generate_planet();
        set_contract_address(ACCOUNT_2());
        actions.planet.generate_planet();

        let p2_position = get!(world, 2, PlanetPosition).position;
        set!(world, PlanetShips { planet_id: 1, name: Names::Fleet::CARRIER, count: 10 });
        set!(world, PlanetShips { planet_id: 1, name: Names::Fleet::SCRAPER, count: 10 });
        set!(world, PlanetShips { planet_id: 1, name: Names::Fleet::SPARROW, count: 10 });
        set!(world, PlanetShips { planet_id: 1, name: Names::Fleet::FRIGATE, count: 10 });
        set!(world, PlanetShips { planet_id: 1, name: Names::Fleet::ARMADE, count: 10 });
        set!(
            world, PlanetResource { planet_id: 1, name: Names::Resource::TRITIUM, amount: 100_000 }
        );
        set!(world, PlanetTechs { planet_id: 1, name: Names::Tech::THRUST, level: 4 });
        set!(world, PlanetTechs { planet_id: 1, name: Names::Tech::SPACETIME, level: 3 });

        let mut fleet: Fleet = Default::default();
        fleet.carrier = 1;
        fleet.scraper = 2;
        fleet.sparrow = 3;
        fleet.frigate = 4;
        fleet.armade = 5;
        set_contract_address(ACCOUNT_1());
        set_block_timestamp(100);
        actions.fleet.send_fleet(fleet, p2_position, MissionCategory::ATTACK, 100, 0);

        let carrier = get!(world, (1, Names::Fleet::CARRIER), PlanetShips).count;
        assert!(carrier == 9, "Fleet: carrier not removed from planet");
        let scraper = get!(world, (1, Names::Fleet::SCRAPER), PlanetShips).count;
        assert!(scraper == 8, "Fleet: scraper not removed from planet");
        let sparrow = get!(world, (1, Names::Fleet::SPARROW), PlanetShips).count;
        assert!(sparrow == 7, "Fleet: sparrow not removed from planet");
        let frigate = get!(world, (1, Names::Fleet::FRIGATE), PlanetShips).count;
        assert!(frigate == 6, "Fleet: frigate not removed from planet");
        let armade = get!(world, (1, Names::Fleet::ARMADE), PlanetShips).count;
        assert!(armade == 5, "Fleet: armade not removed from planet");

        let mission = get!(world, (1, 1), ActiveMission).mission;
        assert!(mission.id == 1, "Fleet: mission id not set correctly");
        assert!(mission.time_start == 100, "Fleet: mission time_start not set correctly");
        assert!(mission.origin == 1, "Fleet: mission origin not set correctly");
        assert!(mission.destination == 2, "Fleet: mission destination not set correctly");
        assert!(mission.time_arrival == 20352, "Fleet: mission time_arrival not set correctly");
        assert!(mission.fleet.carrier == 1, "Fleet: mission carrier not set correctly");
        assert!(mission.fleet.scraper == 2, "Fleet: mission scraper not set correctly");
        assert!(mission.fleet.sparrow == 3, "Fleet: mission sparrow not set correctly");
        assert!(mission.fleet.frigate == 4, "Fleet: mission frigate not set correctly");
        assert!(mission.fleet.armade == 5, "Fleet: mission armade not set correctly");
        assert!(
            mission.category == MissionCategory::ATTACK, "Fleet: mission category not set correctly"
        );
    }

    #[test]
    fn test_attack_planet() {
        let (world, actions) = setup_world();
        actions.game.spawn(GAME_SPEED);

        set_contract_address(ACCOUNT_1());
        actions.planet.generate_planet();
        set_contract_address(ACCOUNT_2());
        actions.planet.generate_planet();

        let p2_position = get!(world, 2, PlanetPosition).position;
        set!(world, PlanetShips { planet_id: 1, name: Names::Fleet::CARRIER, count: 10 });
        set!(world, PlanetResource { planet_id: 1, name: Names::Resource::TRITIUM, amount: 1_000 });

        set!(world, PlanetResource { planet_id: 2, name: Names::Resource::STEEL, amount: 10_000 });
        set!(world, PlanetResource { planet_id: 2, name: Names::Resource::QUARTZ, amount: 10_000 });
        set!(world, PlanetResource { planet_id: 2, name: Names::Resource::TRITIUM, amount: 0 });

        let mut fleet: Fleet = Default::default();
        fleet.carrier = 1;
        set_contract_address(ACCOUNT_1());
        set_block_timestamp(100);
        actions.fleet.send_fleet(fleet, p2_position, MissionCategory::ATTACK, 100, 0);

        set!(world, PlanetResource { planet_id: 1, name: Names::Resource::STEEL, amount: 0 });
        set!(world, PlanetResource { planet_id: 1, name: Names::Resource::QUARTZ, amount: 0 });
        set!(world, PlanetResource { planet_id: 1, name: Names::Resource::TRITIUM, amount: 0 });
        let mission = get!(world, (1, 1), ActiveMission).mission;
        set_block_timestamp(get_block_timestamp() + mission.time_arrival + 1);
        actions.fleet.attack_planet(1);

        let steel = get!(world, (1, Names::Resource::STEEL), PlanetResource).amount;
        assert!(steel == 4_999, "Fleet: attacker steel not looted correctly");
        let quartz = get!(world, (1, Names::Resource::QUARTZ), PlanetResource).amount;
        assert!(quartz == 4_999, "Fleet: attacker quartz not looted correctly");
        let tritium = get!(world, (1, Names::Resource::TRITIUM), PlanetResource).amount;
        assert!(tritium == 0, "Fleet: attacker tritium not looted correctly");

        let steel = get!(world, (2, Names::Resource::STEEL), PlanetResource).amount;
        assert!(steel == 5_037, "Fleet: defender steel not looted correctly");
        let quartz = get!(world, (2, Names::Resource::QUARTZ), PlanetResource).amount;
        assert!(quartz == 5_037, "Fleet: defender quartz not looted correctly");
        let tritium = get!(world, (2, Names::Resource::TRITIUM), PlanetResource).amount;
        assert!(tritium == 0, "Fleet: defender tritium not looted correctly");

        let carriers = get!(world, (1, Names::Fleet::CARRIER), PlanetShips).count;
        assert!(carriers == 10, "Fleet: attacker carrier not returned correctly");

        let mission = get!(world, (1, 1), ActiveMission).mission;
        assert!(mission.is_zero(), "Fleet: mission not removed correctly");
    }

    #[test]
    fn test_recall_fleet() {
        let (world, actions) = setup_world();
        actions.game.spawn(GAME_SPEED);

        set_contract_address(ACCOUNT_1());
        actions.planet.generate_planet();
        set_contract_address(ACCOUNT_2());
        actions.planet.generate_planet();

        let p2_position = get!(world, 2, PlanetPosition).position;
        set!(world, PlanetShips { planet_id: 1, name: Names::Fleet::CARRIER, count: 10 });
        set!(world, PlanetShips { planet_id: 1, name: Names::Fleet::SCRAPER, count: 10 });
        set!(world, PlanetShips { planet_id: 1, name: Names::Fleet::SPARROW, count: 10 });
        set!(world, PlanetShips { planet_id: 1, name: Names::Fleet::FRIGATE, count: 10 });
        set!(world, PlanetShips { planet_id: 1, name: Names::Fleet::ARMADE, count: 10 });
        set!(
            world, PlanetResource { planet_id: 1, name: Names::Resource::TRITIUM, amount: 100_000 }
        );
        set!(world, PlanetTechs { planet_id: 1, name: Names::Tech::THRUST, level: 4 });
        set!(world, PlanetTechs { planet_id: 1, name: Names::Tech::SPACETIME, level: 3 });

        let mut fleet: Fleet = Default::default();
        fleet.carrier = 1;
        fleet.scraper = 2;
        fleet.sparrow = 3;
        fleet.frigate = 4;
        fleet.armade = 5;
        set_contract_address(ACCOUNT_1());
        set_block_timestamp(100);
        actions.fleet.send_fleet(fleet, p2_position, MissionCategory::ATTACK, 100, 0);

        actions.fleet.recall_fleet(1);
        let carrier = get!(world, (1, Names::Fleet::CARRIER), PlanetShips).count;
        assert!(carrier == 10, "Fleet: carrier not returned to planet");
        let scraper = get!(world, (1, Names::Fleet::SCRAPER), PlanetShips).count;
        assert!(scraper == 10, "Fleet: scraper not returned to planet");
        let sparrow = get!(world, (1, Names::Fleet::SPARROW), PlanetShips).count;
        assert!(sparrow == 10, "Fleet: sparrow not returned to planet");
        let frigate = get!(world, (1, Names::Fleet::FRIGATE), PlanetShips).count;
        assert!(frigate == 10, "Fleet: frigate not returned to planet");
        let armade = get!(world, (1, Names::Fleet::ARMADE), PlanetShips).count;
        assert!(armade == 10, "Fleet: armade not returned to planet");

        let mission = get!(world, (1, 1), ActiveMission).mission;
        assert!(mission.is_zero(), "Fleet: mission not removed correctly");
    }

    #[test]
    fn test_dock_fleet() {
        let (world, actions) = setup_world();
        actions.game.spawn(GAME_SPEED);

        set_contract_address(ACCOUNT_1());
        actions.planet.generate_planet();
        set!(world, PlanetTechs { planet_id: 1, name: Names::Tech::EXOCRAFT, level: 1 });
        actions.colony.generate_colony();

        let colony_position = get!(world, (1, 1), ColonyPosition).position;
        set!(world, PlanetShips { planet_id: 1, name: Names::Fleet::CARRIER, count: 10 });
        set!(world, PlanetShips { planet_id: 1, name: Names::Fleet::SCRAPER, count: 10 });
        set!(world, PlanetShips { planet_id: 1, name: Names::Fleet::SPARROW, count: 10 });
        set!(world, PlanetShips { planet_id: 1, name: Names::Fleet::FRIGATE, count: 10 });
        set!(world, PlanetShips { planet_id: 1, name: Names::Fleet::ARMADE, count: 10 });
        set!(
            world, PlanetResource { planet_id: 1, name: Names::Resource::TRITIUM, amount: 100_000 }
        );
        set!(world, PlanetTechs { planet_id: 1, name: Names::Tech::THRUST, level: 4 });
        set!(world, PlanetTechs { planet_id: 1, name: Names::Tech::SPACETIME, level: 3 });

        let mut fleet: Fleet = Default::default();
        fleet.carrier = 1;
        fleet.scraper = 2;
        fleet.sparrow = 3;
        fleet.frigate = 4;
        fleet.armade = 5;
        set_contract_address(ACCOUNT_1());
        set_block_timestamp(100);
        actions.fleet.send_fleet(fleet, colony_position, MissionCategory::TRANSPORT, 100, 0);

        let mission = get!(world, (1, 1), ActiveMission).mission;
        set_block_timestamp(get_block_timestamp() + mission.time_arrival + 1);
        actions.fleet.dock_fleet(1);

        let carrier = get!(world, (1, 1, Names::Fleet::CARRIER), ColonyShips).count;
        assert!(carrier == 1, "Fleet: carrier not docked correctly");
        let scraper = get!(world, (1, 1, Names::Fleet::SCRAPER), ColonyShips).count;
        assert!(scraper == 2, "Fleet: scraper not docked correctly");
        let sparrow = get!(world, (1, 1, Names::Fleet::SPARROW), ColonyShips).count;
        assert!(sparrow == 3, "Fleet: sparrow not docked correctly");
        let frigate = get!(world, (1, 1, Names::Fleet::FRIGATE), ColonyShips).count;
        assert!(frigate == 4, "Fleet: frigate not docked correctly");
        let armade = get!(world, (1, 1, Names::Fleet::ARMADE), ColonyShips).count;
        assert!(armade == 5, "Fleet: armade not docked correctly");
    }

    #[test]
    fn test_collect_debris() {
        let (world, actions) = setup_world();
        actions.game.spawn(GAME_SPEED);

        set_contract_address(ACCOUNT_1());
        actions.planet.generate_planet();
        set_contract_address(ACCOUNT_2());
        actions.planet.generate_planet();

        let p2_position = get!(world, 2, PlanetPosition).position;
        set!(world, PlanetShips { planet_id: 1, name: Names::Fleet::SCRAPER, count: 10 });
        set!(world, PlanetResource { planet_id: 1, name: Names::Resource::TRITIUM, amount: 1_000 });

        let debris = Debris { steel: 20_000, quartz: 20_000, };
        set!(world, PlanetDebrisField { planet_id: 2, debris });

        let mut fleet: Fleet = Default::default();
        fleet.scraper = 1;
        set_contract_address(ACCOUNT_1());
        set_block_timestamp(100);
        actions.fleet.send_fleet(fleet, p2_position, MissionCategory::DEBRIS, 100, 0);

        set!(world, PlanetResource { planet_id: 1, name: Names::Resource::STEEL, amount: 0 });
        set!(world, PlanetResource { planet_id: 1, name: Names::Resource::QUARTZ, amount: 0 });
        set!(world, PlanetResource { planet_id: 1, name: Names::Resource::TRITIUM, amount: 0 });
        let mission = get!(world, (1, 1), ActiveMission).mission;
        assert!(
            mission.category == MissionCategory::DEBRIS, "Fleet: mission category not set correctly"
        );
        set_block_timestamp(get_block_timestamp() + mission.time_arrival + 1);
        actions.fleet.collect_debris(1);

        let steel = get!(world, (1, Names::Resource::STEEL), PlanetResource).amount;
        assert!(steel == 10_000, "Fleet: steel not collected correctly");
        let quartz = get!(world, (1, Names::Resource::QUARTZ), PlanetResource).amount;
        assert!(quartz == 10_000, "Fleet: quartz not collected correctly");

        let debris = get!(world, 2, PlanetDebrisField).debris;
        assert!(debris.steel == 10_000, "Fleet: debris steel not collected correctly");
        assert!(debris.quartz == 10_000, "Fleet: debris quartz not collected correctly");

        let carrier = get!(world, (1, Names::Fleet::SCRAPER), PlanetShips).count;
        assert!(carrier == 10, "Fleet: scraper not returned to planet");

        let mission = get!(world, (1, 1), ActiveMission).mission;
        assert!(mission.is_zero(), "Fleet: mission not removed correctly");
    }
}
