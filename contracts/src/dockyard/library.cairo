use nogame::data::types::{Resources, ShipsCost, TechLevels};

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
