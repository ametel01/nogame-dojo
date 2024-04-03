use debug::PrintTrait;
use integer::{u128_overflowing_add, u128_overflowing_sub};

#[derive(Copy, Default, Drop, Serde, PartialEq, Introspect)]
struct CompoundsLevels {
    steel: u8,
    quartz: u8,
    tritium: u8,
    energy: u8,
    lab: u8,
    dockyard: u8,
    cybernetics: u8,
}

#[derive(Copy, Drop, Serde, Introspect)]
struct Position {
    system: u16,
    orbit: u8,
}

impl PositionZeroable of Zeroable<Position> {
    fn zero() -> Position {
        Position { system: 0, orbit: 0 }
    }
    fn is_zero(self: Position) -> bool {
        self.system == 0 && self.orbit == 0
    }
    fn is_non_zero(self: Position) -> bool {
        !self.is_zero()
    }
}


#[derive(Copy, Default, Drop, Serde, Introspect, Print, PartialOrd)]
struct Resources {
    steel: u128,
    quartz: u128,
    tritium: u128,
}

impl ResourcePartialOrd of PartialOrd<Resources> {
    fn le(lhs: Resources, rhs: Resources) -> bool {
        return (lhs.steel <= rhs.steel && lhs.quartz <= rhs.quartz && lhs.tritium <= rhs.tritium);
    }
    fn ge(lhs: Resources, rhs: Resources) -> bool {
        return (lhs.steel >= rhs.steel && lhs.quartz >= rhs.quartz && lhs.tritium >= rhs.tritium);
    }
    fn lt(lhs: Resources, rhs: Resources) -> bool {
        return (lhs.steel < rhs.steel && lhs.quartz < rhs.quartz && lhs.tritium < rhs.tritium);
    }
    fn gt(lhs: Resources, rhs: Resources) -> bool {
        return (lhs.steel > rhs.steel && lhs.quartz > rhs.quartz && lhs.tritium > rhs.tritium);
    }
}

impl ERC20Zeroable of Zeroable<Resources> {
    fn zero() -> Resources {
        Resources { steel: 0, quartz: 0, tritium: 0 }
    }
    fn is_zero(self: Resources) -> bool {
        self.steel == 0 && self.quartz == 0 && self.tritium == 0
    }
    fn is_non_zero(self: Resources) -> bool {
        !self.is_zero()
    }
}

impl ResourceAdd of Add<Resources> {
    fn add(lhs: Resources, rhs: Resources) -> Resources {
        Resources {
            steel: u128_overflowing_add(lhs.steel, rhs.steel).expect('u128_add Overflow'),
            quartz: u128_overflowing_add(lhs.quartz, rhs.quartz).expect('u128_add Overflow'),
            tritium: u128_overflowing_add(lhs.tritium, rhs.tritium).expect('u128_add Overflow'),
        }
    }
}
impl ResourceSub of Sub<Resources> {
    fn sub(lhs: Resources, rhs: Resources) -> Resources {
        Resources {
            steel: u128_overflowing_sub(lhs.steel, rhs.steel).expect('u128_sub Overflow'),
            quartz: u128_overflowing_sub(lhs.quartz, rhs.quartz).expect('u128_sub Overflow'),
            tritium: u128_overflowing_sub(lhs.tritium, rhs.tritium).expect('u128_sub Overflow'),
        }
    }
}


fn erc20_mul(a: Resources, multiplicator: u128) -> Resources {
    Resources {
        steel: a.steel * multiplicator,
        quartz: a.quartz * multiplicator,
        tritium: a.tritium * multiplicator
    }
}

