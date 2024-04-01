use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};
use nogame::data::types::{
    Resources, TechLevels, Debris, Fleet, Unit, Position, Defences, IncomingMission, Mission
};
use nogame::libraries::{shared, colony, dockyard, names::Names, defence, math};
use nogame::models::{
    colony::{ColonyShips, ColonyResource}, defence::PlanetDefences, dockyard::PlanetShips,
    fleet::{IncomingMissions, IncomingMissionLen, ActiveMissionLen, ActiveMission}
};
use nogame::planet::models::{PlanetResource, PlanetResourcesSpent};
use nogame_fixed::f128::core::{exp, sqrt, pow};
use nogame_fixed::f128::types::{Fixed, FixedTrait, ONE_u128 as ONE};

fn update_points_after_attack(
    world: IWorldDispatcher, planet_id: u32, fleet: Fleet, defences: Defences
) {
    let actual_id = if planet_id > 500 {
        planet_id / 1000
    } else {
        planet_id
    };

    if fleet.is_zero() && defences.is_zero() {
        return;
    }
    let ships_cost = dockyard::get_ships_unit_cost();
    let ships_points = fleet.carrier.into() * (ships_cost.carrier.steel + ships_cost.carrier.quartz)
        + fleet.scraper.into() * (ships_cost.scraper.steel + ships_cost.scraper.quartz)
        + fleet.sparrow.into() * (ships_cost.sparrow.steel + ships_cost.sparrow.quartz)
        + fleet.frigate.into() * (ships_cost.frigate.steel + ships_cost.frigate.quartz)
        + fleet.armade.into() * (ships_cost.armade.steel + ships_cost.armade.quartz);

    let defences_cost = defence::get_defences_unit_cost();
    let defences_points = defences.celestia.into() * 2000
        + defences.blaster.into() * (defences_cost.blaster.steel + defences_cost.blaster.quartz)
        + defences.beam.into() * (defences_cost.beam.steel + defences_cost.beam.quartz)
        + defences.astral.into() * (defences_cost.astral.steel + defences_cost.astral.quartz)
        + defences.plasma.into() * (defences_cost.plasma.steel + defences_cost.plasma.quartz);
    let current_spent = get!(world, actual_id, PlanetResourcesSpent).spent;
    let new_total_spent = if current_spent > (ships_points + defences_points) {
        current_spent - (ships_points + defences_points)
    } else {
        0
    };
    set!(world, PlanetResourcesSpent { planet_id: actual_id, spent: new_total_spent })
}

fn calculate_ships_loss(a: Fleet, b: Fleet) -> Fleet {
    Fleet {
        carrier: a.carrier - b.carrier,
        scraper: a.scraper - b.scraper,
        sparrow: a.sparrow - b.sparrow,
        frigate: a.frigate - b.frigate,
        armade: a.armade - b.armade,
    }
}

fn calculate_defences_loss(a: Defences, b: Defences) -> Defences {
    Defences {
        celestia: a.celestia - b.celestia,
        blaster: a.blaster - b.blaster,
        beam: a.beam - b.beam,
        astral: a.astral - b.astral,
        plasma: a.plasma - b.plasma,
    }
}

fn remove_incoming_mission(world: IWorldDispatcher, planet_id: u32, id_to_remove: usize) {
    let mut actual_id = planet_id;
    if planet_id > 500 {
        actual_id = planet_id / 1000;
    }
    let len = get!(world, actual_id, IncomingMissionLen).lenght;
    let mut i = 1;
    loop {
        if i > len {
            break;
        }
        let mission = get!(world, (actual_id, i), IncomingMissions).mission;
        if mission.id_at_origin == id_to_remove {
            set!(
                world,
                IncomingMissions { planet_id: actual_id, mission_id: i, mission: Zeroable::zero() }
            );
            break;
        }
        i += 1;
    }
}

