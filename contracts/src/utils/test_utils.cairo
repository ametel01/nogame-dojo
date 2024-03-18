use starknet::testing::set_contract_address;

use dojo::world::{IWorldDispatcherTrait, IWorldDispatcher};
use dojo::test_utils::{spawn_test_world};

use nogame::colony::models::{
    ColonyOwner, ColonyCount, PlanetColoniesCount, ColonyPosition, ColonyResource,
    ColonyResourceTimer, ColonyCompounds, ColonyShips, ColonyDefences
};
use nogame::colony::models::{
    colony_owner, colony_count, planet_colonies_count, colony_position, colony_resource,
    colony_resource_timer, colony_compounds, colony_ships, colony_defences
};
use nogame::colony::actions::{
    colonyactions, {IColonyActionsDispatcher, IColonyActionsDispatcherTrait}
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
use nogame::fleet::models::{ActiveMission, ActiveMissionLen, IncomingMissions, IncomingMissionLen};
use nogame::fleet::models::{
    active_mission, active_mission_len, incoming_missions, incoming_mission_len
};
use nogame::fleet::actions::{fleetactions, {IFleetActionsDispatcher, IFleetActionsDispatcherTrait}};
use nogame::defence::models::{PlanetDefences, planet_defences};

use starknet::{syscalls::deploy_syscall, ClassHash, ContractAddress, contract_address_const};

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

#[derive(Clone, Copy, Drop, Serde)]
struct Actions {
    colony: IColonyActionsDispatcher,
    compound: ICompoundActionsDispatcher,
    game: IGameActionsDispatcher,
    planet: IPlanetActionsDispatcher,
    tech: ITechActionsDispatcher,
    dockyard: IDockyardActionsDispatcher,
    defence: IDefenceActionsDispatcher,
    fleet: IFleetActionsDispatcher
}

fn setup_world() -> (IWorldDispatcher, Actions) {
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
        planet_defences::TEST_CLASS_HASH,
        colony_owner::TEST_CLASS_HASH,
        colony_count::TEST_CLASS_HASH,
        planet_colonies_count::TEST_CLASS_HASH,
        colony_position::TEST_CLASS_HASH,
        colony_resource::TEST_CLASS_HASH,
        colony_resource_timer::TEST_CLASS_HASH,
        colony_ships::TEST_CLASS_HASH,
        colony_defences::TEST_CLASS_HASH,
        colony_compounds::TEST_CLASS_HASH,
        active_mission::TEST_CLASS_HASH,
        active_mission_len::TEST_CLASS_HASH,
        incoming_missions::TEST_CLASS_HASH,
        incoming_mission_len::TEST_CLASS_HASH
    ];

    // deploy world with models
    let world = spawn_test_world(models);

    // deploy systems contract
    let contract_address = world
        .deploy_contract(1, compoundactions::TEST_CLASS_HASH.try_into().unwrap());
    let compound_actions = ICompoundActionsDispatcher { contract_address };

    let contract_address = world
        .deploy_contract(2, gameactions::TEST_CLASS_HASH.try_into().unwrap());
    let game_actions = IGameActionsDispatcher { contract_address };

    let contract_address = world
        .deploy_contract(3, planetactions::TEST_CLASS_HASH.try_into().unwrap());
    let planet_actions = IPlanetActionsDispatcher { contract_address };

    let contract_address = world
        .deploy_contract(4, techactions::TEST_CLASS_HASH.try_into().unwrap());
    let tech_actions = ITechActionsDispatcher { contract_address };

    let contract_address = world
        .deploy_contract(5, dockyardactions::TEST_CLASS_HASH.try_into().unwrap());
    let dockyard_actions = IDockyardActionsDispatcher { contract_address };

    let contract_address = world
        .deploy_contract(6, defenceactions::TEST_CLASS_HASH.try_into().unwrap());
    let defence_actions = IDefenceActionsDispatcher { contract_address };

    let contract_address = world
        .deploy_contract(7, colonyactions::TEST_CLASS_HASH.try_into().unwrap());
    let colony_actions = IColonyActionsDispatcher { contract_address };

    let contract_address = world
        .deploy_contract(8, fleetactions::TEST_CLASS_HASH.try_into().unwrap());
    let fleet_actions = IFleetActionsDispatcher { contract_address };

    let actions = Actions {
        colony: colony_actions,
        compound: compound_actions,
        game: game_actions,
        planet: planet_actions,
        tech: tech_actions,
        dockyard: dockyard_actions,
        defence: defence_actions,
        fleet: fleet_actions
    };

    (world, actions)
}

