use nogame::data::types::{TechLevels, TechUpgradeType};

#[dojo::interface]
trait ITechActions {
    fn process_upgrade(component: TechUpgradeType, quantity: u8);
}

#[dojo::contract]
mod techactions {
    use nogame::data::types::{TechLevels, TechUpgradeType, Resources};
    use nogame::libraries::compound;
    use nogame::libraries::constants;
    use nogame::libraries::names::Names;
    use nogame::libraries::shared;
    use nogame::models::{compound::PlanetCompounds, game::{GamePlanet, GameSetup}};
    use nogame::planet::actions::{IPlanetActionsDispatcher, IPlanetActionsDispatcherTrait};
    use nogame::planet::models::{PlanetResource, PlanetResourceTimer, PlanetPosition};
    use nogame::systems::compound::contract::{
        ICompoundActionsDispatcher, ICompoundActionsDispatcherTrait
    };
    use nogame::tech::library as tech;
    use nogame::tech::models::{PlanetTechs};
    use starknet::{get_caller_address};
    use super::private;

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        TechSpent: TechSpent
    }
    #[derive(Drop, starknet::Event)]
    struct TechSpent {
        planet_id: u32,
        quantity: u8,
        spent: Resources
    }

    #[abi(embed_v0)]
    impl TechActionsImpl of super::ITechActions<ContractState> {
        fn process_upgrade(component: TechUpgradeType, quantity: u8) {
            let world = self.world_dispatcher.read();
            let caller = get_caller_address();
            let planet_id = get!(world, caller, GamePlanet).planet_id;
            let cost = private::upgrade_component(world, planet_id, component, quantity);
            shared::update_planet_resources_spent(world, planet_id, cost);
            emit!(world, TechSpent { planet_id, quantity, spent: cost });
        }
    }
}

