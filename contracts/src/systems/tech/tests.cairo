use dojo::world::{IWorldDispatcherTrait, IWorldDispatcher};
use nogame::data::types::TechUpgradeType;
use nogame::libraries::names::Names;
use nogame::models::{
    compound::PlanetCompounds, planet::PlanetResource, tech::{PlanetTechs, PlanetTechTimer}
};
use nogame::systems::{
    game::contract::{IGameActionsDispatcher, IGameActionsDispatcherTrait},
    planet::contract::{IPlanetActionsDispatcher, IPlanetActionsDispatcherTrait},
    tech::contract::{ITechActionsDispatcher, ITechActionsDispatcherTrait}
};
use nogame::utils::test_utils::{setup_world, GAME_SPEED, ACCOUNT_1};
use starknet::{get_block_timestamp, testing::{set_contract_address, set_block_timestamp}};

#[test]
fn test_upgrade_energy_tech_success() {
    let (world, actions) = setup_world();
    actions.game.spawn(GAME_SPEED);

    set_contract_address(ACCOUNT_1());
    actions.planet.generate_planet();
    set!(world, PlanetResource { planet_id: 1, name: Names::Resource::QUARTZ, amount: 800 });
    set!(world, PlanetResource { planet_id: 1, name: Names::Resource::TRITIUM, amount: 400 });
    set!(world, PlanetCompounds { planet_id: 1, name: Names::Compound::LAB, level: 1 });

    actions.tech.start_upgrade(Names::Tech::ENERGY, 1);
    let queue_status = get!(world, 1, PlanetTechTimer);
    assert!(queue_status.time_end > 0, "Queue should have a time_end");
    set_block_timestamp(get_block_timestamp() + queue_status.time_end + 1);
    actions.tech.complete_upgrade();
    let queue_status = get!(world, 1, PlanetTechTimer);
    assert!(queue_status.time_end == 0, "Queue time_end should be 0");
    let energy_tech = get!(world, (1, Names::Tech::ENERGY), PlanetTechs).level;
    assert(energy_tech == 1, 'Energy tech level should be 1');

    let quartz = get!(world, (1, Names::Resource::QUARTZ), PlanetResource).amount;
    assert(quartz == 0, 'Quartz should be 0');
    let tritium = get!(world, (1, Names::Resource::TRITIUM), PlanetResource).amount;
    assert(tritium == 0, 'Tritium should be 0');
}

#[test]
fn test_upgrade_digital_tech_success() {
    let (world, actions) = setup_world();
    actions.game.spawn(GAME_SPEED);

    set_contract_address(ACCOUNT_1());
    actions.planet.generate_planet();
    set!(world, PlanetResource { planet_id: 1, name: Names::Resource::QUARTZ, amount: 400 });
    set!(world, PlanetResource { planet_id: 1, name: Names::Resource::TRITIUM, amount: 600 });
    set!(world, PlanetCompounds { planet_id: 1, name: Names::Compound::LAB, level: 1 });

    actions.tech.start_upgrade(Names::Tech::DIGITAL, 1);
    let queue_status = get!(world, 1, PlanetTechTimer);
    assert!(queue_status.time_end > 0, "Queue should have a time_end");
    set_block_timestamp(get_block_timestamp() + queue_status.time_end + 1);
    actions.tech.complete_upgrade();
    let queue_status = get!(world, 1, PlanetTechTimer);
    assert!(queue_status.time_end == 0, "Queue time_end should be 0");
    let digital_tech = get!(world, (1, Names::Tech::DIGITAL), PlanetTechs).level;
    assert(digital_tech == 1, 'Digital tech level should be 1');

    let quartz = get!(world, (1, Names::Resource::QUARTZ), PlanetResource).amount;
    assert(quartz == 0, 'Quartz should be 0');
    let tritium = get!(world, (1, Names::Resource::TRITIUM), PlanetResource).amount;
    assert(tritium == 0, 'Tritium should be 0');
}

