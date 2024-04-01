use dojo::world::{IWorldDispatcherTrait, IWorldDispatcher};
use nogame::data::types::ShipBuildType;
use nogame::game::actions::{IGameActionsDispatcher, IGameActionsDispatcherTrait};
use nogame::libraries::names::Names;
use nogame::models::compound::PlanetCompounds;
use nogame::systems::dockyard::contract::{IDockyardActionsDispatcher, IDockyardActionsDispatcherTrait};
use nogame::models::dockyard::PlanetShips;
use nogame::planet::actions::{IPlanetActionsDispatcher, IPlanetActionsDispatcherTrait};
use nogame::planet::models::PlanetResource;
use nogame::tech::models::PlanetTechs;
use nogame::utils::test_utils::{setup_world, GAME_SPEED, ACCOUNT_1, ACCOUNT_2};
use starknet::testing::set_contract_address;

#[test]
fn test_build_carrier_success() {
    let (world, actions) = setup_world();
    actions.game.spawn(GAME_SPEED);

    set_contract_address(ACCOUNT_1());
    actions.planet.generate_planet();
    set!(world, PlanetResource { planet_id: 1, name: Names::Resource::STEEL, amount: 20_000 });
    set!(world, PlanetResource { planet_id: 1, name: Names::Resource::QUARTZ, amount: 20_000 });
    set!(world, PlanetCompounds { planet_id: 1, name: Names::Compound::DOCKYARD, level: 2 });
    set!(world, PlanetTechs { planet_id: 1, name: Names::Tech::COMBUSTION, level: 2 });

    actions.dockyard.process_ship_build(ShipBuildType::Carrier(()), 10);
    let carrier = get!(world, (1, Names::Fleet::CARRIER), PlanetShips).count;
    assert(carrier == 10, 'Carrier count should be 10');

    let steel = get!(world, (1, Names::Resource::STEEL), PlanetResource).amount;
    assert(steel == 0, 'Steel should be 0');
    let quartz = get!(world, (1, Names::Resource::QUARTZ), PlanetResource).amount;
    assert(quartz == 0, 'Quartz should be 0');
}

#[test]
fn test_build_scraper_success() {
    let (world, actions) = setup_world();
    actions.game.spawn(GAME_SPEED);

    set_contract_address(ACCOUNT_1());
    actions.planet.generate_planet();
    set!(world, PlanetResource { planet_id: 1, name: Names::Resource::STEEL, amount: 100_000 });
    set!(world, PlanetResource { planet_id: 1, name: Names::Resource::QUARTZ, amount: 60_000 });
    set!(world, PlanetResource { planet_id: 1, name: Names::Resource::TRITIUM, amount: 20_000 });
    set!(world, PlanetCompounds { planet_id: 1, name: Names::Compound::DOCKYARD, level: 4 });
    set!(world, PlanetTechs { planet_id: 1, name: Names::Tech::COMBUSTION, level: 6 });
    set!(world, PlanetTechs { planet_id: 1, name: Names::Tech::SHIELD, level: 2 });

    actions.dockyard.process_ship_build(ShipBuildType::Scraper(()), 10);
    let scraper = get!(world, (1, Names::Fleet::SCRAPER), PlanetShips).count;
    assert(scraper == 10, 'Scraper count should be 10');

    let steel = get!(world, (1, Names::Resource::STEEL), PlanetResource).amount;
    assert(steel == 0, 'Steel should be 0');
    let quartz = get!(world, (1, Names::Resource::QUARTZ), PlanetResource).amount;
    assert(quartz == 0, 'Quartz should be 0');
    let tritium = get!(world, (1, Names::Resource::TRITIUM), PlanetResource).amount;
    assert(tritium == 0, 'Tritium should be 0');
}

