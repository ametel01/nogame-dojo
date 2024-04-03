use nogame::data::types::TechUpgradeType;

#[derive(Model, Copy, Drop, Serde)]
struct PlanetTechs {
    #[key]
    planet_id: u32,
    #[key]
    name: u8,
    level: u8,
}

#[derive(Model, Copy, Debug, Drop, Serde)]
struct PlanetTechTimer {
    #[key]
    planet_id: u32,
    name: TechUpgradeType,
    levels: u8,
    time_end: u64,
}