fn fleet_return_planet(world: IWorldDispatcher, planet_id: u32, fleet: Fleet, cargo: Resources) {
    if planet_id > 500 {
        let mother_planet = planet_id / 1000;
        let colony_id: u8 = (planet_id % 1000).try_into().expect('fleet return planet fail');
        let fleet_levels = colony::get_colony_ships(world, mother_planet, colony_id);
        let resources = shared::get_resources_available(world, mother_planet, colony_id);
        if cargo.steel > 0 {
            set!(
                world,
                ColonyResource {
                    planet_id: mother_planet,
                    colony_id,
                    name: Names::Resource::STEEL,
                    amount: resources.steel + cargo.steel
                }
            );
        }
        if cargo.quartz > 0 {
            set!(
                world,
                ColonyResource {
                    planet_id: mother_planet,
                    colony_id,
                    name: Names::Resource::QUARTZ,
                    amount: resources.quartz + cargo.quartz
                }
            );
        }
        if cargo.tritium > 0 {
            set!(
                world,
                ColonyResource {
                    planet_id: mother_planet,
                    colony_id,
                    name: Names::Resource::TRITIUM,
                    amount: resources.tritium + cargo.tritium
                }
            );
        }
        if fleet.carrier > 0 {
            set!(
                world,
                ColonyShips {
                    planet_id: mother_planet,
                    colony_id,
                    name: Names::Fleet::CARRIER,
                    count: fleet_levels.carrier + fleet.carrier
                }
            );
        }
        if fleet.scraper > 0 {
            set!(
                world,
                ColonyShips {
                    planet_id: mother_planet,
                    colony_id,
                    name: Names::Fleet::SCRAPER,
                    count: fleet_levels.scraper + fleet.scraper
                }
            );
        }
        if fleet.sparrow > 0 {
            set!(
                world,
                ColonyShips {
                    planet_id: mother_planet,
                    colony_id,
                    name: Names::Fleet::SPARROW,
                    count: fleet_levels.sparrow + fleet.sparrow
                }
            );
        }
        if fleet.frigate > 0 {
            set!(
                world,
                ColonyShips {
                    planet_id: mother_planet,
                    colony_id,
                    name: Names::Fleet::FRIGATE,
                    count: fleet_levels.frigate + fleet.frigate
                }
            );
        }
        if fleet.armade > 0 {
            set!(
                world,
                ColonyShips {
                    planet_id: mother_planet,
                    colony_id,
                    name: Names::Fleet::ARMADE,
                    count: fleet_levels.armade + fleet.armade
                }
            );
        }
    } else {
        let fleet_levels = shared::get_ships_levels(world, planet_id);
        let resources = shared::get_resources_available(world, planet_id, 0);
        if cargo.steel > 0 {
            set!(
                world,
                PlanetResource {
                    planet_id, name: Names::Resource::STEEL, amount: resources.steel + cargo.steel
                }
            );
        }
        if cargo.quartz > 0 {
            set!(
                world,
                PlanetResource {
                    planet_id,
                    name: Names::Resource::QUARTZ,
                    amount: resources.quartz + cargo.quartz
                }
            );
        }
        if cargo.tritium > 0 {
            set!(
                world,
                PlanetResource {
                    planet_id,
                    name: Names::Resource::TRITIUM,
                    amount: resources.tritium + cargo.tritium
                }
            );
        }
        if fleet.carrier > 0 {
            set!(
                world,
                PlanetShips {
                    planet_id,
                    name: Names::Fleet::CARRIER,
                    count: fleet_levels.carrier + fleet.carrier
                }
            );
        }
        if fleet.scraper > 0 {
            set!(
                world,
                PlanetShips {
                    planet_id,
                    name: Names::Fleet::SCRAPER,
                    count: fleet_levels.scraper + fleet.scraper
                }
            );
        }
        if fleet.sparrow > 0 {
            set!(
                world,
                PlanetShips {
                    planet_id,
                    name: Names::Fleet::SPARROW,
                    count: fleet_levels.sparrow + fleet.sparrow
                }
            );
        }
        if fleet.frigate > 0 {
            set!(
                world,
                PlanetShips {
                    planet_id,
                    name: Names::Fleet::FRIGATE,
                    count: fleet_levels.frigate + fleet.frigate
                }
            );
        }
        if fleet.armade > 0 {
            set!(
                world,
                PlanetShips {
                    planet_id, name: Names::Fleet::ARMADE, count: fleet_levels.armade + fleet.armade
                }
            );
        }
    }
}


fn receive_loot(world: IWorldDispatcher, origin: u32, loot: Resources) {
    if origin > 500 {
        let mother_planet = origin / 1000;
        let colony_id: u8 = (origin % 1000).try_into().expect('receive loot fail');
        let available = shared::get_resources_available(world, mother_planet, colony_id);
        shared::receive_resources(world, mother_planet, colony_id, available, loot);
    } else {
        let available = shared::get_resources_available(world, origin, 0);
        shared::receive_resources(world, origin, 0, available, loot);
    }
}

fn process_loot_payment(world: IWorldDispatcher, destination_id: u32, loot: Resources,) {
    if destination_id > 500 {
        let mother_planet = destination_id / 1000;
        let colony_id: u8 = (destination_id % 1000).try_into().expect('process loot fail');
        let available = shared::get_resources_available(world, mother_planet, colony_id);
        shared::pay_resources(world, mother_planet, colony_id, available, loot);
    } else {
        let available = shared::get_resources_available(world, destination_id, 0);
        shared::pay_resources(world, destination_id, 0, available, loot);
    }
}

fn calculate_loot_amount(
    world: IWorldDispatcher, destination_id: u32, attacker_fleet: Fleet
) -> Resources {
    let mut loot: Resources = Default::default();
    let mut storage = get_fleet_cargo_capacity(attacker_fleet);
    let mut available: Resources = Default::default();

    if destination_id > 500 {
        let mother_planet = destination_id / 1000;
        let colony_id: u8 = (destination_id % 1000).try_into().expect('calculate loot fail');
        available = shared::get_resources_available(world, mother_planet, colony_id);
        let compounds = colony::get_colony_compounds(world, mother_planet, colony_id);
        shared::collect(world, mother_planet, colony_id, compounds);
    } else {
        let compounds = shared::get_compound_levels(world, destination_id);
        shared::collect(world, destination_id, 0, compounds);
        available = shared::get_resources_available(world, destination_id, 0);
    }

    if !available.is_zero() {
        loot.steel = available.steel / 2;
        loot.quartz = available.quartz / 2;
        loot.tritium = available.tritium / 2;
    }
    load_resources(loot, storage)
}

