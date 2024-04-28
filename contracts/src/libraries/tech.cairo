use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};
use nogame::data::types::{Resources, TechLevels, TechsCost, TechUpgradeType};
use nogame::libraries::{constants, math::pow, names::Names, shared};
use nogame::models::{tech::{PlanetTechs, PlanetTechTimer}, game::GameSetup};

fn upgrade_component(
    world: IWorldDispatcher, planet_id: u32, component: u8, quantity: u8
) -> Resources {
    let compounds = shared::get_compound_levels(world, planet_id);
    let tech_levels = shared::get_tech_levels(world, planet_id);
    let base_tech_cost = base_tech_costs();
    shared::collect(world, planet_id, 0, compounds);
    let available_resources = shared::get_resources_available(world, planet_id, 0);
    let mut cost: Resources = Default::default();
    let time_now = starknet::get_block_timestamp();
    let queue_status = get!(world, planet_id, PlanetTechTimer).time_end;
    assert!(queue_status.is_zero(), "Tech: Already upgrading");
    let game_speed = get!(world, constants::GAME_ID, GameSetup).speed;

    if component == Names::Tech::ENERGY {
        cost = get_tech_cost(tech_levels.energy, quantity, base_tech_cost.energy);
        assert!(available_resources >= cost, "Tech: Not enough resources");
        requirements::energy(compounds.lab, tech_levels);
        shared::pay_resources(world, planet_id, 0, available_resources, cost);
        let built_time = shared::tech_up_time_is_seconds(
            cost.steel + cost.quartz, compounds.lab, game_speed
        );
        set!(
            world,
            (
                PlanetTechTimer {
                    planet_id, name: component, levels: quantity, time_end: time_now + built_time
                },
            )
        );
    } else if component == Names::Tech::DIGITAL {
        cost = get_tech_cost(tech_levels.digital, quantity, base_tech_cost.digital);
        assert!(available_resources >= cost, "Tech: Not enough resources");
        requirements::digital(compounds.lab, tech_levels);
        shared::pay_resources(world, planet_id, 0, available_resources, cost);
        let built_time = shared::tech_up_time_is_seconds(
            cost.steel + cost.quartz, compounds.lab, game_speed
        );
        set!(
            world,
            (
                PlanetTechTimer {
                    planet_id, name: component, levels: quantity, time_end: time_now + built_time
                },
            )
        );
    } else if component == Names::Tech::BEAM {
        cost = get_tech_cost(tech_levels.beam, quantity, base_tech_cost.beam);
        assert!(available_resources >= cost, "Tech: Not enough resources");
        requirements::beam(compounds.lab, tech_levels);
        shared::pay_resources(world, planet_id, 0, available_resources, cost);
        let built_time = shared::tech_up_time_is_seconds(
            cost.steel + cost.quartz, compounds.lab, game_speed
        );
        set!(
            world,
            (
                PlanetTechTimer {
                    planet_id, name: component, levels: quantity, time_end: time_now + built_time
                },
            )
        );
    } else if component == Names::Tech::ARMOUR {
        cost = get_tech_cost(tech_levels.armour, quantity, base_tech_cost.armour);
        assert!(available_resources >= cost, "Tech: Not enough resources");
        requirements::armour(compounds.lab, tech_levels);
        shared::pay_resources(world, planet_id, 0, available_resources, cost);
        let built_time = shared::tech_up_time_is_seconds(
            cost.steel + cost.quartz, compounds.lab, game_speed
        );
        set!(
            world,
            (
                PlanetTechTimer {
                    planet_id, name: component, levels: quantity, time_end: time_now + built_time
                },
            )
        );
    } else if component == Names::Tech::ION {
        cost = get_tech_cost(tech_levels.ion, quantity, base_tech_cost.ion);
        assert!(available_resources >= cost, "Tech: Not enough resources");
        requirements::ion(compounds.lab, tech_levels);
        shared::pay_resources(world, planet_id, 0, available_resources, cost);
        let built_time = shared::tech_up_time_is_seconds(
            cost.steel + cost.quartz, compounds.lab, game_speed
        );
        set!(
            world,
            (
                PlanetTechTimer {
                    planet_id, name: component, levels: quantity, time_end: time_now + built_time
                },
            )
        );
    } else if component == Names::Tech::PLASMA {
        cost = get_tech_cost(tech_levels.plasma, quantity, base_tech_cost.plasma);
        assert!(available_resources >= cost, "Tech: Not enough resources");
        requirements::plasma(compounds.lab, tech_levels);
        shared::pay_resources(world, planet_id, 0, available_resources, cost);
        let built_time = shared::tech_up_time_is_seconds(
            cost.steel + cost.quartz, compounds.lab, game_speed
        );
        set!(
            world,
            (
                PlanetTechTimer {
                    planet_id, name: component, levels: quantity, time_end: time_now + built_time
                },
            )
        );
    } else if component == Names::Tech::WEAPONS {
        cost = get_tech_cost(tech_levels.weapons, quantity, base_tech_cost.weapons);
        assert!(available_resources >= cost, "Tech: Not enough resources");
        requirements::weapons(compounds.lab, tech_levels);
        shared::pay_resources(world, planet_id, 0, available_resources, cost);
        let built_time = shared::tech_up_time_is_seconds(
            cost.steel + cost.quartz, compounds.lab, game_speed
        );
        set!(
            world,
            (
                PlanetTechTimer {
                    planet_id, name: component, levels: quantity, time_end: time_now + built_time
                },
            )
        );
    } else if component == Names::Tech::SHIELD {
        cost = get_tech_cost(tech_levels.shield, quantity, base_tech_cost.shield);
        assert!(available_resources >= cost, "Tech: Not enough resources");
        requirements::shield(compounds.lab, tech_levels);
        shared::pay_resources(world, planet_id, 0, available_resources, cost);
        let built_time = shared::tech_up_time_is_seconds(
            cost.steel + cost.quartz, compounds.lab, game_speed
        );
        set!(
            world,
            (
                PlanetTechTimer {
                    planet_id, name: component, levels: quantity, time_end: time_now + built_time
                },
            )
        );
    } else if component == Names::Tech::SPACETIME {
        cost = get_tech_cost(tech_levels.spacetime, quantity, base_tech_cost.spacetime);
        assert!(available_resources >= cost, "Tech: Not enough resources");
        requirements::spacetime(compounds.lab, tech_levels);
        shared::pay_resources(world, planet_id, 0, available_resources, cost);
        let built_time = shared::tech_up_time_is_seconds(
            cost.steel + cost.quartz, compounds.lab, game_speed
        );
        set!(
            world,
            (
                PlanetTechTimer {
                    planet_id, name: component, levels: quantity, time_end: time_now + built_time
                },
            )
        );
    } else if component == Names::Tech::COMBUSTION {
        cost = get_tech_cost(tech_levels.combustion, quantity, base_tech_cost.combustion);
        assert!(available_resources >= cost, "Tech: Not enough resources");
        requirements::combustion(compounds.lab, tech_levels);
        shared::pay_resources(world, planet_id, 0, available_resources, cost);
        let built_time = shared::tech_up_time_is_seconds(
            cost.steel + cost.quartz, compounds.lab, game_speed
        );
        set!(
            world,
            (
                PlanetTechTimer {
                    planet_id, name: component, levels: quantity, time_end: time_now + built_time
                },
            )
        );
    } else if component == Names::Tech::THRUST {
        cost = get_tech_cost(tech_levels.thrust, quantity, base_tech_cost.thrust);
        assert!(available_resources >= cost, "Tech: Not enough resources");
        requirements::thrust(compounds.lab, tech_levels);
        shared::pay_resources(world, planet_id, 0, available_resources, cost);
        let built_time = shared::tech_up_time_is_seconds(
            cost.steel + cost.quartz, compounds.lab, game_speed
        );
        set!(
            world,
            (
                PlanetTechTimer {
                    planet_id, name: component, levels: quantity, time_end: time_now + built_time
                },
            )
        );
    } else if component == Names::Tech::WARP {
        cost = get_tech_cost(tech_levels.warp, quantity, base_tech_cost.warp);
        assert!(available_resources >= cost, "Tech: Not enough resources");
        requirements::warp(compounds.lab, tech_levels);
        shared::pay_resources(world, planet_id, 0, available_resources, cost);
        let built_time = shared::tech_up_time_is_seconds(
            cost.steel + cost.quartz, compounds.lab, game_speed
        );
        set!(
            world,
            (
                PlanetTechTimer {
                    planet_id, name: component, levels: quantity, time_end: time_now + built_time
                },
            )
        );
    } else {
        cost = exocraft_cost(tech_levels.exocraft, quantity);
        assert!(available_resources >= cost, "Tech: Not enough resources");
        requirements::exocraft(compounds.lab, tech_levels);
        shared::pay_resources(world, planet_id, 0, available_resources, cost);
        let built_time = shared::tech_up_time_is_seconds(
            cost.steel + cost.quartz, compounds.lab, game_speed
        );
        set!(
            world,
            (
                PlanetTechTimer {
                    planet_id, name: component, levels: quantity, time_end: time_now + built_time
                },
            )
        );
    }
    cost
}

