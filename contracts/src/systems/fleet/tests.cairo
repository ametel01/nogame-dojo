use debug::PrintTrait;
use dojo::world::{IWorldDispatcherTrait, IWorldDispatcher};
use nogame::data::types::{MissionCategory, Fleet, Debris, Resources};
use nogame::libraries::names::Names;
use nogame::models::{
    colony::{ColonyPosition, ColonyResource, ColonyShips}, dockyard::PlanetShips,
    fleet::ActiveMission,
    planet::{PlanetPosition, PlanetResource, PlanetDebrisField, PlanetResourcesSpent},
    tech::PlanetTechs
};
use nogame::systems::{
    colony::contract::{IColonyActionsDispatcher, IColonyActionsDispatcherTrait},
    dockyard::contract::{IDockyardActionsDispatcher, IDockyardActionsDispatcherTrait},
    fleet::contract::{IFleetActionsDispatcher, IFleetActionsDispatcherTrait},
    game::contract::{IGameActionsDispatcher, IGameActionsDispatcherTrait},
    planet::contract::{IPlanetActionsDispatcher, IPlanetActionsDispatcherTrait}
};
use nogame::utils::test_utils::{setup_world, GAME_SPEED, ACCOUNT_1, ACCOUNT_2};
use starknet::testing::{set_contract_address, set_block_timestamp};
use starknet::{get_block_timestamp};

#[test]
fn test_send_fleet() {
    let (world, actions) = setup_world();
    actions.game.spawn(GAME_SPEED);

    set_contract_address(ACCOUNT_1());
    actions.planet.generate_planet();
    set_contract_address(ACCOUNT_2());
    actions.planet.generate_planet();

    let p2_position = get!(world, 2, PlanetPosition).position;
    set!(world, PlanetShips { planet_id: 1, name: Names::Fleet::CARRIER, count: 10 });
    set!(world, PlanetShips { planet_id: 1, name: Names::Fleet::SCRAPER, count: 10 });
    set!(world, PlanetShips { planet_id: 1, name: Names::Fleet::SPARROW, count: 10 });
    set!(world, PlanetShips { planet_id: 1, name: Names::Fleet::FRIGATE, count: 10 });
    set!(world, PlanetShips { planet_id: 1, name: Names::Fleet::ARMADE, count: 10 });
    set!(world, PlanetResource { planet_id: 1, name: Names::Resource::TRITIUM, amount: 100_000 });
    set!(world, PlanetTechs { planet_id: 1, name: Names::Tech::THRUST, level: 4 });
    set!(world, PlanetTechs { planet_id: 1, name: Names::Tech::SPACETIME, level: 3 });

    let mut fleet: Fleet = Default::default();
    fleet.carrier = 1;
    fleet.scraper = 2;
    fleet.sparrow = 3;
    fleet.frigate = 4;
    fleet.armade = 5;
    set_contract_address(ACCOUNT_1());
    set_block_timestamp(100);
    actions.fleet.send_fleet(fleet, p2_position, Zeroable::zero(), MissionCategory::ATTACK, 100, 0);

    let carrier = get!(world, (1, Names::Fleet::CARRIER), PlanetShips).count;
    assert!(carrier == 9, "Fleet: carrier not removed from planet");
    let scraper = get!(world, (1, Names::Fleet::SCRAPER), PlanetShips).count;
    assert!(scraper == 8, "Fleet: scraper not removed from planet");
    let sparrow = get!(world, (1, Names::Fleet::SPARROW), PlanetShips).count;
    assert!(sparrow == 7, "Fleet: sparrow not removed from planet");
    let frigate = get!(world, (1, Names::Fleet::FRIGATE), PlanetShips).count;
    assert!(frigate == 6, "Fleet: frigate not removed from planet");
    let armade = get!(world, (1, Names::Fleet::ARMADE), PlanetShips).count;
    assert!(armade == 5, "Fleet: armade not removed from planet");

    let mission = get!(world, (1, 1), ActiveMission).mission;
    assert!(mission.id == 1, "Fleet: mission id not set correctly");
    assert!(mission.time_start == 100, "Fleet: mission time_start not set correctly");
    assert!(mission.origin == 1, "Fleet: mission origin not set correctly");
    assert!(mission.destination == 2, "Fleet: mission destination not set correctly");
    assert!(mission.time_arrival == 20638, "Fleet: mission time_arrival not set correctly");
    assert!(mission.fleet.carrier == 1, "Fleet: mission carrier not set correctly");
    assert!(mission.fleet.scraper == 2, "Fleet: mission scraper not set correctly");
    assert!(mission.fleet.sparrow == 3, "Fleet: mission sparrow not set correctly");
    assert!(mission.fleet.frigate == 4, "Fleet: mission frigate not set correctly");
    assert!(mission.fleet.armade == 5, "Fleet: mission armade not set correctly");
    assert!(
        mission.category == MissionCategory::ATTACK, "Fleet: mission category not set correctly"
    );
}

