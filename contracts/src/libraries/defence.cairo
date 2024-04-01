use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};
use nogame::data::types::{Resources, TechLevels, DefencesCost, DefenceBuildType};
use nogame::libraries::{names::Names, shared};
use nogame::models::defence::PlanetDefences;


fn build_component(
    world: IWorldDispatcher, planet_id: u32, component: DefenceBuildType, quantity: u32
) -> Resources {
    let techs = shared::get_tech_levels(world, planet_id);
    let compounds = shared::get_compound_levels(world, planet_id);
    let defences_levels = shared::get_defences_levels(world, planet_id);
    shared::collect(world, planet_id, 0, compounds);
    let available_resources = shared::get_resources_available(world, planet_id, 0);
    match component {
        DefenceBuildType::Celestia => {
            let cost = get_defences_cost(quantity, get_defences_unit_cost().celestia);
            assert!(available_resources >= cost, "Defence: Not enough resources");
            requirements::celestia(compounds.dockyard, techs);
            shared::pay_resources(world, planet_id, 0, available_resources, cost);
            set!(
                world,
                (
                    PlanetDefences {
                        planet_id,
                        name: Names::Defence::CELESTIA,
                        count: defences_levels.celestia + quantity
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
            set!(
                world,
                (
                    PlanetDefences {
                        planet_id,
                        name: Names::Defence::BLASTER,
                        count: defences_levels.blaster + quantity
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
            set!(
                world,
                (
                    PlanetDefences {
                        planet_id,
                        name: Names::Defence::BEAM,
                        count: defences_levels.beam + quantity
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
            set!(
                world,
                (
                    PlanetDefences {
                        planet_id,
                        name: Names::Defence::ASTRAL,
                        count: defences_levels.astral + quantity
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
            set!(
                world,
                (
                    PlanetDefences {
                        planet_id,
                        name: Names::Defence::PLASMA,
                        count: defences_levels.plasma + quantity
                    },
                )
            );
            return cost;
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
