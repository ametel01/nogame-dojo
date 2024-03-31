use nogame::data::types::Resources;

#[starknet::interface]
trait IPlanetActions<TContractState> {
    fn generate_planet(ref self: TContractState);
    fn get_uncollected_resources(self: @TContractState, planet_id: u32) -> Resources;
    fn get_last_collection_time(self: @TContractState, planet_id: u32) -> u64;
}


#[dojo::contract]
mod planetactions {
    use starknet::{
        ContractAddress, get_caller_address, get_block_timestamp, contract_address_const
    };
    use super::IPlanetActions;

    use nogame::compound::models::PlanetCompounds;
    use nogame::compound::library as compound;
    use nogame::data::types::{Position, Resources, CompoundsLevels};
    use nogame::defence::models::PlanetDefences;
    use nogame::game::models::{
        GameSetup, GamePlanetCount, GamePlanet, GamePlanetOwner, GameOwnerPlanet
    };
    use nogame::planet::models::{
        PlanetPosition, PositionToPlanet, PlanetResource, PlanetResourceTimer
    };
    use nogame::libraries::{names::Names, position, constants, shared};

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        PlanetGenerated: PlanetGenerated,
    }

    #[derive(Drop, starknet::Event)]
    struct PlanetGenerated {
        planet_id: u32,
        position: Position,
        account: ContractAddress,
    }

    #[abi(embed_v0)]
    impl PlanetActionsImpl of IPlanetActions<ContractState> {
        fn generate_planet(ref self: ContractState) {
            // Access the world dispatcher for reading.
            let world = self.world_dispatcher.read();
            let caller = get_caller_address();
            assert!(
                get!(world, caller, GameOwnerPlanet).planet_id == 0,
                "Game Actions: You already have a planet"
            );

            let planets = get!(world, constants::GAME_ID, GamePlanetCount);

            let planet_id = planets.count + 1;
            set!(world, GamePlanet { owner: caller, planet_id });
            set!(world, GamePlanetOwner { planet_id, owner: caller });
            set!(world, GameOwnerPlanet { owner: caller, planet_id });

            let position = position::get_planet_position(planet_id);
            set!(world, PlanetPosition { planet_id, position });
            set!(world, PositionToPlanet { position, planet_id });

            set!(world, GamePlanetCount { game_id: constants::GAME_ID, count: planet_id });

            set!(world, PlanetResource { planet_id, name: Names::Resource::STEEL, amount: 500 });
            set!(world, PlanetResource { planet_id, name: Names::Resource::QUARTZ, amount: 300 });
            set!(world, PlanetResource { planet_id, name: Names::Resource::TRITIUM, amount: 100 });
            set!(world, PlanetResource { planet_id, name: Names::Resource::ENERGY, amount: 0 });

            set!(world, PlanetResourceTimer { planet_id, last_collection: get_block_timestamp() });

            emit!(world, PlanetGenerated { planet_id, position, account: caller, });
        }

        fn get_uncollected_resources(self: @ContractState, planet_id: u32) -> Resources {
            let world = self.world_dispatcher.read();
            let compounds = CompoundsLevels {
                steel: get!(world, (planet_id, Names::Compound::STEEL), PlanetCompounds).level,
                quartz: get!(world, (planet_id, Names::Compound::QUARTZ), PlanetCompounds).level,
                tritium: get!(world, (planet_id, Names::Compound::TRITIUM), PlanetCompounds).level,
                energy: get!(world, (planet_id, Names::Compound::ENERGY), PlanetCompounds).level,
                lab: get!(world, (planet_id, Names::Compound::LAB), PlanetCompounds).level,
                dockyard: get!(world, (planet_id, Names::Compound::DOCKYARD), PlanetCompounds)
                    .level,
            };
            println!("time in get_uncollected_resources: {}", get_block_timestamp());
            shared::calculate_production(world, planet_id, 0, compounds)
        }

        fn get_last_collection_time(self: @ContractState, planet_id: u32) -> u64 {
            let world = self.world_dispatcher.read();
            get!(world, planet_id, PlanetResourceTimer).last_collection
        }
    }
}