fn update_defender_fleet_levels_after_attack(
    world: IWorldDispatcher, planet_id: u32, fleet: Fleet
) {
    if planet_id > 500 {
        let planet_id = planet_id / 1000;
        let colony_id: u8 = (planet_id % 1000).try_into().unwrap();
        set!(
            world,
            ColonyShips { planet_id, colony_id, name: Names::Fleet::CARRIER, count: fleet.carrier }
        );
        set!(
            world,
            ColonyShips { planet_id, colony_id, name: Names::Fleet::SCRAPER, count: fleet.scraper }
        );
        set!(
            world,
            ColonyShips { planet_id, colony_id, name: Names::Fleet::SPARROW, count: fleet.sparrow }
        );
        set!(
            world,
            ColonyShips { planet_id, colony_id, name: Names::Fleet::FRIGATE, count: fleet.frigate }
        );
        set!(
            world,
            ColonyShips { planet_id, colony_id, name: Names::Fleet::ARMADE, count: fleet.armade }
        );
    } else {
        set!(world, PlanetShips { planet_id, name: Names::Fleet::CARRIER, count: fleet.carrier });
        set!(world, PlanetShips { planet_id, name: Names::Fleet::SCRAPER, count: fleet.scraper });
        set!(world, PlanetShips { planet_id, name: Names::Fleet::SPARROW, count: fleet.sparrow });
        set!(world, PlanetShips { planet_id, name: Names::Fleet::FRIGATE, count: fleet.frigate });
        set!(world, PlanetShips { planet_id, name: Names::Fleet::ARMADE, count: fleet.armade });
    }
}

fn update_defences_after_attack(world: IWorldDispatcher, planet_id: u32, defences: Defences) {
    set!(
        world,
        PlanetDefences { planet_id, name: Names::Defence::CELESTIA, count: defences.celestia }
    );
    set!(
        world, PlanetDefences { planet_id, name: Names::Defence::BLASTER, count: defences.blaster }
    );
    set!(world, PlanetDefences { planet_id, name: Names::Defence::BEAM, count: defences.beam });
    set!(world, PlanetDefences { planet_id, name: Names::Defence::ASTRAL, count: defences.astral });
    set!(world, PlanetDefences { planet_id, name: Names::Defence::PLASMA, count: defences.plasma });
}

fn get_fleet_and_defences_before_battle(
    world: IWorldDispatcher, planet_id: u32
) -> (Fleet, Defences, TechLevels) {
    let mut fleet: Fleet = Default::default();
    let mut defences: Defences = Default::default();
    let mut techs: TechLevels = Default::default();
    // let mut celestia = 0;
    if planet_id > 500 {
        let colony_id = (planet_id % 1000).try_into().unwrap();
        let colony_mother_planet = planet_id / 1000;
        fleet = colony::get_colony_ships(world, colony_mother_planet, colony_id);
        defences = colony::get_colony_defences(world, colony_mother_planet, colony_id);
        techs = shared::get_tech_levels(world, colony_mother_planet);
    } else {
        fleet = shared::get_ships_levels(world, planet_id);
        defences = shared::get_defences_levels(world, planet_id);
        techs = shared::get_tech_levels(world, planet_id);
    }
    (fleet, defences, techs)
}

fn check_enough_ships(world: IWorldDispatcher, planet_id: u32, colony_id: u8, fleet: Fleet) {
    if colony_id == 0 {
        let ships_levels = shared::get_ships_levels(world, planet_id);
        assert!(ships_levels >= fleet, "Fleet: not enough ships for mission");
    } else {
        let ships_levels = colony::get_colony_ships(world, planet_id, colony_id);
        assert!(ships_levels >= fleet, "Fleet: not enough ships for mission");
    }
}

fn add_active_mission(world: IWorldDispatcher, planet_id: u32, mut mission: Mission) -> usize {
    let len = get!(world, planet_id, ActiveMissionLen).lenght;
    let mut i = 1;
    loop {
        if i > len {
            mission.id = i.try_into().expect('add active mission fail');
            set!(world, ActiveMission { planet_id, mission_id: i, mission });
            set!(world, ActiveMissionLen { planet_id, lenght: i });
            break;
        }
        let read_mission = get!(world, (planet_id, i), ActiveMission).mission;
        if read_mission.is_zero() {
            mission.id = i.try_into().expect('add active mission fail');
            set!(world, ActiveMission { planet_id, mission_id: i, mission });
            break;
        }
        i += 1;
    };
    i
}

fn add_incoming_mission(world: IWorldDispatcher, planet_id: u32, mission: IncomingMission) {
    let len = get!(world, planet_id, IncomingMissionLen).lenght;
    let mut i = 1;
    loop {
        if i > len {
            set!(world, IncomingMissions { planet_id, mission_id: i, mission });
            set!(world, IncomingMissionLen { planet_id, lenght: i });
            break;
        }
        let read_mission = get!(world, (planet_id, i), IncomingMissions).mission;
        if read_mission.is_zero() {
            set!(world, IncomingMissions { planet_id, mission_id: i, mission });
            break;
        }
        i += 1;
    };
}

