use dojo::world::{IWorldDispatcherTrait, IWorldDispatcher};
use nogame::data::types::CompoundUpgradeType;
use nogame::libraries::{compound, names::Names};
use nogame::models::{compound::{PlanetCompounds , PlanetCompoundTimer}, planet::PlanetResource};
use nogame::systems::{
    compound::contract::{ICompoundActionsDispatcher, ICompoundActionsDispatcherTrait},
    game::contract::{IGameActionsDispatcher, IGameActionsDispatcherTrait},
    planet::contract::{IPlanetActionsDispatcher, IPlanetActionsDispatcherTrait}
};
use nogame::utils::test_utils::{setup_world, GAME_SPEED, ACCOUNT_1};
use starknet::{get_block_timestamp, testing::{set_contract_address, set_block_timestamp}};

#[test]
fn test_upgrade_steel_compound_success() {
    let (world, actions) = setup_world();
    actions.game.spawn(GAME_SPEED);

    set_contract_address(ACCOUNT_1());
    actions.planet.generate_planet();

    actions.compound.start_upgrade(CompoundUpgradeType::SteelMine(()), 1);
    let queue_status = get!(world, 1, PlanetCompoundTimer);
    assert!(queue_status.time_end > 0, "Queue should have a time_end");
    set_block_timestamp(get_block_timestamp() + queue_status.time_end + 1);
    actions.compound.complete_upgrade();
    let queue_status = get!(world, 1, PlanetCompoundTimer);
    assert!(queue_status.time_end == 0, "Queue time_end should be 0");
    let steel_mine = get!(world, (1, Names::Compound::STEEL), PlanetCompounds).level;
    let steel_after = get!(world, (1, Names::Resource::STEEL), PlanetResource).amount;
    let quartz_after = get!(world, (1, Names::Resource::QUARTZ), PlanetResource).amount;
    assert(steel_mine == 1, 'Steel mine level should be 1');
    assert(steel_after == 440, 'Steel amount should be 440');
    assert(quartz_after == 285, 'Quartz amount should be 285');
}

#[test]
fn test_upgrade_quartz_compound_success() {
    let (world, actions) = setup_world();
    actions.game.spawn(GAME_SPEED);

    set_contract_address(ACCOUNT_1());
    actions.planet.generate_planet();

    actions.compound.start_upgrade(CompoundUpgradeType::QuartzMine(()), 1);
    let queue_status = get!(world, 1, PlanetCompoundTimer);
    assert!(queue_status.time_end > 0, "Queue should have a time_end");
    set_block_timestamp(get_block_timestamp() + queue_status.time_end + 1);
    actions.compound.complete_upgrade();
    let queue_status = get!(world, 1, PlanetCompoundTimer);
    assert!(queue_status.time_end == 0, "Queue time_end should be 0");
    let quartz_mine = get!(world, (1, Names::Compound::QUARTZ), PlanetCompounds).level;
    assert(quartz_mine == 1, 'Quartz mine level should be 1');
}

#[test]
fn test_upgrade_tritium_compound_success() {
    let (world, actions) = setup_world();
    actions.game.spawn(GAME_SPEED);

    set_contract_address(ACCOUNT_1());
    actions.planet.generate_planet();

    actions.compound.start_upgrade(CompoundUpgradeType::TritiumMine(()), 1);
let queue_status = get!(world, 1, PlanetCompoundTimer);
    assert!(queue_status.time_end > 0, "Queue should have a time_end");
    set_block_timestamp(get_block_timestamp() + queue_status.time_end + 1);
    actions.compound.complete_upgrade();
    let queue_status = get!(world, 1, PlanetCompoundTimer);
    assert!(queue_status.time_end == 0, "Queue time_end should be 0");
    let tritium_mine = get!(world, (1, Names::Compound::TRITIUM), PlanetCompounds).level;
    assert(tritium_mine == 1, 'Tritium mine level should be 1');
}

