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
}

#[derive(Copy, Drop, Serde, Introspect)]
struct Position {
    system: u16,
    orbit: u8,
}

#[derive(Copy, Default, Drop, Serde, Introspect, Print)]
struct ERC20s {
    steel: u128,
    quartz: u128,
    tritium: u128,
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

#[derive(Drop, Serde)]
enum CompoundUpgradeType {
    SteelMine,
    QuartzMine,
    TritiumMine,
    EnergyPlant,
    Lab,
    Dockyard,
}

impl ERC20Zeroable of Zeroable<ERC20s> {
    fn zero() -> ERC20s {
        ERC20s { steel: 0, quartz: 0, tritium: 0 }
    }
    fn is_zero(self: ERC20s) -> bool {
        self.steel == 0 && self.quartz == 0 && self.tritium == 0
    }
    fn is_non_zero(self: ERC20s) -> bool {
        !self.is_zero()
    }
}

impl ERC20sAdd of Add<ERC20s> {
    fn add(lhs: ERC20s, rhs: ERC20s) -> ERC20s {
        ERC20s {
            steel: u128_overflowing_add(lhs.steel, rhs.steel).expect('u128_add Overflow'),
            quartz: u128_overflowing_add(lhs.quartz, rhs.quartz).expect('u128_add Overflow'),
            tritium: u128_overflowing_add(lhs.tritium, rhs.tritium).expect('u128_add Overflow'),
        }
    }
}
impl ERC20sSub of Sub<ERC20s> {
    fn sub(lhs: ERC20s, rhs: ERC20s) -> ERC20s {
        ERC20s {
            steel: u128_overflowing_sub(lhs.steel, rhs.steel).expect('u128_sub Overflow'),
            quartz: u128_overflowing_sub(lhs.quartz, rhs.quartz).expect('u128_sub Overflow'),
            tritium: u128_overflowing_sub(lhs.tritium, rhs.tritium).expect('u128_sub Overflow'),
        }
    }
}

impl ERC20sPartialOrd of PartialOrd<ERC20s> {
    fn le(lhs: ERC20s, rhs: ERC20s) -> bool {
        return (lhs.steel <= rhs.steel && lhs.quartz <= rhs.quartz && lhs.tritium <= rhs.tritium);
    }
    fn ge(lhs: ERC20s, rhs: ERC20s) -> bool {
        return (lhs.steel >= rhs.steel && lhs.quartz >= rhs.quartz && lhs.tritium >= rhs.tritium);
    }
    fn lt(lhs: ERC20s, rhs: ERC20s) -> bool {
        return (lhs.steel < rhs.steel && lhs.quartz < rhs.quartz && lhs.tritium < rhs.tritium);
    }
    fn gt(lhs: ERC20s, rhs: ERC20s) -> bool {
        return (lhs.steel > rhs.steel && lhs.quartz > rhs.quartz && lhs.tritium > rhs.tritium);
    }
}

fn erc20_mul(a: ERC20s, multiplicator: u128) -> ERC20s {
    ERC20s {
        steel: a.steel * multiplicator,
        quartz: a.quartz * multiplicator,
        tritium: a.tritium * multiplicator
    }
}

// impl ERC20Print of PrintTrait<ERC20s> {
//     fn print(self: ERC20s) {
//         self.steel.print();
//         self.quartz.print();
//         self.tritium.print();
//     }
// }

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
    energy: ERC20s,
    digital: ERC20s,
    beam: ERC20s,
    armour: ERC20s,
    ion: ERC20s,
    plasma: ERC20s,
    weapons: ERC20s,
    shield: ERC20s,
    spacetime: ERC20s,
    combustion: ERC20s,
    thrust: ERC20s,
    warp: ERC20s,
}

#[derive(Drop, Serde)]
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