fn get_is_noob_protected(world: IWorldDispatcher, planet1_id: u32, planet2_id: u32) -> bool {
    let p1_points = get!(world, planet1_id, PlanetResourcesSpent).spent;
    let p2_points = get!(world, planet2_id, PlanetResourcesSpent).spent;
    if p1_points > p2_points {
        return p1_points > p2_points * 5;
    } else {
        return p2_points > p1_points * 5;
    }
}

fn fleet_leave_planet(
    world: IWorldDispatcher, planet_id: u32, colony_id: u8, fleet: Fleet, cargo: Resources
) {
    let resources = shared::get_resources_available(world, planet_id, colony_id);
    if !colony_id.is_zero() {
        let fleet_levels = colony::get_colony_ships(world, planet_id, colony_id);
        if cargo.steel > 0 {
            assert!(resources.steel >= cargo.steel, "Fleet: not enough steel for mission");
            set!(
                world,
                ColonyResource {
                    planet_id,
                    colony_id,
                    name: Names::Resource::STEEL,
                    amount: resources.steel - cargo.steel
                }
            );
        }
        if cargo.quartz > 0 {
            assert!(resources.quartz >= cargo.quartz, "Fleet: not enough quartz for mission");
            set!(
                world,
                ColonyResource {
                    planet_id,
                    colony_id,
                    name: Names::Resource::QUARTZ,
                    amount: resources.quartz - cargo.quartz
                }
            );
        }
        if cargo.tritium > 0 {
            assert!(resources.tritium >= cargo.tritium, "Fleet: not enough tritium for mission");
            set!(
                world,
                ColonyResource {
                    planet_id,
                    colony_id,
                    name: Names::Resource::TRITIUM,
                    amount: resources.tritium - cargo.tritium
                }
            );
        }
        if fleet.carrier > 0 {
            set!(
                world,
                ColonyShips {
                    planet_id,
                    colony_id,
                    name: Names::Fleet::CARRIER,
                    count: fleet_levels.carrier - fleet.carrier
                }
            );
        }
        if fleet.scraper > 0 {
            set!(
                world,
                ColonyShips {
                    planet_id,
                    colony_id,
                    name: Names::Fleet::SCRAPER,
                    count: fleet_levels.scraper - fleet.scraper
                }
            );
        }
        if fleet.sparrow > 0 {
            set!(
                world,
                ColonyShips {
                    planet_id,
                    colony_id,
                    name: Names::Fleet::SPARROW,
                    count: fleet_levels.sparrow - fleet.sparrow
                }
            );
        }
        if fleet.frigate > 0 {
            set!(
                world,
                ColonyShips {
                    planet_id,
                    colony_id,
                    name: Names::Fleet::FRIGATE,
                    count: fleet_levels.frigate - fleet.frigate
                }
            );
        }
        if fleet.armade > 0 {
            set!(
                world,
                ColonyShips {
                    planet_id,
                    colony_id,
                    name: Names::Fleet::ARMADE,
                    count: fleet_levels.armade - fleet.armade
                }
            );
        }
    } else {
        let fleet_levels = shared::get_ships_levels(world, planet_id);
        if cargo.steel > 0 {
            assert!(resources.steel >= cargo.steel, "Fleet: not enough steel for mission");
            set!(
                world,
                PlanetResource {
                    planet_id, name: Names::Resource::STEEL, amount: resources.steel - cargo.steel
                }
            );
        }
        if cargo.quartz > 0 {
            assert!(resources.quartz >= cargo.quartz, "Fleet: not enough quartz for mission");
            set!(
                world,
                PlanetResource {
                    planet_id,
                    name: Names::Resource::QUARTZ,
                    amount: resources.quartz - cargo.quartz
                }
            );
        }
        if cargo.tritium > 0 {
            assert!(resources.tritium >= cargo.tritium, "Fleet: not enough tritium for mission");
            set!(
                world,
                PlanetResource {
                    planet_id,
                    name: Names::Resource::TRITIUM,
                    amount: resources.tritium - cargo.tritium
                }
            );
        }
        if fleet.carrier > 0 {
            set!(
                world,
                PlanetShips {
                    planet_id,
                    name: Names::Fleet::CARRIER,
                    count: fleet_levels.carrier - fleet.carrier
                }
            );
        }
        if fleet.scraper > 0 {
            set!(
                world,
                PlanetShips {
                    planet_id,
                    name: Names::Fleet::SCRAPER,
                    count: fleet_levels.scraper - fleet.scraper
                }
            );
        }
        if fleet.sparrow > 0 {
            set!(
                world,
                PlanetShips {
                    planet_id,
                    name: Names::Fleet::SPARROW,
                    count: fleet_levels.sparrow - fleet.sparrow
                }
            );
        }
        if fleet.frigate > 0 {
            set!(
                world,
                PlanetShips {
                    planet_id,
                    name: Names::Fleet::FRIGATE,
                    count: fleet_levels.frigate - fleet.frigate
                }
            );
            if fleet.armade > 0 {
                set!(
                    world,
                    PlanetShips {
                        planet_id,
                        name: Names::Fleet::ARMADE,
                        count: fleet_levels.armade - fleet.armade
                    }
                );
            }
        }
    }
}

