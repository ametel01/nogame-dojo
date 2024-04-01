use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};
use nogame::data::types::{CompoundUpgradeType, DefenceBuildType, ShipBuildType, Resources, CompoundsLevels, Defences, Fleet};
use nogame::libraries::{names::Names, shared, compound,  defence};
use nogame::models::colony::{ColonyCompounds, ColonyShips, ColonyDefences};
use nogame::dockyard::library as dockyard;

fn upgrade_component(
    world: IWorldDispatcher,
    planet_id: u32,
    colony_id: u8,
    component: CompoundUpgradeType,
    quantity: u8
) -> Resources {
    let compounds = get_colony_compounds(world, planet_id, colony_id);
    shared::collect(world, planet_id, colony_id, compounds);
    let resource_available = shared::get_resources_available(world, planet_id, colony_id);
    let mut cost: Resources = Default::default();
    match component {
        CompoundUpgradeType::SteelMine => {
            cost = compound::cost::steel(compounds.steel, quantity);
            assert!(
                resource_available >= cost, "Colony: not enough resources to upgrade steel mine"
            );
            shared::pay_resources(world, planet_id, colony_id, resource_available, cost);
            set!(
                world,
                ColonyCompounds {
                    planet_id,
                    colony_id,
                    name: Names::Compound::STEEL,
                    level: compounds.steel + quantity
                }
            );
        },
        CompoundUpgradeType::QuartzMine => {
            cost = compound::cost::quartz(compounds.quartz, quantity);
            assert!(
                resource_available >= cost, "Colony: not enough resources to upgrade quartz mine"
            );
            shared::pay_resources(world, planet_id, colony_id, resource_available, cost);
            set!(
                world,
                ColonyCompounds {
                    planet_id,
                    colony_id,
                    name: Names::Compound::QUARTZ,
                    level: compounds.quartz + quantity
                }
            );
        },
        CompoundUpgradeType::TritiumMine => {
            cost = compound::cost::tritium(compounds.tritium, quantity);
            assert!(
                resource_available >= cost, "Colony: not enough resources to upgrade tritium mine"
            );
            shared::pay_resources(world, planet_id, colony_id, resource_available, cost);
            set!(
                world,
                ColonyCompounds {
                    planet_id,
                    colony_id,
                    name: Names::Compound::TRITIUM,
                    level: compounds.tritium + quantity
                }
            );
        },
        CompoundUpgradeType::EnergyPlant => {
            cost = compound::cost::energy(compounds.energy, quantity);
            assert!(
                resource_available >= cost, "Colony: not enough resources to upgrade energy plant"
            );
            shared::pay_resources(world, planet_id, colony_id, resource_available, cost);
            set!(
                world,
                ColonyCompounds {
                    planet_id,
                    colony_id,
                    name: Names::Compound::ENERGY,
                    level: compounds.energy + quantity
                }
            );
        },
        CompoundUpgradeType::Lab => {},
        CompoundUpgradeType::Dockyard => {
            cost = compound::cost::dockyard(compounds.dockyard, quantity);
            assert!(resource_available >= cost, "Colony: not enough resources to upgrade dockyard");
            shared::pay_resources(world, planet_id, colony_id, resource_available, cost);
            set!(
                world,
                ColonyCompounds {
                    planet_id,
                    colony_id,
                    name: Names::Compound::DOCKYARD,
                    level: compounds.dockyard + quantity
                }
            );
        },
    }
    cost
}

