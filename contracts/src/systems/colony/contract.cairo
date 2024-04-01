use nogame::data::types::{CompoundUpgradeType, Resources, ShipBuildType, DefenceBuildType,};

#[dojo::interface]
trait IColonyActions {
    fn generate_colony();
    fn process_compound_upgrade(colony_id: u8, name: CompoundUpgradeType, quantity: u8);
    fn process_ship_build(colony_id: u8, name: ShipBuildType, quantity: u32,);
    fn process_defence_build(colony_id: u8, name: DefenceBuildType, quantity: u32,);
    fn get_uncollected_resources(planet_id: u32, colony_id: u8) -> Resources;
}

#[dojo::contract]
mod colonyactions {
    use nogame::data::types::{
        Position, CompoundUpgradeType, Resources, ShipBuildType, DefenceBuildType,
    };
    use nogame::libraries::colonypositions;
    use nogame::libraries::dockyard;
    use nogame::libraries::{colony, compound, constants, defence, names::Names, shared};
    use nogame::models::{
        colony::{
            ColonyCompounds, ColonyCount, ColonyResourceTimer, ColonyPosition, ColonyDefences,
            PlanetColoniesCount, ColonyResource, ColonyShips, ColonyOwner
        },
        game::GamePlanet, planet::{PositionToPlanet, PlanetPosition}
    };
    use starknet::{get_block_timestamp, get_caller_address, ContractAddress};

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        PlanetGenerated: PlanetGenerated,
        CompoundSpent: CompoundSpent,
        FleetSpent: FleetSpent,
        DefenceSpent: DefenceSpent,
    }
    #[derive(Drop, starknet::Event)]
    struct PlanetGenerated {
        planet_id: u32,
        position: Position,
        account: ContractAddress,
    }
    #[derive(Drop, starknet::Event)]
    struct CompoundSpent {
        planet_id: u32,
        quantity: u8,
        spent: Resources
    }
    #[derive(Drop, starknet::Event)]
    struct FleetSpent {
        planet_id: u32,
        quantity: u32,
        spent: Resources
    }
    #[derive(Drop, starknet::Event)]
    struct DefenceSpent {
        planet_id: u32,
        quantity: u32,
        spent: Resources
    }

    #[abi(embed_v0)]
    impl ColonyActionsImpl of super::IColonyActions<ContractState> {
        fn generate_colony() {
            let world = self.world_dispatcher.read();
            let caller = get_caller_address();
            let planet_id = get!(world, caller, GamePlanet).planet_id;
            let exo_tech = shared::get_tech_levels(world, planet_id).exocraft;
            let max_colonies = if exo_tech % 2 == 1 {
                exo_tech / 2 + 1
            } else {
                exo_tech / 2
            };
            let current_planet_colonies = get!(world, planet_id, PlanetColoniesCount).count;
            let current_count = get!(world, constants::GAME_ID, ColonyCount).count;
            assert!(
                current_planet_colonies < max_colonies.into(),
                "Colony: max colonies {} for planet {} reached, upgrade Exocraft tech to increase max colonies",
                max_colonies,
                planet_id
            );
            let position = colonypositions::get_colony_position(current_count.into());
            let colony_id = current_planet_colonies + 1;
            let id = ((planet_id * 1000) + colony_id.into());
            set!(world, ColonyOwner { colony_planet_id: id, planet_id, });
            set!(world, PositionToPlanet { position, planet_id: id });
            set!(world, PlanetPosition { planet_id: id, position });
            set!(world, ColonyPosition { planet_id, colony_id, position });
            set!(
                world,
                ColonyResource { planet_id, colony_id, name: Names::Resource::STEEL, amount: 500 }
            );
            set!(
                world,
                ColonyResource { planet_id, colony_id, name: Names::Resource::QUARTZ, amount: 300 }
            );
            set!(
                world,
                ColonyResource { planet_id, colony_id, name: Names::Resource::TRITIUM, amount: 100 }
            );
            set!(
                world,
                ColonyResourceTimer { planet_id, colony_id, last_collection: get_block_timestamp() }
            );
            set!(world, PlanetColoniesCount { planet_id, count: colony_id });
            set!(world, ColonyCount { game_id: constants::GAME_ID, count: current_count + 1 });

            emit!(world, PlanetGenerated { planet_id, position, account: get_caller_address() });
        }

        fn process_compound_upgrade(colony_id: u8, name: CompoundUpgradeType, quantity: u8) {
            let world = self.world_dispatcher.read();
            let caller = get_caller_address();
            let planet_id = get!(world, caller, GamePlanet).planet_id;
            let cost = colony::upgrade_component(world, planet_id, colony_id, name, quantity);
            shared::update_planet_resources_spent(world, planet_id, cost);
            emit!(world, CompoundSpent { planet_id, quantity, spent: cost });
        }

        fn process_ship_build(colony_id: u8, name: ShipBuildType, quantity: u32) {
            let world = self.world_dispatcher.read();
            let caller = get_caller_address();
            let planet_id = get!(world, caller, GamePlanet).planet_id;
            let cost = colony::build_ship(world, planet_id, colony_id, name, quantity);
            shared::update_planet_resources_spent(world, planet_id, cost);
            emit!(world, FleetSpent { planet_id, quantity, spent: cost });
        }

        fn process_defence_build(colony_id: u8, name: DefenceBuildType, quantity: u32,) {
            let world = self.world_dispatcher.read();
            let caller = get_caller_address();
            let planet_id = get!(world, caller, GamePlanet).planet_id;
            let cost = colony::build_defence(world, planet_id, colony_id, name, quantity);
            shared::update_planet_resources_spent(world, planet_id, cost);
            emit!(world, DefenceSpent { planet_id, quantity, spent: cost });
        }

        fn get_uncollected_resources(planet_id: u32, colony_id: u8) -> Resources {
            let world = self.world_dispatcher.read();
            shared::calculate_production(
                world,
                planet_id,
                colony_id,
                colony::get_colony_compounds(world, planet_id, colony_id)
            )
        }
    }
}

