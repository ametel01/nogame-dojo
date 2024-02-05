use nogame::data::types::{ERC20s, CompoundUpgradeType, CompoundsLevels};

#[starknet::interface]
trait ICompoundActions<TState> {
    fn process_upgrade(ref self: TState, component: CompoundUpgradeType, quantity: u8);
}

#[dojo::contract]
mod compoundactions {
    use nogame::data::types::{CompoundUpgradeType, CompoundsLevels, ERC20s};
    use nogame::libraries::names::Names;
    use nogame::compound::{library as compound, models::{PlanetCompounds}};
    use nogame::defence::models::{PlanetDefences};
    use nogame::game::models::{GamePlanet, GameSetup};
    use nogame::planet::actions::{IPlanetActionsDispatcher, IPlanetActionsDispatcherTrait};
    use nogame::libraries::constants;
    use nogame::planet::models::{PlanetPosition, PlanetResourceTimer, PlanetResource};
    use starknet::{ContractAddress, get_caller_address};
    use debug::PrintTrait;

    #[abi(embed_v0)]
    impl CompoundActionsImpl of super::ICompoundActions<ContractState> {
        fn process_upgrade(ref self: ContractState, component: CompoundUpgradeType, quantity: u8) {
            let world = self.world_dispatcher.read();
            let caller = get_caller_address();
            let planet_id = get!(world, caller, GamePlanet).planet_id;
            self.upgrade_component(planet_id, component, quantity);
        }
    }

