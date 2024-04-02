#[dojo::interface]
trait IPlanetActions {
    fn generate_planet();
    fn get_uncollected_resources(planet_id: u32) -> nogame::data::types::Resources;
    fn get_last_collection_time(planet_id: u32) -> u64;
}


#[dojo::contract]
mod planetactions {
    use nogame::data::types::{Position, Resources, CompoundsLevels};
    use nogame::libraries::compound;
    use nogame::libraries::{names::Names, position, constants, shared};

    use nogame::models::{
        compound::PlanetCompounds, defence::PlanetDefences,
        game::{GameSetup, GamePlanetCount, GamePlanet, GamePlanetOwner, GameOwnerPlanet},
        planet::{PlanetPosition, PositionToPlanet, PlanetResource, PlanetResourceTimer}
    };
    use starknet::{
        ContractAddress, get_caller_address, get_block_timestamp, contract_address_const
    };
    use super::IPlanetActions;

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
        fn generate_planet() {
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

        fn get_uncollected_resources(planet_id: u32) -> Resources {
            let world = self.world_dispatcher.read();
            let compounds = shared::get_compound_levels(world, planet_id);
            shared::calculate_production(world, planet_id, 0, compounds)
        }

        fn get_last_collection_time(planet_id: u32) -> u64 {
            let world = self.world_dispatcher.read();
            get!(world, planet_id, PlanetResourceTimer).last_collection
        }
    }
}

