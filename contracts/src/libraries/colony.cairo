use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};
use nogame::data::types::{
    CompoundUpgradeType, DefenceBuildType, ShipBuildType, Resources, CompoundsLevels, Defences,
    Fleet
};
use nogame::libraries::{constants, names::Names, shared, compound, defence, dockyard};
use nogame::models::{
    colony::{
        ColonyCompounds, ColonyShips, ColonyDefences, ColonyCompoundTimer, ColonyDockyardTimer,
        ColonyDefenceTimer
    },
    game::GameSetup
};

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
    let time_now = starknet::get_block_timestamp();
    let queue_status = get!(world, (planet_id, colony_id), ColonyCompoundTimer).time_end;
    assert!(queue_status.is_zero(), "Colony: Already building compound");
    let game_speed = get!(world, constants::GAME_ID, GameSetup).speed;
    match component {
        CompoundUpgradeType::SteelMine => {
            cost = compound::cost::steel(compounds.steel, quantity);
            assert!(
                resource_available >= cost, "Colony: not enough resources to upgrade steel mine"
            );
            shared::pay_resources(world, planet_id, colony_id, resource_available, cost);
            let built_time = shared::build_time_is_seconds(
                cost.steel + cost.quartz, compounds.cybernetics, game_speed
            );
            set!(
                world,
                (
                    ColonyCompoundTimer {
                        planet_id,
                        colony_id,
                        name: component,
                        levels: quantity,
                        time_end: time_now + built_time
                    },
                )
            );
        },
        CompoundUpgradeType::QuartzMine => {
            cost = compound::cost::quartz(compounds.quartz, quantity);
            assert!(
                resource_available >= cost, "Colony: not enough resources to upgrade quartz mine"
            );
            shared::pay_resources(world, planet_id, colony_id, resource_available, cost);
            let built_time = shared::build_time_is_seconds(
                cost.steel + cost.quartz, compounds.cybernetics, game_speed
            );
            set!(
                world,
                (
                    ColonyCompoundTimer {
                        planet_id,
                        colony_id,
                        name: component,
                        levels: quantity,
                        time_end: time_now + built_time
                    },
                )
            );
        },
        CompoundUpgradeType::TritiumMine => {
            cost = compound::cost::tritium(compounds.tritium, quantity);
            assert!(
                resource_available >= cost, "Colony: not enough resources to upgrade tritium mine"
            );
            shared::pay_resources(world, planet_id, colony_id, resource_available, cost);
            let built_time = shared::build_time_is_seconds(
                cost.steel + cost.quartz, compounds.cybernetics, game_speed
            );
            set!(
                world,
                (
                    ColonyCompoundTimer {
                        planet_id,
                        colony_id,
                        name: component,
                        levels: quantity,
                        time_end: time_now + built_time
                    },
                )
            );
        },
        CompoundUpgradeType::EnergyPlant => {
            cost = compound::cost::energy(compounds.energy, quantity);
            assert!(
                resource_available >= cost, "Colony: not enough resources to upgrade energy mine"
            );
            shared::pay_resources(world, planet_id, colony_id, resource_available, cost);
            let built_time = shared::build_time_is_seconds(
                cost.steel + cost.quartz, compounds.cybernetics, game_speed
            );
            set!(
                world,
                (
                    ColonyCompoundTimer {
                        planet_id,
                        colony_id,
                        name: component,
                        levels: quantity,
                        time_end: time_now + built_time
                    },
                )
            );
        },
        CompoundUpgradeType::Lab => {},
        CompoundUpgradeType::Dockyard => {
            cost = compound::cost::dockyard(compounds.dockyard, quantity);
            assert!(resource_available >= cost, "Colony: not enough resources to upgrade dockyard");
            shared::pay_resources(world, planet_id, colony_id, resource_available, cost);
            let built_time = shared::build_time_is_seconds(
                cost.steel + cost.quartz, compounds.cybernetics, game_speed
            );
            set!(
                world,
                (
                    ColonyCompoundTimer {
                        planet_id,
                        colony_id,
                        name: component,
                        levels: quantity,
                        time_end: time_now + built_time
                    },
                )
            );
        },
        CompoundUpgradeType::Cybernetics => {
            cost = compound::cost::cybernetics(compounds.cybernetics, quantity);
            assert!(
                resource_available >= cost, "Colony: not enough resources to upgrade cybernetics"
            );
            shared::pay_resources(world, planet_id, colony_id, resource_available, cost);
            let built_time = shared::build_time_is_seconds(
                cost.steel + cost.quartz, compounds.cybernetics, game_speed
            );
            set!(
                world,
                (
                    ColonyCompoundTimer {
                        planet_id,
                        colony_id,
                        name: component,
                        levels: quantity,
                        time_end: time_now + built_time
                    },
                )
            );
        },
    }
    cost
}

