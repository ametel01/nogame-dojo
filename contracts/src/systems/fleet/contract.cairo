use nogame::data::types::{Fleet, Position, SimulationResult, Defences, Resources};

#[dojo::interface]
trait IFleetActions {
    fn send_fleet(
        fleet: Fleet,
        destination: Position,
        cargo: Resources,
        mission_type: u8,
        speed_modifier: u32,
        colony_id: u8,
    );
    fn attack_planet(mission_id: usize);
    fn recall_fleet(mission_id: usize);
    fn dock_fleet(mission_id: usize);
    fn collect_debris(mission_id: usize);
    fn simulate_attack(
        attacker_fleet: Fleet, defender_fleet: Fleet, defences: Defences
    ) -> SimulationResult;
}

#[dojo::contract]
mod fleetactions {
    use nogame::data::types::{
        Fleet, Position, SimulationResult, Defences, Debris, Mission, MissionCategory, Resources,
        IncomingMission, TechLevels
    };
    use nogame::libraries::{constants, fleet, shared};
    use nogame::models::{
        colony::{ColonyOwner, ColonyResourceTimer, ColonyPosition},
        fleet::{ActiveMissionLen, ActiveMission}, game::{GamePlanet, GameSetup}
    };
    use nogame::planet::models::{
        PlanetPosition, PlanetDebrisField, PositionToPlanet, LastActive, PlanetResourceTimer
    };
    use starknet::{get_caller_address, get_block_timestamp};

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        BattleReport: BattleReport,
        DebrisCollected: DebrisCollected,
    }

    #[derive(Drop, starknet::Event)]
    struct BattleReport {
        time: u64,
        attacker: u32,
        attacker_position: Position,
        attacker_initial_fleet: Fleet,
        attacker_fleet_loss: Fleet,
        defender: u32,
        defender_position: Position,
        defender_initial_fleet: Fleet,
        defender_fleet_loss: Fleet,
        initial_defences: Defences,
        defences_loss: Defences,
        loot: Resources,
        debris: Debris,
    }

    #[derive(Drop, starknet::Event)]
    struct DebrisCollected {
        planet_id: u32,
        debris_field: Position,
        collectible_amount: Debris,
        collected_amount: Debris,
    }

    #[abi(embed_v0)]
    impl FleetActionsImpl of super::IFleetActions<ContractState> {
        fn send_fleet(
            fleet: Fleet,
            destination: Position,
            cargo: Resources,
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
            fleet::check_enough_ships(world, sender_mother_planet_id, colony_id, fleet);
            // Calculate distance
            let distance = fleet::get_distance(
                get!(world, (sender_mother_planet_id, colony_id), ColonyPosition).position,
                destination
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
            let mut cost: Resources = Default::default();
            cost.tritium = consumption;
            let available = shared::get_resources_available(
                world, sender_mother_planet_id, colony_id
            );
            assert!(available.tritium >= consumption, "Fleet: not enough tritium for mission");
            shared::pay_resources(world, sender_mother_planet_id, 0, available, cost);
            // Write mission
            let mut mission: Mission = Default::default();
            mission.time_start = time_now;
            mission.origin = origin_id;
            mission.destination = get!(world, destination, PositionToPlanet).planet_id;
            mission.cargo = cargo;
            mission.time_arrival = time_now + travel_time;
            mission.fleet = fleet;
            mission.is_return = false;

            if mission_type == MissionCategory::DEBRIS {
                assert!(
                    !get!(world, destination_id, PlanetDebrisField).debris.is_zero(),
                    "Fleet: no debris at destination"
                );
                assert!(fleet.scraper >= 1, "Fleet: no scraper ships in fleet");
                mission.category = MissionCategory::DEBRIS;
                fleet::add_active_mission(world, sender_mother_planet_id, mission);
            } else if mission_type == MissionCategory::TRANSPORT {
                mission.category = MissionCategory::TRANSPORT;
                fleet::add_active_mission(world, sender_mother_planet_id, mission);
            } else {
                let is_inactive = time_now
                    - get!(world, sender_mother_planet_id, LastActive).time > constants::WEEK;
                if !is_inactive {
                    assert!(
                        !fleet::get_is_noob_protected(
                            world, sender_mother_planet_id, destination_id
                        ),
                        "Fleet: noob protection active between planet {} and {}",
                        sender_mother_planet_id,
                        destination_id
                    );
                }
                mission.category = MissionCategory::ATTACK;
                let id = fleet::add_active_mission(world, sender_mother_planet_id, mission);
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
                fleet::add_incoming_mission(world, target_planet, hostile_mission);
            }
            set!(world, LastActive { planet_id: sender_mother_planet_id, time: time_now });
            let cargo_capacity = fleet::get_fleet_cargo_capacity(fleet);
            assert!(
                cargo_capacity >= cargo.steel + cargo.quartz + cargo.tritium,
                "Fleet: cargo exceeds fleet capacity"
            );
            fleet::fleet_leave_planet(world, sender_mother_planet_id, colony_id, fleet, cargo);
        }

        fn attack_planet(mission_id: usize) {
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
            let (defender_fleet, defences, t2) = fleet::get_fleet_and_defences_before_battle(
                world, mission.destination
            );

            let time_since_arrived = time_now - mission.time_arrival;
            let mut attacker_fleet: Fleet = mission.fleet;

            if time_since_arrived > (2 * constants::HOUR) {
                let decay_amount = fleet::calculate_decay_loss(
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

            fleet::update_defender_fleet_levels_after_attack(world, mission.destination, f2);
            fleet::update_defences_after_attack(world, mission.destination, d);

            let loot = fleet::calculate_loot_amount(world, mission.destination, f1);
            fleet::receive_loot(world, mission.origin, loot);
            fleet::process_loot_payment(world, mission.destination, loot);
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
            fleet::fleet_return_planet(world, mission.origin, f1, Zeroable::zero());
            set!(world, ActiveMission { planet_id: origin, mission_id, mission: Zeroable::zero() });

            fleet::remove_incoming_mission(world, mission.destination, mission_id);

            let attacker_loss = fleet::calculate_ships_loss(mission.fleet, f1);
            let defender_loss = fleet::calculate_ships_loss(defender_fleet, f2);
            let defences_loss = fleet::calculate_defences_loss(defences, d);

            fleet::update_points_after_attack(
                world, mission.origin, attacker_loss, Zeroable::zero()
            );
            fleet::update_points_after_attack(
                world, mission.destination, defender_loss, defences_loss
            );
            set!(world, LastActive { planet_id: mission.origin, time: time_now });
            emit!(
                world,
                BattleReport {
                    time: time_now,
                    attacker: mission.origin,
                    attacker_position: get!(world, mission.origin, PlanetPosition).position,
                    attacker_initial_fleet: mission.fleet,
                    attacker_fleet_loss: attacker_loss,
                    defender: mission.destination,
                    defender_position: get!(world, mission.destination, PlanetPosition).position,
                    defender_initial_fleet: defender_fleet,
                    defender_fleet_loss: defender_loss,
                    initial_defences: defences,
                    defences_loss,
                    loot,
                    debris: total_debris
                }
            );
        }

        fn recall_fleet(mission_id: usize) {
            let world = self.world_dispatcher.read();
            let origin = get!(world, get_caller_address(), GamePlanet).planet_id;
            let mut mission = get!(world, (origin, mission_id), ActiveMission).mission;
            assert!(!mission.is_zero(), "Fleet: mission not found");
            fleet::fleet_return_planet(world, mission.origin, mission.fleet, mission.cargo);
            set!(world, ActiveMission { planet_id: origin, mission_id, mission: Zeroable::zero() });
            fleet::remove_incoming_mission(world, mission.destination, mission_id);
            set!(world, LastActive { planet_id: mission.origin, time: get_block_timestamp() });
        }

        fn dock_fleet(mission_id: usize) {
            let world = self.world_dispatcher.read();
            let origin = get!(world, get_caller_address(), GamePlanet).planet_id;
            let mut mission = get!(world, (origin, mission_id), ActiveMission).mission;
            assert!(!mission.is_zero(), "Fleet: mission not found");
            assert!(
                mission.category == MissionCategory::TRANSPORT, "Fleet: not a transport mission"
            );
            fleet::fleet_return_planet(world, mission.destination, mission.fleet, mission.cargo);
            set!(world, ActiveMission { planet_id: origin, mission_id, mission: Zeroable::zero() });
            set!(world, LastActive { planet_id: mission.origin, time: get_block_timestamp() });
        }

        fn collect_debris(mission_id: usize) {
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
                let decay_amount = fleet::calculate_decay_loss(
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

            let collection = Resources {
                steel: collectible_debris.steel,
                quartz: collectible_debris.quartz,
                tritium: Zeroable::zero()
            };

            // let mother_planet = mission.origin / 1000;
            let colony_id: u8 = (mission.origin % 1000).try_into().expect('collect debris fail');

            let available = shared::get_resources_available(world, mission.origin, colony_id);
            shared::receive_resources(world, mission.origin, 0, available, collection);

            fleet::fleet_return_planet(world, mission.origin, collector_fleet, Zeroable::zero());
            set!(world, ActiveMission { planet_id: origin, mission_id, mission: Zeroable::zero() });
            set!(world, LastActive { planet_id: mission.origin, time: time_now });
            emit!(
                world,
                DebrisCollected {
                    planet_id: mission.origin,
                    debris_field: get!(world, mission.destination, PlanetPosition).position,
                    collectible_amount: collectible_debris,
                    collected_amount: Debris { steel: collection.steel, quartz: collection.quartz }
                }
            );
        }

        fn simulate_attack(
            attacker_fleet: Fleet, defender_fleet: Fleet, defences: Defences
        ) -> SimulationResult {
            let techs: TechLevels = Default::default();
            let (f1, f2, d) = fleet::war(attacker_fleet, techs, defender_fleet, defences, techs);
            let attacker_loss = fleet::calculate_ships_loss(attacker_fleet, f1);
            let defender_loss = fleet::calculate_ships_loss(defender_fleet, f2);
            let defences_loss = fleet::calculate_defences_loss(defences, d);
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
}