    #[generate_trait]
    impl Private of PrivateTrait {
        fn get_compound_levels(self: @ContractState, planet_id: u32) -> CompoundsLevels {
            let world = self.world_dispatcher.read();
            CompoundsLevels {
                steel: get!(world, (planet_id, Names::Compound::STEEL), PlanetCompounds).level,
                quartz: get!(world, (planet_id, Names::Compound::QUARTZ), PlanetCompounds).level,
                tritium: get!(world, (planet_id, Names::Compound::TRITIUM), PlanetCompounds).level,
                energy: get!(world, (planet_id, Names::Compound::ENERGY), PlanetCompounds).level,
                lab: get!(world, (planet_id, Names::Compound::LAB), PlanetCompounds).level,
                dockyard: get!(world, (planet_id, Names::Compound::DOCKYARD), PlanetCompounds).level
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

        fn upgrade_component(
            ref self: ContractState, planet_id: u32, component: CompoundUpgradeType, quantity: u8
        ) -> ERC20s {
            let world = self.world_dispatcher.read();
            let compounds = self.get_compound_levels(planet_id);
            self.collect(planet_id);
            let available_resources = self.get_resources_available(planet_id);
            let mut cost: ERC20s = Default::default();
            match component {
                CompoundUpgradeType::SteelMine => {
                    cost = compound::cost::steel(compounds.steel, quantity);
                    assert!(available_resources >= cost, "Compound: Not enough resources");
                    self.pay_resources(planet_id, available_resources, cost);
                    set!(
                        world,
                        (
                            PlanetCompounds {
                                planet_id,
                                name: Names::Compound::STEEL,
                                level: compounds.steel + quantity
                            },
                        )
                    );
                },
                CompoundUpgradeType::QuartzMine => {
                    cost = compound::cost::quartz(compounds.quartz, quantity);
                    assert!(available_resources >= cost, "Compound: Not enough resources");
                    self.pay_resources(planet_id, available_resources, cost);
                    set!(
                        world,
                        (
                            PlanetCompounds {
                                planet_id,
                                name: Names::Compound::QUARTZ,
                                level: compounds.quartz + quantity
                            },
                        )
                    );
                },
                CompoundUpgradeType::TritiumMine => {
                    cost = compound::cost::tritium(compounds.tritium, quantity);
                    assert!(available_resources >= cost, "Compound: Not enough resources");
                    self.pay_resources(planet_id, available_resources, cost);
                    set!(
                        world,
                        (
                            PlanetCompounds {
                                planet_id,
                                name: Names::Compound::TRITIUM,
                                level: compounds.tritium + quantity
                            },
                        )
                    );
                },
                CompoundUpgradeType::EnergyPlant => {
                    cost = compound::cost::energy(compounds.energy, quantity);
                    assert!(available_resources >= cost, "Compound: Not enough resources");
                    self.pay_resources(planet_id, available_resources, cost);
                    set!(
                        world,
                        (
                            PlanetCompounds {
                                planet_id,
                                name: Names::Compound::ENERGY,
                                level: compounds.energy + quantity
                            },
                        )
                    );
                },
                CompoundUpgradeType::Lab => {
                    cost = compound::cost::lab(compounds.lab, quantity);
                    assert!(available_resources >= cost, "Compound: Not enough resources");
                    self.pay_resources(planet_id, available_resources, cost);
                    set!(
                        world,
                        (
                            PlanetCompounds {
                                planet_id,
                                name: Names::Compound::LAB,
                                level: compounds.lab + quantity
                            },
                        )
                    );
                },
                CompoundUpgradeType::Dockyard => {
                    cost = compound::cost::dockyard(compounds.dockyard, quantity);
                    assert!(available_resources >= cost, "Compound: Not enough resources");
                    self.pay_resources(planet_id, available_resources, cost);
                    set!(
                        world,
                        (
                            PlanetCompounds {
                                planet_id,
                                name: Names::Compound::DOCKYARD,
                                level: compounds.dockyard + quantity
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

#[cfg(test)]
mod tests {
    use starknet::testing::{set_contract_address, set_block_timestamp};
    use dojo::world::{IWorldDispatcherTrait, IWorldDispatcher};

    use nogame::libraries::{constants};
    use nogame::data::types::{Position, CompoundUpgradeType};
    use nogame::libraries::names::Names;
    use nogame::compound::models::{PlanetCompounds};
    use nogame::game::models::{GameSetup, GamePlanetCount};
    use nogame::planet::models::{
        PlanetPosition, PositionToPlanet, PlanetResource, PlanetResourceTimer
    };
    use nogame::utils::test_utils::{
        setup_world, OWNER, GAME_SPEED, ACCOUNT_1, ACCOUNT_2, ACCOUNT_3, ACCOUNT_4, ACCOUNT_5, DAY
    };
    use super::{ICompoundActionsDispatcher, ICompoundActionsDispatcherTrait};
    use nogame::game::actions::{IGameActionsDispatcher, IGameActionsDispatcherTrait};
    use nogame::planet::actions::{IPlanetActionsDispatcher, IPlanetActionsDispatcherTrait};
    use debug::PrintTrait;

    #[test]
    fn test_upgrade_steel_mine_success() {
        let (world, compound_actions, game_actions, planet_actions, tech_actions, nft, eth) =
            setup_world();
        game_actions.spawn(OWNER(), nft, eth, constants::MIN_PRICE_UNSCALED, GAME_SPEED,);

        set_contract_address(ACCOUNT_1());
        planet_actions.generate_planet();

        compound_actions.process_upgrade(CompoundUpgradeType::SteelMine(()), 1);
        let steel_mine = get!(world, (1, Names::Compound::STEEL), PlanetCompounds).level;
        let steel_after = get!(world, (1, Names::Resource::STEEL), PlanetResource).amount;
        let quartz_after = get!(world, (1, Names::Resource::QUARTZ), PlanetResource).amount;
        assert(steel_mine == 1, 'Steel mine level should be 1');
        assert(steel_after == 440, 'Steel amount should be 440');
        assert(quartz_after == 285, 'Quartz amount should be 285');
    }

    #[test]
    fn test_upgrade_quartz_mine_success() {
        let (world, compound_actions, game_actions, planet_actions, tech_actions, nft, eth) =
            setup_world();
        game_actions.spawn(OWNER(), nft, eth, constants::MIN_PRICE_UNSCALED, GAME_SPEED,);

        set_contract_address(ACCOUNT_1());
        planet_actions.generate_planet();

        compound_actions.process_upgrade(CompoundUpgradeType::QuartzMine(()), 1);
        let quartz_mine = get!(world, (1, Names::Compound::QUARTZ), PlanetCompounds).level;
        assert(quartz_mine == 1, 'Quartz mine level should be 1');
    }

    #[test]
    fn test_upgrade_tritium_mine_success() {
        let (world, compound_actions, game_actions, planet_actions, tech_actions, nft, eth) =
            setup_world();
        game_actions.spawn(OWNER(), nft, eth, constants::MIN_PRICE_UNSCALED, GAME_SPEED,);

        set_contract_address(ACCOUNT_1());
        planet_actions.generate_planet();

        compound_actions.process_upgrade(CompoundUpgradeType::TritiumMine(()), 1);
        let tritium_mine = get!(world, (1, Names::Compound::TRITIUM), PlanetCompounds).level;
        assert(tritium_mine == 1, 'Tritium mine level should be 1');
    }

    #[test]
    fn test_upgrade_energy_plant_success() {
        let (world, compound_actions, game_actions, planet_actions, tech_actions, nft, eth) =
            setup_world();
        game_actions.spawn(OWNER(), nft, eth, constants::MIN_PRICE_UNSCALED, GAME_SPEED,);

        set_contract_address(ACCOUNT_1());
        planet_actions.generate_planet();

        compound_actions.process_upgrade(CompoundUpgradeType::EnergyPlant(()), 1);
        let energy_plant = get!(world, (1, Names::Compound::ENERGY), PlanetCompounds).level;
        assert(energy_plant == 1, 'Energy plant level should be 1');
    }

    #[test]
    fn test_upgrade_lab_success() {
        let (world, compound_actions, game_actions, planet_actions, tech_actions, nft, eth) =
            setup_world();
        game_actions.spawn(OWNER(), nft, eth, constants::MIN_PRICE_UNSCALED, GAME_SPEED,);

        set_contract_address(ACCOUNT_1());
        planet_actions.generate_planet();

        set!(world, PlanetResource { planet_id: 1, name: Names::Resource::QUARTZ, amount: 400 });
        set!(world, PlanetResource { planet_id: 1, name: Names::Resource::TRITIUM, amount: 200 });

        compound_actions.process_upgrade(CompoundUpgradeType::Lab(()), 1);
        let lab = get!(world, (1, Names::Compound::LAB), PlanetCompounds).level;
        assert(lab == 1, 'Lab level should be 1');
    }

    #[test]
    fn test_upgrade_dockyard_success() {
        let (world, compound_actions, game_actions, planet_actions, tech_actions, nft, eth) =
            setup_world();
        game_actions.spawn(OWNER(), nft, eth, constants::MIN_PRICE_UNSCALED, GAME_SPEED,);

        set_contract_address(ACCOUNT_1());
        planet_actions.generate_planet();

        compound_actions.process_upgrade(CompoundUpgradeType::Dockyard(()), 1);
        let dockyard = get!(world, (1, Names::Compound::DOCKYARD), PlanetCompounds).level;
        assert(dockyard == 1, 'Dockyard level should be 1');
    }
}