fn complete_upgrade(world: IWorldDispatcher, planet_id: u32, colony_id: u8) {
    let time_now = starknet::get_block_timestamp();
    let queue_status = get!(world, (planet_id, colony_id), ColonyCompoundTimer);
    assert!(!queue_status.time_end.is_zero(), "Colony: No compound upgrade in progress");
    assert!(time_now >= queue_status.time_end, "Colony: Compound upgrade not finished");
    let compounds = get_colony_compounds(world, planet_id, colony_id);
    match queue_status.name {
        CompoundUpgradeType::SteelMine => {
            set!(
                world,
                (
                    ColonyCompounds {
                        planet_id,
                        colony_id,
                        name: Names::Compound::STEEL,
                        level: compounds.steel + queue_status.levels
                    },
                    ColonyCompoundTimer {
                        planet_id,
                        colony_id,
                        name: queue_status.name,
                        levels: Zeroable::zero(),
                        time_end: Zeroable::zero()
                    },
                )
            );
        },
        CompoundUpgradeType::QuartzMine => {
            set!(
                world,
                (
                    ColonyCompounds {
                        planet_id,
                        colony_id,
                        name: Names::Compound::QUARTZ,
                        level: compounds.quartz + queue_status.levels
                    },
                    ColonyCompoundTimer {
                        planet_id,
                        colony_id,
                        name: queue_status.name,
                        levels: Zeroable::zero(),
                        time_end: Zeroable::zero()
                    },
                )
            );
        },
        CompoundUpgradeType::TritiumMine => {
            set!(
                world,
                (
                    ColonyCompounds {
                        planet_id,
                        colony_id,
                        name: Names::Compound::TRITIUM,
                        level: compounds.tritium + queue_status.levels
                    },
                    ColonyCompoundTimer {
                        planet_id,
                        colony_id,
                        name: queue_status.name,
                        levels: Zeroable::zero(),
                        time_end: Zeroable::zero()
                    },
                )
            );
        },
        CompoundUpgradeType::EnergyPlant => {
            set!(
                world,
                (
                    ColonyCompounds {
                        planet_id,
                        colony_id,
                        name: Names::Compound::ENERGY,
                        level: compounds.energy + queue_status.levels
                    },
                    ColonyCompoundTimer {
                        planet_id,
                        colony_id,
                        name: queue_status.name,
                        levels: Zeroable::zero(),
                        time_end: Zeroable::zero()
                    },
                )
            );
        },
        CompoundUpgradeType::Lab => {},
        CompoundUpgradeType::Dockyard => {
            set!(
                world,
                (
                    ColonyCompounds {
                        planet_id,
                        colony_id,
                        name: Names::Compound::DOCKYARD,
                        level: compounds.dockyard + queue_status.levels
                    },
                    ColonyCompoundTimer {
                        planet_id,
                        colony_id,
                        name: queue_status.name,
                        levels: Zeroable::zero(),
                        time_end: Zeroable::zero()
                    },
                )
            );
        },
        CompoundUpgradeType::Cybernetics => {
            set!(
                world,
                (
                    ColonyCompounds {
                        planet_id,
                        colony_id,
                        name: Names::Compound::CYBERNETICS,
                        level: compounds.cybernetics + queue_status.levels
                    },
                    ColonyCompoundTimer {
                        planet_id,
                        colony_id,
                        name: queue_status.name,
                        levels: Zeroable::zero(),
                        time_end: Zeroable::zero()
                    },
                )
            );
        },
    }
}

