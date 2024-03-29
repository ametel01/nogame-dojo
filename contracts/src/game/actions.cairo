use starknet::ContractAddress;

#[starknet::interface]
trait IGameActions<TContractState> {
    fn spawn(self: @TContractState, speed: usize,);
}

// dojo decorator
#[dojo::contract]
mod gameactions {
    use starknet::{
        ContractAddress, get_caller_address, get_block_timestamp, contract_address_const
    };

    use nogame::compound::actions::{ICompoundActionsDispatcher, ICompoundActionsDispatcherTrait};
    use super::{IGameActionsDispatcher, IGameActionsDispatcherTrait};
    use nogame::planet::actions::{IPlanetActionsDispatcher, IPlanetActionsDispatcherTrait};
    use nogame::data::types::{Position};
    use nogame::game::models::{GameSetup, GamePlanetCount, GamePlanet, GamePlanetOwner};
    use nogame::planet::models::{
        PlanetPosition, PositionToPlanet, PlanetResource, PlanetResourceTimer
    };
    use nogame::libraries::{{auction::{LinearVRGDA, LinearVRGDATrait}}, names, position, constants};
    use nogame_fixed::f128::types::{Fixed, FixedTrait, ONE_u128 as ONE};

    #[abi(embed_v0)]
    impl GameActionsImpl of super::IGameActions<ContractState> {
        // ContractState is defined by system decorator expansion
        fn spawn(self: @ContractState, speed: usize,) {
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
    use starknet::testing::set_contract_address;
    use dojo::world::{IWorldDispatcherTrait, IWorldDispatcher};
    use nogame::libraries::{constants, names};
    use nogame::data::types::Position;
    use nogame::game::models::{GameSetup, GamePlanetCount};
    use nogame::planet::models::{
        PlanetPosition, PositionToPlanet, PlanetResource, PlanetResourceTimer
    };
    use nogame::utils::test_utils::{setup_world, OWNER, PRICE, GAME_SPEED, ACCOUNT_1};
    use super::{IGameActionsDispatcher, IGameActionsDispatcherTrait};
    use nogame::compound::actions::{ICompoundActionsDispatcher, ICompoundActionsDispatcherTrait};
    use nogame::planet::actions::{IPlanetActionsDispatcher, IPlanetActionsDispatcherTrait};

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