#[test]
fn test_send_fleet_from_colony() {
    let (world, actions) = setup_world();
    actions.game.spawn(GAME_SPEED);

    set_contract_address(ACCOUNT_1());
    actions.planet.generate_planet();
    set!(world, PlanetTechs { planet_id: 1, name: Names::Tech::EXOCRAFT, level: 3 });
    actions.colony.generate_colony();

    set_contract_address(ACCOUNT_2());
    actions.planet.generate_planet();

    let p2_position = get!(world, 2, PlanetPosition).position;
    set!(world, ColonyShips { planet_id: 1, colony_id: 1, name: Names::Fleet::CARRIER, count: 10 });
    set!(world, ColonyShips { planet_id: 1, colony_id: 1, name: Names::Fleet::SCRAPER, count: 10 });
    set!(world, ColonyShips { planet_id: 1, colony_id: 1, name: Names::Fleet::SPARROW, count: 10 });
    set!(world, ColonyShips { planet_id: 1, colony_id: 1, name: Names::Fleet::FRIGATE, count: 10 });
    set!(world, ColonyShips { planet_id: 1, colony_id: 1, name: Names::Fleet::ARMADE, count: 10 });
    set!(
        world,
        ColonyResource {
            planet_id: 1, colony_id: 1, name: Names::Resource::TRITIUM, amount: 100_000
        }
    );
    set!(world, PlanetTechs { planet_id: 1, name: Names::Tech::THRUST, level: 4 });
    set!(world, PlanetTechs { planet_id: 1, name: Names::Tech::SPACETIME, level: 3 });

    let mut fleet: Fleet = Default::default();
    fleet.carrier = 1;
    fleet.scraper = 2;
    fleet.sparrow = 3;
    fleet.frigate = 4;
    fleet.armade = 5;
    set_contract_address(ACCOUNT_1());
    set_block_timestamp(100);
    actions.fleet.send_fleet(fleet, p2_position, Zeroable::zero(), MissionCategory::ATTACK, 100, 1);

    let carrier = get!(world, (1, 1, Names::Fleet::CARRIER), ColonyShips).count;
    assert!(carrier == 9, "Fleet: carrier not removed from planet");
    let scraper = get!(world, (1, 1, Names::Fleet::SCRAPER), ColonyShips).count;
    assert!(scraper == 8, "Fleet: scraper not removed from planet");
    let sparrow = get!(world, (1, 1, Names::Fleet::SPARROW), ColonyShips).count;
    assert!(sparrow == 7, "Fleet: sparrow not removed from planet");
    let frigate = get!(world, (1, 1, Names::Fleet::FRIGATE), ColonyShips).count;
    assert!(frigate == 6, "Fleet: frigate not removed from planet");
    let armade = get!(world, (1, 1, Names::Fleet::ARMADE), ColonyShips).count;
    assert!(armade == 5, "Fleet: armade not removed from planet");

    let mission = get!(world, (1, 1), ActiveMission).mission;
    assert!(mission.id == 1, "Fleet: mission id not set correctly");
    assert!(mission.time_start == 100, "Fleet: mission time_start not set correctly");
    assert!(mission.origin == 1001, "Fleet: mission origin not set correctly");
    assert!(mission.destination == 2, "Fleet: mission destination not set correctly");
    assert!(mission.time_arrival == 31784, "Fleet: mission time_arrival not set correctly");
    assert!(mission.fleet.carrier == 1, "Fleet: mission carrier not set correctly");
    assert!(mission.fleet.scraper == 2, "Fleet: mission scraper not set correctly");
    assert!(mission.fleet.sparrow == 3, "Fleet: mission sparrow not set correctly");
    assert!(mission.fleet.frigate == 4, "Fleet: mission frigate not set correctly");
    assert!(mission.fleet.armade == 5, "Fleet: mission armade not set correctly");
    assert!(
        mission.category == MissionCategory::ATTACK, "Fleet: mission category not set correctly"
    );
}

