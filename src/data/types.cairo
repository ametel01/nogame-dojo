#[derive(Copy, Drop, Serde, Introspect)]
struct Position {
    system: u16,
    orbit: u8,
}

#[derive(Copy, Drop, PartialEq, Serde, Introspect)]
struct Fleet {
    carrier: u32,
    scraper: u32,
    sparrow: u32,
    frigate: u32,
    armade: u32,
}

#[derive(Copy, Drop, Serde, Introspect)]
struct Debris {
    steel: u128,
    quartz: u128
}

#[derive(Copy, Drop, Serde, Introspect)]
struct Mission {
    id: u16,
    time_start: u64,
    destination: u16,
    time_arrival: u64,
    fleet: Fleet,
    is_debris: bool,
}

#[derive(Copy, Drop, Serde, Introspect)]
struct HostileMission {
    origin: u16,
    id_at_origin: usize,
    time_arrival: u64,
    number_of_ships: u32,
}