mod private {
    use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};
    use nogame::data::types::{TechLevels, TechUpgradeType, Resources};
    use nogame::libraries::constants;
    use nogame::libraries::names::Names;
    use nogame::libraries::shared;
    use nogame::planet::models::{PlanetResource};
    use nogame::tech::{library as tech, models::PlanetTechs};

    fn upgrade_component(
        world: IWorldDispatcher, planet_id: u32, component: TechUpgradeType, quantity: u8
    ) -> Resources {
        let compounds = shared::get_compound_levels(world, planet_id);
        let tech_levels = shared::get_tech_levels(world, planet_id);
        let base_tech_cost = tech::base_tech_costs();
        shared::collect(world, planet_id, 0, compounds);
        let available_resources = shared::get_resources_available(world, planet_id, 0);
        let mut cost: Resources = Default::default();

        match component {
            TechUpgradeType::Energy => {
                cost = tech::get_tech_cost(tech_levels.energy, quantity, base_tech_cost.energy);
                assert!(available_resources >= cost, "Tech: Not enough resources");
                tech::requirements::energy(compounds.lab, tech_levels);
                shared::pay_resources(world, planet_id, 0, available_resources, cost);
                set!(
                    world,
                    (
                        PlanetTechs {
                            planet_id,
                            name: Names::Tech::ENERGY,
                            level: tech_levels.energy + quantity
                        },
                    )
                );
            },
            TechUpgradeType::Digital => {
                cost = tech::get_tech_cost(tech_levels.digital, quantity, base_tech_cost.digital);
                assert!(available_resources >= cost, "Tech: Not enough resources");
                tech::requirements::digital(compounds.lab, tech_levels);
                shared::pay_resources(world, planet_id, 0, available_resources, cost);
                set!(
                    world,
                    (
                        PlanetTechs {
                            planet_id,
                            name: Names::Tech::DIGITAL,
                            level: tech_levels.digital + quantity
                        },
                    )
                );
            },
            TechUpgradeType::Beam => {
                cost = tech::get_tech_cost(tech_levels.beam, quantity, base_tech_cost.beam);
                assert!(available_resources >= cost, "Tech: Not enough resources");
                tech::requirements::beam(compounds.lab, tech_levels);
                shared::pay_resources(world, planet_id, 0, available_resources, cost);
                set!(
                    world,
                    (
                        PlanetTechs {
                            planet_id, name: Names::Tech::BEAM, level: tech_levels.beam + quantity
                        },
                    )
                );
            },
            TechUpgradeType::Armour => {
                cost = tech::get_tech_cost(tech_levels.armour, quantity, base_tech_cost.armour);
                assert!(available_resources >= cost, "Tech: Not enough resources");
                tech::requirements::armour(compounds.lab, tech_levels);
                shared::pay_resources(world, planet_id, 0, available_resources, cost);
                set!(
                    world,
                    (
                        PlanetTechs {
                            planet_id,
                            name: Names::Tech::ARMOUR,
                            level: tech_levels.armour + quantity
                        },
                    )
                );
            },
            TechUpgradeType::Ion => {
                cost = tech::get_tech_cost(tech_levels.ion, quantity, base_tech_cost.ion);
                assert!(available_resources >= cost, "Tech: Not enough resources");
                tech::requirements::ion(compounds.lab, tech_levels);
                shared::pay_resources(world, planet_id, 0, available_resources, cost);
                set!(
                    world,
                    (
                        PlanetTechs {
                            planet_id, name: Names::Tech::ION, level: tech_levels.ion + quantity
                        },
                    )
                );
            },
            TechUpgradeType::Plasma => {
                cost = tech::get_tech_cost(tech_levels.plasma, quantity, base_tech_cost.plasma);
                assert!(available_resources >= cost, "Tech: Not enough resources");
                tech::requirements::plasma(compounds.lab, tech_levels);
                shared::pay_resources(world, planet_id, 0, available_resources, cost);
                set!(
                    world,
                    (
                        PlanetTechs {
                            planet_id,
                            name: Names::Tech::PLASMA,
                            level: tech_levels.plasma + quantity
                        },
                    )
                );
            },
            TechUpgradeType::Weapons => {
                cost = tech::get_tech_cost(tech_levels.weapons, quantity, base_tech_cost.weapons);
                assert!(available_resources >= cost, "Tech: Not enough resources");
                tech::requirements::weapons(compounds.lab, tech_levels);
                shared::pay_resources(world, planet_id, 0, available_resources, cost);
                set!(
                    world,
                    (
                        PlanetTechs {
                            planet_id,
                            name: Names::Tech::WEAPONS,
                            level: tech_levels.weapons + quantity
                        },
                    )
                );
            },
            TechUpgradeType::Shield => {
                cost = tech::get_tech_cost(tech_levels.shield, quantity, base_tech_cost.shield);
                assert!(available_resources >= cost, "Tech: Not enough resources");
                tech::requirements::shield(compounds.lab, tech_levels);
                shared::pay_resources(world, planet_id, 0, available_resources, cost);
                set!(
                    world,
                    (
                        PlanetTechs {
                            planet_id,
                            name: Names::Tech::SHIELD,
                            level: tech_levels.shield + quantity
                        },
                    )
                );
            },
            TechUpgradeType::Spacetime => {
                cost =
                    tech::get_tech_cost(tech_levels.spacetime, quantity, base_tech_cost.spacetime);
                assert!(available_resources >= cost, "Tech: Not enough resources");
                tech::requirements::spacetime(compounds.lab, tech_levels);
                shared::pay_resources(world, planet_id, 0, available_resources, cost);
                set!(
                    world,
                    (
                        PlanetTechs {
                            planet_id,
                            name: Names::Tech::SPACETIME,
                            level: tech_levels.spacetime + quantity
                        },
                    )
                );
            },
            TechUpgradeType::Combustion => {
                cost =
                    tech::get_tech_cost(
                        tech_levels.combustion, quantity, base_tech_cost.combustion
                    );
                assert!(available_resources >= cost, "Tech: Not enough resources");
                tech::requirements::combustion(compounds.lab, tech_levels);
                shared::pay_resources(world, planet_id, 0, available_resources, cost);
                set!(
                    world,
                    (
                        PlanetTechs {
                            planet_id,
                            name: Names::Tech::COMBUSTION,
                            level: tech_levels.combustion + quantity
                        },
                    )
                );
            },
            TechUpgradeType::Thrust => {
                cost = tech::get_tech_cost(tech_levels.thrust, quantity, base_tech_cost.thrust);
                assert!(available_resources >= cost, "Tech: Not enough resources");
                tech::requirements::thrust(compounds.lab, tech_levels);
                shared::pay_resources(world, planet_id, 0, available_resources, cost);
                set!(
                    world,
                    (
                        PlanetTechs {
                            planet_id,
                            name: Names::Tech::THRUST,
                            level: tech_levels.thrust + quantity
                        },
                    )
                );
            },
            TechUpgradeType::Warp => {
                cost = tech::get_tech_cost(tech_levels.warp, quantity, base_tech_cost.warp);
                assert!(available_resources >= cost, "Tech: Not enough resources");
                tech::requirements::warp(compounds.lab, tech_levels);
                shared::pay_resources(world, planet_id, 0, available_resources, cost);
                set!(
                    world,
                    (
                        PlanetTechs {
                            planet_id, name: Names::Tech::WARP, level: tech_levels.warp + quantity
                        },
                    )
                );
            },
            TechUpgradeType::Exocraft => {
                cost = tech::exocraft_cost(tech_levels.exocraft, quantity);
                assert!(available_resources >= cost, "Tech: Not enough resources");
                tech::requirements::exocraft(compounds.lab, tech_levels);
                shared::pay_resources(world, planet_id, 0, available_resources, cost);
                set!(
                    world,
                    (
                        PlanetTechs {
                            planet_id,
                            name: Names::Tech::EXOCRAFT,
                            level: tech_levels.exocraft + quantity
                        },
                    )
                );
            },
        };
        cost
    }
}