fn build_ship(
    world: IWorldDispatcher, planet_id: u32, colony_id: u8, component: ShipBuildType, quantity: u32,
) -> Resources {
    let compounds = get_colony_compounds(world, planet_id, colony_id);
    let ships_levels = get_colony_ships(world, planet_id, colony_id);
    shared::collect(world, planet_id, colony_id, compounds);
    let resource_available = shared::get_resources_available(world, planet_id, colony_id);
    let techs = shared::get_tech_levels(world, planet_id);
    let mut cost: Resources = Default::default();
    match component {
        ShipBuildType::Carrier => {
            cost = dockyard::get_ships_cost(quantity, dockyard::get_ships_unit_cost().carrier);
            assert!(resource_available >= cost, "Colony Dockyard: Not enough resources");
            dockyard::carrier_requirements_check(compounds.dockyard, techs);
            shared::pay_resources(world, planet_id, colony_id, resource_available, cost);
            set!(
                world,
                (
                    ColonyShips {
                        planet_id,
                        colony_id,
                        name: Names::Fleet::CARRIER,
                        count: ships_levels.carrier + quantity
                    },
                )
            );
            return cost;
        },
        ShipBuildType::Scraper => {
            cost = dockyard::get_ships_cost(quantity, dockyard::get_ships_unit_cost().scraper);
            assert!(resource_available >= cost, "Colony Dockyard: Not enough resources");
            dockyard::scraper_requirements_check(compounds.dockyard, techs);
            shared::pay_resources(world, planet_id, colony_id, resource_available, cost);
            set!(
                world,
                (
                    ColonyShips {
                        planet_id,
                        colony_id,
                        name: Names::Fleet::SCRAPER,
                        count: ships_levels.scraper + quantity
                    },
                )
            );
            return cost;
        },
        ShipBuildType::Sparrow => {
            cost = dockyard::get_ships_cost(quantity, dockyard::get_ships_unit_cost().sparrow);
            assert!(resource_available >= cost, "Colony Dockyard: Not enough resources");
            dockyard::sparrow_requirements_check(compounds.dockyard, techs);
            shared::pay_resources(world, planet_id, colony_id, resource_available, cost);
            set!(
                world,
                (
                    ColonyShips {
                        planet_id,
                        colony_id,
                        name: Names::Fleet::SPARROW,
                        count: ships_levels.sparrow + quantity
                    },
                )
            );
            return cost;
        },
        ShipBuildType::Frigate => {
            cost = dockyard::get_ships_cost(quantity, dockyard::get_ships_unit_cost().frigate);
            assert!(resource_available >= cost, "Colony Dockyard: Not enough resources");
            dockyard::frigate_requirements_check(compounds.dockyard, techs);
            shared::pay_resources(world, planet_id, colony_id, resource_available, cost);
            set!(
                world,
                (
                    ColonyShips {
                        planet_id,
                        colony_id,
                        name: Names::Fleet::FRIGATE,
                        count: ships_levels.frigate + quantity
                    },
                )
            );
            return cost;
        },
        ShipBuildType::Armade => {
            cost = dockyard::get_ships_cost(quantity, dockyard::get_ships_unit_cost().armade);
            assert!(resource_available >= cost, "Colony Dockyard: Not enough resources");
            dockyard::armade_requirements_check(compounds.dockyard, techs);
            shared::pay_resources(world, planet_id, colony_id, resource_available, cost);
            set!(
                world,
                (
                    ColonyShips {
                        planet_id,
                        colony_id,
                        name: Names::Fleet::ARMADE,
                        count: ships_levels.armade + quantity
                    },
                )
            );
            return cost;
        },
    }
    cost
}

