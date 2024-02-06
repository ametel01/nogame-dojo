use starknet::{ContractAddress, contract_address_const};
use starknet::testing::set_contract_address;

use dojo::world::{IWorldDispatcherTrait, IWorldDispatcher};
use dojo::test_utils::{spawn_test_world, deploy_contract};

use openzeppelin::token::erc20::interface::{
    IERC20Dispatcher, IERC20DispatcherTrait, IERC20CamelDispatcher, IERC20CamelDispatcherTrait
};
use nogame::compound::models::{planet_compounds};
use nogame::compound::models::{PlanetCompounds};
use nogame::game::models::{game_setup, game_planet, game_planet_owner, game_planet_count};
use nogame::game::models::{GameSetup, GamePlanet, GamePlanetOwner, GamePlanetCount};
use nogame::planet::models::{
    planet_position, position_to_planet, planet_resource, planet_resource_timer
};
use nogame::planet::models::{PlanetPosition, PositionToPlanet, PlanetResource, PlanetResourceTimer};
use nogame::compound::actions::{
    compoundactions, {ICompoundActionsDispatcher, ICompoundActionsDispatcherTrait}
};
use nogame::tech::models::{PlanetTechs, planet_techs};
use nogame::tech::actions::{techactions, {ITechActionsDispatcher, ITechActionsDispatcherTrait}};
use nogame::game::actions::{gameactions, {IGameActionsDispatcher, IGameActionsDispatcherTrait}};
use nogame::planet::actions::{
    planetactions, {IPlanetActionsDispatcher, IPlanetActionsDispatcherTrait}
};
use nogame::dockyard::models::{PlanetShips, planet_ships};
use nogame::dockyard::actions::{
    dockyardactions, {IDockyardActionsDispatcher, IDockyardActionsDispatcherTrait}
};
use nogame::defence::actions::{
    defenceactions, {IDefenceActionsDispatcher, IDefenceActionsDispatcherTrait}
};
use nogame::defence::models::{PlanetDefences, planet_defences};
use nogame::token::erc721::erc721::ERC721NoGame;
use nogame::token::erc20::erc20::ERC20;

const PRICE: u128 = 1_000_000_000_000_000_000;
const GAME_SPEED: usize = 1;
const E18: u256 = 1_000_000_000_000_000_000;
const ETH_SUPPLY: felt252 = 1_000_000_000_000_000_000_000_000;
const DAY: u64 = 86400;

fn OWNER() -> ContractAddress {
    contract_address_const::<'owner'>()
}
fn ACCOUNT_1() -> ContractAddress {
    contract_address_const::<'account_1'>()
}
fn ACCOUNT_2() -> ContractAddress {
    contract_address_const::<'account_2'>()
}
fn ACCOUNT_3() -> ContractAddress {
    contract_address_const::<'account_3'>()
}
fn ACCOUNT_4() -> ContractAddress {
    contract_address_const::<'account_4'>()
}
fn ACCOUNT_5() -> ContractAddress {
    contract_address_const::<'account_5'>()
}

#[derive(Clone, Copy, Serde)]
struct Actions {
    compound: ICompoundActionsDispatcher,
    game: IGameActionsDispatcher,
    planet: IPlanetActionsDispatcher,
    tech: ITechActionsDispatcher,
    dockyard: IDockyardActionsDispatcher,
    defence: IDefenceActionsDispatcher,
}

