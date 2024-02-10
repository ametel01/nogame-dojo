use nogame::data::types::{IncomingMission, Mission};

#[derive(Model, Drop, Serde)]
struct ActiveMission {
    #[key]
    planet_id: u32,
    #[key]
    mission_id: usize,
    mission: Mission,
}

#[derive(Model, Drop, Serde)]
struct ActiveMissionLen {
    #[key]
    planet_id: u32,
    lenght: usize,
}

#[derive(Model, Drop, Serde)]
struct IncomingMissions {
    #[key]
    planet_id: u32,
    #[key]
    mission_id: usize,
    mission: IncomingMission,
}

#[derive(Model, Drop, Serde)]
struct IncomingMissionLen {
    #[key]
    planet_id: u32,
    lenght: usize,
}