fn build_defence(
    world: IWorldDispatcher,
    planet_id: u32,
    colony_id: u8,
    component: DefenceBuildType,
    quantity: u32,
) -> Resources {
    let compounds = get_colony_compounds(world, planet_id, colony_id);
    let defences_levels = get_colony_defences(world, planet_id, colony_id);
    let costs = defence::get_defences_unit_cost();
    shared::collect(world, planet_id, colony_id, compounds);
    let resource_available = shared::get_resources_available(world, planet_id, colony_id);
    let techs = shared::get_tech_levels(world, planet_id);
    let mut cost: Resources = Default::default();
    match component {
        DefenceBuildType::Celestia => {
            cost = defence::get_defences_cost(quantity, costs.celestia);
            assert!(resource_available >= cost, "Colony Defence: Not enough resources");
            defence::requirements::celestia(compounds.dockyard, techs);
            shared::pay_resources(world, planet_id, colony_id, resource_available, cost);
            set!(
                world,
                (
                    ColonyDefences {
                        planet_id,
                        colony_id,
                        name: Names::Defence::CELESTIA,
                        count: defences_levels.celestia + quantity
                    },
                )
            );
            return cost;
        },
        DefenceBuildType::Blaster => {
            cost = defence::get_defences_cost(quantity, costs.blaster);
            assert!(resource_available >= cost, "Colony Defence: Not enough resources");
            defence::requirements::blaster(compounds.dockyard, techs);
            shared::pay_resources(world, planet_id, colony_id, resource_available, cost);
            set!(
                world,
                (
                    ColonyDefences {
                        planet_id,
                        colony_id,
                        name: Names::Defence::BLASTER,
                        count: defences_levels.blaster + quantity
                    },
                )
            );
            return cost;
        },
        DefenceBuildType::Beam => {
            cost = defence::get_defences_cost(quantity, costs.beam);
            assert!(resource_available >= cost, "Colony Defence: Not enough resources");
            defence::requirements::beam(compounds.dockyard, techs);
            shared::pay_resources(world, planet_id, colony_id, resource_available, cost);
            set!(
                world,
                (
                    ColonyDefences {
                        planet_id,
                        colony_id,
                        name: Names::Defence::BEAM,
                        count: defences_levels.beam + quantity
                    },
                )
            );
            return cost;
        },
        DefenceBuildType::Astral => {
            cost = defence::get_defences_cost(quantity, costs.astral);
            assert!(resource_available >= cost, "Colony Defence: Not enough resources");
            defence::requirements::astral(compounds.dockyard, techs);
            shared::pay_resources(world, planet_id, colony_id, resource_available, cost);
            set!(
                world,
                (
                    ColonyDefences {
                        planet_id,
                        colony_id,
                        name: Names::Defence::ASTRAL,
                        count: defences_levels.astral + quantity
                    },
                )
            );
            return cost;
        },
        DefenceBuildType::Plasma => {
            cost = defence::get_defences_cost(quantity, costs.plasma);
            assert!(resource_available >= cost, "Colony Defence: Not enough resources");
            defence::requirements::plasma(compounds.dockyard, techs);
            shared::pay_resources(world, planet_id, colony_id, resource_available, cost);
            set!(
                world,
                (
                    ColonyDefences {
                        planet_id,
                        colony_id,
                        name: Names::Defence::PLASMA,
                        count: defences_levels.plasma + quantity
                    },
                )
            );
            return cost;
        },
    }
    cost
}

fn get_colony_compounds(world: IWorldDispatcher, planet_id: u32, colony_id: u8) -> CompoundsLevels {
    CompoundsLevels {
        steel: get!(world, (planet_id, colony_id, Names::Compound::STEEL), ColonyCompounds).level,
        quartz: get!(world, (planet_id, colony_id, Names::Compound::QUARTZ), ColonyCompounds).level,
        tritium: get!(world, (planet_id, colony_id, Names::Compound::TRITIUM), ColonyCompounds)
            .level,
        energy: get!(world, (planet_id, colony_id, Names::Compound::ENERGY), ColonyCompounds).level,
        lab: 0,
        dockyard: get!(world, (planet_id, colony_id, Names::Compound::DOCKYARD), ColonyCompounds)
            .level,
    }
}

fn get_colony_ships(world: IWorldDispatcher, planet_id: u32, colony_id: u8) -> Fleet {
    Fleet {
        carrier: get!(world, (planet_id, colony_id, Names::Fleet::CARRIER), ColonyShips).count,
        scraper: get!(world, (planet_id, colony_id, Names::Fleet::SCRAPER), ColonyShips).count,
        sparrow: get!(world, (planet_id, colony_id, Names::Fleet::SPARROW), ColonyShips).count,
        frigate: get!(world, (planet_id, colony_id, Names::Fleet::FRIGATE), ColonyShips).count,
        armade: get!(world, (planet_id, colony_id, Names::Fleet::ARMADE), ColonyShips).count,
    }
}

fn get_colony_defences(world: IWorldDispatcher, planet_id: u32, colony_id: u8) -> Defences {
    Defences {
        celestia: get!(world, (planet_id, colony_id, Names::Defence::CELESTIA), ColonyDefences)
            .count,
        blaster: get!(world, (planet_id, colony_id, Names::Defence::BLASTER), ColonyDefences).count,
        beam: get!(world, (planet_id, colony_id, Names::Defence::BEAM), ColonyDefences).count,
        astral: get!(world, (planet_id, colony_id, Names::Defence::ASTRAL), ColonyDefences).count,
        plasma: get!(world, (planet_id, colony_id, Names::Defence::PLASMA), ColonyDefences).count,
    }
}
