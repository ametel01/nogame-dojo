use dojo::world::{IWorldDispatcherTrait, IWorldDispatcher};
use nogame::data::types::{TechLevels, ShipsCost, Resources, ShipBuildType};
use nogame::libraries::shared;
use nogame::libraries::{constants, names::Names};
use nogame::models::{dockyard::{PlanetDockyardTimer, PlanetShips}, game::GameSetup};

fn build_component(
    world: IWorldDispatcher, planet_id: u32, component: ShipBuildType, quantity: u32
) -> Resources {
    let techs = shared::get_tech_levels(world, planet_id);
    let compounds = shared::get_compound_levels(world, planet_id);
    shared::collect(world, planet_id, 0, compounds);
    let available_resources = shared::get_resources_available(world, planet_id, 0);
    let time_now = starknet::get_block_timestamp();
    let queue_status = get!(world, planet_id, PlanetDockyardTimer).time_end;
    assert!(time_now >= queue_status, "Dockyard: Already building");
    let game_speed = get!(world, constants::GAME_ID, GameSetup).speed;
    match component {
        ShipBuildType::Carrier => {
            let cost = get_ships_cost(quantity, get_ships_unit_cost().carrier);
            assert!(available_resources >= cost, "Dockyard: Not enough resources");
            carrier_requirements_check(compounds.dockyard, techs);
            shared::pay_resources(world, planet_id, 0, available_resources, cost);
            let built_time = shared::build_time_is_seconds(
                cost.steel + cost.quartz, compounds.cybernetics, game_speed
            );
            set!(
                world,
                (
                    PlanetDockyardTimer {
                        planet_id, name: component, quantity, time_end: time_now + built_time
                    },
                )
            );
            return cost;
        },
        ShipBuildType::Scraper => {
            let cost = get_ships_cost(quantity, get_ships_unit_cost().scraper);
            assert!(available_resources >= cost, "Dockyard: Not enough resources");
            scraper_requirements_check(compounds.dockyard, techs);
            shared::pay_resources(world, planet_id, 0, available_resources, cost);
            let built_time = shared::build_time_is_seconds(
                cost.steel + cost.quartz, compounds.cybernetics, game_speed
            );
            set!(
                world,
                (
                    PlanetDockyardTimer {
                        planet_id, name: component, quantity, time_end: time_now + built_time
                    },
                )
            );
            return cost;
        },
        ShipBuildType::Sparrow => {
            let cost = get_ships_cost(quantity, get_ships_unit_cost().sparrow);
            assert!(available_resources >= cost, "Dockyard: Not enough resources");
            sparrow_requirements_check(compounds.dockyard, techs);
            shared::pay_resources(world, planet_id, 0, available_resources, cost);
            let built_time = shared::build_time_is_seconds(
                cost.steel + cost.quartz, compounds.cybernetics, game_speed
            );
            set!(
                world,
                (
                    PlanetDockyardTimer {
                        planet_id, name: component, quantity, time_end: time_now + built_time
                    },
                )
            );
            return cost;
        },
        ShipBuildType::Frigate => {
            let cost = get_ships_cost(quantity, get_ships_unit_cost().frigate);
            assert!(available_resources >= cost, "Dockyard: Not enough resources");
            frigate_requirements_check(compounds.dockyard, techs);
            shared::pay_resources(world, planet_id, 0, available_resources, cost);
            let built_time = shared::build_time_is_seconds(
                cost.steel + cost.quartz, compounds.cybernetics, game_speed
            );
            set!(
                world,
                (
                    PlanetDockyardTimer {
                        planet_id, name: component, quantity, time_end: time_now + built_time
                    },
                )
            );
            return cost;
        },
        ShipBuildType::Armade => {
            let cost = get_ships_cost(quantity, get_ships_unit_cost().armade);
            assert!(available_resources >= cost, "Dockyard: Not enough resources");
            armade_requirements_check(compounds.dockyard, techs);
            shared::pay_resources(world, planet_id, 0, available_resources, cost);
            let built_time = shared::build_time_is_seconds(
                cost.steel + cost.quartz, compounds.cybernetics, game_speed
            );
            set!(
                world,
                (
                    PlanetDockyardTimer {
                        planet_id, name: component, quantity, time_end: time_now + built_time
                    },
                )
            );
            return cost;
        },
    }
}