fn complete_upgrade(world: IWorldDispatcher, planet_id: u32) {
    let time_now = starknet::get_block_timestamp();
    let queue_status = get!(world, planet_id, PlanetTechTimer);
    assert!(!queue_status.time_end.is_zero(), "Tech: No upgrade in progress");
    assert!(time_now >= queue_status.time_end, "Tech: Upgrade not finished");
    let techs = shared::get_tech_levels(world, planet_id);
    if queue_status.name == Names::Tech::ENERGY {
        set!(
            world,
            (
                PlanetTechs {
                    planet_id, name: Names::Tech::ENERGY, level: techs.energy + queue_status.levels
                },
                PlanetTechTimer {
                    planet_id,
                    name: queue_status.name,
                    levels: Zeroable::zero(),
                    time_end: Zeroable::zero()
                },
            )
        );
    } else if queue_status.name == Names::Tech::DIGITAL {
        set!(
            world,
            (
                PlanetTechs {
                    planet_id,
                    name: Names::Tech::DIGITAL,
                    level: techs.digital + queue_status.levels
                },
                PlanetTechTimer {
                    planet_id,
                    name: queue_status.name,
                    levels: Zeroable::zero(),
                    time_end: Zeroable::zero()
                },
            )
        );
    } else if queue_status.name == Names::Tech::BEAM {
        set!(
            world,
            (
                PlanetTechs {
                    planet_id, name: Names::Tech::BEAM, level: techs.beam + queue_status.levels
                },
                PlanetTechTimer {
                    planet_id,
                    name: queue_status.name,
                    levels: Zeroable::zero(),
                    time_end: Zeroable::zero()
                },
            )
        );
    } else if queue_status.name == Names::Tech::ARMOUR {
        set!(
            world,
            (
                PlanetTechs {
                    planet_id, name: Names::Tech::ARMOUR, level: techs.armour + queue_status.levels
                },
                PlanetTechTimer {
                    planet_id,
                    name: queue_status.name,
                    levels: Zeroable::zero(),
                    time_end: Zeroable::zero()
                },
            )
        );
    } else if queue_status.name == Names::Tech::ION {
        set!(
            world,
            (
                PlanetTechs {
                    planet_id, name: Names::Tech::ION, level: techs.ion + queue_status.levels
                },
                PlanetTechTimer {
                    planet_id,
                    name: queue_status.name,
                    levels: Zeroable::zero(),
                    time_end: Zeroable::zero()
                },
            )
        );
    } else if queue_status.name == Names::Tech::PLASMA {
        set!(
            world,
            (
                PlanetTechs {
                    planet_id, name: Names::Tech::PLASMA, level: techs.plasma + queue_status.levels
                },
                PlanetTechTimer {
                    planet_id,
                    name: queue_status.name,
                    levels: Zeroable::zero(),
                    time_end: Zeroable::zero()
                },
            )
        );
    } else if queue_status.name == Names::Tech::WEAPONS {
        set!(
            world,
            (
                PlanetTechs {
                    planet_id,
                    name: Names::Tech::WEAPONS,
                    level: techs.weapons + queue_status.levels
                },
                PlanetTechTimer {
                    planet_id,
                    name: queue_status.name,
                    levels: Zeroable::zero(),
                    time_end: Zeroable::zero()
                },
            )
        );
    } else if queue_status.name == Names::Tech::SHIELD {
        set!(
            world,
            (
                PlanetTechs {
                    planet_id, name: Names::Tech::SHIELD, level: techs.shield + queue_status.levels
                },
                PlanetTechTimer {
                    planet_id,
                    name: queue_status.name,
                    levels: Zeroable::zero(),
                    time_end: Zeroable::zero()
                },
            )
        );
    } else if queue_status.name == Names::Tech::SPACETIME {
        set!(
            world,
            (
                PlanetTechs {
                    planet_id,
                    name: Names::Tech::SPACETIME,
                    level: techs.spacetime + queue_status.levels
                },
                PlanetTechTimer {
                    planet_id,
                    name: queue_status.name,
                    levels: Zeroable::zero(),
                    time_end: Zeroable::zero()
                },
            )
        );
    } else if queue_status.name == Names::Tech::COMBUSTION {
        set!(
            world,
            (
                PlanetTechs {
                    planet_id,
                    name: Names::Tech::COMBUSTION,
                    level: techs.combustion + queue_status.levels
                },
                PlanetTechTimer {
                    planet_id,
                    name: queue_status.name,
                    levels: Zeroable::zero(),
                    time_end: Zeroable::zero()
                },
            )
        );
    } else if queue_status.name == Names::Tech::THRUST {
        set!(
            world,
            (
                PlanetTechs {
                    planet_id, name: Names::Tech::THRUST, level: techs.thrust + queue_status.levels
                },
                PlanetTechTimer {
                    planet_id,
                    name: queue_status.name,
                    levels: Zeroable::zero(),
                    time_end: Zeroable::zero()
                },
            )
        );
    } else if queue_status.name == Names::Tech::WARP {
        set!(
            world,
            (
                PlanetTechs {
                    planet_id, name: Names::Tech::WARP, level: techs.warp + queue_status.levels
                },
                PlanetTechTimer {
                    planet_id,
                    name: queue_status.name,
                    levels: Zeroable::zero(),
                    time_end: Zeroable::zero()
                },
            )
        );
    } else {
        set!(
            world,
            (
                PlanetTechs {
                    planet_id,
                    name: Names::Tech::EXOCRAFT,
                    level: techs.exocraft + queue_status.levels
                },
                PlanetTechTimer {
                    planet_id,
                    name: queue_status.name,
                    levels: Zeroable::zero(),
                    time_end: Zeroable::zero()
                },
            )
        );
    }
}