#[cfg(test)]
mod test {
    use dojo::world::{IWorldDispatcherTrait, IWorldDispatcher};
    use nogame::data::types::{Position, TechUpgradeType};
    use nogame::libraries::names::Names;

    use nogame::libraries::{constants};
    use nogame::models::{compound::PlanetCompounds, game::GameSetup};
    use nogame::planet::actions::{IPlanetActionsDispatcher, IPlanetActionsDispatcherTrait};
    use nogame::planet::models::{
        PlanetPosition, PositionToPlanet, PlanetResource, PlanetResourceTimer
    };
    use nogame::systems::game::contract::{IGameActionsDispatcher, IGameActionsDispatcherTrait};
    use nogame::tech::actions::{ITechActionsDispatcher, ITechActionsDispatcherTrait};
    use nogame::tech::models::{PlanetTechs};
    use nogame::utils::test_utils::{
        setup_world, OWNER, GAME_SPEED, ACCOUNT_1, ACCOUNT_2, ACCOUNT_3, ACCOUNT_4, ACCOUNT_5, DAY
    };
    use starknet::testing::{set_contract_address, set_block_timestamp};

    #[test]
    fn test_upgrade_energy_tech_success() {
        let (world, actions) = setup_world();
        actions.game.spawn(GAME_SPEED);

        set_contract_address(ACCOUNT_1());
        actions.planet.generate_planet();
        set!(world, PlanetResource { planet_id: 1, name: Names::Resource::QUARTZ, amount: 800 });
        set!(world, PlanetResource { planet_id: 1, name: Names::Resource::TRITIUM, amount: 400 });
        set!(world, PlanetCompounds { planet_id: 1, name: Names::Compound::LAB, level: 1 });

        actions.tech.process_upgrade(TechUpgradeType::Energy(()), 1);
        let energy_tech = get!(world, (1, Names::Tech::ENERGY), PlanetTechs).level;
        assert(energy_tech == 1, 'Energy tech level should be 1');

        let quartz = get!(world, (1, Names::Resource::QUARTZ), PlanetResource).amount;
        assert(quartz == 0, 'Quartz should be 0');
        let tritium = get!(world, (1, Names::Resource::TRITIUM), PlanetResource).amount;
        assert(tritium == 0, 'Tritium should be 0');
    }

