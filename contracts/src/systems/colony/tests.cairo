use debug::PrintTrait;
use dojo::world::{IWorldDispatcherTrait, IWorldDispatcher};
use nogame::data::types::{ShipBuildType, CompoundUpgradeType, DefenceBuildType};
use nogame::libraries::{names::Names, constants};
use nogame::models::{
    colony::{
        ColonyOwner, ColonyPosition, ColonyCount, ColonyResourceTimer, PlanetColoniesCount,
        ColonyResource, ColonyShips, ColonyDefences, ColonyCompounds, ColonyCompoundTimer,
        ColonyDockyardTimer, ColonyDefenceTimer
    },
    dockyard::PlanetShips, tech::PlanetTechs
};
use nogame::systems::{
    colony::contract::{IColonyActionsDispatcher, IColonyActionsDispatcherTrait},
    game::contract::{IGameActionsDispatcher, IGameActionsDispatcherTrait},
    planet::contract::{IPlanetActionsDispatcher, IPlanetActionsDispatcherTrait}
};
use nogame::utils::test_utils::{setup_world, GAME_SPEED, ACCOUNT_1, ACCOUNT_2};
use starknet::{get_block_timestamp, testing::{set_contract_address, set_block_timestamp}};

#[test]
fn test_generate_colony() {
    let (world, actions) = setup_world();
    actions.game.spawn(GAME_SPEED);

    set_contract_address(ACCOUNT_1());
    actions.planet.generate_planet();
    set!(world, PlanetTechs { planet_id: 1, name: Names::Tech::EXOCRAFT, level: 3 });

    actions.colony.generate_colony();

    let colony_owner = get!(world, 1001, ColonyOwner).planet_id;
    assert!(colony_owner == 1, "Colony: owner not set correctly");

    let total_colonies_count = get!(world, constants::GAME_ID, ColonyCount).count;
    assert!(total_colonies_count == 1, "Colony: count not set correctly");

    let planet_colonies_count = get!(world, 1, PlanetColoniesCount).count;
    assert!(planet_colonies_count == 1, "Colony: count not set correctly");

    let colony_position = get!(world, (1, 1), ColonyPosition).position;
    assert!(
        colony_position.system == 188 && colony_position.orbit == 10,
        "Colony: position not set correctly"
    );

    actions.colony.generate_colony();
    let colony_owner = get!(world, 1002, ColonyOwner).planet_id;
    assert!(colony_owner == 1, "Colony: owner not set correctly");

    let total_colonies_count = get!(world, constants::GAME_ID, ColonyCount).count;
    assert!(total_colonies_count == 2, "Colony: count not set correctly");

    let planet_colonies_count = get!(world, 1, PlanetColoniesCount).count;
    assert!(planet_colonies_count == 2, "Colony: count not set correctly");

    let colony_position = get!(world, (1, 2), ColonyPosition).position;
    assert!(
        colony_position.system == 182 && colony_position.orbit == 2,
        "Colony: position not set correctly"
    );
}

#[test]
fn test_generate_colony_different_planets() {
    let (world, actions) = setup_world();
    actions.game.spawn(GAME_SPEED);

    set_contract_address(ACCOUNT_1());
    actions.planet.generate_planet();
    set!(world, PlanetTechs { planet_id: 1, name: Names::Tech::EXOCRAFT, level: 1 });
    actions.colony.generate_colony();

    let colony_owner = get!(world, 1001, ColonyOwner).planet_id;
    assert!(colony_owner == 1, "Colony: owner not set correctly");
    let total_colonies_count = get!(world, constants::GAME_ID, ColonyCount).count;
    assert!(total_colonies_count == 1, "Colony: count not set correctly");
    let planet_colonies_count = get!(world, 1, PlanetColoniesCount).count;
    assert!(planet_colonies_count == 1, "Colony: count not set correctly");
    let colony_position = get!(world, (1, 1), ColonyPosition).position;
    assert!(
        colony_position.system == 188 && colony_position.orbit == 10,
        "Colony: position not set correctly"
    );

    set_contract_address(ACCOUNT_2());
    actions.planet.generate_planet();
    set!(world, PlanetTechs { planet_id: 2, name: Names::Tech::EXOCRAFT, level: 1 });
    actions.colony.generate_colony();

    let colony_owner = get!(world, 2001, ColonyOwner).planet_id;
    assert!(colony_owner == 2, "Colony: owner not set correctly");
    let total_colonies_count = get!(world, constants::GAME_ID, ColonyCount).count;
    assert!(total_colonies_count == 2, "Colony: count not set correctly");
    let planet_colonies_count = get!(world, 2, PlanetColoniesCount).count;
    assert!(planet_colonies_count == 1, "Colony: count not set correctly");
    let colony_position = get!(world, (2, 1), ColonyPosition).position;
    assert!(
        colony_position.system == 182 && colony_position.orbit == 2,
        "Colony: position not set correctly"
    );
}