fn build_ship(
    world: IWorldDispatcher, planet_id: u32, colony_id: u8, component: ShipBuildType, quantity: u32,
) -> Resources {
    let compounds = get_colony_compounds(world, planet_id, colony_id);
    shared::collect(world, planet_id, colony_id, compounds);
    let resource_available = shared::get_resources_available(world, planet_id, colony_id);
    let techs = shared::get_tech_levels(world, planet_id);
    let time_now = starknet::get_block_timestamp();
    let queue_status = get!(world, (planet_id, colony_id), ColonyDockyardTimer).time_end;
    assert!(time_now >= queue_status, "Colony: Already building ship");
    let game_speed = get!(world, constants::GAME_ID, GameSetup).speed;
    match component {
        ShipBuildType::Carrier => {
            let cost = dockyard::get_ships_cost(quantity, dockyard::get_ships_unit_cost().carrier);
            assert!(resource_available >= cost, "Colony Dockyard: Not enough resources");
            dockyard::carrier_requirements_check(compounds.dockyard, techs);
            shared::pay_resources(world, planet_id, colony_id, resource_available, cost);
            let built_time = shared::build_time_is_seconds(
                cost.steel + cost.quartz, compounds.dockyard, game_speed
            );
            set!(
                world,
                (
                    ColonyDockyardTimer {
                        planet_id,
                        colony_id,
                        name: component,
                        quantity,
                        time_end: time_now + built_time
                    },
                )
            );
            return cost;
        },
        ShipBuildType::Scraper => {
            let cost = dockyard::get_ships_cost(quantity, dockyard::get_ships_unit_cost().scraper);
            assert!(resource_available >= cost, "Colony Dockyard: Not enough resources");
            dockyard::scraper_requirements_check(compounds.dockyard, techs);
            shared::pay_resources(world, planet_id, colony_id, resource_available, cost);
            let built_time = shared::build_time_is_seconds(
                cost.steel + cost.quartz, compounds.dockyard, game_speed
            );
            set!(
                world,
                (
                    ColonyDockyardTimer {
                        planet_id,
                        colony_id,
                        name: component,
                        quantity,
                        time_end: time_now + built_time
                    },
                )
            );
            return cost;
        },
        ShipBuildType::Sparrow => {
            let cost = dockyard::get_ships_cost(quantity, dockyard::get_ships_unit_cost().sparrow);
            assert!(resource_available >= cost, "Colony Dockyard: Not enough resources");
            dockyard::sparrow_requirements_check(compounds.dockyard, techs);
            shared::pay_resources(world, planet_id, colony_id, resource_available, cost);
            let built_time = shared::build_time_is_seconds(
                cost.steel + cost.quartz, compounds.dockyard, game_speed
            );
            set!(
                world,
                (
                    ColonyDockyardTimer {
                        planet_id,
                        colony_id,
                        name: component,
                        quantity,
                        time_end: time_now + built_time
                    },
                )
            );
            return cost;
        },
        ShipBuildType::Frigate => {
            let cost = dockyard::get_ships_cost(quantity, dockyard::get_ships_unit_cost().frigate);
            assert!(resource_available >= cost, "Colony Dockyard: Not enough resources");
            dockyard::frigate_requirements_check(compounds.dockyard, techs);
            shared::pay_resources(world, planet_id, colony_id, resource_available, cost);
            let built_time = shared::build_time_is_seconds(
                cost.steel + cost.quartz, compounds.dockyard, game_speed
            );
            set!(
                world,
                (
                    ColonyDockyardTimer {
                        planet_id,
                        colony_id,
                        name: component,
                        quantity,
                        time_end: time_now + built_time
                    },
                )
            );
            return cost;
        },
        ShipBuildType::Armade => {
            let cost = dockyard::get_ships_cost(quantity, dockyard::get_ships_unit_cost().armade);
            assert!(resource_available >= cost, "Colony Dockyard: Not enough resources");
            dockyard::armade_requirements_check(compounds.dockyard, techs);
            shared::pay_resources(world, planet_id, colony_id, resource_available, cost);
            let built_time = shared::build_time_is_seconds(
                cost.steel + cost.quartz, compounds.dockyard, game_speed
            );
            set!(
                world,
                (
                    ColonyDockyardTimer {
                        planet_id,
                        colony_id,
                        name: component,
                        quantity,
                        time_end: time_now + built_time
                    },
                )
            );
            return cost;
        },
    }
}

