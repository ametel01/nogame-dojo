#[derive(Model, Copy, Drop, Serde)]
struct PlanetCompounds {
    #[key]
    planet_id: u32,
    #[key]
    name: u8,
    level: u8,
}