    #[test]
    fn test_upgrade_digital_tech_success() {
        let (world, actions) = setup_world();
        actions.game.spawn(GAME_SPEED);

        set_contract_address(ACCOUNT_1());
        actions.planet.generate_planet();
        set!(world, PlanetResource { planet_id: 1, name: Names::Resource::QUARTZ, amount: 400 });
        set!(world, PlanetResource { planet_id: 1, name: Names::Resource::TRITIUM, amount: 600 });
        set!(world, PlanetCompounds { planet_id: 1, name: Names::Compound::LAB, level: 1 });

        actions.tech.process_upgrade(TechUpgradeType::Digital(()), 1);
        let digital_tech = get!(world, (1, Names::Tech::DIGITAL), PlanetTechs).level;
        assert(digital_tech == 1, 'Digital tech level should be 1');

        let quartz = get!(world, (1, Names::Resource::QUARTZ), PlanetResource).amount;
        assert(quartz == 0, 'Quartz should be 0');
        let tritium = get!(world, (1, Names::Resource::TRITIUM), PlanetResource).amount;
        assert(tritium == 0, 'Tritium should be 0');
    }

    #[test]
    fn test_upgrade_beam_tech_success() {
        let (world, actions) = setup_world();
        actions.game.spawn(GAME_SPEED);

        set_contract_address(ACCOUNT_1());
        actions.planet.generate_planet();
        set!(world, PlanetResource { planet_id: 1, name: Names::Resource::QUARTZ, amount: 800 });
        set!(world, PlanetResource { planet_id: 1, name: Names::Resource::TRITIUM, amount: 400 });
        set!(world, PlanetCompounds { planet_id: 1, name: Names::Compound::LAB, level: 1 });
        set!(world, PlanetTechs { planet_id: 1, name: Names::Tech::ENERGY, level: 2 });

        actions.tech.process_upgrade(TechUpgradeType::Beam(()), 1);
        let beam_tech = get!(world, (1, Names::Tech::BEAM), PlanetTechs).level;
        assert(beam_tech == 1, 'Beam tech level should be 1');

        let quartz = get!(world, (1, Names::Resource::QUARTZ), PlanetResource).amount;
        assert(quartz == 0, 'Quartz should be 0');
        let tritium = get!(world, (1, Names::Resource::TRITIUM), PlanetResource).amount;
        assert(tritium == 0, 'Tritium should be 0');
    }

    #[test]
    fn test_upgrade_armour_tech_success() {
        let (world, actions) = setup_world();
        actions.game.spawn(GAME_SPEED);

        set_contract_address(ACCOUNT_1());
        actions.planet.generate_planet();
        set!(world, PlanetResource { planet_id: 1, name: Names::Resource::STEEL, amount: 1000 });
        set!(world, PlanetCompounds { planet_id: 1, name: Names::Compound::LAB, level: 2 });

        actions.tech.process_upgrade(TechUpgradeType::Armour(()), 1);
        let armour_tech = get!(world, (1, Names::Tech::ARMOUR), PlanetTechs).level;
        assert(armour_tech == 1, 'Armour tech level should be 1');

        let steel = get!(world, (1, Names::Resource::STEEL), PlanetResource).amount;
        assert(steel == 0, 'Stee should be 0');
    }

    #[test]
    fn test_upgrade_ion_tech_success() {
        let (world, actions) = setup_world();
        actions.game.spawn(GAME_SPEED);

        set_contract_address(ACCOUNT_1());
        actions.planet.generate_planet();
        set!(world, PlanetResource { planet_id: 1, name: Names::Resource::STEEL, amount: 1000 });
        set!(world, PlanetResource { planet_id: 1, name: Names::Resource::QUARTZ, amount: 300 });
        set!(world, PlanetResource { planet_id: 1, name: Names::Resource::TRITIUM, amount: 1000 });
        set!(world, PlanetCompounds { planet_id: 1, name: Names::Compound::LAB, level: 4 });
        set!(world, PlanetTechs { planet_id: 1, name: Names::Tech::ENERGY, level: 4 });
        set!(world, PlanetTechs { planet_id: 1, name: Names::Tech::BEAM, level: 5 });

        actions.tech.process_upgrade(TechUpgradeType::Ion(()), 1);
        let ion_tech = get!(world, (1, Names::Tech::ION), PlanetTechs).level;
        assert(ion_tech == 1, 'Ion tech level should be 1');

        let steel = get!(world, (1, Names::Resource::STEEL), PlanetResource).amount;
        assert(steel == 0, 'Steel should be 0');
        let quartz = get!(world, (1, Names::Resource::QUARTZ), PlanetResource).amount;
        assert(quartz == 0, 'Quartz should be 0');
        let tritium = get!(world, (1, Names::Resource::TRITIUM), PlanetResource).amount;
        assert(tritium == 0, 'Tritium should be 0');
    }