#[test]
fn test_attack_planet() {
    let (world, actions) = setup_world();
    actions.game.spawn(GAME_SPEED);
    set_contract_address(ACCOUNT_1());
    actions.planet.generate_planet();
    set_contract_address(ACCOUNT_2());
    actions.planet.generate_planet();
    let p2_position = get!(world, 2, PlanetPosition).position;
    set!(world, PlanetShips { planet_id: 1, name: Names::Fleet::CARRIER, count: 1 });
    set!(world, PlanetResource { planet_id: 1, name: Names::Resource::TRITIUM, amount: 1_000 });
    set!(world, PlanetResourcesSpent { planet_id: 1, spent: 4_000 });

    set!(world, PlanetResource { planet_id: 2, name: Names::Resource::STEEL, amount: 10_000 });
    set!(world, PlanetResource { planet_id: 2, name: Names::Resource::QUARTZ, amount: 10_000 });
    set!(world, PlanetResource { planet_id: 2, name: Names::Resource::TRITIUM, amount: 0 });

    let mut fleet: Fleet = Default::default();
    fleet.carrier = 1;
    set_contract_address(ACCOUNT_1());
    set_block_timestamp(100);
    actions.fleet.send_fleet(fleet, p2_position, Zeroable::zero(), MissionCategory::ATTACK, 100, 0);

    set!(world, PlanetResource { planet_id: 1, name: Names::Resource::STEEL, amount: 0 });
    set!(world, PlanetResource { planet_id: 1, name: Names::Resource::QUARTZ, amount: 0 });
    set!(world, PlanetResource { planet_id: 1, name: Names::Resource::TRITIUM, amount: 0 });
    let mission = get!(world, (1, 1), ActiveMission).mission;
    set_block_timestamp(get_block_timestamp() + mission.time_arrival + 1);
    actions.fleet.attack_planet(1);

    let steel = get!(world, (1, Names::Resource::STEEL), PlanetResource).amount;
    assert!(steel == 4_999, "Fleet: attacker steel not looted correctly");
    let quartz = get!(world, (1, Names::Resource::QUARTZ), PlanetResource).amount;
    assert!(quartz == 4_999, "Fleet: attacker quartz not looted correctly");
    let tritium = get!(world, (1, Names::Resource::TRITIUM), PlanetResource).amount;
    assert!(tritium == 0, "Fleet: attacker tritium not looted correctly");

    let steel = get!(world, (2, Names::Resource::STEEL), PlanetResource).amount;
    assert!(steel == 5_037, "Fleet: defender steel not looted correctly");
    let quartz = get!(world, (2, Names::Resource::QUARTZ), PlanetResource).amount;
    assert!(quartz == 5_037, "Fleet: defender quartz not looted correctly");
    let tritium = get!(world, (2, Names::Resource::TRITIUM), PlanetResource).amount;
    assert!(tritium == 0, "Fleet: defender tritium not looted correctly");

    let carriers = get!(world, (1, Names::Fleet::CARRIER), PlanetShips).count;
    assert!(carriers == 1, "Fleet: attacker carrier not returned correctly");

    let mission = get!(world, (1, 1), ActiveMission).mission;
    assert!(mission.is_zero(), "Fleet: mission not removed correctly");
}

// #[test]
// fn test_attack_planet_from_colony() {
//     let (world, actions) = setup_world();
//     actions.game.spawn(GAME_SPEED);
//     set_contract_address(ACCOUNT_1());
//     actions.planet.generate_planet();
//     set!(world, PlanetTechs { planet_id: 1, name: Names::Tech::EXOCRAFT, level: 3 });
//     actions.colony.generate_colony();