#[test]
fn test_upgrade_colony_compound() {
    let (world, actions) = setup_world();
    actions.game.spawn(GAME_SPEED);

    set_contract_address(ACCOUNT_1());
    actions.planet.generate_planet();
    set!(world, PlanetTechs { planet_id: 1, name: Names::Tech::EXOCRAFT, level: 1 });
    actions.colony.generate_colony();
    set!(
        world,
        ColonyResource { planet_id: 1, colony_id: 1, name: Names::Resource::STEEL, amount: 10000 }
    );
    set!(
        world,
        ColonyResource { planet_id: 1, colony_id: 1, name: Names::Resource::QUARTZ, amount: 10000 }
    );
    set!(
        world,
        ColonyResource { planet_id: 1, colony_id: 1, name: Names::Resource::TRITIUM, amount: 10000 }
    );

    actions.colony.start_compound_upgrade(1, CompoundUpgradeType::SteelMine, 1);
    let queue_status = get!(world, (1, 1), ColonyCompoundTimer);
    assert!(queue_status.time_end > 0, "Queue should have a time_end");
    set_block_timestamp(get_block_timestamp() + queue_status.time_end + 1);
    actions.colony.complete_compound_upgrade(1);

    actions.colony.start_compound_upgrade(1, CompoundUpgradeType::QuartzMine, 1);
    let queue_status = get!(world, (1, 1), ColonyCompoundTimer);
    assert!(queue_status.time_end > 0, "Queue should have a time_end");
    set_block_timestamp(get_block_timestamp() + queue_status.time_end + 1);
    actions.colony.complete_compound_upgrade(1);

    actions.colony.start_compound_upgrade(1, CompoundUpgradeType::TritiumMine, 1);
    let queue_status = get!(world, (1, 1), ColonyCompoundTimer);
    assert!(queue_status.time_end > 0, "Queue should have a time_end");
    set_block_timestamp(get_block_timestamp() + queue_status.time_end + 1);
    actions.colony.complete_compound_upgrade(1);

    actions.colony.start_compound_upgrade(1, CompoundUpgradeType::EnergyPlant, 1);
    let queue_status = get!(world, (1, 1), ColonyCompoundTimer);
    assert!(queue_status.time_end > 0, "Queue should have a time_end");
    set_block_timestamp(get_block_timestamp() + queue_status.time_end + 1);
    actions.colony.complete_compound_upgrade(1);

    actions.colony.start_compound_upgrade(1, CompoundUpgradeType::Dockyard, 1);
    let queue_status = get!(world, (1, 1), ColonyCompoundTimer);
    assert!(queue_status.time_end > 0, "Queue should have a time_end");
    set_block_timestamp(get_block_timestamp() + queue_status.time_end + 1);
    actions.colony.complete_compound_upgrade(1);

    actions.colony.start_compound_upgrade(1, CompoundUpgradeType::Cybernetics, 1);
    let queue_status = get!(world, (1, 1), ColonyCompoundTimer);
    assert!(queue_status.time_end > 0, "Queue should have a time_end");
    set_block_timestamp(get_block_timestamp() + queue_status.time_end + 1);
    actions.colony.complete_compound_upgrade(1);

    let steel_level = get!(world, (1, 1, Names::Compound::STEEL), ColonyCompounds).level;
    assert!(steel_level == 1, "Colony: steel mine not upgraded correctly");

    let quartz_level = get!(world, (1, 1, Names::Compound::QUARTZ), ColonyCompounds).level;
    assert!(quartz_level == 1, "Colony: quartz mine not upgraded correctly");

    let tritium_level = get!(world, (1, 1, Names::Compound::TRITIUM), ColonyCompounds).level;
    assert!(tritium_level == 1, "Colony: tritium mine not upgraded correctly");

    let energy_level = get!(world, (1, 1, Names::Compound::ENERGY), ColonyCompounds).level;
    assert!(energy_level == 1, "Colony: energy plant not upgraded correctly");

    let dockyard_level = get!(world, (1, 1, Names::Compound::DOCKYARD), ColonyCompounds).level;
    assert!(dockyard_level == 1, "Colony: dockyard not upgraded correctly");

    let cybernetics_level = get!(world, (1, 1, Names::Compound::CYBERNETICS), ColonyCompounds)
        .level;
    assert!(cybernetics_level == 1, "Colony: cybernetics not upgraded correctly");
}

