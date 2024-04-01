use dojo::world::{IWorldDispatcherTrait, IWorldDispatcher};
use nogame::libraries::{constants, names::Names};
use nogame::models::{
    game::GamePlanetCount,
    planet::{PlanetPosition, PositionToPlanet, PlanetResource, PlanetResourceTimer}
};
use nogame::systems::{
    game::contract::{IGameActionsDispatcher, IGameActionsDispatcherTrait},
    planet::contract::{IPlanetActionsDispatcher, IPlanetActionsDispatcherTrait}
};
use nogame::utils::test_utils::{setup_world, GAME_SPEED, ACCOUNT_1};
use starknet::testing::set_contract_address;

#[test]
fn test_generate_planet() {
    let (world, actions) = setup_world();
    actions.game.spawn(GAME_SPEED);

    set_contract_address(ACCOUNT_1());
    actions.planet.generate_planet();

    let planet_id = get!(world, constants::GAME_ID, (GamePlanetCount)).count;

    let position = get!(world, planet_id, (PlanetPosition)).position;
    assert!(
        position.system == 86 && position.orbit == 1, "test_generate_planet: wrong planet position"
    );

    let id_from_position = get!(world, position, (PositionToPlanet)).planet_id;
    assert!(id_from_position == planet_id, "test_generate_planet: wrong position to planet");

    let steel = get!(world, (planet_id, Names::Resource::STEEL), (PlanetResource)).amount;
    assert!(steel == 500, "test_generate_planet: wrong initial steel");
    let qurtz = get!(world, (planet_id, Names::Resource::QUARTZ), (PlanetResource)).amount;
    assert!(qurtz == 300, "test_generate_planet: wrong initial qurtz");
    let tritium = get!(world, (planet_id, Names::Resource::TRITIUM), (PlanetResource)).amount;
    assert!(tritium == 100, "test_generate_planet: wrong initial tritium");
    let energy = get!(world, (planet_id, Names::Resource::ENERGY), (PlanetResource)).amount;
    assert!(energy == 0, "test_generate_planet: wrong initial energy");

    let time_start = get!(world, planet_id, (PlanetResourceTimer)).last_collection;
    assert!(
        time_start == starknet::get_block_timestamp(), "test_generate_planet: wrong time start"
    );
}
