use nogame::data::types::{DefenceBuildType};

#[starknet::interface]
trait IDefenceActions<TState> {
    fn process_defence_build(ref self: TState, component: DefenceBuildType, quantity: u32);
}

#[dojo::contract]
mod defenceactions {
    use nogame::compound::models::PlanetCompounds;
    use nogame::compound::library as compound;
    use nogame::libraries::constants;
    use nogame::data::types::{DefenceBuildType, ERC20s, TechLevels, Defences};
    use nogame::defence::models::PlanetDefences;
    use nogame::defence::library as defence;
    use nogame::libraries::names::Names;
    use nogame::game::models::{GamePlanet, GameSetup};
    use nogame::planet::models::{PlanetResource, PlanetResourceTimer, PlanetPosition};
    use nogame::tech::models::PlanetTechs;
    use starknet::{get_caller_address, ContractAddress};

    #[abi(embed_v0)]
    impl DefenceActionsImpl of super::IDefenceActions<ContractState> {
        fn process_defence_build(
            ref self: ContractState, component: DefenceBuildType, quantity: u32
        ) {
            let world = self.world_dispatcher.read();
            let caller = get_caller_address();
            let planet_id = get!(world, caller, GamePlanet).planet_id;
            self.build_component(planet_id, component, quantity);
        }
    }

    #[generate_trait]
    impl Private of PrivateTrait {
        fn build_component(
            ref self: ContractState, planet_id: u32, component: DefenceBuildType, quantity: u32
        ) -> ERC20s {
            let world = self.world_dispatcher.read();
            let techs = self.get_tech_levels(planet_id);
            let dockyard_level = get!(
                world, (planet_id, Names::Compound::DOCKYARD), PlanetCompounds
            )
                .level;
            let defences_levels = self.get_defences_levels(planet_id);
            self.collect(planet_id);
            let available_resources = self.get_resources_available(planet_id);
            match component {
                DefenceBuildType::Celestia => {
                    let cost = defence::get_defences_cost(
                        quantity, defence::get_defences_unit_cost().celestia
                    );
                    assert!(available_resources >= cost, "Defence: Not enough resources");
                    defence::requirements::celestia(dockyard_level, techs);
                    self.pay_resources(planet_id, available_resources, cost);
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
                    defence::requirements::blaster(dockyard_level, techs);
                    self.pay_resources(planet_id, available_resources, cost);
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
                    defence::requirements::beam(dockyard_level, techs);
                    self.pay_resources(planet_id, available_resources, cost);
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
                    defence::requirements::astral(dockyard_level, techs);
                    self.pay_resources(planet_id, available_resources, cost);
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
                    defence::requirements::plasma(dockyard_level, techs);
                    self.pay_resources(planet_id, available_resources, cost);
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

        fn get_defences_levels(self: @ContractState, planet_id: u32) -> Defences {
            let world = self.world_dispatcher.read();
            Defences {
                celestia: get!(world, (planet_id, Names::Defence::CELESTIA), PlanetDefences).count,
                blaster: get!(world, (planet_id, Names::Defence::BLASTER), PlanetDefences).count,
                beam: get!(world, (planet_id, Names::Defence::BEAM), PlanetDefences).count,
                astral: get!(world, (planet_id, Names::Defence::ASTRAL), PlanetDefences).count,
                plasma: get!(world, (planet_id, Names::Defence::PLASMA), PlanetDefences).count,
            }
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

        fn get_resources_available(self: @ContractState, planet_id: u32) -> ERC20s {
            let world = self.world_dispatcher.read();
            ERC20s {
                steel: get!(world, (planet_id, Names::Resource::STEEL), PlanetResource).amount,
                quartz: get!(world, (planet_id, Names::Resource::QUARTZ), PlanetResource).amount,
                tritium: get!(world, (planet_id, Names::Resource::TRITIUM), PlanetResource).amount
            }
        }

        fn calculate_production(self: @ContractState, planet_id: u32) -> ERC20s {
            let world = self.world_dispatcher.read();
            let time_now = starknet::get_block_timestamp();
            let last_collection_time = get!(world, planet_id, PlanetResourceTimer).timestamp;
            let time_elapsed = time_now - last_collection_time;

            let steel_level = get!(world, (planet_id, Names::Compound::STEEL), PlanetCompounds)
                .level;
            let quartz_level = get!(world, (planet_id, Names::Compound::QUARTZ), PlanetCompounds)
                .level;
            let tritium_level = get!(world, (planet_id, Names::Compound::TRITIUM), PlanetCompounds)
                .level;
            let energy_level = get!(world, (planet_id, Names::Compound::ENERGY), PlanetCompounds)
                .level;

            let position = get!(world, planet_id, PlanetPosition).position;
            let temp = compound::calculate_avg_temperature(position.orbit);
            let speed = get!(world, constants::GAME_ID, GameSetup).speed;
            let steel_available = compound::production::steel(steel_level)
                * speed.into()
                * time_elapsed.into()
                / constants::HOUR.into();

            let quartz_available = compound::production::quartz(quartz_level)
                * speed.into()
                * time_elapsed.into()
                / constants::HOUR.into();

            let tritium_available = compound::production::tritium(tritium_level, temp, speed.into())
                * time_elapsed.into()
                / constants::HOUR.into();
            let energy_available = compound::production::energy(energy_level);
            let celestia_production = compound::celestia_production(position.orbit);
            let celestia_available = get!(
                world, (planet_id, Names::Defence::CELESTIA), PlanetDefences
            )
                .count;
            let energy_required = compound::consumption::base(steel_level)
                + compound::consumption::base(quartz_level)
                + compound::consumption::base(tritium_level);
            if energy_available
                + (celestia_production.into() * celestia_available).into() < energy_required {
                let _steel = compound::production_scaler(
                    steel_available, energy_available, energy_required
                );
                let _quartz = compound::production_scaler(
                    quartz_available, energy_available, energy_required
                );
                let _tritium = compound::production_scaler(
                    tritium_available, energy_available, energy_required
                );

                return ERC20s { steel: _steel, quartz: _quartz, tritium: _tritium, };
            }

            ERC20s { steel: steel_available, quartz: quartz_available, tritium: tritium_available, }
        }

        fn collect(ref self: ContractState, planet_id: u32) {
            let world = self.world_dispatcher.read();
            let available = self.get_resources_available(planet_id);
            let collectible = self.calculate_production(planet_id);
            set!(
                world,
                (
                    PlanetResource {
                        planet_id,
                        name: Names::Resource::STEEL,
                        amount: available.steel + collectible.steel
                    },
                )
            );
            set!(
                world,
                (
                    PlanetResource {
                        planet_id,
                        name: Names::Resource::QUARTZ,
                        amount: available.quartz + collectible.quartz
                    },
                )
            );
            set!(
                world,
                (
                    PlanetResource {
                        planet_id,
                        name: Names::Resource::TRITIUM,
                        amount: available.tritium + collectible.tritium
                    },
                )
            );
            set!(
                world,
                (PlanetResourceTimer { planet_id, timestamp: starknet::get_block_timestamp() },)
            );
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
