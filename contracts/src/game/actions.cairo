use starknet::ContractAddress;

#[dojo::interface]
trait IGameActions<TContractState> {
    fn spawn(speed: usize,);
}

// dojo decorator
#[dojo::contract]
mod gameactions {
    use nogame::data::types::{Position};
    use nogame::game::models::{GameSetup, GamePlanetCount, GamePlanet, GamePlanetOwner};
    use nogame::libraries::{{auction::{LinearVRGDA, LinearVRGDATrait}}, names, position, constants};
    use nogame::planet::actions::{IPlanetActionsDispatcher, IPlanetActionsDispatcherTrait};
    use nogame::planet::models::{
        PlanetPosition, PositionToPlanet, PlanetResource, PlanetResourceTimer
    };
    use nogame::systems::compound::contract::{
        ICompoundActionsDispatcher, ICompoundActionsDispatcherTrait
    };
    use nogame_fixed::f128::types::{Fixed, FixedTrait, ONE_u128 as ONE};
    use starknet::{
        ContractAddress, get_caller_address, get_block_timestamp, contract_address_const
    };
    use super::{IGameActionsDispatcher, IGameActionsDispatcherTrait};

    #[abi(embed_v0)]
    impl GameActionsImpl of super::IGameActions<ContractState> {
        // ContractState is defined by system decorator expansion
        fn spawn(speed: usize,) {
            let world = self.world_dispatcher.read();

            set!(
                world,
                (
                    GameSetup {
                        game_id: constants::GAME_ID, speed, start_time: get_block_timestamp()
                    },
                    GamePlanetCount { game_id: constants::GAME_ID, count: 0 },
                )
            );
        }
    }
}

#[cfg(test)]
mod tests {
    use dojo::world::{IWorldDispatcherTrait, IWorldDispatcher};
    use nogame::data::types::Position;
    use nogame::game::models::{GameSetup, GamePlanetCount};
    use nogame::libraries::{constants, names};
    use nogame::planet::actions::{IPlanetActionsDispatcher, IPlanetActionsDispatcherTrait};
    use nogame::planet::models::{
        PlanetPosition, PositionToPlanet, PlanetResource, PlanetResourceTimer
    };
    use nogame::systems::compound::contract::{
        ICompoundActionsDispatcher, ICompoundActionsDispatcherTrait
    };
    use nogame::utils::test_utils::{setup_world, OWNER, PRICE, GAME_SPEED, ACCOUNT_1};
    use starknet::testing::set_contract_address;
    use super::{IGameActionsDispatcher, IGameActionsDispatcherTrait};

    #[test]
    fn test_spawn() {
        let (world, actions) = setup_world();
        actions.game.spawn(GAME_SPEED,);

        let game_setup = get!(world, constants::GAME_ID, (GameSetup));
        assert!(
            game_setup.start_time == starknet::get_block_timestamp(),
            "test_spawn: wrong game start time"
        );
    }
}

