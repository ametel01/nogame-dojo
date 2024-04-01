use nogame::data::types::{DefenceBuildType};

#[dojo::interface]
trait IDefenceActions {
    fn process_defence_build(component: DefenceBuildType, quantity: u32);
}

#[dojo::contract]
mod defenceactions {
    use nogame::data::types::{DefenceBuildType, Resources, TechLevels, Defences};
    use nogame::defence::library as defence;
    use nogame::defence::models::PlanetDefences;
    use nogame::game::models::{GamePlanet, GameSetup};
    use nogame::libraries::compounds;
    use nogame::libraries::constants;
    use nogame::libraries::names::Names;
    use nogame::libraries::shared;
    use nogame::models::compound::PlanetCompounds;
    use nogame::planet::models::{PlanetResource, PlanetResourceTimer, PlanetPosition};
    use nogame::tech::models::PlanetTechs;
    use starknet::{get_caller_address, ContractAddress};
    use super::private;

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        DefenceSpent: DefenceSpent,
    }
    #[derive(Drop, starknet::Event)]
    struct DefenceSpent {
        planet_id: u32,
        quantity: u32,
        spent: Resources
    }

    #[abi(embed_v0)]
    impl DefenceActionsImpl of super::IDefenceActions<ContractState> {
        fn process_defence_build(component: DefenceBuildType, quantity: u32) {
            let world = self.world_dispatcher.read();
            let caller = get_caller_address();
            let planet_id = get!(world, caller, GamePlanet).planet_id;
            let cost = private::build_component(world, planet_id, component, quantity);
            shared::update_planet_resources_spent(world, planet_id, cost);
            emit!(world, DefenceSpent { planet_id, quantity, spent: cost });
        }
    }
}

mod private {
    use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};
    use nogame::data::types::{DefenceBuildType, Resources};
    use nogame::defence::{models::PlanetDefences, library as defence};
    use nogame::libraries::names::Names;
    use nogame::libraries::shared;

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
                let cost = defence::get_defences_cost(
                    quantity, defence::get_defences_unit_cost().celestia
                );
                assert!(available_resources >= cost, "Defence: Not enough resources");
                defence::requirements::celestia(compounds.dockyard, techs);
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
                let cost = defence::get_defences_cost(
                    quantity, defence::get_defences_unit_cost().blaster
                );
                assert!(available_resources >= cost, "Defence: Not enough resources");
                defence::requirements::blaster(compounds.dockyard, techs);
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
                let cost = defence::get_defences_cost(
                    quantity, defence::get_defences_unit_cost().beam
                );
                assert!(available_resources >= cost, "Defence: Not enough resources");
                defence::requirements::beam(compounds.dockyard, techs);
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
                let cost = defence::get_defences_cost(
                    quantity, defence::get_defences_unit_cost().astral
                );
                assert!(available_resources >= cost, "Defence: Not enough resources");
                defence::requirements::astral(compounds.dockyard, techs);
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
                let cost = defence::get_defences_cost(
                    quantity, defence::get_defences_unit_cost().plasma
                );
                assert!(available_resources >= cost, "Defence: Not enough resources");
                defence::requirements::plasma(compounds.dockyard, techs);
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
}

#[cfg(test)]
mod test {
    use debug::PrintTrait;
    use dojo::world::{IWorldDispatcherTrait, IWorldDispatcher};
    use nogame::data::types::{Position, DefenceBuildType};
    use nogame::defence::actions::{IDefenceActionsDispatcher, IDefenceActionsDispatcherTrait};
    use nogame::defence::models::{PlanetDefences};
    use nogame::game::actions::{IGameActionsDispatcher, IGameActionsDispatcherTrait};
    use nogame::game::models::{GameSetup, GamePlanetCount};
    use nogame::libraries::names::Names;

    use nogame::libraries::{constants};
    use nogame::models::compound::{PlanetCompounds};
    use nogame::planet::actions::{IPlanetActionsDispatcher, IPlanetActionsDispatcherTrait};
    use nogame::planet::models::{
        PlanetPosition, PositionToPlanet, PlanetResource, PlanetResourceTimer
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