#[test]
fn test_upgrade_beam_tech_success() {
    let (world, actions) = setup_world();
    actions.game.spawn(GAME_SPEED);

    set_contract_address(ACCOUNT_1());
    actions.planet.generate_planet();
    set!(world, PlanetResource { planet_id: 1, name: Names::Resource::QUARTZ, amount: 800 });
    set!(world, PlanetResource { planet_id: 1, name: Names::Resource::TRITIUM, amount: 400 });
    set!(world, PlanetCompounds { planet_id: 1, name: Names::Compound::LAB, level: 1 });
    set!(world, PlanetTechs { planet_id: 1, name: Names::Tech::ENERGY, level: 2 });

    actions.tech.start_upgrade(Names::Tech::BEAM, 1);
    let queue_status = get!(world, 1, PlanetTechTimer);
    assert!(queue_status.time_end > 0, "Queue should have a time_end");
    set_block_timestamp(get_block_timestamp() + queue_status.time_end + 1);
    actions.tech.complete_upgrade();
    let queue_status = get!(world, 1, PlanetTechTimer);
    assert!(queue_status.time_end == 0, "Queue time_end should be 0");
    let beam_tech = get!(world, (1, Names::Tech::BEAM), PlanetTechs).level;
    assert(beam_tech == 1, 'Beam tech level should be 1');

    let quartz = get!(world, (1, Names::Resource::QUARTZ), PlanetResource).amount;
    assert(quartz == 0, 'Quartz should be 0');
    let tritium = get!(world, (1, Names::Resource::TRITIUM), PlanetResource).amount;
    assert(tritium == 0, 'Tritium should be 0');
}

#[test]
fn test_upgrade_armour_tech_success() {
    let (world, actions) = setup_world();
    actions.game.spawn(GAME_SPEED);

    set_contract_address(ACCOUNT_1());
    actions.planet.generate_planet();
    set!(world, PlanetResource { planet_id: 1, name: Names::Resource::STEEL, amount: 1000 });
    set!(world, PlanetCompounds { planet_id: 1, name: Names::Compound::LAB, level: 2 });

    actions.tech.start_upgrade(Names::Tech::ARMOUR, 1);
    let queue_status = get!(world, 1, PlanetTechTimer);
    assert!(queue_status.time_end > 0, "Queue should have a time_end");
    set_block_timestamp(get_block_timestamp() + queue_status.time_end + 1);
    actions.tech.complete_upgrade();
    let queue_status = get!(world, 1, PlanetTechTimer);
    assert!(queue_status.time_end == 0, "Queue time_end should be 0");
    let armour_tech = get!(world, (1, Names::Tech::ARMOUR), PlanetTechs).level;
    assert(armour_tech == 1, 'Armour tech level should be 1');

    let steel = get!(world, (1, Names::Resource::STEEL), PlanetResource).amount;
    assert(steel == 0, 'Stee should be 0');
}