fn get_tech_cost(current_level: u8, quantity: u8, base_cost: Resources) -> Resources {
    let mut cost: Resources = Default::default();

    let mut i = current_level + quantity.into();
    loop {
        if i == current_level {
            break;
        }

        let level_cost = Resources {
            steel: (base_cost.steel * pow(2, i.into() - 1)),
            quartz: (base_cost.quartz * pow(2, i.into() - 1)),
            tritium: (base_cost.tritium * pow(2, i.into() - 1))
        };
        cost = cost + level_cost;
        i -= 1;
    };
    cost
}

mod requirements {
    use nogame::data::types::TechLevels;

    fn energy(lab_level: u8, techs: TechLevels) {
        assert(lab_level >= 1, 'Lab 1 required');
    }

    fn digital(lab_level: u8, techs: TechLevels) {
        assert(lab_level >= 1, 'Lab 1 required');
    }

    fn beam(lab_level: u8, techs: TechLevels) {
        assert(lab_level >= 1, 'Lab level 1 required');
        assert(techs.energy >= 2, 'Energy innovation 2 required');
    }

    fn armour(lab_level: u8, techs: TechLevels) {
        assert(lab_level >= 2, 'Lab 2 required');
    }

    fn ion(lab_level: u8, techs: TechLevels) {
        assert(lab_level >= 4, 'Lab 4 required');
        assert(techs.energy >= 4, 'Energy innovation 4 required');
        assert(techs.beam >= 5, 'Beam tech 5 required');
    }

