#[derive(Model, Copy, Drop, Serde)]
struct PlanetDefences {
    #[key]
    planet_id: u32,
    #[key]
    name: u8,
    count: u32,
}
