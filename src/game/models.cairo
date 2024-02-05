use starknet::ContractAddress;
use nogame::compound::actions::ICompoundActionsDispatcher;
use nogame::game::actions::IGameActionsDispatcher;
use nogame::planet::actions::IPlanetActionsDispatcher;
use dojo::database::introspect::Introspect;

#[derive(Model, Drop, Serde)]
struct GameSetup {
    #[key]
    id: u8,
    owner: ContractAddress,
    nft_address: ContractAddress,
    eth_address: ContractAddress,
    price: u128,
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
struct GamePlanetCount {
    #[key]
    planet_id: u8,
    count: u32,
}