    fn plasma(lab_level: u8, techs: TechLevels) {
        assert(lab_level >= 4, 'Lab 4 required');
        assert(techs.energy >= 8, 'Energy innovation 8 required');
        assert(techs.beam >= 10, 'Beam tech 10 required');
        assert(techs.ion >= 5, 'ion systems 5 required');
    }

    fn weapons(lab_level: u8, techs: TechLevels) {
        assert(lab_level >= 4, 'Lab 4 required');
    }

    fn shield(lab_level: u8, techs: TechLevels) {
        assert(lab_level >= 6, 'Lab 6 required');
        assert(techs.energy >= 3, 'Energy innovation 3 required')
    }

    fn spacetime(lab_level: u8, techs: TechLevels) {
        assert(lab_level >= 7, 'Lab 7 required');
        assert(techs.energy >= 5, 'Energy innovation 5 required');
        assert(techs.shield >= 5, 'Shield tech 5 required');
    }

    fn combustion(lab_level: u8, techs: TechLevels) {
        assert(lab_level >= 1, 'Lab 1 required');
        assert(techs.energy >= 1, 'Energy innovation 1 required')
    }

    fn thrust(lab_level: u8, techs: TechLevels) {
        assert(lab_level >= 2, 'Lab 2 required');
        assert(techs.energy >= 1, 'Energy innovation 1 required')
    }

