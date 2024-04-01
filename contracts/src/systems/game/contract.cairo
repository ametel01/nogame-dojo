#[dojo::interface]
trait IGameActions<TContractState> {
    fn spawn(speed: usize,);
}

// dojo decorator
#[dojo::contract]
mod gameactions {
    use nogame::data::types::{Position};
    use nogame::libraries::constants;
    use nogame::models::game::{GameSetup, GamePlanetCount};
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
                        game_id: constants::GAME_ID,
                        speed,
                        start_time: starknet::get_block_timestamp()
                    },
                    GamePlanetCount { game_id: constants::GAME_ID, count: 0 },
                )
            );
        }
    }
}