#[test]
fn test_build_colony_ships() {
    let (world, actions) = setup_world();
    actions.game.spawn(GAME_SPEED);

    set_contract_address(ACCOUNT_1());
    actions.planet.generate_planet();
    set!(world, PlanetTechs { planet_id: 1, name: Names::Tech::EXOCRAFT, level: 1 });
    actions.colony.generate_colony();
    set!(
        world,
        ColonyResource { planet_id: 1, colony_id: 1, name: Names::Resource::STEEL, amount: 100000 }
    );
    set!(
        world,
        ColonyResource { planet_id: 1, colony_id: 1, name: Names::Resource::QUARTZ, amount: 100000 }
    );
    set!(
        world,
        ColonyResource {
            planet_id: 1, colony_id: 1, name: Names::Resource::TRITIUM, amount: 100000
        }
    );
    set!(
        world,
        ColonyCompounds { planet_id: 1, colony_id: 1, name: Names::Compound::DOCKYARD, level: 7 }
    );
    set!(world, PlanetTechs { planet_id: 1, name: Names::Tech::COMBUSTION, level: 6 });
    set!(world, PlanetTechs { planet_id: 1, name: Names::Tech::SHIELD, level: 2 });
    set!(world, PlanetTechs { planet_id: 1, name: Names::Tech::ION, level: 2 });
    set!(world, PlanetTechs { planet_id: 1, name: Names::Tech::THRUST, level: 4 });
    set!(world, PlanetTechs { planet_id: 1, name: Names::Tech::WARP, level: 4 });
    actions.colony.start_ship_build(1, ShipBuildType::Carrier, 1);
    let queue_status = get!(world, (1, 1), ColonyDockyardTimer);
    assert!(queue_status.time_end > 0, "Queue should have a time_end");
    set_block_timestamp(get_block_timestamp() + queue_status.time_end + 1);
    actions.colony.complete_ship_build(1);

    actions.colony.start_ship_build(1, ShipBuildType::Scraper, 1);
    let queue_status = get!(world, (1, 1), ColonyDockyardTimer);
    assert!(queue_status.time_end > 0, "Queue should have a time_end");
    set_block_timestamp(get_block_timestamp() + queue_status.time_end + 1);
    actions.colony.complete_ship_build(1);

    actions.colony.start_ship_build(1, ShipBuildType::Sparrow, 1);
    let queue_status = get!(world, (1, 1), ColonyDockyardTimer);
    assert!(queue_status.time_end > 0, "Queue should have a time_end");
    set_block_timestamp(get_block_timestamp() + queue_status.time_end + 1);
    actions.colony.complete_ship_build(1);

    actions.colony.start_ship_build(1, ShipBuildType::Frigate, 1);
    let queue_status = get!(world, (1, 1), ColonyDockyardTimer);
    assert!(queue_status.time_end > 0, "Queue should have a time_end");
    set_block_timestamp(get_block_timestamp() + queue_status.time_end + 1);
    actions.colony.complete_ship_build(1);

    actions.colony.start_ship_build(1, ShipBuildType::Armade, 1);
    let queue_status = get!(world, (1, 1), ColonyDockyardTimer);
    assert!(queue_status.time_end > 0, "Queue should have a time_end");
    set_block_timestamp(get_block_timestamp() + queue_status.time_end + 1);
    actions.colony.complete_ship_build(1);

    let carrier_count = get!(world, (1, 1, Names::Fleet::CARRIER), ColonyShips).count;
    assert!(carrier_count == 1, "Colony: carrier not built correctly");
    let scraper_count = get!(world, (1, 1, Names::Fleet::SCRAPER), ColonyShips).count;
    assert!(scraper_count == 1, "Colony: scraper not built correctly");
    let sparrow_count = get!(world, (1, 1, Names::Fleet::SPARROW), ColonyShips).count;
    assert!(sparrow_count == 1, "Colony: sparrow not built correctly");
    let frigate_count = get!(world, (1, 1, Names::Fleet::FRIGATE), ColonyShips).count;
    assert!(frigate_count == 1, "Colony: frigate not built correctly");
    let armade_count = get!(world, (1, 1, Names::Fleet::ARMADE), ColonyShips).count;
    assert!(armade_count == 1, "Colony: armade not built correctly");
}

