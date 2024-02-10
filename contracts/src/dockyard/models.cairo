#[derive(Model, Copy, Drop, Serde)]
struct PlanetShips {
    #[key]
    planet_id: u32,
    #[key]
    name: felt252,
    count: u32,
}
