use dojo::database::introspect::Introspect;
use nogame::compound::actions::ICompoundActionsDispatcher;
use nogame::game::actions::IGameActionsDispatcher;
use nogame::planet::actions::IPlanetActionsDispatcher;
use starknet::ContractAddress;

#[derive(Model, Drop, Serde)]
struct GameSetup {
    #[key]
    game_id: u8,
    speed: usize,
    start_time: u64,
}

#[derive(Model, Drop, Serde)]
struct GamePlanet {
    #[key]
    owner: ContractAddress,
    planet_id: u32,
}

#[derive(Model, Drop, Serde)]
struct GamePlanetOwner {
    #[key]
    planet_id: u32,
    owner: ContractAddress,
}

#[derive(Model, Drop, Serde)]
struct GameOwnerPlanet {
    #[key]
    owner: ContractAddress,
    planet_id: u32,
}

#[derive(Model, Drop, Serde)]
struct GamePlanetCount {
    #[key]
    game_id: u8,
    count: u32,
}