    fn warp(lab_level: u8, techs: TechLevels) {
        assert(lab_level >= 7, 'Lab 7 required');
        assert(techs.energy >= 5, 'Energy innovation 5 required');
        assert(techs.spacetime >= 3, 'Spacetime Warp 3 required');
    }

    fn exocraft(lab_level: u8, techs: TechLevels) {
        assert(lab_level >= 3, 'Lab 3 required');
        assert(techs.thrust >= 3, 'Thrust prop 3 required')
    }
}

fn base_tech_costs() -> TechsCost {
    TechsCost {
        energy: Resources { steel: 0, quartz: 800, tritium: 400 },
        digital: Resources { steel: 0, quartz: 400, tritium: 600 },
        beam: Resources { steel: 0, quartz: 800, tritium: 400 },
        armour: Resources { steel: 1000, quartz: 0, tritium: 0 },
        ion: Resources { steel: 1000, quartz: 300, tritium: 1000 },
        plasma: Resources { steel: 2000, quartz: 4000, tritium: 1000 },
        weapons: Resources { steel: 800, quartz: 200, tritium: 0 },
        shield: Resources { steel: 200, quartz: 600, tritium: 0 },
        spacetime: Resources { steel: 0, quartz: 4000, tritium: 2000 },
        combustion: Resources { steel: 400, quartz: 0, tritium: 600 },
        thrust: Resources { steel: 2000, quartz: 4000, tritium: 600 },
        warp: Resources { steel: 10000, quartz: 20000, tritium: 6000 },
    }
}