//     set_contract_address(ACCOUNT_2());
//     actions.planet.generate_planet();

//     let p2_position = get!(world, 2, PlanetPosition).position;
//     set!(
//         world,
//         ColonyShips { planet_id: 1, colony_id: 1, name: Names::Fleet::CARRIER, count: 10 }
//     );
//     set!(
//         world,
//         ColonyResource {
//             planet_id: 1, colony_id: 1, name: Names::Resource::TRITIUM, amount: 1_000
//         }
//     );

//     set!(world, PlanetResource { planet_id: 2, name: Names::Resource::STEEL, amount: 10_000 });
//     set!(world, PlanetResource { planet_id: 2, name: Names::Resource::QUARTZ, amount: 10_000 });
//     set!(world, PlanetResource { planet_id: 2, name: Names::Resource::TRITIUM, amount: 0 });

//     let mut fleet: Fleet = Default::default();
//     fleet.carrier = 1;
//     set_contract_address(ACCOUNT_1());
//     set_block_timestamp(100);
//     actions
//         .fleet
//         .send_fleet(fleet, p2_position, Zeroable::zero(), MissionCategory::ATTACK, 100, 1);

//     set!(
//         world,
//         ColonyResource { planet_id: 1, colony_id: 1, name: Names::Resource::STEEL, amount: 0 }
//     );
//     set!(
//         world,
//         ColonyResource { planet_id: 1, colony_id: 1, name: Names::Resource::QUARTZ, amount: 0 }
//     );
//     set!(
//         world,
//         ColonyResource { planet_id: 1, colony_id: 1, name: Names::Resource::TRITIUM, amount: 0 }
//     );
//     let mission = get!(world, (1, 1), ActiveMission).mission;
//     set_block_timestamp(get_block_timestamp() + mission.time_arrival + 1);
//     actions.fleet.attack_planet(1);

//     let steel = get!(world, (1, 1, Names::Resource::STEEL), ColonyResource).amount;
//     assert!(steel == 4_999, "Fleet: attacker steel not looted correctly");
//     let quartz = get!(world, (1, 1, Names::Resource::QUARTZ), ColonyResource).amount;
//     assert!(quartz == 4_999, "Fleet: attacker quartz not looted correctly");
//     let tritium = get!(world, (1, 1, Names::Resource::TRITIUM), ColonyResource).amount;
//     assert!(tritium == 0, "Fleet: attacker tritium not looted correctly");

//     let steel = get!(world, (2, Names::Resource::STEEL), PlanetResource).amount;
//     assert!(steel == 5_057, "Fleet: defender steel not looted correctly");
//     let quartz = get!(world, (2, Names::Resource::QUARTZ), PlanetResource).amount;
//     assert!(quartz == 5_057, "Fleet: defender quartz not looted correctly");
//     let tritium = get!(world, (2, Names::Resource::TRITIUM), PlanetResource).amount;
//     assert!(tritium == 0, "Fleet: defender tritium not looted correctly");

//     let carriers = get!(world, (1, 1, Names::Fleet::CARRIER), ColonyShips).count;
//     assert!(carriers == 10, "Fleet: attacker carrier not returned correctly");

//     let mission = get!(world, (1, 1), ActiveMission).mission;
//     assert!(mission.is_zero(), "Fleet: mission not removed correctly");
// }

