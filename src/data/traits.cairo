use debug::PrintTrait;

use nogame::data::types::{HostileMission, Mission, Fleet, Position};

impl FleetZeroable of Zeroable<Fleet> {
    fn zero() -> Fleet {
        Fleet { carrier: 0, scraper: 0, sparrow: 0, frigate: 0, armade: 0, }
    }
    fn is_zero(self: Fleet) -> bool {
        self.carrier == 0
            && self.scraper == 0
            && self.sparrow == 0
            && self.frigate == 0
            && self.armade == 0
    }
    fn is_non_zero(self: Fleet) -> bool {
        !self.is_zero()
    }
}

impl FleetPrint of PrintTrait<Fleet> {
    fn print(self: Fleet) {
        self.carrier.print();
        self.scraper.print();
        self.sparrow.print();
        self.frigate.print();
        self.armade.print();
    }
}

impl HostileMissionPrint of PrintTrait<HostileMission> {
    fn print(self: HostileMission) {
        self.origin.print();
        self.id_at_origin.print();
        self.time_arrival.print();
        self.number_of_ships.print();
    }
}

impl HostileMissionZeroable of Zeroable<HostileMission> {
    fn zero() -> HostileMission {
        HostileMission {
            origin: Zeroable::zero(),
            id_at_origin: Zeroable::zero(),
            time_arrival: Zeroable::zero(),
            number_of_ships: Zeroable::zero(),
        }
    }
    fn is_zero(self: HostileMission) -> bool {
        self.origin.is_zero() || self.number_of_ships.is_zero() || self.time_arrival.is_zero()
    }
    fn is_non_zero(self: HostileMission) -> bool {
        !self.is_zero()
    }
}

impl MissionZeroable of Zeroable<Mission> {
    fn zero() -> Mission {
        Mission {
            id: 0,
            time_start: 0,
            destination: 0,
            time_arrival: 0,
            fleet: Zeroable::zero(),
            is_debris: false,
        }
    }
    fn is_zero(self: Mission) -> bool {
        self.time_start == 0
            || self.destination == 0
            || self.time_arrival == 0
            || self.fleet == Zeroable::zero()
    }
    fn is_non_zero(self: Mission) -> bool {
        !self.is_zero()
    }
}

impl MissionPrint of PrintTrait<Mission> {
    fn print(self: Mission) {
        self.time_start.print();
        self.destination.print();
        self.time_arrival.print();
        self.is_debris.print();
        self.fleet.print();
    }
}
