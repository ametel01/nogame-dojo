use starknet::ContractAddress;

#[derive(Model, Drop, Serde)]
struct GameSetup {
    #[key]
    id: u8,
    owner: ContractAddress,
    nft_address: ContractAddress,
    price: u128,
    speed: usize,
    start_time: u64,
}

#[derive(Model, Drop, Serde)]
struct GamePlanet {
    #[key]
    owner: ContractAddress,
    id: u16,
}

#[derive(Model, Drop, Serde)]
struct GamePlanetOwner {
    #[key]
    id: u16,
    owner: ContractAddress,
}

#[derive(Model, Drop, Serde)]
struct GamePlanetCount {
    #[key]
    id: u8,
    count: u16,
}

