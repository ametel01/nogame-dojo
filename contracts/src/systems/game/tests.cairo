use dojo::world::{IWorldDispatcherTrait, IWorldDispatcher};
use nogame::libraries::constants;
use nogame::models::game::GameSetup;
use nogame::systems::game::contract::{IGameActionsDispatcher, IGameActionsDispatcherTrait};
use nogame::utils::test_utils::{setup_world, GAME_SPEED};
use starknet::testing::set_contract_address;

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

