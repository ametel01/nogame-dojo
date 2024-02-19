use nogame::data::types::{ShipBuildType};

#[starknet::interface]
trait IDockyardActions<TState> {
    fn process_ship_build(ref self: TState, component: ShipBuildType, quantity: u32);
}

#[dojo::contract]
mod dockyardactions {
    use nogame::compound::models::PlanetCompounds;
    use nogame::compound::library as compound;
    use nogame::libraries::constants;
    use nogame::data::types::{ShipBuildType, Resources, TechLevels, Fleet};
    use nogame::defence::models::PlanetDefences;
    use nogame::dockyard::models::PlanetShips;
    use nogame::dockyard::library as dockyard;
    use nogame::libraries::names::Names;
    use nogame::libraries::shared;
    use nogame::game::models::{GamePlanet, GameSetup};
    use nogame::planet::models::{PlanetResource, PlanetResourceTimer, PlanetPosition};
    use nogame::tech::models::PlanetTechs;
    use starknet::{get_caller_address, ContractAddress};

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        FleetSpent: FleetSpent,
    }
    #[derive(Drop, starknet::Event)]
    struct FleetSpent {
        planet_id: u32,
        quantity: u32,
        spent: Resources
    }

    #[abi(embed_v0)]
    impl DockyardActionsImpl of super::IDockyardActions<ContractState> {
        fn process_ship_build(ref self: ContractState, component: ShipBuildType, quantity: u32) {
            let world = self.world_dispatcher.read();
            let caller = get_caller_address();
            let planet_id = get!(world, caller, GamePlanet).planet_id;
            let cost = build_component(world, planet_id, component, quantity);
            emit!(world, FleetSpent { planet_id, quantity, spent: cost });
        }
    }

    fn build_component(
        world: IWorldDispatcher, planet_id: u32, component: ShipBuildType, quantity: u32
    ) -> Resources {
        let techs = shared::get_tech_levels(world, planet_id);
        let compounds = shared::get_compound_levels(world, planet_id);
        let ships_levels = shared::get_ships_levels(world, planet_id);
        shared::collect(world, planet_id, compounds);
        let available_resources = shared::get_resources_available(world, planet_id);
        match component {
            ShipBuildType::Carrier => {
                let cost = dockyard::get_ships_cost(
                    quantity, dockyard::get_ships_unit_cost().carrier
                );
                assert!(available_resources >= cost, "Dockyard: Not enough resources");
                dockyard::carrier_requirements_check(compounds.dockyard, techs);
                shared::pay_resources(world, planet_id, available_resources, cost);
                set!(
                    world,
                    (
                        PlanetShips {
                            planet_id,
                            name: Names::Fleet::CARRIER,
                            count: ships_levels.carrier + quantity
                        },
                    )
                );
                return cost;
            },
            ShipBuildType::Scraper => {
                let cost = dockyard::get_ships_cost(
                    quantity, dockyard::get_ships_unit_cost().scraper
                );
                assert!(available_resources >= cost, "Dockyard: Not enough resources");
                dockyard::scraper_requirements_check(compounds.dockyard, techs);
                shared::pay_resources(world, planet_id, available_resources, cost);
                set!(
                    world,
                    (
                        PlanetShips {
                            planet_id,
                            name: Names::Fleet::SCRAPER,
                            count: ships_levels.scraper + quantity
                        },
                    )
                );
                return cost;
            },
            ShipBuildType::Sparrow => {
                let cost = dockyard::get_ships_cost(
                    quantity, dockyard::get_ships_unit_cost().sparrow
                );
                assert!(available_resources >= cost, "Dockyard: Not enough resources");
                dockyard::sparrow_requirements_check(compounds.dockyard, techs);
                shared::pay_resources(world, planet_id, available_resources, cost);
                set!(
                    world,
                    (
                        PlanetShips {
                            planet_id,
                            name: Names::Fleet::SPARROW,
                            count: ships_levels.sparrow + quantity
                        },
                    )
                );
                return cost;
            },
            ShipBuildType::Frigate => {
                let cost = dockyard::get_ships_cost(
                    quantity, dockyard::get_ships_unit_cost().frigate
                );
                assert!(available_resources >= cost, "Dockyard: Not enough resources");
                dockyard::frigate_requirements_check(compounds.dockyard, techs);
                shared::pay_resources(world, planet_id, available_resources, cost);
                set!(
                    world,
                    (
                        PlanetShips {
                            planet_id,
                            name: Names::Fleet::FRIGATE,
                            count: ships_levels.frigate + quantity
                        },
                    )
                );
                return cost;
            },
            ShipBuildType::Armade => {
                let cost = dockyard::get_ships_cost(
                    quantity, dockyard::get_ships_unit_cost().armade
                );
                assert!(available_resources >= cost, "Dockyard: Not enough resources");
                dockyard::armade_requirements_check(compounds.dockyard, techs);
                shared::pay_resources(world, planet_id, available_resources, cost);
                set!(
                    world,
                    (
                        PlanetShips {
                            planet_id,
                            name: Names::Fleet::ARMADE,
                            count: ships_levels.armade + quantity
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
    use starknet::testing::{set_contract_address, set_block_timestamp};
    use dojo::world::{IWorldDispatcherTrait, IWorldDispatcher};

    use nogame::libraries::{constants};
    use nogame::data::types::{Position, ShipBuildType};
    use nogame::libraries::names::Names;
    use nogame::compound::models::{PlanetCompounds};
    use nogame::game::models::{GameSetup, GamePlanetCount};
    use nogame::planet::models::{
        PlanetPosition, PositionToPlanet, PlanetResource, PlanetResourceTimer
    };
    use nogame::utils::test_utils::{
        setup_world, OWNER, GAME_SPEED, ACCOUNT_1, ACCOUNT_2, ACCOUNT_3, ACCOUNT_4, ACCOUNT_5, DAY
    };
    use nogame::game::actions::{IGameActionsDispatcher, IGameActionsDispatcherTrait};
    use nogame::planet::actions::{IPlanetActionsDispatcher, IPlanetActionsDispatcherTrait};
    use nogame::dockyard::actions::{IDockyardActionsDispatcher, IDockyardActionsDispatcherTrait};
    use nogame::tech::models::{PlanetTechs};
    use nogame::dockyard::models::{PlanetShips};
    use debug::PrintTrait;

    #[test]
    fn test_build_carrier_success() {
        let (world, actions) = setup_world();
        actions.game.spawn(GAME_SPEED);

        set_contract_address(ACCOUNT_1());
        actions.planet.generate_planet();
        set!(world, PlanetResource { planet_id: 1, name: Names::Resource::STEEL, amount: 20_000 });
        set!(world, PlanetResource { planet_id: 1, name: Names::Resource::QUARTZ, amount: 20_000 });
        set!(world, PlanetCompounds { planet_id: 1, name: Names::Compound::DOCKYARD, level: 2 });
        set!(world, PlanetTechs { planet_id: 1, name: Names::Tech::COMBUSTION, level: 2 });

        actions.dockyard.process_ship_build(ShipBuildType::Carrier(()), 10);
        let carrier = get!(world, (1, Names::Fleet::CARRIER), PlanetShips).count;
        assert(carrier == 10, 'Carrier count should be 10');

        let steel = get!(world, (1, Names::Resource::STEEL), PlanetResource).amount;
        assert(steel == 0, 'Steel should be 0');
        let quartz = get!(world, (1, Names::Resource::QUARTZ), PlanetResource).amount;
        assert(quartz == 0, 'Quartz should be 0');
    }

    #[test]
    fn test_build_scraper_success() {
        let (world, actions) = setup_world();
        actions.game.spawn(GAME_SPEED);

        set_contract_address(ACCOUNT_1());
        actions.planet.generate_planet();
        set!(world, PlanetResource { planet_id: 1, name: Names::Resource::STEEL, amount: 100_000 });
        set!(world, PlanetResource { planet_id: 1, name: Names::Resource::QUARTZ, amount: 60_000 });
        set!(
            world, PlanetResource { planet_id: 1, name: Names::Resource::TRITIUM, amount: 20_000 }
        );
        set!(world, PlanetCompounds { planet_id: 1, name: Names::Compound::DOCKYARD, level: 4 });
        set!(world, PlanetTechs { planet_id: 1, name: Names::Tech::COMBUSTION, level: 6 });
        set!(world, PlanetTechs { planet_id: 1, name: Names::Tech::SHIELD, level: 2 });

        actions.dockyard.process_ship_build(ShipBuildType::Scraper(()), 10);
        let scraper = get!(world, (1, Names::Fleet::SCRAPER), PlanetShips).count;
        assert(scraper == 10, 'Scraper count should be 10');

        let steel = get!(world, (1, Names::Resource::STEEL), PlanetResource).amount;
        assert(steel == 0, 'Steel should be 0');
        let quartz = get!(world, (1, Names::Resource::QUARTZ), PlanetResource).amount;
        assert(quartz == 0, 'Quartz should be 0');
        let tritium = get!(world, (1, Names::Resource::TRITIUM), PlanetResource).amount;
        assert(tritium == 0, 'Tritium should be 0');
    }

    #[test]
    fn test_build_sparrow_success() {
        let (world, actions) = setup_world();
        actions.game.spawn(GAME_SPEED);

        set_contract_address(ACCOUNT_1());
        actions.planet.generate_planet();
        set!(world, PlanetResource { planet_id: 1, name: Names::Resource::STEEL, amount: 30_000 });
        set!(world, PlanetResource { planet_id: 1, name: Names::Resource::QUARTZ, amount: 10_000 });

        set!(world, PlanetCompounds { planet_id: 1, name: Names::Compound::DOCKYARD, level: 1 });
        set!(world, PlanetTechs { planet_id: 1, name: Names::Tech::COMBUSTION, level: 1 });

        actions.dockyard.process_ship_build(ShipBuildType::Sparrow(()), 10);
        let sparrow = get!(world, (1, Names::Fleet::SPARROW), PlanetShips).count;
        assert(sparrow == 10, 'Sparrow count should be 10');

        let steel = get!(world, (1, Names::Resource::STEEL), PlanetResource).amount;
        assert(steel == 0, 'Steel should be 0');
        let quartz = get!(world, (1, Names::Resource::QUARTZ), PlanetResource).amount;
        assert(quartz == 0, 'Quartz should be 0');
    }

    #[test]
    fn test_build_frigate_success() {
        let (world, actions) = setup_world();
        actions.game.spawn(GAME_SPEED);

        set_contract_address(ACCOUNT_1());
        actions.planet.generate_planet();
        set!(world, PlanetResource { planet_id: 1, name: Names::Resource::STEEL, amount: 200_000 });
        set!(world, PlanetResource { planet_id: 1, name: Names::Resource::QUARTZ, amount: 70_000 });
        set!(
            world, PlanetResource { planet_id: 1, name: Names::Resource::TRITIUM, amount: 20_000 }
        );

        set!(world, PlanetCompounds { planet_id: 1, name: Names::Compound::DOCKYARD, level: 5 });
        set!(world, PlanetTechs { planet_id: 1, name: Names::Tech::ION, level: 2 });
        set!(world, PlanetTechs { planet_id: 1, name: Names::Tech::THRUST, level: 4 });

        actions.dockyard.process_ship_build(ShipBuildType::Frigate(()), 10);
        let frigate = get!(world, (1, Names::Fleet::FRIGATE), PlanetShips).count;
        assert(frigate == 10, 'Frigate count should be 10');

        let steel = get!(world, (1, Names::Resource::STEEL), PlanetResource).amount;
        assert(steel == 0, 'Steel should be 0');
        let quartz = get!(world, (1, Names::Resource::QUARTZ), PlanetResource).amount;
        assert(quartz == 0, 'Quartz should be 0');
        let tritium = get!(world, (1, Names::Resource::TRITIUM), PlanetResource).amount;
        assert(tritium == 0, 'Tritium should be 0');
    }

    #[test]
    fn test_build_armade_success() {
        let (world, actions) = setup_world();
        actions.game.spawn(GAME_SPEED);

        set_contract_address(ACCOUNT_1());
        actions.planet.generate_planet();
        set!(world, PlanetResource { planet_id: 1, name: Names::Resource::STEEL, amount: 450_000 });
        set!(
            world, PlanetResource { planet_id: 1, name: Names::Resource::QUARTZ, amount: 150_000 }
        );

        set!(world, PlanetCompounds { planet_id: 1, name: Names::Compound::DOCKYARD, level: 7 });
        set!(world, PlanetTechs { planet_id: 1, name: Names::Tech::WARP, level: 4 });

        actions.dockyard.process_ship_build(ShipBuildType::Armade(()), 10);
        let armade = get!(world, (1, Names::Fleet::ARMADE), PlanetShips).count;
        assert(armade == 10, 'Armade count should be 10');

        let steel = get!(world, (1, Names::Resource::STEEL), PlanetResource).amount;
        assert(steel == 0, 'Steel should be 0');
        let quartz = get!(world, (1, Names::Resource::QUARTZ), PlanetResource).amount;
        assert(quartz == 0, 'Quartz should be 0');
    }
}