fn setup_world() -> (IWorldDispatcher, Actions, ContractAddress, ContractAddress) {
    // components
    let mut models = array![
        planet_compounds::TEST_CLASS_HASH,
        game_setup::TEST_CLASS_HASH,
        game_planet::TEST_CLASS_HASH,
        game_planet_owner::TEST_CLASS_HASH,
        game_planet_count::TEST_CLASS_HASH,
        planet_position::TEST_CLASS_HASH,
        position_to_planet::TEST_CLASS_HASH,
        planet_resource::TEST_CLASS_HASH,
        planet_resource_timer::TEST_CLASS_HASH,
        planet_techs::TEST_CLASS_HASH,
        planet_ships::TEST_CLASS_HASH,
        planet_defences::TEST_CLASS_HASH
    ];

    // deploy world with models
    let world = spawn_test_world(models);

    // deploy systems contract
    let contract_address = world
        .deploy_contract('salt', compoundactions::TEST_CLASS_HASH.try_into().unwrap());
    let compound_actions = ICompoundActionsDispatcher { contract_address };

    let contract_address = world
        .deploy_contract('salt', gameactions::TEST_CLASS_HASH.try_into().unwrap());
    let game_actions = IGameActionsDispatcher { contract_address };

    let contract_address = world
        .deploy_contract('salt', planetactions::TEST_CLASS_HASH.try_into().unwrap());
    let planet_actions = IPlanetActionsDispatcher { contract_address };

    let contract_address = world
        .deploy_contract('salt', techactions::TEST_CLASS_HASH.try_into().unwrap());
    let tech_actions = ITechActionsDispatcher { contract_address };

    let contract_address = world
        .deploy_contract('salt', dockyardactions::TEST_CLASS_HASH.try_into().unwrap());
    let dockyard_actions = IDockyardActionsDispatcher { contract_address };

    let contract_address = world
        .deploy_contract('salt', defenceactions::TEST_CLASS_HASH.try_into().unwrap());
    let defence_actions = IDefenceActionsDispatcher { contract_address };

    let nft = deploy_nft(array!['NoGame NFT', 'NGPLANET', world.contract_address.into()]);
    let eth = deploy_eth(array!['Ether', 'ETH', ETH_SUPPLY, 0, OWNER().into()]);

    let eth_contract = IERC20Dispatcher { contract_address: eth };
    set_contract_address(OWNER());
    eth_contract.transfer(ACCOUNT_1(), 10 * E18);
    eth_contract.transfer(ACCOUNT_2(), 10 * E18);
    eth_contract.transfer(ACCOUNT_3(), 10 * E18);
    eth_contract.transfer(ACCOUNT_4(), 10 * E18);
    eth_contract.transfer(ACCOUNT_5(), 10 * E18);

    set_contract_address(ACCOUNT_1());
    eth_contract.approve(planet_actions.contract_address, 10 * E18);

    set_contract_address(ACCOUNT_2());
    eth_contract.approve(planet_actions.contract_address, 10 * E18);

    set_contract_address(ACCOUNT_3());
    eth_contract.approve(planet_actions.contract_address, 10 * E18);

    set_contract_address(ACCOUNT_4());
    eth_contract.approve(planet_actions.contract_address, 10 * E18);

    set_contract_address(ACCOUNT_5());
    eth_contract.approve(planet_actions.contract_address, 10 * E18);

    let actions = Actions {
        compound: compound_actions,
        game: game_actions,
        planet: planet_actions,
        tech: tech_actions,
        dockyard: dockyard_actions,
        defence: defence_actions
    };

    (world, actions, nft, eth)
}

fn deploy_nft(calldata: Array<felt252>) -> ContractAddress {
    let (address, _) = starknet::deploy_syscall(
        ERC721NoGame::TEST_CLASS_HASH.try_into().unwrap(), 0, calldata.span(), false
    )
        .unwrap();
    address
}

fn deploy_eth(calldata: Array<felt252>) -> ContractAddress {
    let (address, _) = starknet::deploy_syscall(
        ERC20::TEST_CLASS_HASH.try_into().unwrap(), 0, calldata.span(), false
    )
        .unwrap();
    address
}

#[test]
fn test_setup() {
    let (world, actions, nft, eth) = setup_world();
    set_contract_address(actions.planet.contract_address);
    IERC20CamelDispatcher { contract_address: eth }.transferFrom(ACCOUNT_1(), OWNER(), 1.into());
}
