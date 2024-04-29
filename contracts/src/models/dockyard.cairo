use nogame::data::types::ShipBuildType;

#[derive(Model, Copy, Drop, Serde)]
struct PlanetShips {
    #[key]
    planet_id: u32,
    #[key]
    name: u8,
    count: u32,
}

#[derive(Model, Copy, Debug, Drop, Serde)]
struct PlanetDockyardTimer {
    #[key]
    planet_id: u32,
    name: u8,
    quantity: u32,
    time_end: u64,
}