fn CARRIER() -> Unit {
    Unit { id: 0, weapon: 50, shield: 10, hull: 1000, speed: 5000, cargo: 10000, consumption: 10 }
}

fn SCRAPER() -> Unit {
    Unit { id: 1, weapon: 50, shield: 10, hull: 4000, speed: 2000, cargo: 20000, consumption: 300 }
}

// weapon: 20, shield: 500, hull: 5
// 5_000
fn SPARROW() -> Unit {
    Unit { id: 2, weapon: 250, shield: 10, hull: 1000, speed: 12500, cargo: 50, consumption: 20 }
}

// 34_000
fn FRIGATE() -> Unit {
    Unit { id: 3, weapon: 1700, shield: 70, hull: 6900, speed: 15000, cargo: 800, consumption: 300 }
}

// 75000
fn ARMADE() -> Unit {
    Unit {
        id: 4, weapon: 3750, shield: 150, hull: 15000, speed: 10000, cargo: 1500, consumption: 500
    }
}

fn CELESTIA() -> Unit {
    Unit { id: 5, weapon: 1, shield: 1, hull: 500, speed: 0, cargo: 0, consumption: 0 }
}

// weapon: 16, shield: 400, hull: 4
// 2_000
fn BLASTER() -> Unit {
    Unit { id: 6, weapon: 125, shield: 5, hull: 500, speed: 0, cargo: 0, consumption: 0 }
}

// 10_000
fn BEAM() -> Unit {
    Unit { id: 7, weapon: 625, shield: 25, hull: 2500, speed: 0, cargo: 0, consumption: 0 }
}

// 50_000
fn ASTRAL() -> Unit {
    Unit { id: 8, weapon: 3125, shield: 125, hull: 12500, speed: 0, cargo: 0, consumption: 0 }
}

// 150_000
fn PLASMA() -> Unit {
    Unit { id: 9, weapon: 9375, shield: 375, hull: 37500, speed: 0, cargo: 0, consumption: 0 }
}


fn war(
    mut attackers: Fleet,
    a_techs: TechLevels,
    mut defenders: Fleet,
    defences: Defences,
    d_techs: TechLevels
) -> (Fleet, Fleet, Defences) {
    let mut attackers = build_ships_array(attackers, Zeroable::zero(), a_techs);
    let mut defenders = build_ships_array(defenders, defences, d_techs);
    loop {
        if attackers.len().is_zero() || defenders.len().is_zero() {
            break;
        }
        let mut u1 = attackers.pop_front().unwrap();
        let mut u2 = defenders.pop_front().unwrap();
        let (u1, u2) = unit_combat(ref u1, ref u2);
        if u1.hull > 0 {
            attackers.append(u1);
        }
        if u2.hull > 0 {
            defenders.append(u2);
        }
    };
    let (attacker_fleet_struct, _) = build_fleet_struct(ref attackers, a_techs);
    let (defender_fleet_struct, defences_struct) = build_fleet_struct(ref defenders, d_techs);
    (attacker_fleet_struct, defender_fleet_struct, defences_struct)
}

fn unit_combat(ref unit1: Unit, ref unit2: Unit) -> (Unit, Unit) {
    if unit1.weapon < unit2.shield / 100 {
        unit2.shield = unit2.shield;
    } else if unit1.weapon < unit2.shield {
        unit2.shield -= unit1.weapon
    } else if unit2.hull < unit1.weapon - unit2.shield {
        unit2.hull = 0;
    } else {
        unit2.shield = 0;
        unit2.hull -= unit1.weapon - unit2.shield;
    }

    if unit2.weapon < unit1.shield / 100 {
        unit1.shield = unit1.shield;
    } else if unit2.weapon < unit1.shield {
        unit1.shield -= unit2.weapon
    } else if unit1.hull < unit2.weapon - unit1.shield {
        unit1.hull = 0;
    } else {
        unit1.shield = 0;
        unit1.hull -= unit2.weapon - unit1.shield;
    }
    (unit1, unit2)
}

fn rapid_fire(ref unit1: Unit, ref unit2: Unit) {
    if unit1.id == 3 && unit2.id == 2 {
        unit2.hull = 0
    }
}

