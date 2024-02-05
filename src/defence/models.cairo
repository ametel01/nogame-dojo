#[derive(Model, Copy, Drop, Serde)]
struct PlanetDefences {
    #[key]
    planet_id: u32,
    #[key]
    defence_id: felt252,
    count: u32,
}
