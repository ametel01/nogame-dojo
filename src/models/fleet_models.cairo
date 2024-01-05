use nogame::data::types::{HostileMission, Mission};

#[derive(Model, Drop, Serde)]
struct FleetActiveMission {
    #[key]
    planet_id: u16,
    #[key]
    id: u16,
    mission: Mission,
}

#[derive(Model, Drop, Serde)]
struct FleetActiveMissionLen {
    #[key]
    planet_id: u16,
    lenght: usize,
}

#[derive(Model, Drop, Serde)]
struct FleetHostileMission {
    #[key]
    planet_id: u16,
    #[key]
    id: u16,
    mission: HostileMission,
}

#[derive(Model, Drop, Serde)]
struct FleetHostileMissionLen {
    #[key]
    planet_id: u16,
    lenght: usize,
}