fn build_fleet_struct(ref a: Array<Unit>, techs: TechLevels) -> (Fleet, Defences) {
    let mut fleet: Fleet = Default::default();
    let mut d: Defences = Default::default();
    loop {
        if a.len().is_zero() {
            break;
        }
        let u = a.pop_front().unwrap();
        if u.id == 0 {
            if u.hull > 0 {
                let unit_count = get_number_of_units_from_blob(u, techs);
                fleet.carrier += unit_count;
            }
        }
        if u.id == 1 {
            if u.hull > 0 {
                let unit_count = get_number_of_units_from_blob(u, techs);
                fleet.scraper += unit_count;
            }
        }
        if u.id == 2 {
            if u.hull > 0 {
                let unit_count = get_number_of_units_from_blob(u, techs);
                fleet.sparrow += unit_count;
            }
        }
        if u.id == 3 {
            if u.hull > 0 {
                let unit_count = get_number_of_units_from_blob(u, techs);
                fleet.frigate += unit_count;
            }
        }
        if u.id == 4 {
            if u.hull > 0 {
                let unit_count = get_number_of_units_from_blob(u, techs);
                fleet.armade += unit_count;
            }
        }
        if u.id == 5 {
            if u.hull > 0 {
                let unit_count = get_number_of_units_from_blob(u, techs);
                d.celestia += unit_count;
            }
        }
        if u.id == 6 {
            if u.hull > 0 {
                let unit_count = get_number_of_units_from_blob(u, techs);
                d.blaster += unit_count;
            }
        }
        if u.id == 7 {
            if u.hull > 0 {
                let unit_count = get_number_of_units_from_blob(u, techs);
                d.beam += unit_count;
            }
        }
        if u.id == 8 {
            if u.hull > 0 {
                let unit_count = get_number_of_units_from_blob(u, techs);
                d.astral += unit_count;
            }
        }
        if u.id == 9 {
            if u.hull > 0 {
                let unit_count = get_number_of_units_from_blob(u, techs);
                d.plasma += unit_count;
            }
        }
        continue;
    };
    (fleet, d)
}

fn build_ships_array(mut fleet: Fleet, mut defences: Defences, techs: TechLevels) -> Array<Unit> {
    let mut array: Array<Unit> = array![];

    if defences.plasma > 0 {
        let mut defence = PLASMA();
        add_techs(ref defence, techs);
        defence.hull *= defences.plasma;
        defence.shield *= defences.plasma;
        defence.weapon *= defences.plasma;
        array.append(defence);
    }
    if fleet.armade > 0 {
        let mut ship = ARMADE();
        add_techs(ref ship, techs);
        ship.hull *= fleet.armade;
        ship.shield *= fleet.armade;
        ship.weapon *= fleet.armade;
        array.append(ship);
    }
    if defences.astral > 0 {
        let mut defence = ASTRAL();
        add_techs(ref defence, techs);
        defence.hull *= defences.astral;
        defence.shield *= defences.astral;
        defence.weapon *= defences.astral;
        array.append(defence)
    }
    if fleet.frigate > 0 {
        let mut ship = FRIGATE();
        add_techs(ref ship, techs);
        ship.hull *= fleet.frigate;
        ship.shield *= fleet.frigate;
        ship.weapon *= fleet.frigate;
        array.append(ship);
    }
    if defences.beam > 0 {
        let mut defence = BEAM();
        add_techs(ref defence, techs);
        defence.hull *= defences.beam;
        defence.shield *= defences.beam;
        defence.weapon *= defences.beam;
        array.append(defence);
    }
    if fleet.sparrow > 0 {
        let mut ship = SPARROW();
        add_techs(ref ship, techs);
        ship.hull *= fleet.sparrow;
        ship.shield *= fleet.sparrow;
        ship.weapon *= fleet.sparrow;
        array.append(ship);
    }
    if defences.blaster > 0 {
        let mut defence = BLASTER();
        add_techs(ref defence, techs);
        defence.hull *= defences.blaster;
        defence.shield *= defences.blaster;
        defence.weapon *= defences.blaster;
        array.append(defence);
    }
    if fleet.scraper > 0 {
        let mut ship = SCRAPER();
        add_techs(ref ship, techs);
        ship.hull *= fleet.scraper;
        ship.shield *= fleet.scraper;
        ship.weapon *= fleet.scraper;
        array.append(ship);
    }
    if defences.celestia > 0 {
        let mut defence = CELESTIA();
        add_techs(ref defence, techs);
        defence.hull *= defences.celestia;
        defence.shield *= defences.celestia;
        defence.weapon *= defences.celestia;
        array.append(defence);
    }
    if fleet.carrier > 0 {
        let mut ship = CARRIER();
        add_techs(ref ship, techs);
        ship.hull *= fleet.carrier;
        ship.shield *= fleet.carrier;
        ship.weapon *= fleet.carrier;
        array.append(ship);
    }

    array
}

fn add_techs(ref unit: Unit, techs: TechLevels) {
    unit.weapon += unit.weapon * techs.weapons.into() / 10;
    unit.shield += unit.shield * techs.shield.into() / 10;
    unit.hull += unit.hull * techs.armour.into() / 10;
}