    #[test]
    fn test_upgrade_plasma_tech_success() {
        let (world, actions) = setup_world();
        actions.game.spawn(GAME_SPEED);

        set_contract_address(ACCOUNT_1());
        actions.planet.generate_planet();
        set!(world, PlanetResource { planet_id: 1, name: Names::Resource::STEEL, amount: 2000 });
        set!(world, PlanetResource { planet_id: 1, name: Names::Resource::QUARTZ, amount: 4000 });
        set!(world, PlanetResource { planet_id: 1, name: Names::Resource::TRITIUM, amount: 1000 });
        set!(world, PlanetCompounds { planet_id: 1, name: Names::Compound::LAB, level: 4 });
        set!(world, PlanetTechs { planet_id: 1, name: Names::Tech::ENERGY, level: 8 });
        set!(world, PlanetTechs { planet_id: 1, name: Names::Tech::BEAM, level: 10 });
        set!(world, PlanetTechs { planet_id: 1, name: Names::Tech::ION, level: 5 });

        actions.tech.process_upgrade(TechUpgradeType::Plasma(()), 1);
        let plasma_tech = get!(world, (1, Names::Tech::PLASMA), PlanetTechs).level;
        assert(plasma_tech == 1, 'Plasma tech level should be 1');

        let steel = get!(world, (1, Names::Resource::STEEL), PlanetResource).amount;
        assert(steel == 0, 'Steel should be 0');
        let quartz = get!(world, (1, Names::Resource::QUARTZ), PlanetResource).amount;
        assert(quartz == 0, 'Quartz should be 0');
        let tritium = get!(world, (1, Names::Resource::TRITIUM), PlanetResource).amount;
        assert(tritium == 0, 'Tritium should be 0');
    }

    #[test]
    fn test_upgrade_weapons_tech_success() {
        let (world, actions) = setup_world();
        actions.game.spawn(GAME_SPEED);

        set_contract_address(ACCOUNT_1());
        actions.planet.generate_planet();
        set!(world, PlanetResource { planet_id: 1, name: Names::Resource::STEEL, amount: 800 });
        set!(world, PlanetResource { planet_id: 1, name: Names::Resource::QUARTZ, amount: 200 });
        set!(world, PlanetCompounds { planet_id: 1, name: Names::Compound::LAB, level: 4 });

        actions.tech.process_upgrade(TechUpgradeType::Weapons(()), 1);
        let weapons_tech = get!(world, (1, Names::Tech::WEAPONS), PlanetTechs).level;
        assert(weapons_tech == 1, 'Weapons tech level should be 1');

        let steel = get!(world, (1, Names::Resource::STEEL), PlanetResource).amount;
        assert(steel == 0, 'Steel should be 0');
        let quartz = get!(world, (1, Names::Resource::QUARTZ), PlanetResource).amount;
        assert(quartz == 0, 'Quartz should be 0');
    }

