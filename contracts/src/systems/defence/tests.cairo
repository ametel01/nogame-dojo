#[cfg(test)]
mod test {
    use debug::PrintTrait;
    use dojo::world::{IWorldDispatcherTrait, IWorldDispatcher};
    use nogame::data::types::{Position, DefenceBuildType};
    use nogame::game::actions::{IGameActionsDispatcher, IGameActionsDispatcherTrait};
    use nogame::game::models::{GameSetup, GamePlanetCount};
    use nogame::libraries::names::Names;

    use nogame::libraries::{constants};
    use nogame::models::{compound::PlanetCompounds, defence::PlanetDefences};
    use nogame::planet::actions::{IPlanetActionsDispatcher, IPlanetActionsDispatcherTrait};
    use nogame::planet::models::{
        PlanetPosition, PositionToPlanet, PlanetResource, PlanetResourceTimer
    };
    use nogame::systems::defence::contract::{
        IDefenceActionsDispatcher, IDefenceActionsDispatcherTrait
    };
    use nogame::tech::models::{PlanetTechs};
    use nogame::utils::test_utils::{
        setup_world, OWNER, GAME_SPEED, ACCOUNT_1, ACCOUNT_2, ACCOUNT_3, ACCOUNT_4, ACCOUNT_5, DAY
    };
    use starknet::testing::{set_contract_address, set_block_timestamp};

    #[test]
    fn test_build_celestia_success() {
        let (world, actions) = setup_world();
        actions.game.spawn(GAME_SPEED);

        set_contract_address(ACCOUNT_1());
        actions.planet.generate_planet();
        set!(world, PlanetResource { planet_id: 1, name: Names::Resource::QUARTZ, amount: 20_000 });
        set!(world, PlanetResource { planet_id: 1, name: Names::Resource::TRITIUM, amount: 5_000 });
        set!(world, PlanetCompounds { planet_id: 1, name: Names::Compound::DOCKYARD, level: 1 });
        set!(world, PlanetTechs { planet_id: 1, name: Names::Tech::COMBUSTION, level: 1 });

        actions.defence.process_defence_build(DefenceBuildType::Celestia(()), 10);
        let celestia = get!(world, (1, Names::Defence::CELESTIA), PlanetDefences).count;
        assert(celestia == 10, 'Celestia count should be 10');

        let quartz = get!(world, (1, Names::Resource::QUARTZ), PlanetResource).amount;
        assert(quartz == 0, 'Steel should be 0');
        let tritium = get!(world, (1, Names::Resource::TRITIUM), PlanetResource).amount;
        assert(tritium == 0, 'Quartz should be 0');
    }

    #[test]
    fn test_build_blaster_success() {
        let (world, actions) = setup_world();
        actions.game.spawn(GAME_SPEED);

        set_contract_address(ACCOUNT_1());
        actions.planet.generate_planet();
        set!(world, PlanetResource { planet_id: 1, name: Names::Resource::STEEL, amount: 20_000 });
        set!(world, PlanetCompounds { planet_id: 1, name: Names::Compound::DOCKYARD, level: 1 });

        actions.defence.process_defence_build(DefenceBuildType::Blaster(()), 10);
        let blaster = get!(world, (1, Names::Defence::BLASTER), PlanetDefences).count;
        assert(blaster == 10, 'Blaster count should be 10');

        let steel = get!(world, (1, Names::Resource::STEEL), PlanetResource).amount;
        assert(steel == 0, 'Steel should be 0');
    }

