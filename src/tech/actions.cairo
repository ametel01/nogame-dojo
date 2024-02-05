use nogame::data::types::{TechLevels, TechUpgradeType};

#[starknet::interface]
trait ITechActions<TState> {
    fn process_upgrade(ref self: TState, component: TechUpgradeType, quantity: u8);
    fn get_tech_levels(self: @TState, planet_id: u32) -> TechLevels;
}

#[dojo::contract]
mod techactions {
    use nogame::compound::actions::{ICompoundActionsDispatcher, ICompoundActionsDispatcherTrait};
    use nogame::data::types::{TechLevels, TechUpgradeType, ERC20s};
    use nogame::libraries::names::Names;
    use nogame::libraries::constants;
    use nogame::game::models::{GamePlanet, GameSystems};
    use nogame::planet::models::{PlanetResource};
    use nogame::planet::actions::{IPlanetActionsDispatcher, IPlanetActionsDispatcherTrait};
    use nogame::tech::models::{PlanetTechs};
    use nogame::tech::library as tech;
    use starknet::{get_caller_address};

    #[abi(embed_v0)]
    impl TechActionsImpl of super::ITechActions<ContractState> {
        fn process_upgrade(ref self: ContractState, component: TechUpgradeType, quantity: u8) {
            let world = self.world_dispatcher.read();
            let caller = get_caller_address();
            let planet_id = get!(world, caller, GamePlanet).planet_id;
            self.upgrade_component(planet_id, component, quantity);
        }

        fn get_tech_levels(self: @ContractState, planet_id: u32) -> TechLevels {
            let world = self.world_dispatcher.read();
            TechLevels {
                energy: get!(world, (planet_id, Names::Tech::ENERGY), PlanetTechs).level,
                digital: get!(world, (planet_id, Names::Tech::DIGITAL), PlanetTechs).level,
                beam: get!(world, (planet_id, Names::Tech::BEAM), PlanetTechs).level,
                armour: get!(world, (planet_id, Names::Tech::ARMOUR), PlanetTechs).level,
                ion: get!(world, (planet_id, Names::Tech::ION), PlanetTechs).level,
                plasma: get!(world, (planet_id, Names::Tech::PLASMA), PlanetTechs).level,
                weapons: get!(world, (planet_id, Names::Tech::WEAPONS), PlanetTechs).level,
                shield: get!(world, (planet_id, Names::Tech::SHIELD), PlanetTechs).level,
                spacetime: get!(world, (planet_id, Names::Tech::SPACETIME), PlanetTechs).level,
                combustion: get!(world, (planet_id, Names::Tech::COMBUSTION), PlanetTechs).level,
                thrust: get!(world, (planet_id, Names::Tech::THRUST), PlanetTechs).level,
                warp: get!(world, (planet_id, Names::Tech::WARP), PlanetTechs).level,
                exocraft: get!(world, (planet_id, Names::Tech::EXOCRAFT), PlanetTechs).level,
            }
        }
    }

