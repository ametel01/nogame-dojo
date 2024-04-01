use debug::PrintTrait;
use dojo::world::{IWorldDispatcherTrait, IWorldDispatcher};
use nogame::data::types::{Position, CompoundUpgradeType};
use nogame::libraries::names::Names;

use nogame::libraries::{constants};
use nogame::models::compound::PlanetCompounds;
use nogame::planet::actions::{IPlanetActionsDispatcher, IPlanetActionsDispatcherTrait};
use nogame::planet::models::{PlanetPosition, PositionToPlanet, PlanetResource, PlanetResourceTimer};
use nogame::systems::{
    compound::contract::{ICompoundActionsDispatcher, ICompoundActionsDispatcherTrait},
    game::contract::{IGameActionsDispatcher, IGameActionsDispatcherTrait}
};
use nogame::utils::test_utils::{
    setup_world, OWNER, GAME_SPEED, ACCOUNT_1, ACCOUNT_2, ACCOUNT_3, ACCOUNT_4, ACCOUNT_5, DAY
};
use starknet::testing::{set_contract_address, set_block_timestamp};

#[test]
fn test_upgrade_steel_mine_success() {
    let (world, actions) = setup_world();
    actions.game.spawn(GAME_SPEED);

    set_contract_address(ACCOUNT_1());
    actions.planet.generate_planet();

    actions.compound.process_upgrade(CompoundUpgradeType::SteelMine(()), 1);
    let steel_mine = get!(world, (1, Names::Compound::STEEL), PlanetCompounds).level;
    let steel_after = get!(world, (1, Names::Resource::STEEL), PlanetResource).amount;
    let quartz_after = get!(world, (1, Names::Resource::QUARTZ), PlanetResource).amount;
    assert(steel_mine == 1, 'Steel mine level should be 1');
    assert(steel_after == 440, 'Steel amount should be 440');
    assert(quartz_after == 285, 'Quartz amount should be 285');
}

#[test]
fn test_upgrade_quartz_mine_success() {
    let (world, actions) = setup_world();
    actions.game.spawn(GAME_SPEED);

    set_contract_address(ACCOUNT_1());
    actions.planet.generate_planet();

    actions.compound.process_upgrade(CompoundUpgradeType::QuartzMine(()), 1);
    let quartz_mine = get!(world, (1, Names::Compound::QUARTZ), PlanetCompounds).level;
    assert(quartz_mine == 1, 'Quartz mine level should be 1');
}

#[test]
fn test_upgrade_tritium_mine_success() {
    let (world, actions) = setup_world();
    actions.game.spawn(GAME_SPEED);

    set_contract_address(ACCOUNT_1());
    actions.planet.generate_planet();

    actions.compound.process_upgrade(CompoundUpgradeType::TritiumMine(()), 1);
    let tritium_mine = get!(world, (1, Names::Compound::TRITIUM), PlanetCompounds).level;
    assert(tritium_mine == 1, 'Tritium mine level should be 1');
}

#[test]
fn test_upgrade_energy_plant_success() {
    let (world, actions) = setup_world();
    actions.game.spawn(GAME_SPEED);

    set_contract_address(ACCOUNT_1());
    actions.planet.generate_planet();

    actions.compound.process_upgrade(CompoundUpgradeType::EnergyPlant(()), 1);
    let energy_plant = get!(world, (1, Names::Compound::ENERGY), PlanetCompounds).level;
    assert(energy_plant == 1, 'Energy plant level should be 1');
}

#[test]
fn test_upgrade_lab_success() {
    let (world, actions) = setup_world();
    actions.game.spawn(GAME_SPEED);

    set_contract_address(ACCOUNT_1());
    actions.planet.generate_planet();

    set!(world, PlanetResource { planet_id: 1, name: Names::Resource::QUARTZ, amount: 400 });
    set!(world, PlanetResource { planet_id: 1, name: Names::Resource::TRITIUM, amount: 200 });

    actions.compound.process_upgrade(CompoundUpgradeType::Lab(()), 1);
    let lab = get!(world, (1, Names::Compound::LAB), PlanetCompounds).level;
    assert(lab == 1, 'Lab level should be 1');
}

#[test]
fn test_upgrade_dockyard_success() {
    let (world, actions) = setup_world();
    actions.game.spawn(GAME_SPEED);

    set_contract_address(ACCOUNT_1());
    actions.planet.generate_planet();

    actions.compound.process_upgrade(CompoundUpgradeType::Dockyard(()), 1);
    let dockyard = get!(world, (1, Names::Compound::DOCKYARD), PlanetCompounds).level;
    assert(dockyard == 1, 'Dockyard level should be 1');
}

