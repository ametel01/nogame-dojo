use nogame::data::types::{CompoundUpgradeType, Position};

#[derive(Model, Copy, Drop, Serde)]
struct ColonyOwner {
    #[key]
    colony_planet_id: u32,
    planet_id: u32,
}

#[derive(Model, Copy, Drop, Serde)]
struct ColonyCount {
    #[key]
    game_id: u8,
    count: u8,
}

#[derive(Model, Copy, Drop, Serde)]
struct PlanetColoniesCount {
    #[key]
    planet_id: u32,
    count: u8,
}

#[derive(Model, Copy, Drop, Serde)]
struct ColonyPosition {
    #[key]
    planet_id: u32,
    #[key]
    colony_id: u8,
    position: Position,
}

#[derive(Model, Copy, Drop, Serde)]
struct ColonyResource {
    #[key]
    planet_id: u32,
    #[key]
    colony_id: u8,
    #[key]
    name: u8,
    amount: u128,
}

#[derive(Model, Copy, Drop, Serde)]
struct ColonyResourceTimer {
    #[key]
    planet_id: u32,
    #[key]
    colony_id: u8,
    last_collection: u64,
}

#[derive(Model, Copy, Drop, Serde)]
struct ColonyCompounds {
    #[key]
    planet_id: u32,
    #[key]
    colony_id: u8,
    #[key]
    name: u8,
    level: u8,
}

#[derive(Model, Copy, Debug, Drop, Serde)]
struct ColonyCompoundTimer {
    #[key]
    planet_id: u32,
    #[key]
    colony_id: u8,
    name: CompoundUpgradeType,
    levels: u8,
    time_end: u64,
}

#[derive(Model, Copy, Drop, Serde)]
struct ColonyShips {
    #[key]
    planet_id: u32,
    #[key]
    colony_id: u8,
    #[key]
    name: u8,
    count: u32,
}

#[derive(Model, Copy, Drop, Serde)]
struct ColonyDefences {
    #[key]
    planet_id: u32,
    #[key]
    colony_id: u8,
    #[key]
    name: u8,
    count: u32,
}
