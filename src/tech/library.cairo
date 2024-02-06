use nogame::libraries::math::pow;
use nogame::data::types::{ERC20s, TechLevels, TechsCost};

fn get_tech_cost(current_level: u8, quantity: u8, base_cost: ERC20s) -> ERC20s {
    let mut cost: ERC20s = Default::default();

    let mut i = current_level + quantity.into();
    loop {
        if i == current_level {
            break;
        }

        let level_cost = ERC20s {
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
        energy: ERC20s { steel: 0, quartz: 800, tritium: 400 },
        digital: ERC20s { steel: 0, quartz: 400, tritium: 600 },
        beam: ERC20s { steel: 0, quartz: 800, tritium: 400 },
        armour: ERC20s { steel: 1000, quartz: 0, tritium: 0 },
        ion: ERC20s { steel: 1000, quartz: 300, tritium: 1000 },
        plasma: ERC20s { steel: 2000, quartz: 4000, tritium: 1000 },
        weapons: ERC20s { steel: 800, quartz: 200, tritium: 0 },
        shield: ERC20s { steel: 200, quartz: 600, tritium: 0 },
        spacetime: ERC20s { steel: 0, quartz: 4000, tritium: 2000 },
        combustion: ERC20s { steel: 400, quartz: 0, tritium: 600 },
        thrust: ERC20s { steel: 2000, quartz: 4000, tritium: 600 },
        warp: ERC20s { steel: 10000, quartz: 20000, tritium: 6000 },
    }
}


fn exocraft_cost(level: u8, quantity: u8) -> ERC20s {
    assert(!quantity.is_zero(), 'quantity can not be zero');
    let mut costs: Array<ERC20s> = array![
        ERC20s { steel: 4000, quartz: 8000, tritium: 4000 },
        ERC20s { steel: 7000, quartz: 14000, tritium: 7000 },
        ERC20s { steel: 12250, quartz: 24500, tritium: 12250 },
        ERC20s { steel: 21437, quartz: 42875, tritium: 21437 },
        ERC20s { steel: 37515, quartz: 75031, tritium: 37515 },
        ERC20s { steel: 65652, quartz: 131304, tritium: 65652 },
        ERC20s { steel: 114891, quartz: 229783, tritium: 114891 },
        ERC20s { steel: 201060, quartz: 402120, tritium: 201060 },
        ERC20s { steel: 351855, quartz: 703711, tritium: 351855 },
        ERC20s { steel: 615747, quartz: 1231494, tritium: 615747 },
        ERC20s { steel: 1077557, quartz: 2155115, tritium: 1077557 },
        ERC20s { steel: 1885725, quartz: 3771451, tritium: 1885725 },
        ERC20s { steel: 3300020, quartz: 6600040, tritium: 3300020 },
        ERC20s { steel: 5775035, quartz: 11550070, tritium: 5775035 },
        ERC20s { steel: 10106311, quartz: 20212622, tritium: 10106311 },
        ERC20s { steel: 17686044, quartz: 35372089, tritium: 17686044 },
        ERC20s { steel: 30950578, quartz: 61901156, tritium: 30950578 },
        ERC20s { steel: 54163512, quartz: 108327024, tritium: 54163512 },
        ERC20s { steel: 94786146, quartz: 189572293, tritium: 94786146 },
        ERC20s { steel: 165875756, quartz: 331751512, tritium: 165875756 },
        ERC20s { steel: 290282573, quartz: 580565147, tritium: 290282573 },
        ERC20s { steel: 507994504, quartz: 1015989008, tritium: 507994504 },
        ERC20s { steel: 888990382, quartz: 1777980764, tritium: 888990382 },
        ERC20s { steel: 1555733168, quartz: 3111466337, tritium: 1555733168 },
        ERC20s { steel: 2722533045, quartz: 5445066090, tritium: 2722533045 },
        ERC20s { steel: 4764432829, quartz: 9528865658, tritium: 4764432829 },
        ERC20s { steel: 8337757451, quartz: 16675514902, tritium: 8337757451 },
        ERC20s { steel: 14591075539, quartz: 29182151079, tritium: 14591075539 },
        ERC20s { steel: 25534382194, quartz: 51068764388, tritium: 25534382194 },
        ERC20s { steel: 44685168840, quartz: 89370337680, tritium: 44685168840 },
        ERC20s { steel: 78199045470, quartz: 156398090941, tritium: 78199045470 },
        ERC20s { steel: 136848329573, quartz: 273696659147, tritium: 136848329573 },
        ERC20s { steel: 239484576753, quartz: 478969153507, tritium: 239484576753 },
        ERC20s { steel: 419098009318, quartz: 838196018637, tritium: 419098009318 },
        ERC20s { steel: 733421516308, quartz: 1466843032616, tritium: 733421516308 },
        ERC20s { steel: 1283487653539, quartz: 2566975307078, tritium: 1283487653539 },
        ERC20s { steel: 2246103393693, quartz: 4492206787387, tritium: 2246103393693 },
        ERC20s { steel: 3930680938963, quartz: 7861361877927, tritium: 3930680938963 },
        ERC20s { steel: 6878691643186, quartz: 13757383286373, tritium: 6878691643186 },
        ERC20s { steel: 12037710375576, quartz: 24075420751153, tritium: 12037710375576 },
    ];
    let mut sum: ERC20s = Default::default();
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