#[test]
fn test_recall_fleet() {
    let (world, actions) = setup_world();
    actions.game.spawn(GAME_SPEED);

    set_contract_address(ACCOUNT_1());
    actions.planet.generate_planet();
    set_contract_address(ACCOUNT_2());
    actions.planet.generate_planet();

    let p2_position = get!(world, 2, PlanetPosition).position;
    set!(world, PlanetShips { planet_id: 1, name: Names::Fleet::CARRIER, count: 10 });
    set!(world, PlanetShips { planet_id: 1, name: Names::Fleet::SCRAPER, count: 10 });
    set!(world, PlanetShips { planet_id: 1, name: Names::Fleet::SPARROW, count: 10 });
    set!(world, PlanetShips { planet_id: 1, name: Names::Fleet::FRIGATE, count: 10 });
    set!(world, PlanetShips { planet_id: 1, name: Names::Fleet::ARMADE, count: 10 });
    set!(world, PlanetResource { planet_id: 1, name: Names::Resource::TRITIUM, amount: 100_000 });
    set!(world, PlanetTechs { planet_id: 1, name: Names::Tech::THRUST, level: 4 });
    set!(world, PlanetTechs { planet_id: 1, name: Names::Tech::SPACETIME, level: 3 });

    let mut fleet: Fleet = Default::default();
    fleet.carrier = 1;
    fleet.scraper = 2;
    fleet.sparrow = 3;
    fleet.frigate = 4;
    fleet.armade = 5;
    set_contract_address(ACCOUNT_1());
    set_block_timestamp(100);
    actions.fleet.send_fleet(fleet, p2_position, Zeroable::zero(), MissionCategory::ATTACK, 100, 0);

    actions.fleet.recall_fleet(1);
    let carrier = get!(world, (1, Names::Fleet::CARRIER), PlanetShips).count;
    assert!(carrier == 10, "Fleet: carrier not returned to planet");
    let scraper = get!(world, (1, Names::Fleet::SCRAPER), PlanetShips).count;
    assert!(scraper == 10, "Fleet: scraper not returned to planet");
    let sparrow = get!(world, (1, Names::Fleet::SPARROW), PlanetShips).count;
    assert!(sparrow == 10, "Fleet: sparrow not returned to planet");
    let frigate = get!(world, (1, Names::Fleet::FRIGATE), PlanetShips).count;
    assert!(frigate == 10, "Fleet: frigate not returned to planet");
    let armade = get!(world, (1, Names::Fleet::ARMADE), PlanetShips).count;
    assert!(armade == 10, "Fleet: armade not returned to planet");

    let mission = get!(world, (1, 1), ActiveMission).mission;
    assert!(mission.is_zero(), "Fleet: mission not removed correctly");
}

#[test]
fn test_recall_fleet_with_cargo() {
    let (world, actions) = setup_world();
    actions.game.spawn(GAME_SPEED);

    set_contract_address(ACCOUNT_1());
    actions.planet.generate_planet();
    set_contract_address(ACCOUNT_2());
    actions.planet.generate_planet();

    let p2_position = get!(world, 2, PlanetPosition).position;
    set!(world, PlanetShips { planet_id: 1, name: Names::Fleet::CARRIER, count: 10 });

    set!(world, PlanetResource { planet_id: 1, name: Names::Resource::STEEL, amount: 100_000 });
    set!(world, PlanetResource { planet_id: 1, name: Names::Resource::QUARTZ, amount: 100_000 });
    set!(world, PlanetResource { planet_id: 1, name: Names::Resource::TRITIUM, amount: 100_000 });
    set!(world, PlanetTechs { planet_id: 1, name: Names::Tech::THRUST, level: 4 });

    let mut fleet: Fleet = Default::default();
    fleet.carrier = 10;

    let mut cargo: Resources = Default::default();
    cargo.steel = 10_000;
    cargo.quartz = 10_000;
    cargo.tritium = 10_000;

    set_contract_address(ACCOUNT_1());
    set_block_timestamp(100);
    actions.fleet.send_fleet(fleet, p2_position, cargo, MissionCategory::TRANSPORT, 100, 0);

    actions.fleet.recall_fleet(1);
    let steel = get!(world, (1, Names::Resource::STEEL), PlanetResource).amount;
    assert!(steel == 100_000, "Fleet: steel not returned to planet");
    let quartz = get!(world, (1, Names::Resource::QUARTZ), PlanetResource).amount;
    assert!(quartz == 100_000, "Fleet: quartz not returned to planet");
    let tritium = get!(world, (1, Names::Resource::TRITIUM), PlanetResource).amount;
    assert!(tritium == 99_920, "Fleet: tritium not returned to planet");

    let mission = get!(world, (1, 1), ActiveMission).mission;
    assert!(mission.is_zero(), "Fleet: mission not removed correctly");
}