fn get_number_of_units_from_blob(blob: Unit, techs: TechLevels) -> u32 {
    if blob.id == 0 {
        let mut base_unit = CARRIER();
        add_techs(ref base_unit, techs);
        return blob.hull / base_unit.hull;
    }
    if blob.id == 1 {
        let mut base_unit = SCRAPER();
        add_techs(ref base_unit, techs);
        return blob.hull / base_unit.hull;
    }
    if blob.id == 2 {
        let mut base_unit = SPARROW();
        add_techs(ref base_unit, techs);
        return blob.hull / base_unit.hull;
    }
    if blob.id == 3 {
        let mut base_unit = FRIGATE();
        add_techs(ref base_unit, techs);
        return blob.hull / base_unit.hull;
    }
    if blob.id == 4 {
        let mut base_unit = ARMADE();
        add_techs(ref base_unit, techs);
        return blob.hull / base_unit.hull;
    }
    if blob.id == 5 {
        let mut base_unit = CELESTIA();
        add_techs(ref base_unit, techs);
        return blob.hull / base_unit.hull;
    }
    if blob.id == 6 {
        let mut base_unit = BLASTER();
        add_techs(ref base_unit, techs);
        return blob.hull / base_unit.hull;
    }
    if blob.id == 7 {
        let mut base_unit = BEAM();
        add_techs(ref base_unit, techs);
        return blob.hull / base_unit.hull;
    }
    if blob.id == 8 {
        let mut base_unit = ASTRAL();
        add_techs(ref base_unit, techs);
        return blob.hull / base_unit.hull;
    } else {
        let mut base_unit = PLASMA();
        add_techs(ref base_unit, techs);
        return blob.hull / base_unit.hull;
    }
}

fn get_fleet_speed(fleet: Fleet, techs: TechLevels) -> u32 {
    let mut min_speed = 4294967295;
    let combustion: u32 = techs.combustion.into();
    let thrust: u32 = techs.thrust.into();
    let spacetime: u32 = techs.spacetime.into();
    if fleet.carrier > 0 && thrust >= 4 {
        let base_speed = CARRIER().speed * 2;
        let level_diff = thrust - 4;
        let speed = base_speed + (base_speed * level_diff * 2) / 10;
        if speed < min_speed {
            min_speed = speed;
        }
    }
    if fleet.carrier > 0 && thrust < 4 {
        let base_speed = CARRIER().speed;
        let speed = base_speed + (base_speed * combustion) / 10;
        if speed < min_speed {
            min_speed = speed;
        }
    }
    if fleet.scraper > 0 {
        let base_speed = SCRAPER().speed;
        let speed = base_speed + (base_speed * combustion) / 10;
        if speed < min_speed {
            min_speed = speed;
        }
    }
    if fleet.sparrow > 0 {
        let base_speed = SPARROW().speed;
        let speed = base_speed + (base_speed * combustion) / 10;
        if speed < min_speed {
            min_speed = speed;
        }
    }
    if fleet.frigate > 0 {
        let base_speed = FRIGATE().speed;
        let level_diff = thrust - 4;
        let speed = base_speed + (base_speed * level_diff * 2) / 10;
        if speed < min_speed {
            min_speed = speed;
        }
    }
    if fleet.armade > 0 {
        let base_speed = ARMADE().speed;
        let level_diff = spacetime - 3;
        let speed = base_speed + (base_speed * level_diff * 3) / 10;
        if speed < min_speed {
            min_speed = speed;
        }
    }
    min_speed
}

// TODO: implement speed modifier.
fn get_flight_time(speed: u32, distance: u32, speed_percentage: u32) -> u64 {
    let f_speed = FixedTrait::new_unscaled(speed.into(), false);
    let f_distance = FixedTrait::new_unscaled(distance.into(), false);
    let multiplier = FixedTrait::new_unscaled(3500, false);
    let ten = FixedTrait::new_unscaled(10, false);
    let res = ten + multiplier * sqrt(FixedTrait::new_unscaled(10, false) * f_distance / f_speed);
    let speed_percentage = FixedTrait::new_unscaled(speed_percentage.into(), false)
        / FixedTrait::new_unscaled(100, false);
    let res = res / speed_percentage;
    (res.mag / ONE).try_into().expect('get flight time failed')
}


fn get_unit_consumption(ship: Unit, distance: u32, speed_percentage: u32) -> u128 {
    (FixedTrait::new_unscaled(1, false)
        + (FixedTrait::new_unscaled(ship.consumption.into(), false)
            * FixedTrait::new_unscaled(distance.into(), false)
            / FixedTrait::new_unscaled(35000, false))
            * pow(
                (FixedTrait::new_unscaled(speed_percentage.into(), false)
                    / FixedTrait::new_unscaled(100, false)
                    + FixedTrait::new_unscaled(1, false)),
                FixedTrait::new_unscaled(2, false)
            ))
        .mag
        / ONE
}

fn get_fuel_consumption(f: Fleet, distance: u32, speed_percentage: u32) -> u128 {
    f.carrier.into() * get_unit_consumption(CARRIER(), distance, speed_percentage)
        + f.scraper.into() * get_unit_consumption(SCRAPER(), distance, speed_percentage)
        + f.sparrow.into() * get_unit_consumption(SPARROW(), distance, speed_percentage)
        + f.frigate.into() * get_unit_consumption(FRIGATE(), distance, speed_percentage)
        + f.armade.into() * get_unit_consumption(ARMADE(), distance, speed_percentage)
}

fn get_distance(start: Position, end: Position) -> u32 {
    if start.system == end.system && start.orbit == end.orbit {
        return 5;
    }
    if start.system == end.system {
        if start.orbit > end.orbit {
            let dis: u32 = (start.orbit - end.orbit).into();
            return 1000 + 5 * dis;
        } else {
            let dis: u32 = (end.orbit - start.orbit).into();
            return 1000 + 5 * dis;
        }
    } else {
        if start.system > end.system {
            let dis: u32 = (start.system - end.system).into();
            return 2700 + 95 * dis;
        } else {
            let dis: u32 = (end.system - start.system).into();
            return 2700 + 95 * dis;
        }
    }
}

