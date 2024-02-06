use nogame::data::types::{Debris, Position};

#[derive(Model, Copy, Drop, Serde)]
struct PlanetPosition {
    #[key]
    planet_id: u32,
    position: Position,
}

#[derive(Model, Copy, Drop, Serde)]
struct PositionToPlanet {
    #[key]
    position: Position,
    planet_id: u32,
}

#[derive(Model, Copy, Drop, Serde)]
struct PlanetDebrisField {
    #[key]
    planet_id: u32,
    debris: Debris,
}

struct PlanetResourcesSpent {
    #[key]
    planet_id: u32,
    spent: u128,
}

#[derive(Model, Copy, Drop, Serde)]
struct PlanetResourceTimer {
    #[key]
    planet_id: u32,
    timestamp: u64,
}

#[derive(Model, Copy, Drop, Serde)]
struct PlanetResource {
    #[key]
    planet_id: u32,
    #[key]
    name: felt252,
    amount: u128,
}