#[test]
fn test_transport() {
    let (world, actions) = setup_world();
    actions.game.spawn(GAME_SPEED);

    set_contract_address(ACCOUNT_1());
    actions.planet.generate_planet();
    set_contract_address(ACCOUNT_2());
    actions.planet.generate_planet();

    let p2_position = get!(world, 2, PlanetPosition).position;
    set!(world, PlanetShips { planet_id: 1, name: Names::Fleet::CARRIER, count: 10 });

    set!(world, PlanetResource { planet_id: 1, name: Names::Resource::STEEL, amount: 100_000 });
    set!(world, PlanetResource { planet_id: 1, name: Names::Resource::QUARTZ, amount: 100_000 });
    set!(world, PlanetResource { planet_id: 1, name: Names::Resource::TRITIUM, amount: 100_000 });
    set!(world, PlanetTechs { planet_id: 1, name: Names::Tech::THRUST, level: 4 });

    let mut fleet: Fleet = Default::default();
    fleet.carrier = 10;

    let mut cargo: Resources = Default::default();
    cargo.steel = 10_000;
    cargo.quartz = 10_000;
    cargo.tritium = 10_000;

    set_contract_address(ACCOUNT_1());
    set_block_timestamp(100);
    actions.fleet.send_fleet(fleet, p2_position, cargo, MissionCategory::TRANSPORT, 100, 0);

    let mission = get!(world, (1, 1), ActiveMission).mission;
    set_block_timestamp(mission.time_arrival + 1);
    actions.fleet.dock_fleet(1);

    let steel = get!(world, (2, Names::Resource::STEEL), PlanetResource).amount;
    assert!(steel == 10_500, "Fleet: steel not transported correctly");
    let quartz = get!(world, (2, Names::Resource::QUARTZ), PlanetResource).amount;
    assert!(quartz == 10_300, "Fleet: quartz not transported correctly");
    let tritium = get!(world, (2, Names::Resource::TRITIUM), PlanetResource).amount;
    assert!(tritium == 10_100, "Fleet: tritium not transported correctly");
}

#[test]
fn test_transport_from_colony() {
    let (world, actions) = setup_world();
    actions.game.spawn(GAME_SPEED);

    set_contract_address(ACCOUNT_1());
    actions.planet.generate_planet();
    set!(world, PlanetTechs { planet_id: 1, name: Names::Tech::EXOCRAFT, level: 3 });
    actions.colony.generate_colony();

    set_contract_address(ACCOUNT_2());
    actions.planet.generate_planet();

    let p2_position = get!(world, 2, PlanetPosition).position;
    set!(world, ColonyShips { planet_id: 1, colony_id: 1, name: Names::Fleet::CARRIER, count: 10 });

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
    set!(world, PlanetTechs { planet_id: 1, name: Names::Tech::THRUST, level: 4 });

    let mut fleet: Fleet = Default::default();
    fleet.carrier = 10;

    let mut cargo: Resources = Default::default();
    cargo.steel = 10_000;
    cargo.quartz = 10_000;
    cargo.tritium = 10_000;

    set_contract_address(ACCOUNT_1());
    set_block_timestamp(100);
    actions.fleet.send_fleet(fleet, p2_position, cargo, MissionCategory::TRANSPORT, 100, 1);

    let mission = get!(world, (1, 1), ActiveMission).mission;
    set_block_timestamp(mission.time_arrival + 1);
    actions.fleet.dock_fleet(1);

    let steel = get!(world, (2, Names::Resource::STEEL), PlanetResource).amount;
    assert!(steel == 10_500, "Fleet: steel not transported correctly");
    let quartz = get!(world, (2, Names::Resource::QUARTZ), PlanetResource).amount;
    assert!(quartz == 10_300, "Fleet: quartz not transported correctly");
    let tritium = get!(world, (2, Names::Resource::TRITIUM), PlanetResource).amount;
    assert!(tritium == 10_100, "Fleet: tritium not transported correctly");
}