#[test]
fn test_upgrade_ion_tech_success() {
    let (world, actions) = setup_world();
    actions.game.spawn(GAME_SPEED);

    set_contract_address(ACCOUNT_1());
    actions.planet.generate_planet();
    set!(world, PlanetResource { planet_id: 1, name: Names::Resource::STEEL, amount: 1000 });
    set!(world, PlanetResource { planet_id: 1, name: Names::Resource::QUARTZ, amount: 300 });
    set!(world, PlanetResource { planet_id: 1, name: Names::Resource::TRITIUM, amount: 1000 });
    set!(world, PlanetCompounds { planet_id: 1, name: Names::Compound::LAB, level: 4 });
    set!(world, PlanetTechs { planet_id: 1, name: Names::Tech::ENERGY, level: 4 });
    set!(world, PlanetTechs { planet_id: 1, name: Names::Tech::BEAM, level: 5 });

    actions.tech.start_upgrade(Names::Tech::ION, 1);
    let queue_status = get!(world, 1, PlanetTechTimer);
    assert!(queue_status.time_end > 0, "Queue should have a time_end");
    set_block_timestamp(get_block_timestamp() + queue_status.time_end + 1);
    actions.tech.complete_upgrade();
    let queue_status = get!(world, 1, PlanetTechTimer);
    assert!(queue_status.time_end == 0, "Queue time_end should be 0");
    let ion_tech = get!(world, (1, Names::Tech::ION), PlanetTechs).level;
    assert(ion_tech == 1, 'Ion tech level should be 1');

    let steel = get!(world, (1, Names::Resource::STEEL), PlanetResource).amount;
    assert(steel == 0, 'Steel should be 0');
    let quartz = get!(world, (1, Names::Resource::QUARTZ), PlanetResource).amount;
    assert(quartz == 0, 'Quartz should be 0');
    let tritium = get!(world, (1, Names::Resource::TRITIUM), PlanetResource).amount;
    assert(tritium == 0, 'Tritium should be 0');
}

#[test]
fn test_upgrade_plasma_tech_success() {
    let (world, actions) = setup_world();
    actions.game.spawn(GAME_SPEED);

    set_contract_address(ACCOUNT_1());
    actions.planet.generate_planet();
    set!(world, PlanetResource { planet_id: 1, name: Names::Resource::STEEL, amount: 2000 });
    set!(world, PlanetResource { planet_id: 1, name: Names::Resource::QUARTZ, amount: 4000 });
    set!(world, PlanetResource { planet_id: 1, name: Names::Resource::TRITIUM, amount: 1000 });
    set!(world, PlanetCompounds { planet_id: 1, name: Names::Compound::LAB, level: 4 });
    set!(world, PlanetTechs { planet_id: 1, name: Names::Tech::ENERGY, level: 8 });
    set!(world, PlanetTechs { planet_id: 1, name: Names::Tech::BEAM, level: 10 });
    set!(world, PlanetTechs { planet_id: 1, name: Names::Tech::ION, level: 5 });

    actions.tech.start_upgrade(Names::Tech::PLASMA, 1);
    let queue_status = get!(world, 1, PlanetTechTimer);
    assert!(queue_status.time_end > 0, "Queue should have a time_end");
    set_block_timestamp(get_block_timestamp() + queue_status.time_end + 1);
    actions.tech.complete_upgrade();
    let queue_status = get!(world, 1, PlanetTechTimer);
    assert!(queue_status.time_end == 0, "Queue time_end should be 0");
    let plasma_tech = get!(world, (1, Names::Tech::PLASMA), PlanetTechs).level;
    assert(plasma_tech == 1, 'Plasma tech level should be 1');

    let steel = get!(world, (1, Names::Resource::STEEL), PlanetResource).amount;
    assert(steel == 0, 'Steel should be 0');
    let quartz = get!(world, (1, Names::Resource::QUARTZ), PlanetResource).amount;
    assert(quartz == 0, 'Quartz should be 0');
    let tritium = get!(world, (1, Names::Resource::TRITIUM), PlanetResource).amount;
    assert(tritium == 0, 'Tritium should be 0');
}