fn complete_build(world: IWorldDispatcher, planet_id: u32) {
    let time_now = starknet::get_block_timestamp();
    let queue_status = get!(world, planet_id, PlanetDockyardTimer);
    assert!(!queue_status.time_end.is_zero(), "Dockyard: No builds in progress");
    assert!(time_now >= queue_status.time_end, "Dockyard: Build process not finished");
    let ships = shared::get_ships_levels(world, planet_id);
    match queue_status.name {
        ShipBuildType::Carrier => {
            set!(
                world,
                (
                    PlanetShips {
                        planet_id,
                        name: Names::Fleet::CARRIER,
                        count: ships.carrier + queue_status.quantity
                    },
                    PlanetDockyardTimer {
                        planet_id,
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
                    PlanetShips {
                        planet_id,
                        name: Names::Fleet::SCRAPER,
                        count: ships.scraper + queue_status.quantity
                    },
                    PlanetDockyardTimer {
                        planet_id,
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
                    PlanetShips {
                        planet_id,
                        name: Names::Fleet::SPARROW,
                        count: ships.sparrow + queue_status.quantity
                    },
                    PlanetDockyardTimer {
                        planet_id,
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
                    PlanetShips {
                        planet_id,
                        name: Names::Fleet::FRIGATE,
                        count: ships.frigate + queue_status.quantity
                    },
                    PlanetDockyardTimer {
                        planet_id,
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
                    PlanetShips {
                        planet_id,
                        name: Names::Fleet::ARMADE,
                        count: ships.armade + queue_status.quantity
                    },
                    PlanetDockyardTimer {
                        planet_id,
                        name: queue_status.name,
                        quantity: Zeroable::zero(),
                        time_end: Zeroable::zero()
                    },
                )
            );
        },
    }
}

fn get_ships_cost(quantity: u32, cost: Resources) -> Resources {
    Resources {
        steel: (cost.steel * quantity.into()),
        quartz: (cost.quartz * quantity.into()),
        tritium: (cost.tritium * quantity.into())
    }
}

fn get_ships_unit_cost() -> ShipsCost {
    ShipsCost {
        carrier: Resources { steel: 2000, quartz: 2000, tritium: 0 },
        celestia: Resources { steel: 0, quartz: 2000, tritium: 500 },
        scraper: Resources { steel: 10000, quartz: 6000, tritium: 2000 },
        sparrow: Resources { steel: 3000, quartz: 1000, tritium: 0 },
        frigate: Resources { steel: 20000, quartz: 7000, tritium: 2000 },
        armade: Resources { steel: 45000, quartz: 15000, tritium: 0 }
    }
}

fn carrier_requirements_check(dockyard_level: u8, techs: TechLevels) {
    assert(dockyard_level >= 2, 'Dockyard 2 required');
    assert(techs.combustion >= 2, 'Combustive Engine 2 required');
}

fn sparrow_requirements_check(dockyard_level: u8, techs: TechLevels) {
    assert(dockyard_level >= 1, 'Dockyard 1 required');
    assert(techs.combustion >= 1, 'Combustive Engine 1 required');
}

fn scraper_requirements_check(dockyard_level: u8, techs: TechLevels) {
    assert(dockyard_level >= 4, 'Dockyard 4 required');
    assert(techs.combustion >= 6, 'Combustive Engine 6 required');
    assert(techs.shield >= 2, 'Shield Tech 2 required');
}

fn frigate_requirements_check(dockyard_level: u8, techs: TechLevels) {
    assert(dockyard_level >= 5, 'Dockyard 5 required');
    assert(techs.ion >= 2, 'Ion Systems 2 required');
    assert(techs.thrust >= 4, 'Thrust Propulsion 4 required');
}

fn armade_requirements_check(dockyard_level: u8, techs: TechLevels) {
    assert(dockyard_level >= 7, 'Dockyard 7 required');
    assert(techs.warp >= 4, 'Warp Drive 4 required');
}