#[test]
fn test_dock_fleet() {
    let (world, actions) = setup_world();
    actions.game.spawn(GAME_SPEED);

    set_contract_address(ACCOUNT_1());
    actions.planet.generate_planet();
    set!(world, PlanetTechs { planet_id: 1, name: Names::Tech::EXOCRAFT, level: 1 });
    actions.colony.generate_colony();

    let colony_position = get!(world, (1, 1), ColonyPosition).position;
    set!(world, PlanetShips { planet_id: 1, name: Names::Fleet::CARRIER, count: 10 });
    set!(world, PlanetShips { planet_id: 1, name: Names::Fleet::SCRAPER, count: 10 });
    set!(world, PlanetShips { planet_id: 1, name: Names::Fleet::SPARROW, count: 10 });
    set!(world, PlanetShips { planet_id: 1, name: Names::Fleet::FRIGATE, count: 10 });
    set!(world, PlanetShips { planet_id: 1, name: Names::Fleet::ARMADE, count: 10 });
    set!(world, PlanetResource { planet_id: 1, name: Names::Resource::TRITIUM, amount: 100_000 });
    set!(world, PlanetTechs { planet_id: 1, name: Names::Tech::THRUST, level: 4 });
    set!(world, PlanetTechs { planet_id: 1, name: Names::Tech::SPACETIME, level: 3 });

    let mut fleet: Fleet = Default::default();
    fleet.carrier = 1;
    fleet.scraper = 2;
    fleet.sparrow = 3;
    fleet.frigate = 4;
    fleet.armade = 5;
    set_contract_address(ACCOUNT_1());
    set_block_timestamp(100);
    actions
        .fleet
        .send_fleet(fleet, colony_position, Zeroable::zero(), MissionCategory::TRANSPORT, 100, 0);

    let mission = get!(world, (1, 1), ActiveMission).mission;
    set_block_timestamp(get_block_timestamp() + mission.time_arrival + 1);
    actions.fleet.dock_fleet(1);

    let carrier = get!(world, (1, 1, Names::Fleet::CARRIER), ColonyShips).count;
    assert!(carrier == 1, "Fleet: carrier not docked correctly");
    let scraper = get!(world, (1, 1, Names::Fleet::SCRAPER), ColonyShips).count;
    assert!(scraper == 2, "Fleet: scraper not docked correctly");
    let sparrow = get!(world, (1, 1, Names::Fleet::SPARROW), ColonyShips).count;
    assert!(sparrow == 3, "Fleet: sparrow not docked correctly");
    let frigate = get!(world, (1, 1, Names::Fleet::FRIGATE), ColonyShips).count;
    assert!(frigate == 4, "Fleet: frigate not docked correctly");
    let armade = get!(world, (1, 1, Names::Fleet::ARMADE), ColonyShips).count;
    assert!(armade == 5, "Fleet: armade not docked correctly");
}