    #[test]
    fn test_upgrade_shield_tech_success() {
        let (world, actions) = setup_world();
        actions.game.spawn(GAME_SPEED);

        set_contract_address(ACCOUNT_1());
        actions.planet.generate_planet();
        set!(world, PlanetResource { planet_id: 1, name: Names::Resource::STEEL, amount: 200 });
        set!(world, PlanetResource { planet_id: 1, name: Names::Resource::QUARTZ, amount: 600 });
        set!(world, PlanetCompounds { planet_id: 1, name: Names::Compound::LAB, level: 6 });
        set!(world, PlanetTechs { planet_id: 1, name: Names::Tech::ENERGY, level: 3 });

        actions.tech.process_upgrade(TechUpgradeType::Shield(()), 1);
        let shield_tech = get!(world, (1, Names::Tech::SHIELD), PlanetTechs).level;
        assert(shield_tech == 1, 'Shield tech level should be 1');

        let steel = get!(world, (1, Names::Resource::STEEL), PlanetResource).amount;
        assert(steel == 0, 'Steel should be 0');
        let quartz = get!(world, (1, Names::Resource::QUARTZ), PlanetResource).amount;
        assert(quartz == 0, 'Quartz should be 0');
    }

    #[test]
    fn test_upgrade_spacetime_tech_success() {
        let (world, actions) = setup_world();
        actions.game.spawn(GAME_SPEED);

        set_contract_address(ACCOUNT_1());
        actions.planet.generate_planet();
        set!(world, PlanetResource { planet_id: 1, name: Names::Resource::QUARTZ, amount: 4000 });
        set!(world, PlanetResource { planet_id: 1, name: Names::Resource::TRITIUM, amount: 2000 });
        set!(world, PlanetCompounds { planet_id: 1, name: Names::Compound::LAB, level: 7 });
        set!(world, PlanetTechs { planet_id: 1, name: Names::Tech::ENERGY, level: 5 });
        set!(world, PlanetTechs { planet_id: 1, name: Names::Tech::SHIELD, level: 5 });

        actions.tech.process_upgrade(TechUpgradeType::Spacetime(()), 1);
        let spacetime_tech = get!(world, (1, Names::Tech::SPACETIME), PlanetTechs).level;
        assert!(spacetime_tech == 1, "Spacetime tech level should be 1");

        let steel = get!(world, (1, Names::Resource::TRITIUM), PlanetResource).amount;
        assert(steel == 0, 'Tritium should be 0');
        let quartz = get!(world, (1, Names::Resource::QUARTZ), PlanetResource).amount;
        assert(quartz == 0, 'Quartz should be 0');
    }

    #[test]
    fn test_upgrade_combustion_tech_success() {
        let (world, actions) = setup_world();
        actions.game.spawn(GAME_SPEED);

        set_contract_address(ACCOUNT_1());
        actions.planet.generate_planet();
        set!(world, PlanetResource { planet_id: 1, name: Names::Resource::STEEL, amount: 400 });
        set!(world, PlanetResource { planet_id: 1, name: Names::Resource::TRITIUM, amount: 600 });
        set!(world, PlanetCompounds { planet_id: 1, name: Names::Compound::LAB, level: 1 });
        set!(world, PlanetTechs { planet_id: 1, name: Names::Tech::ENERGY, level: 1 });

        actions.tech.process_upgrade(TechUpgradeType::Combustion(()), 1);
        let combustion_tech = get!(world, (1, Names::Tech::COMBUSTION), PlanetTechs).level;
        assert!(combustion_tech == 1, "Combustion tech level should be 1");

        let steel = get!(world, (1, Names::Resource::STEEL), PlanetResource).amount;
        assert(steel == 0, 'Steel should be 0');
        let tritium = get!(world, (1, Names::Resource::TRITIUM), PlanetResource).amount;
        assert(tritium == 0, 'Tritium should be 0');
    }

