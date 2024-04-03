use nogame::data::types::DefenceBuildType;

#[derive(Model, Copy, Drop, Serde)]
struct PlanetDefences {
    #[key]
    planet_id: u32,
    #[key]
    name: u8,
    count: u32,
}

#[derive(Model, Copy, Debug, Drop, Serde)]
struct PlanetDefenceTimer {
    #[key]
    planet_id: u32,
    name: DefenceBuildType,
    quantity: u32,
    time_end: u64,
}