#[test]
fn test_dock_fleet_with_cargo_own_fleet() {
    let (world, actions) = setup_world();
    actions.game.spawn(GAME_SPEED);

    set_contract_address(ACCOUNT_1());
    actions.planet.generate_planet();
    set!(world, PlanetTechs { planet_id: 1, name: Names::Tech::EXOCRAFT, level: 1 });
    actions.colony.generate_colony();

    let colony_position = get!(world, (1, 1), ColonyPosition).position;
    set!(world, PlanetShips { planet_id: 1, name: Names::Fleet::CARRIER, count: 10 });

    set!(world, PlanetResource { planet_id: 1, name: Names::Resource::STEEL, amount: 100_000 });
    set!(world, PlanetResource { planet_id: 1, name: Names::Resource::QUARTZ, amount: 100_000 });
    set!(world, PlanetResource { planet_id: 1, name: Names::Resource::TRITIUM, amount: 100_000 });
    set!(world, PlanetTechs { planet_id: 1, name: Names::Tech::THRUST, level: 4 });
    set!(world, PlanetTechs { planet_id: 1, name: Names::Tech::SPACETIME, level: 3 });

    let mut fleet: Fleet = Default::default();
    fleet.carrier = 10;

    let mut cargo: Resources = Default::default();
    cargo.steel = 10_000;
    cargo.quartz = 10_000;
    cargo.tritium = 10_000;

    set_contract_address(ACCOUNT_1());
    set_block_timestamp(100);
    actions.fleet.send_fleet(fleet, colony_position, cargo, MissionCategory::TRANSPORT, 100, 0);

    let steel = get!(world, (1, Names::Resource::STEEL), PlanetResource).amount;
    assert!(steel == 90_000, "Fleet: steel not removed from planet");
    let quartz = get!(world, (1, Names::Resource::QUARTZ), PlanetResource).amount;
    assert!(quartz == 90_000, "Fleet: quartz not removed from planet");
    let tritium = get!(world, (1, Names::Resource::TRITIUM), PlanetResource).amount;
    assert!(tritium == 89_760, "Fleet: tritium not removed from planet");

    let mission = get!(world, (1, 1), ActiveMission).mission;
    set_block_timestamp(get_block_timestamp() + mission.time_arrival + 1);
    actions.fleet.dock_fleet(1);

    let steel = get!(world, (1, 1, Names::Resource::STEEL), ColonyResource).amount;
    assert!(steel == 10_500, "Fleet: steel not docked correctly");
    let quartz = get!(world, (1, 1, Names::Resource::QUARTZ), ColonyResource).amount;
    assert!(quartz == 10_300, "Fleet: quartz not docked correctly");
    let tritium = get!(world, (1, 1, Names::Resource::TRITIUM), ColonyResource).amount;
    assert!(tritium == 10_100, "Fleet: tritium not docked correctly");
}

#[test]
fn test_collect_debris() {
    let (world, actions) = setup_world();
    actions.game.spawn(GAME_SPEED);

    set_contract_address(ACCOUNT_1());
    actions.planet.generate_planet();
    set_contract_address(ACCOUNT_2());
    actions.planet.generate_planet();

    let p2_position = get!(world, 2, PlanetPosition).position;
    set!(world, PlanetShips { planet_id: 1, name: Names::Fleet::SCRAPER, count: 10 });
    set!(world, PlanetResource { planet_id: 1, name: Names::Resource::TRITIUM, amount: 1_000 });

    let debris = Debris { steel: 20_000, quartz: 20_000, };
    set!(world, PlanetDebrisField { planet_id: 2, debris });

    let mut fleet: Fleet = Default::default();
    fleet.scraper = 1;
    set_contract_address(ACCOUNT_1());
    set_block_timestamp(100);
    actions.fleet.send_fleet(fleet, p2_position, Zeroable::zero(), MissionCategory::DEBRIS, 100, 0);

    set!(world, PlanetResource { planet_id: 1, name: Names::Resource::STEEL, amount: 0 });
    set!(world, PlanetResource { planet_id: 1, name: Names::Resource::QUARTZ, amount: 0 });
    set!(world, PlanetResource { planet_id: 1, name: Names::Resource::TRITIUM, amount: 0 });
    let mission = get!(world, (1, 1), ActiveMission).mission;
    assert!(
        mission.category == MissionCategory::DEBRIS, "Fleet: mission category not set correctly"
    );
    set_block_timestamp(get_block_timestamp() + mission.time_arrival + 1);
    actions.fleet.collect_debris(1);

    let steel = get!(world, (1, Names::Resource::STEEL), PlanetResource).amount;
    assert!(steel == 10_000, "Fleet: steel not collected correctly");
    let quartz = get!(world, (1, Names::Resource::QUARTZ), PlanetResource).amount;
    assert!(quartz == 10_000, "Fleet: quartz not collected correctly");

    let debris = get!(world, 2, PlanetDebrisField).debris;
    assert!(debris.steel == 10_000, "Fleet: debris steel not collected correctly");
    assert!(debris.quartz == 10_000, "Fleet: debris quartz not collected correctly");

    let carrier = get!(world, (1, Names::Fleet::SCRAPER), PlanetShips).count;
    assert!(carrier == 10, "Fleet: scraper not returned to planet");

    let mission = get!(world, (1, 1), ActiveMission).mission;
    assert!(mission.is_zero(), "Fleet: mission not removed correctly");
}