#[test]
fn test_upgrade_energy_compound_success() {
    let (world, actions) = setup_world();
    actions.game.spawn(GAME_SPEED);

    set_contract_address(ACCOUNT_1());
    actions.planet.generate_planet();

    actions.compound.start_upgrade(CompoundUpgradeType::EnergyPlant(()), 1);
    let queue_status = get!(world, 1, PlanetCompoundTimer);
    assert!(queue_status.time_end > 0, "Queue should have a time_end");
    set_block_timestamp(get_block_timestamp() + queue_status.time_end + 1);
    actions.compound.complete_upgrade();
    let queue_status = get!(world, 1, PlanetCompoundTimer);
    assert!(queue_status.time_end == 0, "Queue time_end should be 0");
    let energy_plant = get!(world, (1, Names::Compound::ENERGY), PlanetCompounds).level;
    assert(energy_plant == 1, 'Energy plant level should be 1');
}

#[test]
fn test_upgrade_compound_success() {
    let (world, actions) = setup_world();
    actions.game.spawn(GAME_SPEED);

    set_contract_address(ACCOUNT_1());
    actions.planet.generate_planet();

    set!(world, PlanetResource { planet_id: 1, name: Names::Resource::QUARTZ, amount: 400 });
    set!(world, PlanetResource { planet_id: 1, name: Names::Resource::TRITIUM, amount: 200 });

    actions.compound.start_upgrade(CompoundUpgradeType::Lab(()), 1);
    let queue_status = get!(world, 1, PlanetCompoundTimer);
    assert!(queue_status.time_end > 0, "Queue should have a time_end");
    set_block_timestamp(get_block_timestamp() + queue_status.time_end + 1);
    actions.compound.complete_upgrade();
    let queue_status = get!(world, 1, PlanetCompoundTimer);
    assert!(queue_status.time_end == 0, "Queue time_end should be 0");
    let lab = get!(world, (1, Names::Compound::LAB), PlanetCompounds).level;
    assert(lab == 1, 'Lab level should be 1');
}

#[test]
fn test_upgrade_dockyard_compound_success() {
    let (world, actions) = setup_world();
    actions.game.spawn(GAME_SPEED);

    set_contract_address(ACCOUNT_1());
    actions.planet.generate_planet();

    actions.compound.start_upgrade(CompoundUpgradeType::Dockyard(()), 1);
    let queue_status = get!(world, 1, PlanetCompoundTimer);
    assert!(queue_status.time_end > 0, "Queue should have a time_end");
    set_block_timestamp(get_block_timestamp() + queue_status.time_end + 1);
    actions.compound.complete_upgrade();
    let queue_status = get!(world, 1, PlanetCompoundTimer);
    assert!(queue_status.time_end == 0, "Queue time_end should be 0");
    let dockyard = get!(world, (1, Names::Compound::DOCKYARD), PlanetCompounds).level;
    assert(dockyard == 1, 'Dockyard level should be 1');
}
#[test]
fn test_upgrade_cybernetics_compound_success() {
    let (world, actions) = setup_world();
    actions.game.spawn(GAME_SPEED);

    set_contract_address(ACCOUNT_1());
    actions.planet.generate_planet();

    actions.compound.start_upgrade(CompoundUpgradeType::Cybernetics(()), 1);
    let queue_status = get!(world, 1, PlanetCompoundTimer);
    assert!(queue_status.time_end > 0, "Queue should have a time_end");
    set_block_timestamp(get_block_timestamp() + queue_status.time_end + 1);
    actions.compound.complete_upgrade();
    let queue_status = get!(world, 1, PlanetCompoundTimer);
    assert!(queue_status.time_end == 0, "Queue time_end should be 0");
    let cybernetics = get!(world, (1, Names::Compound::CYBERNETICS), PlanetCompounds).level;
    assert(cybernetics == 1, 'Dockyard level should be 1');
}

#[test]
fn test_build_time() {
    let cost = compound::cost::steel(0, 1);
    let time = compound::build_time_is_seconds(cost.steel + cost.quartz, 1, 1);
    println!("Time: {}", time);

    let cost = compound::cost::quartz(0, 10);
    let time = compound::build_time_is_seconds(cost.steel + cost.quartz, 1, 1);
    println!("Time: {}", time);
}