fn get_debris(f_before: Fleet, f_after: Fleet, celestia: u32) -> Debris {
    let mut debris: Debris = Default::default();
    let costs = dockyard::get_ships_unit_cost();
    let steel = ((f_before.carrier - f_after.carrier).into() * costs.carrier.steel)
        + ((f_before.scraper - f_after.scraper).into() * costs.scraper.steel)
        + ((f_before.sparrow - f_after.sparrow).into() * costs.sparrow.steel)
        + ((f_before.frigate - f_after.frigate).into() * costs.sparrow.steel)
        + ((f_before.armade - f_after.armade).into() * costs.sparrow.steel);

    let quartz = ((f_before.carrier - f_after.carrier).into() * costs.carrier.quartz)
        + ((f_before.scraper - f_after.scraper).into() * costs.scraper.quartz)
        + ((f_before.sparrow - f_after.sparrow).into() * costs.sparrow.quartz)
        + ((f_before.frigate - f_after.frigate).into() * costs.sparrow.quartz)
        + ((f_before.armade - f_after.armade).into() * costs.sparrow.quartz)
        + (celestia * 2000).into();

    debris.steel = steel / 3;
    debris.quartz = quartz / 3;
    debris
}


fn load_resources(mut resources: Resources, mut storage: u128) -> Resources {
    let mut steel_loaded = 0;
    let mut quartz_loaded = 0;
    let mut tritium_loaded = 0;

    loop {
        if storage.is_zero() || resources.is_zero() {
            break;
        }
        let steel_to_load = min(storage / 3, resources.steel);
        let quartz__to_load = min(storage / 3, resources.quartz);
        let tritium_to_load = min(storage / 3, resources.tritium);
        if (steel_to_load + quartz__to_load + tritium_to_load).is_zero() {
            break;
        }
        storage -= (steel_to_load + quartz__to_load + tritium_to_load);
        resources.steel -= steel_to_load;
        resources.quartz -= quartz__to_load;
        resources.tritium -= tritium_to_load;
        steel_loaded += steel_to_load;
        quartz_loaded += quartz__to_load;
        tritium_loaded += tritium_to_load;
    };

    Resources { steel: steel_loaded, quartz: quartz_loaded, tritium: tritium_loaded, }
}

fn min(a: u128, b: u128) -> u128 {
    if a < b {
        return a;
    }
    b
}

fn get_fleet_cargo_capacity(f: Fleet) -> u128 {
    (CARRIER().cargo * f.carrier
        + SCRAPER().cargo * f.scraper
        + SPARROW().cargo * f.sparrow
        + FRIGATE().cargo * f.frigate
        + ARMADE().cargo * f.armade)
        .into()
}

fn get_collectible_debris(cargo_capacity: u128, debris: Debris) -> Debris {
    let total_debris = debris.steel + debris.quartz;
    if cargo_capacity >= total_debris {
        return debris;
    }

    let half_capacity = cargo_capacity / 2;
    let mut collected_steel = math::min(debris.steel, half_capacity);
    let mut collected_quartz = math::min(debris.quartz, half_capacity);

    let remaining_capacity = cargo_capacity - collected_steel - collected_quartz;
    if collected_steel < half_capacity {
        collected_quartz += remaining_capacity;
    } else if collected_quartz < half_capacity {
        collected_steel += remaining_capacity;
    }
    return Debris { steel: collected_steel, quartz: collected_quartz };
}

const _0_02: u128 = 368934881474191000;

// loss = 100 * (1 - math.exp(-k * time_seconds / 60))
fn calculate_decay_loss(time_seconds: u64) -> u32 {
    ((FixedTrait::new_unscaled(100_u128, false)
        * (FixedTrait::new(ONE, false)
            - FixedTrait::exp(
                FixedTrait::new(_0_02, true)
                    * FixedTrait::new_unscaled(time_seconds.into(), false)
                    / FixedTrait::new_unscaled(60, false)
            )))
        .mag
        / ONE)
        .try_into()
        .expect('fleet loss calc failed')
}

fn decay_fleet(fleet: Fleet, decay_amount: u32) -> Fleet {
    let mut res: Fleet = Default::default();
    res.carrier = fleet.carrier * (100 - decay_amount) / 100;
    res.scraper = fleet.scraper * (100 - decay_amount) / 100;
    res.sparrow = fleet.sparrow * (100 - decay_amount) / 100;
    res.frigate = fleet.frigate * (100 - decay_amount) / 100;
    res.armade = fleet.armade * (100 - decay_amount) / 100;
    res
}

fn calculate_number_of_ships(fleet: Fleet, defences: Defences) -> u32 {
    fleet.carrier
        + fleet.scraper
        + fleet.sparrow
        + fleet.frigate
        + fleet.armade
        + defences.celestia
        + defences.blaster
        + defences.beam
        + defences.astral
        + defences.plasma
}