#[test]
fn test_upgrade_weapons_tech_success() {
    let (world, actions) = setup_world();
    actions.game.spawn(GAME_SPEED);

    set_contract_address(ACCOUNT_1());
    actions.planet.generate_planet();
    set!(world, PlanetResource { planet_id: 1, name: Names::Resource::STEEL, amount: 800 });
    set!(world, PlanetResource { planet_id: 1, name: Names::Resource::QUARTZ, amount: 200 });
    set!(world, PlanetCompounds { planet_id: 1, name: Names::Compound::LAB, level: 4 });

    actions.tech.start_upgrade(Names::Tech::WEAPONS, 1);
    let queue_status = get!(world, 1, PlanetTechTimer);
    assert!(queue_status.time_end > 0, "Queue should have a time_end");
    set_block_timestamp(get_block_timestamp() + queue_status.time_end + 1);
    actions.tech.complete_upgrade();
    let queue_status = get!(world, 1, PlanetTechTimer);
    assert!(queue_status.time_end == 0, "Queue time_end should be 0");
    let weapons_tech = get!(world, (1, Names::Tech::WEAPONS), PlanetTechs).level;
    assert(weapons_tech == 1, 'Weapons tech level should be 1');

    let steel = get!(world, (1, Names::Resource::STEEL), PlanetResource).amount;
    assert(steel == 0, 'Steel should be 0');
    let quartz = get!(world, (1, Names::Resource::QUARTZ), PlanetResource).amount;
    assert(quartz == 0, 'Quartz should be 0');
}

#[test]
fn test_upgrade_shield_tech_success() {
    let (world, actions) = setup_world();
    actions.game.spawn(GAME_SPEED);

    set_contract_address(ACCOUNT_1());
    actions.planet.generate_planet();
    set!(world, PlanetResource { planet_id: 1, name: Names::Resource::STEEL, amount: 200 });
    set!(world, PlanetResource { planet_id: 1, name: Names::Resource::QUARTZ, amount: 600 });
    set!(world, PlanetCompounds { planet_id: 1, name: Names::Compound::LAB, level: 6 });
    set!(world, PlanetTechs { planet_id: 1, name: Names::Tech::ENERGY, level: 3 });

    actions.tech.start_upgrade(Names::Tech::SHIELD, 1);
    let queue_status = get!(world, 1, PlanetTechTimer);
    assert!(queue_status.time_end > 0, "Queue should have a time_end");
    set_block_timestamp(get_block_timestamp() + queue_status.time_end + 1);
    actions.tech.complete_upgrade();
    let queue_status = get!(world, 1, PlanetTechTimer);
    assert!(queue_status.time_end == 0, "Queue time_end should be 0");
    let shield_tech = get!(world, (1, Names::Tech::SHIELD), PlanetTechs).level;
    assert(shield_tech == 1, 'Shield tech level should be 1');

    let steel = get!(world, (1, Names::Resource::STEEL), PlanetResource).amount;
    assert(steel == 0, 'Steel should be 0');
    let quartz = get!(world, (1, Names::Resource::QUARTZ), PlanetResource).amount;
    assert(quartz == 0, 'Quartz should be 0');
}

#[test]
fn test_upgrade_spacetime_tech_success() {
    let (world, actions) = setup_world();
    actions.game.spawn(GAME_SPEED);

    set_contract_address(ACCOUNT_1());
    actions.planet.generate_planet();
    set!(world, PlanetResource { planet_id: 1, name: Names::Resource::QUARTZ, amount: 4000 });
    set!(world, PlanetResource { planet_id: 1, name: Names::Resource::TRITIUM, amount: 2000 });
    set!(world, PlanetCompounds { planet_id: 1, name: Names::Compound::LAB, level: 7 });
    set!(world, PlanetTechs { planet_id: 1, name: Names::Tech::ENERGY, level: 5 });
    set!(world, PlanetTechs { planet_id: 1, name: Names::Tech::SHIELD, level: 5 });

    actions.tech.start_upgrade(Names::Tech::SPACETIME, 1);
    let queue_status = get!(world, 1, PlanetTechTimer);
    assert!(queue_status.time_end > 0, "Queue should have a time_end");
    set_block_timestamp(get_block_timestamp() + queue_status.time_end + 1);
    actions.tech.complete_upgrade();
    let queue_status = get!(world, 1, PlanetTechTimer);
    assert!(queue_status.time_end == 0, "Queue time_end should be 0");
    let spacetime_tech = get!(world, (1, Names::Tech::SPACETIME), PlanetTechs).level;
    assert!(spacetime_tech == 1, "Spacetime tech level should be 1");

    let steel = get!(world, (1, Names::Resource::TRITIUM), PlanetResource).amount;
    assert(steel == 0, 'Tritium should be 0');
    let quartz = get!(world, (1, Names::Resource::QUARTZ), PlanetResource).amount;
    assert(quartz == 0, 'Quartz should be 0');
}