fn complete_ship_build(world: IWorldDispatcher, planet_id: u32, colony_id: u8) {
    let time_now = starknet::get_block_timestamp();
    let queue_status = get!(world, (planet_id, colony_id), ColonyDockyardTimer);
    assert!(!queue_status.time_end.is_zero(), "Colony: No ship building in progress");
    assert!(time_now >= queue_status.time_end, "Colony: Ship build not finished");
    let ships = get_colony_ships(world, planet_id, colony_id);
    match queue_status.name {
        ShipBuildType::Carrier => {
            set!(
                world,
                (
                    ColonyShips {
                        planet_id,
                        colony_id,
                        name: Names::Fleet::CARRIER,
                        count: ships.carrier + queue_status.quantity
                    },
                    ColonyDockyardTimer {
                        planet_id,
                        colony_id,
                        name: queue_status.name,
                        quantity: Zeroable::zero(),
                        time_end: Zeroable::zero()
                    },
                )
            );
        },
        ShipBuildType::Scraper => {
            set!(
                world,
                (
                    ColonyShips {
                        planet_id,
                        colony_id,
                        name: Names::Fleet::SCRAPER,
                        count: ships.scraper + queue_status.quantity
                    },
                    ColonyDockyardTimer {
                        planet_id,
                        colony_id,
                        name: queue_status.name,
                        quantity: Zeroable::zero(),
                        time_end: Zeroable::zero()
                    },
                )
            );
        },
        ShipBuildType::Sparrow => {
            set!(
                world,
                (
                    ColonyShips {
                        planet_id,
                        colony_id,
                        name: Names::Fleet::SPARROW,
                        count: ships.sparrow + queue_status.quantity
                    },
                    ColonyDockyardTimer {
                        planet_id,
                        colony_id,
                        name: queue_status.name,
                        quantity: Zeroable::zero(),
                        time_end: Zeroable::zero()
                    },
                )
            );
        },
        ShipBuildType::Frigate => {
            set!(
                world,
                (
                    ColonyShips {
                        planet_id,
                        colony_id,
                        name: Names::Fleet::FRIGATE,
                        count: ships.frigate + queue_status.quantity
                    },
                    ColonyDockyardTimer {
                        planet_id,
                        colony_id,
                        name: queue_status.name,
                        quantity: Zeroable::zero(),
                        time_end: Zeroable::zero()
                    },
                )
            );
        },
        ShipBuildType::Armade => {
            set!(
                world,
                (
                    ColonyShips {
                        planet_id,
                        colony_id,
                        name: Names::Fleet::ARMADE,
                        count: ships.armade + queue_status.quantity
                    },
                    ColonyDockyardTimer {
                        planet_id,
                        colony_id,
                        name: queue_status.name,
                        quantity: Zeroable::zero(),
                        time_end: Zeroable::zero()
                    },
                )
            );
        },
    }
}