#[test]
fn test_build_colony_defence() {
    let (world, actions) = setup_world();
    actions.game.spawn(GAME_SPEED);

    set_contract_address(ACCOUNT_1());
    actions.planet.generate_planet();
    set!(world, PlanetTechs { planet_id: 1, name: Names::Tech::EXOCRAFT, level: 1 });
    actions.colony.generate_colony();
    set!(
        world,
        ColonyResource { planet_id: 1, colony_id: 1, name: Names::Resource::STEEL, amount: 100_000 }
    );
    set!(
        world,
        ColonyResource {
            planet_id: 1, colony_id: 1, name: Names::Resource::QUARTZ, amount: 100_000
        }
    );
    set!(
        world,
        ColonyResource {
            planet_id: 1, colony_id: 1, name: Names::Resource::TRITIUM, amount: 100_000
        }
    );
    set!(
        world,
        ColonyCompounds { planet_id: 1, colony_id: 1, name: Names::Compound::DOCKYARD, level: 8 }
    );
    set!(world, PlanetTechs { planet_id: 1, name: Names::Tech::COMBUSTION, level: 1 });
    set!(world, PlanetTechs { planet_id: 1, name: Names::Tech::SHIELD, level: 1 });
    set!(world, PlanetTechs { planet_id: 1, name: Names::Tech::ENERGY, level: 6 });
    set!(world, PlanetTechs { planet_id: 1, name: Names::Tech::BEAM, level: 6 });
    set!(world, PlanetTechs { planet_id: 1, name: Names::Tech::WEAPONS, level: 3 });
    set!(world, PlanetTechs { planet_id: 1, name: Names::Tech::PLASMA, level: 7 });

    actions.colony.start_defence_build(1, DefenceBuildType::Celestia, 1);
    let queue_status = get!(world, (1, 1), ColonyDefenceTimer);
    assert!(queue_status.time_end > 0, "Queue should have a time_end");
    set_block_timestamp(get_block_timestamp() + queue_status.time_end + 1);
    actions.colony.complete_defence_build(1);

    actions.colony.start_defence_build(1, DefenceBuildType::Blaster, 1);
    let queue_status = get!(world, (1, 1), ColonyDefenceTimer);
    assert!(queue_status.time_end > 0, "Queue should have a time_end");
    set_block_timestamp(get_block_timestamp() + queue_status.time_end + 1);
    actions.colony.complete_defence_build(1);

    actions.colony.start_defence_build(1, DefenceBuildType::Beam, 1);
    let queue_status = get!(world, (1, 1), ColonyDefenceTimer);
    assert!(queue_status.time_end > 0, "Queue should have a time_end");
    set_block_timestamp(get_block_timestamp() + queue_status.time_end + 1);
    actions.colony.complete_defence_build(1);

    actions.colony.start_defence_build(1, DefenceBuildType::Astral, 1);
    let queue_status = get!(world, (1, 1), ColonyDefenceTimer);
    assert!(queue_status.time_end > 0, "Queue should have a time_end");
    set_block_timestamp(get_block_timestamp() + queue_status.time_end + 1);
    actions.colony.complete_defence_build(1);

    actions.colony.start_defence_build(1, DefenceBuildType::Plasma, 1);
    let queue_status = get!(world, (1, 1), ColonyDefenceTimer);
    assert!(queue_status.time_end > 0, "Queue should have a time_end");
    set_block_timestamp(get_block_timestamp() + queue_status.time_end + 1);
    actions.colony.complete_defence_build(1);

    let celestia_count = get!(world, (1, 1, Names::Defence::CELESTIA), ColonyDefences).count;
    assert!(celestia_count == 1, "Colony: celestia not built correctly");
    let blaster_count = get!(world, (1, 1, Names::Defence::BLASTER), ColonyDefences).count;
    assert!(blaster_count == 1, "Colony: blaster not built correctly");
    let beam_count = get!(world, (1, 1, Names::Defence::BEAM), ColonyDefences).count;
    assert!(beam_count == 1, "Colony: beam not built correctly");
    let astral_count = get!(world, (1, 1, Names::Defence::ASTRAL), ColonyDefences).count;
    assert!(astral_count == 1, "Colony: astral not built correctly");
    let plasma_count = get!(world, (1, 1, Names::Defence::PLASMA), ColonyDefences).count;
    assert!(plasma_count == 1, "Colony: plasma not built correctly");
}