#[test]
fn test_upgrade_combustion_tech_success() {
    let (world, actions) = setup_world();
    actions.game.spawn(GAME_SPEED);

    set_contract_address(ACCOUNT_1());
    actions.planet.generate_planet();
    set!(world, PlanetResource { planet_id: 1, name: Names::Resource::STEEL, amount: 400 });
    set!(world, PlanetResource { planet_id: 1, name: Names::Resource::TRITIUM, amount: 600 });
    set!(world, PlanetCompounds { planet_id: 1, name: Names::Compound::LAB, level: 1 });
    set!(world, PlanetTechs { planet_id: 1, name: Names::Tech::ENERGY, level: 1 });

    actions.tech.start_upgrade(Names::Tech::COMBUSTION, 1);
    let queue_status = get!(world, 1, PlanetTechTimer);
    assert!(queue_status.time_end > 0, "Queue should have a time_end");
    set_block_timestamp(get_block_timestamp() + queue_status.time_end + 1);
    actions.tech.complete_upgrade();
    let queue_status = get!(world, 1, PlanetTechTimer);
    assert!(queue_status.time_end == 0, "Queue time_end should be 0");
    let combustion_tech = get!(world, (1, Names::Tech::COMBUSTION), PlanetTechs).level;
    assert!(combustion_tech == 1, "Combustion tech level should be 1");

    let steel = get!(world, (1, Names::Resource::STEEL), PlanetResource).amount;
    assert(steel == 0, 'Steel should be 0');
    let tritium = get!(world, (1, Names::Resource::TRITIUM), PlanetResource).amount;
    assert(tritium == 0, 'Tritium should be 0');
}

#[test]
fn test_upgrade_thrust_tech_success() {
    let (world, actions) = setup_world();
    actions.game.spawn(GAME_SPEED);

    set_contract_address(ACCOUNT_1());
    actions.planet.generate_planet();
    set!(world, PlanetResource { planet_id: 1, name: Names::Resource::STEEL, amount: 2000 });
    set!(world, PlanetResource { planet_id: 1, name: Names::Resource::QUARTZ, amount: 4000 });
    set!(world, PlanetResource { planet_id: 1, name: Names::Resource::TRITIUM, amount: 600 });
    set!(world, PlanetCompounds { planet_id: 1, name: Names::Compound::LAB, level: 2 });
    set!(world, PlanetTechs { planet_id: 1, name: Names::Tech::ENERGY, level: 1 });

    actions.tech.start_upgrade(Names::Tech::THRUST, 1);
    let queue_status = get!(world, 1, PlanetTechTimer);
    assert!(queue_status.time_end > 0, "Queue should have a time_end");
    set_block_timestamp(get_block_timestamp() + queue_status.time_end + 1);
    actions.tech.complete_upgrade();
    let queue_status = get!(world, 1, PlanetTechTimer);
    assert!(queue_status.time_end == 0, "Queue time_end should be 0");
    let thrust_tech = get!(world, (1, Names::Tech::THRUST), PlanetTechs).level;
    assert!(thrust_tech == 1, "Thrust tech level should be 1");

    let steel = get!(world, (1, Names::Resource::STEEL), PlanetResource).amount;
    assert(steel == 0, 'Steel should be 0');
    let quartz = get!(world, (1, Names::Resource::QUARTZ), PlanetResource).amount;
    assert(quartz == 0, 'Quartz should be 0');
    let tritium = get!(world, (1, Names::Resource::TRITIUM), PlanetResource).amount;
    assert(tritium == 0, 'Tritium should be 0');
}

