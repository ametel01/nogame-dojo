use nogame::data::types::{
    Position, ColonyUpgradeType, ERC20s, ShipBuildType, DefenceBuildType, TechLevels,
    CompoundsLevels, Fleet, Defences
};

#[starknet::interface]
trait IColonyActions<TState> {
    fn generate_colony(ref self: TState);
    fn collect_resources(ref self: TState, colony_id: u8) -> ERC20s;
    fn process_colony_compound_upgrade(
        ref self: TState, colony_id: u8, name: ColonyUpgradeType, quantity: u8
    );
    fn process_ship_build(ref self: TState, colony_id: u8, name: ShipBuildType, quantity: u32,);
    fn process_defence_build(
        ref self: TState, colony_id: u8, name: DefenceBuildType, quantity: u32,
    );
}

#[dojo::contract]
mod colonyactions {
    use nogame::data::types::{
        Position, ColonyUpgradeType, ERC20s, ShipBuildType, DefenceBuildType, TechLevels,
        CompoundsLevels, Fleet, Defences
    };
    use nogame::colony::models::{
        ColonyCompounds, ColonyCount, ColonyResourceTimer, ColonyPosition, ColonyDefences,
        PlanetColoniesCount
    };
    use nogame::colony::positions;
    use nogame::compound::library as compound;
    use nogame::game::models::{GamePlanet, GamePlanetCount, GameSetup};
    use nogame::libraries::constants;
    use nogame::libraries::names::Names;
    use nogame::libraries::shared;
    use starknet::{get_block_timestamp, get_caller_address};
    use openzeppelin::token::erc20::interface::{IERC20CamelDispatcher, IERC20CamelDispatcherTrait};

    #[abi(embed_v0)]
    impl ColonyActionsImpl of super::IColonyActions<ContractState> {
        fn generate_colony(ref self: ContractState) {
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
                "Colony: max colonies {} reached, upgrade Exocraft tech to increase max colonies",
                max_colonies
            );
            let price: u256 = 0;
            if !price.is_zero() {
                let game_setup = get!(world, constants::GAME_ID, GameSetup);
                IERC20CamelDispatcher { contract_address: game_setup.eth_address }
                    .transferFrom(caller, game_setup.owner, price);
            }
            let position = positions::get_colony_position(current_count.into());
            let colony_id = current_planet_colonies + 1;
            let id = ((planet_id * 1000) + colony_id.into());
            set!(world, ColonyPosition { planet_id, colony_id, position });
            set!(
                world,
                ColonyResourceTimer { planet_id, colony_id, last_collection: get_block_timestamp() }
            );
            set!(world, PlanetColoniesCount { planet_id, count: colony_id });
            set!(world, ColonyCount { game_id: constants::GAME_ID, count: current_count + 1 });
            let current_number_of_planets = get!(world, constants::GAME_ID, GamePlanetCount).count;
            set!(
                world,
                GamePlanetCount {
                    game_id: constants::GAME_ID, count: current_number_of_planets + 1
                }
            );
        }

        fn collect_resources(ref self: ContractState, colony_id: u8) -> ERC20s { // ...
            Default::default()
        }

        fn process_colony_compound_upgrade(
            ref self: ContractState, colony_id: u8, name: ColonyUpgradeType, quantity: u8
        ) { // ...
        }

        fn process_ship_build(
            ref self: ContractState, colony_id: u8, name: ShipBuildType, quantity: u32
        ) { // ...
        }

        fn process_defence_build(
            ref self: ContractState, colony_id: u8, name: DefenceBuildType, quantity: u32,
        ) { // ...
        }
    }

    fn get_colony_compounds(
        self: @ContractState, planet_id: u32, colony_id: u8
    ) -> CompoundsLevels {
        let world = self.world_dispatcher.read();
        CompoundsLevels {
            steel: get!(world, (planet_id, colony_id, Names::Compound::STEEL), ColonyCompounds)
                .level,
            quartz: get!(world, (planet_id, colony_id, Names::Compound::QUARTZ), ColonyCompounds)
                .level,
            tritium: get!(world, (planet_id, colony_id, Names::Compound::TRITIUM), ColonyCompounds)
                .level,
            energy: get!(world, (planet_id, colony_id, Names::Compound::ENERGY), ColonyCompounds)
                .level,
            lab: 0,
            dockyard: get!(
                world, (planet_id, colony_id, Names::Compound::DOCKYARD), ColonyCompounds
            )
                .level,
        }
    }
}
