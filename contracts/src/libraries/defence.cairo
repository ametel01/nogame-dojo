use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};
use nogame::data::types::{Resources, TechLevels, DefencesCost, DefenceBuildType};
use nogame::libraries::{constants, names::Names, shared};
use nogame::models::{defence::{PlanetDefences, PlanetDefenceTimer}, game::GameSetup};


fn build_component(
    world: IWorldDispatcher, planet_id: u32, component: DefenceBuildType, quantity: u32
) -> Resources {
    let techs = shared::get_tech_levels(world, planet_id);
    let compounds = shared::get_compound_levels(world, planet_id);
    shared::collect(world, planet_id, 0, compounds);
    let available_resources = shared::get_resources_available(world, planet_id, 0);
    let time_now = starknet::get_block_timestamp();
    let queue_status = get!(world, planet_id, PlanetDefenceTimer).time_end;
    assert!(queue_status.is_zero(), "PlanetDefenceTimer: Already building");
    let game_speed = get!(world, constants::GAME_ID, GameSetup).speed;
    match component {
        DefenceBuildType::Celestia => {
            let cost = get_defences_cost(quantity, get_defences_unit_cost().celestia);
            assert!(available_resources >= cost, "Defence: Not enough resources");
            requirements::celestia(compounds.dockyard, techs);
            shared::pay_resources(world, planet_id, 0, available_resources, cost);
            let built_time = shared::build_time_is_seconds(
                cost.steel + cost.quartz, compounds.dockyard, game_speed
            );
            set!(
                world,
                (
                    PlanetDefenceTimer {
                        planet_id, name: component, quantity, time_end: time_now + built_time
                    },
                )
            );
            return cost;
        },
        DefenceBuildType::Blaster => {
            let cost = get_defences_cost(quantity, get_defences_unit_cost().blaster);
            assert!(available_resources >= cost, "Defence: Not enough resources");
            requirements::blaster(compounds.dockyard, techs);
            shared::pay_resources(world, planet_id, 0, available_resources, cost);
            let built_time = shared::build_time_is_seconds(
                cost.steel + cost.quartz, compounds.dockyard, game_speed
            );
            set!(
                world,
                (
                    PlanetDefenceTimer {
                        planet_id, name: component, quantity, time_end: time_now + built_time
                    },
                )
            );
            return cost;
        },
        DefenceBuildType::Beam => {
            let cost = get_defences_cost(quantity, get_defences_unit_cost().beam);
            assert!(available_resources >= cost, "Defence: Not enough resources");
            requirements::beam(compounds.dockyard, techs);
            shared::pay_resources(world, planet_id, 0, available_resources, cost);
            let built_time = shared::build_time_is_seconds(
                cost.steel + cost.quartz, compounds.dockyard, game_speed
            );
            set!(
                world,
                (
                    PlanetDefenceTimer {
                        planet_id, name: component, quantity, time_end: time_now + built_time
                    },
                )
            );
            return cost;
        },
        DefenceBuildType::Astral => {
            let cost = get_defences_cost(quantity, get_defences_unit_cost().astral);
            assert!(available_resources >= cost, "Defence: Not enough resources");
            requirements::astral(compounds.dockyard, techs);
            shared::pay_resources(world, planet_id, 0, available_resources, cost);
            let built_time = shared::build_time_is_seconds(
                cost.steel + cost.quartz, compounds.dockyard, game_speed
            );
            set!(
                world,
                (
                    PlanetDefenceTimer {
                        planet_id, name: component, quantity, time_end: time_now + built_time
                    },
                )
            );
            return cost;
        },
        DefenceBuildType::Plasma => {
            let cost = get_defences_cost(quantity, get_defences_unit_cost().plasma);
            assert!(available_resources >= cost, "Defence: Not enough resources");
            requirements::plasma(compounds.dockyard, techs);
            shared::pay_resources(world, planet_id, 0, available_resources, cost);
            let built_time = shared::build_time_is_seconds(
                cost.steel + cost.quartz, compounds.dockyard, game_speed
            );
            set!(
                world,
                (
                    PlanetDefenceTimer {
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
    let queue_status = get!(world, planet_id, PlanetDefenceTimer);
    assert!(!queue_status.time_end.is_zero(), "Defence: No builds in progress");
    assert!(time_now >= queue_status.time_end, "Defence: Build process not finished");
    let defences = shared::get_defences_levels(world, planet_id);
    match queue_status.name {
        DefenceBuildType::Celestia => {
            set!(
                world,
                (
                    PlanetDefences {
                        planet_id,
                        name: Names::Defence::CELESTIA,
                        count: defences.celestia + queue_status.quantity
                    },
                    PlanetDefenceTimer {
                        planet_id,
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
                    PlanetDefences {
                        planet_id,
                        name: Names::Defence::BLASTER,
                        count: defences.blaster + queue_status.quantity
                    },
                    PlanetDefenceTimer {
                        planet_id,
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
                    PlanetDefences {
                        planet_id,
                        name: Names::Defence::BEAM,
                        count: defences.beam + queue_status.quantity
                    },
                    PlanetDefenceTimer {
                        planet_id,
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
                    PlanetDefences {
                        planet_id,
                        name: Names::Defence::ASTRAL,
                        count: defences.astral + queue_status.quantity
                    },
                    PlanetDefenceTimer {
                        planet_id,
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
                    PlanetDefences {
                        planet_id,
                        name: Names::Defence::PLASMA,
                        count: defences.plasma + queue_status.quantity
                    },
                    PlanetDefenceTimer {
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


fn get_defences_cost(quantity: u32, base_cost: Resources) -> Resources {
    Resources {
        steel: base_cost.steel * quantity.into(),
        quartz: base_cost.quartz * quantity.into(),
        tritium: base_cost.tritium * quantity.into()
    }
}

fn get_defences_unit_cost() -> DefencesCost {
    DefencesCost {
        celestia: Resources { steel: 0, quartz: 2000, tritium: 500 },
        blaster: Resources { steel: 2000, quartz: 0, tritium: 0 },
        beam: Resources { steel: 6000, quartz: 2000, tritium: 0 },
        astral: Resources { steel: 20000, quartz: 15000, tritium: 2000 },
        plasma: Resources { steel: 50000, quartz: 50000, tritium: 30000 },
    }
}

mod requirements {
    use nogame::data::types::TechLevels;

    fn celestia(dockyard_level: u8, techs: TechLevels) {
        assert(dockyard_level >= 1, 'Dockyard 1 required');
        assert(techs.combustion >= 1, 'Combustive Engine 1 required');
    }

    fn blaster(dockyard_level: u8, techs: TechLevels) {
        assert(dockyard_level >= 1, 'dockyard 1 required');
    }

    fn beam(dockyard_level: u8, techs: TechLevels) {
        assert(dockyard_level >= 4, 'dockyard 4 required');
        assert(techs.energy >= 3, 'energy innovation 3 required');
        assert(techs.beam >= 6, 'beam technology 6 required');
    }

    fn astral(dockyard_level: u8, techs: TechLevels) {
        assert(dockyard_level >= 6, 'dockyard 6 required');
        assert(techs.energy >= 6, 'energy innovation 6 required');
        assert(techs.weapons >= 3, 'weapons tech 3 required');
        assert(techs.shield >= 1, 'shield tech 1 required')
    }

    fn plasma(dockyard_level: u8, techs: TechLevels) {
        assert(dockyard_level >= 8, 'dockyard 8 required');
        assert(techs.plasma >= 7, 'plasma engineering 7 required');
    }
}
