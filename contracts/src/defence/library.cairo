use nogame::data::types::{ERC20s, TechLevels, DefencesCost};

fn get_defences_cost(quantity: u32, base_cost: ERC20s) -> ERC20s {
    ERC20s {
        steel: base_cost.steel * quantity.into(),
        quartz: base_cost.quartz * quantity.into(),
        tritium: base_cost.tritium * quantity.into()
    }
}

fn get_defences_unit_cost() -> DefencesCost {
    DefencesCost {
        celestia: ERC20s { steel: 0, quartz: 2000, tritium: 500 },
        blaster: ERC20s { steel: 2000, quartz: 0, tritium: 0 },
        beam: ERC20s { steel: 6000, quartz: 2000, tritium: 0 },
        astral: ERC20s { steel: 20000, quartz: 15000, tritium: 2000 },
        plasma: ERC20s { steel: 50000, quartz: 50000, tritium: 30000 },
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
