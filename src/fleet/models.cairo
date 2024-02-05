use nogame::data::types::{HostileMission, Mission};

#[derive(Model, Drop, Serde)]
struct ActiveMission {
    #[key]
    planet_id: u16,
    #[key]
    id: u16,
    mission: Mission,
}

#[derive(Model, Drop, Serde)]
struct ActiveMissionLen {
    #[key]
    planet_id: u16,
    lenght: usize,
}

#[derive(Model, Drop, Serde)]
struct IncomingMission {
    #[key]
    planet_id: u16,
    #[key]
    id: u16,
    mission: HostileMission,
}

#[derive(Model, Drop, Serde)]
struct IncomingMissionLen {
    #[key]
    planet_id: u16,
    lenght: usize,
}
