use nogame::data::types::CompoundUpgradeType;

#[derive(Model, Copy, Drop, Serde)]
struct PlanetCompounds {
    #[key]
    planet_id: u32,
    #[key]
    name: u8,
    level: u8,
}

#[derive(Model, Copy, Debug, Drop, Serde)]
struct PlanetCompoundTimer {
    #[key]
    planet_id: u32,
    name: u8,
    levels: u8,
    time_end: u64,
}