#[cfg(test)]
mod tests {
    use starknet::testing::{set_contract_address, set_block_timestamp};
    use dojo::world::{IWorldDispatcherTrait, IWorldDispatcher};

    use nogame::libraries::{constants, names::Names};
    use nogame::data::types::{Position};
    use nogame::compound::models::PlanetCompounds;
    use nogame::game::models::{GameSetup, GamePlanetCount,};
    use nogame::planet::models::{
        PlanetPosition, PositionToPlanet, PlanetResource, PlanetResourceTimer
    };
    use nogame::utils::test_utils::{
        setup_world, OWNER, GAME_SPEED, ACCOUNT_1, ACCOUNT_2, ACCOUNT_3, ACCOUNT_4, ACCOUNT_5, DAY,
        PRICE
    };
    use super::{IPlanetActionsDispatcher, IPlanetActionsDispatcherTrait};
    use nogame::game::actions::{IGameActionsDispatcher, IGameActionsDispatcherTrait};
    use debug::PrintTrait;

    #[test]
    fn test_generate_planet() {
        let (world, actions) = setup_world();
        actions.game.spawn(GAME_SPEED);

        set_contract_address(ACCOUNT_1());
        actions.planet.generate_planet();

        let planet_id = get!(world, constants::GAME_ID, (GamePlanetCount)).count;

        let position = get!(world, planet_id, (PlanetPosition)).position;
        assert!(
            position.system == 86 && position.orbit == 1,
            "test_generate_planet: wrong planet position"
        );

        let id_from_position = get!(world, position, (PositionToPlanet)).planet_id;
        assert!(id_from_position == planet_id, "test_generate_planet: wrong position to planet");

        let steel = get!(world, (planet_id, Names::Resource::STEEL), (PlanetResource)).amount;
        assert!(steel == 500, "test_generate_planet: wrong initial steel");
        let qurtz = get!(world, (planet_id, Names::Resource::QUARTZ), (PlanetResource)).amount;
        assert!(qurtz == 300, "test_generate_planet: wrong initial qurtz");
        let tritium = get!(world, (planet_id, Names::Resource::TRITIUM), (PlanetResource)).amount;
        assert!(tritium == 100, "test_generate_planet: wrong initial tritium");
        let energy = get!(world, (planet_id, Names::Resource::ENERGY), (PlanetResource)).amount;
        assert!(energy == 0, "test_generate_planet: wrong initial energy");

        let time_start = get!(world, planet_id, (PlanetResourceTimer)).last_collection;
        assert!(
            time_start == starknet::get_block_timestamp(), "test_generate_planet: wrong time start"
        );
    }

    #[test]
    fn test_get_uncollected_resources() {
        let (world, actions) = setup_world();
        actions.game.spawn(GAME_SPEED);

        set_contract_address(ACCOUNT_1());
        actions.planet.generate_planet();
        set!(world, PlanetCompounds { planet_id: 1, name: Names::Compound::STEEL, level: 10 });
        set!(world, PlanetCompounds { planet_id: 1, name: Names::Compound::QUARTZ, level: 10 });
        set!(world, PlanetCompounds { planet_id: 1, name: Names::Compound::TRITIUM, level: 10 });
        set!(world, PlanetCompounds { planet_id: 1, name: Names::Compound::ENERGY, level: 30 });

        starknet::testing::set_block_timestamp(starknet::get_block_timestamp() + DAY);
        let uncollected = actions.planet.get_uncollected_resources(1);
        println!(
            "steel: {}, quartz: {}, tritium: {}",
            uncollected.steel,
            uncollected.quartz,
            uncollected.tritium
        );

        starknet::testing::set_block_timestamp(starknet::get_block_timestamp() + DAY * 10);
        let uncollected = actions.planet.get_uncollected_resources(1);
        println!(
            "steel: {}, quartz: {}, tritium: {}",
            uncollected.steel,
            uncollected.quartz,
            uncollected.tritium
        );
    }
}
