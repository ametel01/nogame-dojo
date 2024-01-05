use nogame::data::types::{Debris, Position};

#[derive(Model, Drop, Serde)]
struct PlanetPosition {
    #[key]
    id: u16,
    position: Position,
}

#[derive(Model, Drop, Serde)]
struct PositionToPlanet {
    #[key]
    position: Position,
    id: u16,
}

#[derive(Model, Drop, Serde)]
struct PlanetDebrisField {
    #[key]
    id: u16,
    debris: Debris,
}

#[derive(Model, Drop, Serde)]
struct PlanetResourcesSpent {
    #[key]
    id: u16,
    spent: u128,
}

#[derive(Model, Drop, Serde)]
struct PlanetResourceTimer {
    #[key]
    id: u16,
    timestamp: u64,
}

#[derive(Model, Drop, Serde)]
struct PlanetResource {
    #[key]
    id: u16,
    #[key]
    name: felt252,
    amount: u128,
}

#[derive(Model, Drop, Serde)]
struct PlanetCompound {
    #[key]
    id: u16,
    #[key]
    name: felt252,
    level: u8,
}

#[derive(Model, Drop, Serde)]
struct PlanetTech {
    #[key]
    id: u16,
    #[key]
    name: felt252,
    level: u8,
}

#[derive(Model, Drop, Serde)]
struct PlanetFleet {
    #[key]
    id: u16,
    #[key]
    name: felt252,
    amount: u32,
}

#[derive(Model, Drop, Serde)]
struct PlanetDefence {
    #[key]
    id: u16,
    #[key]
    name: felt252,
    amount: u32,
}