fn build_defence(
    world: IWorldDispatcher,
    planet_id: u32,
    colony_id: u8,
    component: DefenceBuildType,
    quantity: u32,
) -> Resources {
    let compounds = get_colony_compounds(world, planet_id, colony_id);
    let costs = defence::get_defences_unit_cost();
    shared::collect(world, planet_id, colony_id, compounds);
    let resource_available = shared::get_resources_available(world, planet_id, colony_id);
    let techs = shared::get_tech_levels(world, planet_id);
    let mut cost: Resources = Default::default();
    let time_now = starknet::get_block_timestamp();
    let queue_status = get!(world, (planet_id, colony_id), ColonyDefenceTimer).time_end;
    assert!(time_now >= queue_status, "Colony: Already building defence");
    let game_speed = get!(world, constants::GAME_ID, GameSetup).speed;
    match component {
        DefenceBuildType::Celestia => {
            cost = defence::get_defences_cost(quantity, costs.celestia);
            assert!(resource_available >= cost, "Colony Defence: Not enough resources");
            defence::requirements::celestia(compounds.dockyard, techs);
            shared::pay_resources(world, planet_id, colony_id, resource_available, cost);
            let built_time = shared::build_time_is_seconds(
                cost.steel + cost.quartz, compounds.dockyard, game_speed
            );
            set!(
                world,
                (
                    ColonyDefenceTimer {
                        planet_id,
                        colony_id,
                        name: component,
                        quantity,
                        time_end: time_now + built_time
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
            let built_time = shared::build_time_is_seconds(
                cost.steel + cost.quartz, compounds.dockyard, game_speed
            );
            set!(
                world,
                (
                    ColonyDefenceTimer {
                        planet_id,
                        colony_id,
                        name: component,
                        quantity,
                        time_end: time_now + built_time
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
            let built_time = shared::build_time_is_seconds(
                cost.steel + cost.quartz, compounds.dockyard, game_speed
            );
            set!(
                world,
                (
                    ColonyDefenceTimer {
                        planet_id,
                        colony_id,
                        name: component,
                        quantity,
                        time_end: time_now + built_time
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
            let built_time = shared::build_time_is_seconds(
                cost.steel + cost.quartz, compounds.dockyard, game_speed
            );
            set!(
                world,
                (
                    ColonyDefenceTimer {
                        planet_id,
                        colony_id,
                        name: component,
                        quantity,
                        time_end: time_now + built_time
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
            let built_time = shared::build_time_is_seconds(
                cost.steel + cost.quartz, compounds.dockyard, game_speed
            );
            set!(
                world,
                (
                    ColonyDefenceTimer {
                        planet_id,
                        colony_id,
                        name: component,
                        quantity,
                        time_end: time_now + built_time
                    },
                )
            );
            return cost;
        },
    }
    cost
}

fn complete_defence_build(world: IWorldDispatcher, planet_id: u32, colony_id: u8) {
    let time_now = starknet::get_block_timestamp();
    let queue_status = get!(world, (planet_id, colony_id), ColonyDefenceTimer);
    assert!(!queue_status.time_end.is_zero(), "Colony: No defence building in progress");
    assert!(time_now >= queue_status.time_end, "Colony: Defence build not finished");
    let defences = get_colony_defences(world, planet_id, colony_id);
    match queue_status.name {
        DefenceBuildType::Celestia => {
            set!(
                world,
                (
                    ColonyDefences {
                        planet_id,
                        colony_id,
                        name: Names::Defence::CELESTIA,
                        count: defences.celestia + queue_status.quantity
                    },
                    ColonyDefenceTimer {
                        planet_id,
                        colony_id,
                        name: queue_status.name,
                        quantity: Zeroable::zero(),
                        time_end: Zeroable::zero()
                    },
                )
            );
        },
        DefenceBuildType::Blaster => {
            set!(
                world,
                (
                    ColonyDefences {
                        planet_id,
                        colony_id,
                        name: Names::Defence::BLASTER,
                        count: defences.blaster + queue_status.quantity
                    },
                    ColonyDefenceTimer {
                        planet_id,
                        colony_id,
                        name: queue_status.name,
                        quantity: Zeroable::zero(),
                        time_end: Zeroable::zero()
                    },
                )
            );
        },
        DefenceBuildType::Beam => {
            set!(
                world,
                (
                    ColonyDefences {
                        planet_id,
                        colony_id,
                        name: Names::Defence::BEAM,
                        count: defences.beam + queue_status.quantity
                    },
                    ColonyDefenceTimer {
                        planet_id,
                        colony_id,
                        name: queue_status.name,
                        quantity: Zeroable::zero(),
                        time_end: Zeroable::zero()
                    },
                )
            );
        },
        DefenceBuildType::Astral => {
            set!(
                world,
                (
                    ColonyDefences {
                        planet_id,
                        colony_id,
                        name: Names::Defence::ASTRAL,
                        count: defences.astral + queue_status.quantity
                    },
                    ColonyDefenceTimer {
                        planet_id,
                        colony_id,
                        name: queue_status.name,
                        quantity: Zeroable::zero(),
                        time_end: Zeroable::zero()
                    },
                )
            );
        },
        DefenceBuildType::Plasma => {
            set!(
                world,
                (
                    ColonyDefences {
                        planet_id,
                        colony_id,
                        name: Names::Defence::PLASMA,
                        count: defences.plasma + queue_status.quantity
                    },
                    ColonyDefenceTimer {
                        planet_id,
                        colony_id,
                        name: queue_status.name,
                        quantity: Zeroable::zero(),
                        time_end: Zeroable::zero()
                    },
                )
            );
        },
    }
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
        cybernetics: get!(
            world, (planet_id, colony_id, Names::Compound::CYBERNETICS), ColonyCompounds
        )
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