#[test]
fn test_upgrade_warp_tech_success() {
    let (world, actions) = setup_world();
    actions.game.spawn(GAME_SPEED);

    set_contract_address(ACCOUNT_1());
    actions.planet.generate_planet();
    set!(world, PlanetResource { planet_id: 1, name: Names::Resource::STEEL, amount: 10000 });
    set!(world, PlanetResource { planet_id: 1, name: Names::Resource::QUARTZ, amount: 20000 });
    set!(world, PlanetResource { planet_id: 1, name: Names::Resource::TRITIUM, amount: 6000 });
    set!(world, PlanetCompounds { planet_id: 1, name: Names::Compound::LAB, level: 7 });
    set!(world, PlanetTechs { planet_id: 1, name: Names::Tech::ENERGY, level: 5 });
    set!(world, PlanetTechs { planet_id: 1, name: Names::Tech::SPACETIME, level: 3 });

    actions.tech.start_upgrade(Names::Tech::WARP, 1);
    let queue_status = get!(world, 1, PlanetTechTimer);
    assert!(queue_status.time_end > 0, "Queue should have a time_end");
    set_block_timestamp(get_block_timestamp() + queue_status.time_end + 1);
    actions.tech.complete_upgrade();
    let queue_status = get!(world, 1, PlanetTechTimer);
    assert!(queue_status.time_end == 0, "Queue time_end should be 0");
    let warp_tech = get!(world, (1, Names::Tech::WARP), PlanetTechs).level;
    assert!(warp_tech == 1, "Warp tech level should be 1");

    let steel = get!(world, (1, Names::Resource::STEEL), PlanetResource).amount;
    assert(steel == 0, 'Steel should be 0');
    let quartz = get!(world, (1, Names::Resource::QUARTZ), PlanetResource).amount;
    assert(quartz == 0, 'Quartz should be 0');
    let tritium = get!(world, (1, Names::Resource::TRITIUM), PlanetResource).amount;
    assert(tritium == 0, 'Tritium should be 0');
}

#[test]
fn test_upgrade_exocraft_tech_success() {
    let (world, actions) = setup_world();
    actions.game.spawn(GAME_SPEED);

    set_contract_address(ACCOUNT_1());
    actions.planet.generate_planet();
    set!(world, PlanetResource { planet_id: 1, name: Names::Resource::STEEL, amount: 4000 });
    set!(world, PlanetResource { planet_id: 1, name: Names::Resource::QUARTZ, amount: 8000 });
    set!(world, PlanetResource { planet_id: 1, name: Names::Resource::TRITIUM, amount: 4000 });
    set!(world, PlanetCompounds { planet_id: 1, name: Names::Compound::LAB, level: 3 });
    set!(world, PlanetTechs { planet_id: 1, name: Names::Tech::THRUST, level: 3 });

    actions.tech.start_upgrade(Names::Tech::EXOCRAFT, 1);
    let queue_status = get!(world, 1, PlanetTechTimer);
    assert!(queue_status.time_end > 0, "Queue should have a time_end");
    set_block_timestamp(get_block_timestamp() + queue_status.time_end + 1);
    actions.tech.complete_upgrade();
    let queue_status = get!(world, 1, PlanetTechTimer);
    assert!(queue_status.time_end == 0, "Queue time_end should be 0");
    let exocraft_tech = get!(world, (1, Names::Tech::EXOCRAFT), PlanetTechs).level;
    assert!(exocraft_tech == 1, "Exocraft tech level should be 1");

    let steel = get!(world, (1, Names::Resource::STEEL), PlanetResource).amount;
    assert(steel == 0, 'Steel should be 0');
    let quartz = get!(world, (1, Names::Resource::QUARTZ), PlanetResource).amount;
    assert(quartz == 0, 'Quartz should be 0');
    let tritium = get!(world, (1, Names::Resource::TRITIUM), PlanetResource).amount;
    assert(tritium == 0, 'Tritium should be 0');
}