    #[test]
    fn test_upgrade_thrust_tech_success() {
        let (world, actions) = setup_world();
        actions.game.spawn(GAME_SPEED);

        set_contract_address(ACCOUNT_1());
        actions.planet.generate_planet();
        set!(world, PlanetResource { planet_id: 1, name: Names::Resource::STEEL, amount: 2000 });
        set!(world, PlanetResource { planet_id: 1, name: Names::Resource::QUARTZ, amount: 4000 });
        set!(world, PlanetResource { planet_id: 1, name: Names::Resource::TRITIUM, amount: 600 });
        set!(world, PlanetCompounds { planet_id: 1, name: Names::Compound::LAB, level: 2 });
        set!(world, PlanetTechs { planet_id: 1, name: Names::Tech::ENERGY, level: 1 });

        actions.tech.process_upgrade(TechUpgradeType::Thrust(()), 1);
        let thrust_tech = get!(world, (1, Names::Tech::THRUST), PlanetTechs).level;
        assert!(thrust_tech == 1, "Thrust tech level should be 1");

        let steel = get!(world, (1, Names::Resource::STEEL), PlanetResource).amount;
        assert(steel == 0, 'Steel should be 0');
        let quartz = get!(world, (1, Names::Resource::QUARTZ), PlanetResource).amount;
        assert(quartz == 0, 'Quartz should be 0');
        let tritium = get!(world, (1, Names::Resource::TRITIUM), PlanetResource).amount;
        assert(tritium == 0, 'Tritium should be 0');
    }

    #[test]
    fn test_upgrade_warp_tech_success() {
        let (world, actions) = setup_world();
        actions.game.spawn(GAME_SPEED);

        set_contract_address(ACCOUNT_1());
        actions.planet.generate_planet();
        set!(world, PlanetResource { planet_id: 1, name: Names::Resource::STEEL, amount: 10000 });
        set!(world, PlanetResource { planet_id: 1, name: Names::Resource::QUARTZ, amount: 20000 });
        set!(world, PlanetResource { planet_id: 1, name: Names::Resource::TRITIUM, amount: 6000 });
        set!(world, PlanetCompounds { planet_id: 1, name: Names::Compound::LAB, level: 7 });
        set!(world, PlanetTechs { planet_id: 1, name: Names::Tech::ENERGY, level: 5 });
        set!(world, PlanetTechs { planet_id: 1, name: Names::Tech::SPACETIME, level: 3 });

        actions.tech.process_upgrade(TechUpgradeType::Warp(()), 1);
        let warp_tech = get!(world, (1, Names::Tech::WARP), PlanetTechs).level;
        assert!(warp_tech == 1, "Warp tech level should be 1");

        let steel = get!(world, (1, Names::Resource::STEEL), PlanetResource).amount;
        assert(steel == 0, 'Steel should be 0');
        let quartz = get!(world, (1, Names::Resource::QUARTZ), PlanetResource).amount;
        assert(quartz == 0, 'Quartz should be 0');
        let tritium = get!(world, (1, Names::Resource::TRITIUM), PlanetResource).amount;
        assert(tritium == 0, 'Tritium should be 0');
    }

    #[test]
    fn test_upgrade_exocraft_tech_success() {
        let (world, actions) = setup_world();
        actions.game.spawn(GAME_SPEED);

        set_contract_address(ACCOUNT_1());
        actions.planet.generate_planet();
        set!(world, PlanetResource { planet_id: 1, name: Names::Resource::STEEL, amount: 4000 });
        set!(world, PlanetResource { planet_id: 1, name: Names::Resource::QUARTZ, amount: 8000 });
        set!(world, PlanetResource { planet_id: 1, name: Names::Resource::TRITIUM, amount: 4000 });
        set!(world, PlanetCompounds { planet_id: 1, name: Names::Compound::LAB, level: 3 });
        set!(world, PlanetTechs { planet_id: 1, name: Names::Tech::THRUST, level: 3 });

        actions.tech.process_upgrade(TechUpgradeType::Exocraft(()), 1);
        let exocraft_tech = get!(world, (1, Names::Tech::EXOCRAFT), PlanetTechs).level;
        assert!(exocraft_tech == 1, "Exocraft tech level should be 1");

        let steel = get!(world, (1, Names::Resource::STEEL), PlanetResource).amount;
        assert(steel == 0, 'Steel should be 0');
        let quartz = get!(world, (1, Names::Resource::QUARTZ), PlanetResource).amount;
        assert(quartz == 0, 'Quartz should be 0');
        let tritium = get!(world, (1, Names::Resource::TRITIUM), PlanetResource).amount;
        assert(tritium == 0, 'Tritium should be 0');
    }
}