#[test]
fn test_build_sparrow_success() {
    let (world, actions) = setup_world();
    actions.game.spawn(GAME_SPEED);

    set_contract_address(ACCOUNT_1());
    actions.planet.generate_planet();
    set!(world, PlanetResource { planet_id: 1, name: Names::Resource::STEEL, amount: 30_000 });
    set!(world, PlanetResource { planet_id: 1, name: Names::Resource::QUARTZ, amount: 10_000 });

    set!(world, PlanetCompounds { planet_id: 1, name: Names::Compound::DOCKYARD, level: 1 });
    set!(world, PlanetTechs { planet_id: 1, name: Names::Tech::COMBUSTION, level: 1 });

    actions.dockyard.process_ship_build(ShipBuildType::Sparrow(()), 10);
    let sparrow = get!(world, (1, Names::Fleet::SPARROW), PlanetShips).count;
    assert(sparrow == 10, 'Sparrow count should be 10');

    let steel = get!(world, (1, Names::Resource::STEEL), PlanetResource).amount;
    assert(steel == 0, 'Steel should be 0');
    let quartz = get!(world, (1, Names::Resource::QUARTZ), PlanetResource).amount;
    assert(quartz == 0, 'Quartz should be 0');
}

#[test]
fn test_build_frigate_success() {
    let (world, actions) = setup_world();
    actions.game.spawn(GAME_SPEED);

    set_contract_address(ACCOUNT_1());
    actions.planet.generate_planet();
    set!(world, PlanetResource { planet_id: 1, name: Names::Resource::STEEL, amount: 200_000 });
    set!(world, PlanetResource { planet_id: 1, name: Names::Resource::QUARTZ, amount: 70_000 });
    set!(world, PlanetResource { planet_id: 1, name: Names::Resource::TRITIUM, amount: 20_000 });

    set!(world, PlanetCompounds { planet_id: 1, name: Names::Compound::DOCKYARD, level: 5 });
    set!(world, PlanetTechs { planet_id: 1, name: Names::Tech::ION, level: 2 });
    set!(world, PlanetTechs { planet_id: 1, name: Names::Tech::THRUST, level: 4 });

    actions.dockyard.process_ship_build(ShipBuildType::Frigate(()), 10);
    let frigate = get!(world, (1, Names::Fleet::FRIGATE), PlanetShips).count;
    assert(frigate == 10, 'Frigate count should be 10');

    let steel = get!(world, (1, Names::Resource::STEEL), PlanetResource).amount;
    assert(steel == 0, 'Steel should be 0');
    let quartz = get!(world, (1, Names::Resource::QUARTZ), PlanetResource).amount;
    assert(quartz == 0, 'Quartz should be 0');
    let tritium = get!(world, (1, Names::Resource::TRITIUM), PlanetResource).amount;
    assert(tritium == 0, 'Tritium should be 0');
}

#[test]
fn test_build_armade_success() {
    let (world, actions) = setup_world();
    actions.game.spawn(GAME_SPEED);

    set_contract_address(ACCOUNT_1());
    actions.planet.generate_planet();
    set!(world, PlanetResource { planet_id: 1, name: Names::Resource::STEEL, amount: 450_000 });
    set!(world, PlanetResource { planet_id: 1, name: Names::Resource::QUARTZ, amount: 150_000 });

    set!(world, PlanetCompounds { planet_id: 1, name: Names::Compound::DOCKYARD, level: 7 });
    set!(world, PlanetTechs { planet_id: 1, name: Names::Tech::WARP, level: 4 });

    actions.dockyard.process_ship_build(ShipBuildType::Armade(()), 10);
    let armade = get!(world, (1, Names::Fleet::ARMADE), PlanetShips).count;
    assert(armade == 10, 'Armade count should be 10');

    let steel = get!(world, (1, Names::Resource::STEEL), PlanetResource).amount;
    assert(steel == 0, 'Steel should be 0');
    let quartz = get!(world, (1, Names::Resource::QUARTZ), PlanetResource).amount;
    assert(quartz == 0, 'Quartz should be 0');
}
