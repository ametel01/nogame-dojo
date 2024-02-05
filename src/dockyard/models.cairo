#[derive(Model, Copy, Drop, Serde)]
struct PlanetShips {
    #[key]
    planet_id: u32,
    #[key]
    ship_id: felt252,
    count: u32,
}
