#[derive(Model, Copy, Drop, Serde)]
struct PlanetTechs {
    #[key]
    planet_id: u32,
    #[key]
    name: felt252,
    level: u8,
}