    #[test]
    fn test_build_beam_success() {
        let (world, actions) = setup_world();
        actions.game.spawn(GAME_SPEED);

        set_contract_address(ACCOUNT_1());
        actions.planet.generate_planet();
        set!(world, PlanetResource { planet_id: 1, name: Names::Resource::STEEL, amount: 60_000 });
        set!(world, PlanetResource { planet_id: 1, name: Names::Resource::QUARTZ, amount: 20_000 });
        set!(world, PlanetCompounds { planet_id: 1, name: Names::Compound::DOCKYARD, level: 4 });
        set!(world, PlanetTechs { planet_id: 1, name: Names::Tech::ENERGY, level: 3 });
        set!(world, PlanetTechs { planet_id: 1, name: Names::Tech::BEAM, level: 6 });

        actions.defence.process_defence_build(DefenceBuildType::Beam(()), 10);
        let beam = get!(world, (1, Names::Defence::BEAM), PlanetDefences).count;
        assert(beam == 10, 'Beam count should be 10');

        let steel = get!(world, (1, Names::Resource::STEEL), PlanetResource).amount;
        assert(steel == 0, 'Steel should be 0');
        let quartz = get!(world, (1, Names::Resource::QUARTZ), PlanetResource).amount;
        assert(quartz == 0, 'Quartz should be 0');
    }

    #[test]
    fn test_build_astral_success() {
        let (world, actions) = setup_world();
        actions.game.spawn(GAME_SPEED);

        set_contract_address(ACCOUNT_1());
        actions.planet.generate_planet();
        set!(world, PlanetResource { planet_id: 1, name: Names::Resource::STEEL, amount: 200_000 });
        set!(
            world, PlanetResource { planet_id: 1, name: Names::Resource::QUARTZ, amount: 150_000 }
        );
        set!(
            world, PlanetResource { planet_id: 1, name: Names::Resource::TRITIUM, amount: 20_000 }
        );
        set!(world, PlanetCompounds { planet_id: 1, name: Names::Compound::DOCKYARD, level: 6 });
        set!(world, PlanetTechs { planet_id: 1, name: Names::Tech::ENERGY, level: 6 });
        set!(world, PlanetTechs { planet_id: 1, name: Names::Tech::WEAPONS, level: 3 });
        set!(world, PlanetTechs { planet_id: 1, name: Names::Tech::SHIELD, level: 1 });

        actions.defence.process_defence_build(DefenceBuildType::Astral(()), 10);
        let astral = get!(world, (1, Names::Defence::ASTRAL), PlanetDefences).count;
        assert(astral == 10, 'Astral count should be 10');

        let steel = get!(world, (1, Names::Resource::STEEL), PlanetResource).amount;
        assert(steel == 0, 'Steel should be 0');
        let quartz = get!(world, (1, Names::Resource::QUARTZ), PlanetResource).amount;
        assert(quartz == 0, 'Quartz should be 0');
        let tritium = get!(world, (1, Names::Resource::TRITIUM), PlanetResource).amount;
        assert(tritium == 0, 'Tritium should be 0');
    }

    #[test]
    fn test_build_plasma_success() {
        let (world, actions) = setup_world();
        actions.game.spawn(GAME_SPEED);

        set_contract_address(ACCOUNT_1());
        actions.planet.generate_planet();
        set!(world, PlanetResource { planet_id: 1, name: Names::Resource::STEEL, amount: 500_000 });
        set!(
            world, PlanetResource { planet_id: 1, name: Names::Resource::QUARTZ, amount: 500_000 }
        );
        set!(
            world, PlanetResource { planet_id: 1, name: Names::Resource::TRITIUM, amount: 300_000 }
        );
        set!(world, PlanetCompounds { planet_id: 1, name: Names::Compound::DOCKYARD, level: 8 });
        set!(world, PlanetTechs { planet_id: 1, name: Names::Tech::PLASMA, level: 7 });

        actions.defence.process_defence_build(DefenceBuildType::Plasma(()), 10);
        let plasma = get!(world, (1, Names::Defence::PLASMA), PlanetDefences).count;
        assert(plasma == 10, 'Plasma count should be 10');

        let steel = get!(world, (1, Names::Resource::STEEL), PlanetResource).amount;
        assert(steel == 0, 'Steel should be 0');
        let quartz = get!(world, (1, Names::Resource::QUARTZ), PlanetResource).amount;
        assert(quartz == 0, 'Quartz should be 0');
        let tritium = get!(world, (1, Names::Resource::TRITIUM), PlanetResource).amount;
        assert(tritium == 0, 'Tritium should be 0');
    }
}
