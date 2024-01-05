use starknet::{ContractAddress, contract_address_const};

use dojo::world::{IWorldDispatcherTrait, IWorldDispatcher};
use dojo::test_utils::{spawn_test_world, deploy_contract};
use nogame::models::game_models::{game_setup, game_planet, game_planet_owner, game_planet_count};
use nogame::models::game_models::{GameSetup, GamePlanet, GamePlanetOwner, GamePlanetCount};
use nogame::models::planet_models::{
    planet_position, position_to_planet, planet_resource, planet_resource_timer
};
use nogame::models::planet_models::{
    PlanetPosition, PositionToPlanet, PlanetResource, PlanetResourceTimer
};
use nogame::actions::game_actions::{actions, {IGameActionsDispatcher, IGameActionsDispatcherTrait}};
use nogame::token::erc721::erc721::ERC721NoGame;

const PRICE: u128 = 1_000_000_000;
const GAME_SPEED: usize = 1;

fn OWNER() -> ContractAddress {
    contract_address_const::<'owner'>()
}
fn ACCOUNT_1() -> ContractAddress {
    contract_address_const::<'account_1'>()
}
fn ACCOUNT_2() -> ContractAddress {
    contract_address_const::<'account_2'>()
}

fn setup_world() -> (IWorldDispatcher, IGameActionsDispatcher, ContractAddress) {
    // components
    let mut models = array![
        game_setup::TEST_CLASS_HASH,
        game_planet::TEST_CLASS_HASH,
        game_planet_owner::TEST_CLASS_HASH,
        game_planet_count::TEST_CLASS_HASH,
        planet_position::TEST_CLASS_HASH,
        position_to_planet::TEST_CLASS_HASH,
        planet_resource::TEST_CLASS_HASH,
        planet_resource_timer::TEST_CLASS_HASH
    ];

    // deploy world with models
    let world = spawn_test_world(models);

    // deploy systems contract
    let contract_address = world
        .deploy_contract('salt', actions::TEST_CLASS_HASH.try_into().unwrap());
    let actions_system = IGameActionsDispatcher { contract_address };
    let nft = deploy_nft(array!['NoGame NFT', 'NGPLANET', world.contract_address.into()]);

    (world, actions_system, nft)
}

fn deploy_nft(calldata: Array<felt252>) -> ContractAddress {
    let (address, _) = starknet::deploy_syscall(
        ERC721NoGame::TEST_CLASS_HASH.try_into().unwrap(), 0, calldata.span(), false
    )
        .unwrap();
    address
}