    #[generate_trait]
    impl Private of PrivateTrait {
        fn upgrade_component(
            ref self: ContractState, planet_id: u32, component: TechUpgradeType, quantity: u8
        ) -> ERC20s {
            let world = self.world_dispatcher.read();
            let systems = get!(world, constants::GAME_ID, GameSystems);
            let compounds = ICompoundActionsDispatcher { contract_address: systems.compound };
            let lab_level = compounds.get_compound_levels(planet_id).lab;
            let tech_levels = self.get_tech_levels(planet_id);
            let base_tech_cost = tech::base_tech_costs();
            compounds.collect_resources();
            let available_resources = IPlanetActionsDispatcher { contract_address: systems.planet }
                .get_resources_available(planet_id);
            let mut cost: ERC20s = Default::default();

            match component {
                TechUpgradeType::Energy => {
                    cost = tech::get_tech_cost(tech_levels.energy, quantity, base_tech_cost.energy);
                    assert!(available_resources >= cost, "Tech: Not enough resources");
                    tech::requirements::energy(lab_level, tech_levels);
                    self.pay_resources(planet_id, available_resources, cost);
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
                    cost =
                        tech::get_tech_cost(tech_levels.digital, quantity, base_tech_cost.digital);
                    assert!(available_resources >= cost, "Tech: Not enough resources");
                    tech::requirements::digital(lab_level, tech_levels);
                    self.pay_resources(planet_id, available_resources, cost);
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
                    tech::requirements::beam(lab_level, tech_levels);
                    self.pay_resources(planet_id, available_resources, cost);
                    set!(
                        world,
                        (
                            PlanetTechs {
                                planet_id,
                                name: Names::Tech::BEAM,
                                level: tech_levels.beam + quantity
                            },
                        )
                    );
                },
                TechUpgradeType::Armour => {
                    cost = tech::get_tech_cost(tech_levels.armour, quantity, base_tech_cost.armour);
                    assert!(available_resources >= cost, "Tech: Not enough resources");
                    tech::requirements::armour(lab_level, tech_levels);
                    self.pay_resources(planet_id, available_resources, cost);
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
                    tech::requirements::ion(lab_level, tech_levels);
                    self.pay_resources(planet_id, available_resources, cost);
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
                    tech::requirements::plasma(lab_level, tech_levels);
                    self.pay_resources(planet_id, available_resources, cost);
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
                    cost =
                        tech::get_tech_cost(tech_levels.weapons, quantity, base_tech_cost.weapons);
                    assert!(available_resources >= cost, "Tech: Not enough resources");
                    tech::requirements::weapons(lab_level, tech_levels);
                    self.pay_resources(planet_id, available_resources, cost);
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
                    tech::requirements::shield(lab_level, tech_levels);
                    self.pay_resources(planet_id, available_resources, cost);
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
                        tech::get_tech_cost(
                            tech_levels.spacetime, quantity, base_tech_cost.spacetime
                        );
                    assert!(available_resources >= cost, "Tech: Not enough resources");
                    tech::requirements::spacetime(lab_level, tech_levels);
                    self.pay_resources(planet_id, available_resources, cost);
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
                    tech::requirements::combustion(lab_level, tech_levels);
                    self.pay_resources(planet_id, available_resources, cost);
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
                    tech::requirements::thrust(lab_level, tech_levels);
                    self.pay_resources(planet_id, available_resources, cost);
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
                    tech::requirements::warp(lab_level, tech_levels);
                    self.pay_resources(planet_id, available_resources, cost);
                    set!(
                        world,
                        (
                            PlanetTechs {
                                planet_id,
                                name: Names::Tech::WARP,
                                level: tech_levels.warp + quantity
                            },
                        )
                    );
                },
                TechUpgradeType::Exocraft => {
                    cost = tech::exocraft_cost(tech_levels.exocraft, quantity);
                    assert!(available_resources >= cost, "Tech: Not enough resources");
                    tech::requirements::exocraft(lab_level, tech_levels);
                    self.pay_resources(planet_id, available_resources, cost);
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

        fn pay_resources(ref self: ContractState, planet_id: u32, available: ERC20s, cost: ERC20s) {
            let world = self.world_dispatcher.read();
            if cost.steel > 0 {
                set!(
                    world,
                    (
                        PlanetResource {
                            planet_id,
                            name: Names::Resource::STEEL,
                            amount: available.steel - cost.steel
                        },
                    )
                );
            }
            if cost.quartz > 0 {
                set!(
                    world,
                    (
                        PlanetResource {
                            planet_id,
                            name: Names::Resource::QUARTZ,
                            amount: available.quartz - cost.quartz
                        },
                    )
                );
            }
            if cost.tritium > 0 {
                set!(
                    world,
                    (
                        PlanetResource {
                            planet_id,
                            name: Names::Resource::TRITIUM,
                            amount: available.tritium - cost.tritium
                        },
                    )
                );
            }
        }
    }
}
