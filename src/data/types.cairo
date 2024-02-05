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

#[derive(Copy, Default, Drop, Serde, PartialEq, AddEq, SubEq, Introspect, Clone, Debug)]
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

mod Names {
    const STEEL_MINE: felt252 = 1;
    const QUARTZ_MINE: felt252 = 2;
    const TRITIUM_MINE: felt252 = 3;
    const ENERGY_PLANT: felt252 = 4;
    const LAB: felt252 = 5;
    const DOCKYARD: felt252 = 6;
    const ENERGY_TECH: felt252 = 7;
    const DIGITAL: felt252 = 8;
    const BEAM_TECH: felt252 = 9;
    const ARMOUR: felt252 = 10;
    const ION: felt252 = 11;
    const PLASMA_TECH: felt252 = 12;
    const WEAPONS: felt252 = 13;
    const SHIELD: felt252 = 14;
    const SPACETIME: felt252 = 15;
    const COMBUSTION: felt252 = 16;
    const THRUST: felt252 = 17;
    const WARP: felt252 = 18;
    const CARRIER: felt252 = 19;
    const SCRAPER: felt252 = 20;
    const CELESTIA: felt252 = 21;
    const SPARROW: felt252 = 22;
    const FRIGATE: felt252 = 23;
    const ARMADE: felt252 = 24;
    const BLASTER: felt252 = 25;
    const BEAM: felt252 = 26;
    const ASTRAL: felt252 = 27;
    const PLASMA: felt252 = 28;
    const EXOCRAFT: felt252 = 29;
    const STEEL: felt252 = 30;
    const QUARTZ: felt252 = 31;
    const TRITIUM: felt252 = 32;
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

impl ERC20Print of PrintTrait<ERC20s> {
    fn print(self: ERC20s) {
        self.steel.print();
        self.quartz.print();
        self.tritium.print();
    }
}