#[derive(Copy, Default, Drop, PartialEq, Serde, Introspect)]
struct Fleet {
    carrier: u32,
    scraper: u32,
    sparrow: u32,
    frigate: u32,
    armade: u32,
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

impl FleetPartialOrd of PartialOrd<Fleet> {
    fn le(lhs: Fleet, rhs: Fleet) -> bool {
        return (lhs.carrier <= rhs.carrier
            && lhs.scraper <= rhs.scraper
            && lhs.sparrow <= rhs.sparrow
            && lhs.frigate <= rhs.frigate
            && lhs.armade <= rhs.armade);
    }
    fn ge(lhs: Fleet, rhs: Fleet) -> bool {
        return (lhs.carrier >= rhs.carrier
            && lhs.scraper >= rhs.scraper
            && lhs.sparrow >= rhs.sparrow
            && lhs.frigate >= rhs.frigate
            && lhs.armade >= rhs.armade);
    }
    fn lt(lhs: Fleet, rhs: Fleet) -> bool {
        return (lhs.carrier < rhs.carrier
            && lhs.scraper < rhs.scraper
            && lhs.sparrow < rhs.sparrow
            && lhs.frigate < rhs.frigate
            && lhs.armade < rhs.armade);
    }
    fn gt(lhs: Fleet, rhs: Fleet) -> bool {
        return (lhs.carrier > rhs.carrier
            && lhs.scraper > rhs.scraper
            && lhs.sparrow > rhs.sparrow
            && lhs.frigate > rhs.frigate
            && lhs.armade > rhs.armade);
    }
}

#[derive(Copy, Default, Drop, Serde, Introspect)]
struct Debris {
    steel: u128,
    quartz: u128
}

impl DebrisZeroable of Zeroable<Debris> {
    fn zero() -> Debris {
        Debris { steel: 0, quartz: 0 }
    }
    fn is_zero(self: Debris) -> bool {
        self.steel == 0 && self.quartz == 0
    }
    fn is_non_zero(self: Debris) -> bool {
        !self.is_zero()
    }
}

impl DebrisAdd of Add<Debris> {
    fn add(lhs: Debris, rhs: Debris) -> Debris {
        Debris {
            steel: u128_overflowing_add(lhs.steel, rhs.steel).expect('u128_add Overflow'),
            quartz: u128_overflowing_add(lhs.quartz, rhs.quartz).expect('u128_add Overflow')
        }
    }
}

#[derive(Copy, Default, Drop, Serde, Print, Introspect)]
struct Mission {
    id: u32,
    time_start: u64,
    origin: u32,
    destination: u32,
    cargo: Resources,
    time_arrival: u64,
    fleet: Fleet,
    category: u8,
    is_return: bool,
}

impl MissionZeroable of Zeroable<Mission> {
    fn zero() -> Mission {
        Mission {
            id: 0,
            time_start: 0,
            origin: 0,
            destination: 0,
            cargo: Zeroable::zero(),
            time_arrival: 0,
            fleet: Zeroable::zero(),
            category: 0,
            is_return: false,
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

#[derive(Copy, Default, PartialEq, Drop, Serde, Introspect)]
struct IncomingMission {
    origin: u32,
    id_at_origin: usize,
    time_arrival: u64,
    number_of_ships: u32,
    destination: u32,
}

impl IncomingMissionZeroable of Zeroable<IncomingMission> {
    fn zero() -> IncomingMission {
        IncomingMission {
            origin: Zeroable::zero(),
            id_at_origin: Zeroable::zero(),
            time_arrival: Zeroable::zero(),
            number_of_ships: Zeroable::zero(),
            destination: Zeroable::zero(),
        }
    }
    fn is_zero(self: IncomingMission) -> bool {
        self.origin.is_zero() || self.number_of_ships.is_zero() || self.time_arrival.is_zero()
    }
    fn is_non_zero(self: IncomingMission) -> bool {
        !self.is_zero()
    }
}

#[derive(Copy, Debug, Drop, Introspect, Serde)]
enum CompoundUpgradeType {
    SteelMine,
    QuartzMine,
    TritiumMine,
    EnergyPlant,
    Lab,
    Dockyard,
    Cybernetics,
}

#[derive(Copy, Default, Drop, Serde)]
struct TechLevels {
    energy: u8,
    digital: u8,
    beam: u8,
    armour: u8,
    ion: u8,
    plasma: u8,
    weapons: u8,
    shield: u8,
    spacetime: u8,
    combustion: u8,
    thrust: u8,
    warp: u8,
    exocraft: u8,
}

#[derive(Copy, Drop, Serde)]
struct TechsCost {
    energy: Resources,
    digital: Resources,
    beam: Resources,
    armour: Resources,
    ion: Resources,
    plasma: Resources,
    weapons: Resources,
    shield: Resources,
    spacetime: Resources,
    combustion: Resources,
    thrust: Resources,
    warp: Resources,
}

#[derive(Copy, Debug, Drop, Introspect, Serde)]
enum TechUpgradeType {
    Energy,
    Digital,
    Beam,
    Armour,
    Ion,
    Plasma,
    Weapons,
    Shield,
    Spacetime,
    Combustion,
    Thrust,
    Warp,
    Exocraft,
}


#[derive(Copy, Drop, Serde)]
struct ShipsCost {
    carrier: Resources,
    celestia: Resources,
    scraper: Resources,
    sparrow: Resources,
    frigate: Resources,
    armade: Resources,
}

#[derive(Copy, Debug, Drop, Introspect, Serde)]
enum ShipBuildType {
    Carrier,
    Scraper,
    Sparrow,
    Frigate,
    Armade,
}
#[derive(Drop, Serde)]
enum DefenceBuildType {
    Celestia,
    Blaster,
    Beam,
    Astral,
    Plasma
}

#[derive(Copy, Drop, Serde)]
struct DefencesCost {
    celestia: Resources,
    blaster: Resources,
    beam: Resources,
    astral: Resources,
    plasma: Resources,
}

#[derive(Copy, Default, PartialEq, Drop, Serde)]
struct Defences {
    celestia: u32,
    blaster: u32,
    beam: u32,
    astral: u32,
    plasma: u32
}

#[derive(Default, Drop, Copy, PartialEq, Serde)]
struct Unit {
    id: u8,
    hull: u32,
    shield: u32,
    weapon: u32,
    speed: u32,
    cargo: u32,
    consumption: u32,
}

impl DefencesZeroable of Zeroable<Defences> {
    fn zero() -> Defences {
        Defences { celestia: 0, blaster: 0, beam: 0, astral: 0, plasma: 0, }
    }
    fn is_zero(self: Defences) -> bool {
        self.celestia == 0
            && self.blaster == 0
            && self.beam == 0
            && self.astral == 0
            && self.plasma == 0
    }
    fn is_non_zero(self: Defences) -> bool {
        !self.is_zero()
    }
}

#[generate_trait]
impl UnitImpl of UnitTrait {
    fn is_destroyed(self: Unit) -> bool {
        self.hull == 0
    }
}

#[derive(Default, Drop, Copy, PartialEq, Serde)]
struct SimulationResult {
    attacker_carrier: u32,
    attacker_scraper: u32,
    attacker_sparrow: u32,
    attacker_frigate: u32,
    attacker_armade: u32,
    defender_carrier: u32,
    defender_scraper: u32,
    defender_sparrow: u32,
    defender_frigate: u32,
    defender_armade: u32,
    celestia: u32,
    blaster: u32,
    beam: u32,
    astral: u32,
    plasma: u32,
}

#[derive(Copy, Drop, Serde)]
enum ColonyUpgradeType {
    SteelMine,
    QuartzMine,
    TritiumMine,
    EnergyPlant,
    Dockyard,
    Cybernetics,
}

mod MissionCategory {
    const ATTACK: u8 = 1;
    const TRANSPORT: u8 = 2;
    const DEBRIS: u8 = 3;
}