fn exocraft_cost(level: u8, quantity: u8) -> Resources {
    assert(!quantity.is_zero(), 'quantity can not be zero');
    let mut costs: Array<Resources> = array![
        Resources { steel: 4000, quartz: 8000, tritium: 4000 },
        Resources { steel: 7000, quartz: 14000, tritium: 7000 },
        Resources { steel: 12250, quartz: 24500, tritium: 12250 },
        Resources { steel: 21437, quartz: 42875, tritium: 21437 },
        Resources { steel: 37515, quartz: 75031, tritium: 37515 },
        Resources { steel: 65652, quartz: 131304, tritium: 65652 },
        Resources { steel: 114891, quartz: 229783, tritium: 114891 },
        Resources { steel: 201060, quartz: 402120, tritium: 201060 },
        Resources { steel: 351855, quartz: 703711, tritium: 351855 },
        Resources { steel: 615747, quartz: 1231494, tritium: 615747 },
        Resources { steel: 1077557, quartz: 2155115, tritium: 1077557 },
        Resources { steel: 1885725, quartz: 3771451, tritium: 1885725 },
        Resources { steel: 3300020, quartz: 6600040, tritium: 3300020 },
        Resources { steel: 5775035, quartz: 11550070, tritium: 5775035 },
        Resources { steel: 10106311, quartz: 20212622, tritium: 10106311 },
        Resources { steel: 17686044, quartz: 35372089, tritium: 17686044 },
        Resources { steel: 30950578, quartz: 61901156, tritium: 30950578 },
        Resources { steel: 54163512, quartz: 108327024, tritium: 54163512 },
        Resources { steel: 94786146, quartz: 189572293, tritium: 94786146 },
        Resources { steel: 165875756, quartz: 331751512, tritium: 165875756 },
        Resources { steel: 290282573, quartz: 580565147, tritium: 290282573 },
        Resources { steel: 507994504, quartz: 1015989008, tritium: 507994504 },
        Resources { steel: 888990382, quartz: 1777980764, tritium: 888990382 },
        Resources { steel: 1555733168, quartz: 3111466337, tritium: 1555733168 },
        Resources { steel: 2722533045, quartz: 5445066090, tritium: 2722533045 },
        Resources { steel: 4764432829, quartz: 9528865658, tritium: 4764432829 },
        Resources { steel: 8337757451, quartz: 16675514902, tritium: 8337757451 },
        Resources { steel: 14591075539, quartz: 29182151079, tritium: 14591075539 },
        Resources { steel: 25534382194, quartz: 51068764388, tritium: 25534382194 },
        Resources { steel: 44685168840, quartz: 89370337680, tritium: 44685168840 },
        Resources { steel: 78199045470, quartz: 156398090941, tritium: 78199045470 },
        Resources { steel: 136848329573, quartz: 273696659147, tritium: 136848329573 },
        Resources { steel: 239484576753, quartz: 478969153507, tritium: 239484576753 },
        Resources { steel: 419098009318, quartz: 838196018637, tritium: 419098009318 },
        Resources { steel: 733421516308, quartz: 1466843032616, tritium: 733421516308 },
        Resources { steel: 1283487653539, quartz: 2566975307078, tritium: 1283487653539 },
        Resources { steel: 2246103393693, quartz: 4492206787387, tritium: 2246103393693 },
        Resources { steel: 3930680938963, quartz: 7861361877927, tritium: 3930680938963 },
        Resources { steel: 6878691643186, quartz: 13757383286373, tritium: 6878691643186 },
        Resources { steel: 12037710375576, quartz: 24075420751153, tritium: 12037710375576 },
    ];
    let mut sum: Resources = Default::default();
    let mut i: usize = (level + quantity).into();
    loop {
        if i == level.into() {
            break;
        }
        match costs.pop_front() {
            Option::Some(e) => { sum = sum + e; },
            Option::None => { break; }
        }
        i -= 1;
    };
    sum
}
