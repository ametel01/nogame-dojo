use nogame::data::types::{
    Position, CompoundUpgradeType, ERC20s, ShipBuildType, DefenceBuildType, TechLevels,
    CompoundsLevels, Fleet, Defences
};

#[starknet::interface]
trait IColonyActions<TState> {
    fn generate_colony(ref self: TState);
    fn process_colony_compound_upgrade(
        ref self: TState, colony_id: u8, name: CompoundUpgradeType, quantity: u8
    );
    fn process_ship_build(ref self: TState, colony_id: u8, name: ShipBuildType, quantity: u32,);
    fn process_defence_build(
        ref self: TState, colony_id: u8, name: DefenceBuildType, quantity: u32,
    );
    fn get_resources_available(ref self: TState, colony_id: u8) -> ERC20s;
}

#[dojo::contract]
mod colonyactions {
    use nogame::data::types::{
        Position, CompoundUpgradeType, ERC20s, ShipBuildType, DefenceBuildType, TechLevels,
        CompoundsLevels, Fleet, Defences
    };
    use nogame::colony::models::{
        ColonyCompounds, ColonyCount, ColonyResourceTimer, ColonyPosition, ColonyDefences,
        PlanetColoniesCount, ColonyResource, ColonyShips, ColonyOwner
    };
    use nogame::colony::positions;
    use nogame::compound::library as compound;
    use nogame::defence::library as defence;
    use nogame::dockyard::library as dockyard;
    use nogame::game::models::{GamePlanet, GameSetup};
    use nogame::libraries::constants;
    use nogame::libraries::names::Names;
    use nogame::libraries::shared;
    use nogame::planet::models::{PositionToPlanet, PlanetPosition, PlanetResourcesSpent};
    use starknet::{get_block_timestamp, get_caller_address};
    use openzeppelin::token::erc20::interface::{IERC20CamelDispatcher, IERC20CamelDispatcherTrait};

    #[abi(embed_v0)]
    impl ColonyActionsImpl of super::IColonyActions<ContractState> {
        fn generate_colony(ref self: ContractState) {
            let world = self.world_dispatcher.read();
            let caller = get_caller_address();
            let planet_id = get!(world, caller, GamePlanet).planet_id;
            let exo_tech = shared::get_tech_levels(world, planet_id).exocraft;
            let max_colonies = if exo_tech % 2 == 1 {
                exo_tech / 2 + 1
            } else {
                exo_tech / 2
            };
            let current_planet_colonies = get!(world, planet_id, PlanetColoniesCount).count;
            let current_count = get!(world, constants::GAME_ID, ColonyCount).count;
            assert!(
                current_planet_colonies < max_colonies.into(),
                "Colony: max colonies {} for planet {} reached, upgrade Exocraft tech to increase max colonies",
                max_colonies,
                planet_id
            );
            let position = positions::get_colony_position(current_count.into());
            let colony_id = current_planet_colonies + 1;
            let id = ((planet_id * 1000) + colony_id.into());
            set!(world, ColonyOwner { colony_planet_id: id, planet_id, });
            set!(world, PositionToPlanet { position, planet_id: id });
            set!(world, PlanetPosition { planet_id: id, position });
            set!(world, ColonyPosition { planet_id, colony_id, position });
            set!(
                world,
                ColonyResourceTimer { planet_id, colony_id, last_collection: get_block_timestamp() }
            );
            set!(world, PlanetColoniesCount { planet_id, count: colony_id });
            set!(world, ColonyCount { game_id: constants::GAME_ID, count: current_count + 1 });
        }

        fn process_colony_compound_upgrade(
            ref self: ContractState, colony_id: u8, name: CompoundUpgradeType, quantity: u8
        ) {
            let world = self.world_dispatcher.read();
            let caller = get_caller_address();
            let planet_id = get!(world, caller, GamePlanet).planet_id;
            upgrade_component(world, planet_id, colony_id, name, quantity);
        }

        fn process_ship_build(
            ref self: ContractState, colony_id: u8, name: ShipBuildType, quantity: u32
        ) {
            let world = self.world_dispatcher.read();
            let caller = get_caller_address();
            let planet_id = get!(world, caller, GamePlanet).planet_id;
            build_ship(world, planet_id, colony_id, name, quantity);
        }

        fn process_defence_build(
            ref self: ContractState, colony_id: u8, name: DefenceBuildType, quantity: u32,
        ) {
            let world = self.world_dispatcher.read();
            let caller = get_caller_address();
            let planet_id = get!(world, caller, GamePlanet).planet_id;
            build_defence(world, planet_id, colony_id, name, quantity);
        }

        fn get_resources_available(
            ref self: ContractState, planet_id: u32, colony_id: u8
        ) -> ERC20s {
            let world = self.world_dispatcher.read();
            let caller = get_caller_address();
            get_colony_resources(world, planet_id, colony_id)
                + calculate_production(
                    world, planet_id, colony_id, get_colony_compounds(world, planet_id, colony_id)
                )
        }
    }


    fn upgrade_component(
        world: IWorldDispatcher,
        planet_id: u32,
        colony_id: u8,
        component: CompoundUpgradeType,
        quantity: u8
    ) {
        let compounds = get_colony_compounds(world, planet_id, colony_id);
        collect(world, planet_id, colony_id, compounds);
        let resource_available = get_colony_resources(world, planet_id, colony_id);
        match component {
            CompoundUpgradeType::SteelMine => {
                let cost = compound::cost::steel(compounds.steel, quantity);
                assert!(
                    resource_available >= cost, "Colony: not enough resources to upgrade steel mine"
                );
                pay_resources(world, planet_id, colony_id, resource_available, cost);
                set!(
                    world,
                    ColonyCompounds {
                        planet_id,
                        colony_id,
                        name: Names::Compound::STEEL,
                        level: compounds.steel + quantity
                    }
                );
            },
            CompoundUpgradeType::QuartzMine => {
                let cost = compound::cost::quartz(compounds.quartz, quantity);
                assert!(
                    resource_available >= cost,
                    "Colony: not enough resources to upgrade quartz mine"
                );
                pay_resources(world, planet_id, colony_id, resource_available, cost);
                set!(
                    world,
                    ColonyCompounds {
                        planet_id,
                        colony_id,
                        name: Names::Compound::QUARTZ,
                        level: compounds.quartz + quantity
                    }
                );
            },
            CompoundUpgradeType::TritiumMine => {
                let cost = compound::cost::tritium(compounds.tritium, quantity);
                assert!(
                    resource_available >= cost,
                    "Colony: not enough resources to upgrade tritium mine"
                );
                pay_resources(world, planet_id, colony_id, resource_available, cost);
                set!(
                    world,
                    ColonyCompounds {
                        planet_id,
                        colony_id,
                        name: Names::Compound::TRITIUM,
                        level: compounds.tritium + quantity
                    }
                );
            },
            CompoundUpgradeType::EnergyPlant => {
                let cost = compound::cost::energy(compounds.energy, quantity);
                assert!(
                    resource_available >= cost,
                    "Colony: not enough resources to upgrade energy plant"
                );
                pay_resources(world, planet_id, colony_id, resource_available, cost);
                set!(
                    world,
                    ColonyCompounds {
                        planet_id,
                        colony_id,
                        name: Names::Compound::ENERGY,
                        level: compounds.energy + quantity
                    }
                );
            },
            CompoundUpgradeType::Lab => {},
            CompoundUpgradeType::Dockyard => {
                let cost = compound::cost::dockyard(compounds.dockyard, quantity);
                assert!(
                    resource_available >= cost, "Colony: not enough resources to upgrade dockyard"
                );
                pay_resources(world, planet_id, colony_id, resource_available, cost);
                set!(
                    world,
                    ColonyCompounds {
                        planet_id,
                        colony_id,
                        name: Names::Compound::DOCKYARD,
                        level: compounds.dockyard + quantity
                    }
                );
            },
        }
    }

    fn build_ship(
        world: IWorldDispatcher,
        planet_id: u32,
        colony_id: u8,
        component: ShipBuildType,
        quantity: u32,
    ) -> ERC20s {
        let compounds = get_colony_compounds(world, planet_id, colony_id);
        let ships_levels = get_colony_ships(world, planet_id, colony_id);
        collect(world, planet_id, colony_id, compounds);
        let resource_available = get_colony_resources(world, planet_id, colony_id);
        let techs = shared::get_tech_levels(world, planet_id);
        match component {
            ShipBuildType::Carrier => {
                let cost = dockyard::get_ships_cost(
                    quantity, dockyard::get_ships_unit_cost().carrier
                );
                assert!(resource_available >= cost, "Colony Dockyard: Not enough resources");
                dockyard::carrier_requirements_check(compounds.dockyard, techs);
                pay_resources(world, planet_id, colony_id, resource_available, cost);
                set!(
                    world,
                    (
                        ColonyShips {
                            planet_id,
                            colony_id,
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
                assert!(resource_available >= cost, "Colony Dockyard: Not enough resources");
                dockyard::scraper_requirements_check(compounds.dockyard, techs);
                pay_resources(world, planet_id, colony_id, resource_available, cost);
                set!(
                    world,
                    (
                        ColonyShips {
                            planet_id,
                            colony_id,
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
                assert!(resource_available >= cost, "Colony Dockyard: Not enough resources");
                dockyard::sparrow_requirements_check(compounds.dockyard, techs);
                pay_resources(world, planet_id, colony_id, resource_available, cost);
                set!(
                    world,
                    (
                        ColonyShips {
                            planet_id,
                            colony_id,
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
                assert!(resource_available >= cost, "Colony Dockyard: Not enough resources");
                dockyard::frigate_requirements_check(compounds.dockyard, techs);
                pay_resources(world, planet_id, colony_id, resource_available, cost);
                set!(
                    world,
                    (
                        ColonyShips {
                            planet_id,
                            colony_id,
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
                assert!(resource_available >= cost, "Colony Dockyard: Not enough resources");
                dockyard::armade_requirements_check(compounds.dockyard, techs);
                pay_resources(world, planet_id, colony_id, resource_available, cost);
                set!(
                    world,
                    (
                        ColonyShips {
                            planet_id,
                            colony_id,
                            name: Names::Fleet::ARMADE,
                            count: ships_levels.armade + quantity
                        },
                    )
                );
                return cost;
            },
        }
    }

    fn build_defence(
        world: IWorldDispatcher,
        planet_id: u32,
        colony_id: u8,
        component: DefenceBuildType,
        quantity: u32,
    ) -> ERC20s {
        let compounds = get_colony_compounds(world, planet_id, colony_id);
        let defences_levels = get_colony_defences(world, planet_id, colony_id);
        let costs = defence::get_defences_unit_cost();
        collect(world, planet_id, colony_id, compounds);
        let resource_available = get_colony_resources(world, planet_id, colony_id);
        let techs = shared::get_tech_levels(world, planet_id);
        match component {
            DefenceBuildType::Celestia => {
                let cost = defence::get_defences_cost(quantity, costs.celestia);
                assert!(resource_available >= cost, "Colony Defence: Not enough resources");
                defence::requirements::celestia(compounds.dockyard, techs);
                pay_resources(world, planet_id, colony_id, resource_available, cost);
                set!(
                    world,
                    (
                        ColonyDefences {
                            planet_id,
                            colony_id,
                            name: Names::Defence::CELESTIA,
                            count: defences_levels.celestia + quantity
                        },
                    )
                );
                return cost;
            },
            DefenceBuildType::Blaster => {
                let cost = defence::get_defences_cost(quantity, costs.blaster);
                assert!(resource_available >= cost, "Colony Defence: Not enough resources");
                defence::requirements::blaster(compounds.dockyard, techs);
                pay_resources(world, planet_id, colony_id, resource_available, cost);
                set!(
                    world,
                    (
                        ColonyDefences {
                            planet_id,
                            colony_id,
                            name: Names::Defence::BLASTER,
                            count: defences_levels.blaster + quantity
                        },
                    )
                );
                return cost;
            },
            DefenceBuildType::Beam => {
                let cost = defence::get_defences_cost(quantity, costs.beam);
                assert!(resource_available >= cost, "Colony Defence: Not enough resources");
                defence::requirements::beam(compounds.dockyard, techs);
                pay_resources(world, planet_id, colony_id, resource_available, cost);
                set!(
                    world,
                    (
                        ColonyDefences {
                            planet_id,
                            colony_id,
                            name: Names::Defence::BEAM,
                            count: defences_levels.beam + quantity
                        },
                    )
                );
                return cost;
            },
            DefenceBuildType::Astral => {
                let cost = defence::get_defences_cost(quantity, costs.astral);
                assert!(resource_available >= cost, "Colony Defence: Not enough resources");
                defence::requirements::astral(compounds.dockyard, techs);
                pay_resources(world, planet_id, colony_id, resource_available, cost);
                set!(
                    world,
                    (
                        ColonyDefences {
                            planet_id,
                            colony_id,
                            name: Names::Defence::ASTRAL,
                            count: defences_levels.astral + quantity
                        },
                    )
                );
                return cost;
            },
            DefenceBuildType::Plasma => {
                let cost = defence::get_defences_cost(quantity, costs.plasma);
                assert!(resource_available >= cost, "Colony Defence: Not enough resources");
                defence::requirements::plasma(compounds.dockyard, techs);
                pay_resources(world, planet_id, colony_id, resource_available, cost);
                set!(
                    world,
                    (
                        ColonyDefences {
                            planet_id,
                            colony_id,
                            name: Names::Defence::PLASMA,
                            count: defences_levels.plasma + quantity
                        },
                    )
                );
                return cost;
            },
        }
    }

    fn get_colony_resources(world: IWorldDispatcher, planet_id: u32, colony_id: u8) -> ERC20s {
        let uni_speed = get!(world, constants::GAME_ID, GameSetup).speed;
        ERC20s {
            steel: get!(world, (planet_id, colony_id, Names::Resource::STEEL), ColonyResource)
                .amount
                * uni_speed.into(),
            quartz: get!(world, (planet_id, colony_id, Names::Resource::QUARTZ), ColonyResource)
                .amount
                * uni_speed.into(),
            tritium: get!(world, (planet_id, colony_id, Names::Resource::TRITIUM), ColonyResource)
                .amount
                * uni_speed.into(),
        }
    }

    fn get_colony_compounds(
        world: IWorldDispatcher, planet_id: u32, colony_id: u8
    ) -> CompoundsLevels {
        CompoundsLevels {
            steel: get!(world, (planet_id, colony_id, Names::Compound::STEEL), ColonyCompounds)
                .level,
            quartz: get!(world, (planet_id, colony_id, Names::Compound::QUARTZ), ColonyCompounds)
                .level,
            tritium: get!(world, (planet_id, colony_id, Names::Compound::TRITIUM), ColonyCompounds)
                .level,
            energy: get!(world, (planet_id, colony_id, Names::Compound::ENERGY), ColonyCompounds)
                .level,
            lab: 0,
            dockyard: get!(
                world, (planet_id, colony_id, Names::Compound::DOCKYARD), ColonyCompounds
            )
                .level,
        }
    }

    fn get_colony_ships(world: IWorldDispatcher, planet_id: u32, colony_id: u8) -> Fleet {
        Fleet {
            carrier: get!(world, (planet_id, colony_id, Names::Fleet::CARRIER), ColonyShips).count,
            scraper: get!(world, (planet_id, colony_id, Names::Fleet::SCRAPER), ColonyShips).count,
            sparrow: get!(world, (planet_id, colony_id, Names::Fleet::SPARROW), ColonyShips).count,
            frigate: get!(world, (planet_id, colony_id, Names::Fleet::FRIGATE), ColonyShips).count,
            armade: get!(world, (planet_id, colony_id, Names::Fleet::ARMADE), ColonyShips).count,
        }
    }

    fn get_colony_defences(world: IWorldDispatcher, planet_id: u32, colony_id: u8) -> Defences {
        Defences {
            celestia: get!(world, (planet_id, colony_id, Names::Defence::CELESTIA), ColonyDefences)
                .count,
            blaster: get!(world, (planet_id, colony_id, Names::Defence::BLASTER), ColonyDefences)
                .count,
            beam: get!(world, (planet_id, colony_id, Names::Defence::BEAM), ColonyDefences).count,
            astral: get!(world, (planet_id, colony_id, Names::Defence::ASTRAL), ColonyDefences)
                .count,
            plasma: get!(world, (planet_id, colony_id, Names::Defence::PLASMA), ColonyDefences)
                .count,
        }
    }

    fn collect(world: IWorldDispatcher, planet_id: u32, colony_id: u8, compounds: CompoundsLevels) {
        let available = get_colony_resources(world, planet_id, colony_id);
        let collectible = calculate_production(world, planet_id, colony_id, compounds);
        set!(
            world,
            (
                ColonyResource {
                    planet_id,
                    colony_id,
                    name: Names::Resource::STEEL,
                    amount: available.steel + collectible.steel
                },
            )
        );
        set!(
            world,
            (
                ColonyResource {
                    planet_id,
                    colony_id,
                    name: Names::Resource::QUARTZ,
                    amount: available.quartz + collectible.quartz
                },
            )
        );
        set!(
            world,
            (
                ColonyResource {
                    planet_id,
                    colony_id,
                    name: Names::Resource::TRITIUM,
                    amount: available.tritium + collectible.tritium
                },
            )
        );
        set!(
            world,
            (
                ColonyResourceTimer {
                    planet_id, colony_id, last_collection: starknet::get_block_timestamp()
                },
            )
        );
    }


    fn pay_resources(
        world: IWorldDispatcher, planet_id: u32, colony_id: u8, available: ERC20s, cost: ERC20s
    ) {
        if cost.steel > 0 {
            set!(
                world,
                (
                    ColonyResource {
                        planet_id,
                        colony_id,
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
                    ColonyResource {
                        planet_id,
                        colony_id,
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
                    ColonyResource {
                        planet_id,
                        colony_id,
                        name: Names::Resource::TRITIUM,
                        amount: available.tritium - cost.tritium
                    },
                )
            );
        }
        set!(world, PlanetResourcesSpent { planet_id, spent: cost.steel + cost.quartz });
    }

    fn receive_resources(
        world: IWorldDispatcher, planet_id: u32, colony_id: u8, available: ERC20s, amount: ERC20s
    ) {
        if amount.steel > 0 {
            set!(
                world,
                (
                    ColonyResource {
                        planet_id,
                        colony_id,
                        name: Names::Resource::STEEL,
                        amount: available.steel + amount.steel
                    },
                )
            );
        }
        if amount.quartz > 0 {
            set!(
                world,
                (
                    ColonyResource {
                        planet_id,
                        colony_id,
                        name: Names::Resource::QUARTZ,
                        amount: available.quartz + amount.quartz
                    },
                )
            );
        }
        if amount.tritium > 0 {
            set!(
                world,
                (
                    ColonyResource {
                        planet_id,
                        colony_id,
                        name: Names::Resource::TRITIUM,
                        amount: available.tritium + amount.tritium
                    },
                )
            );
        }
    }

    fn calculate_production(
        world: IWorldDispatcher, planet_id: u32, colony_id: u8, compounds: CompoundsLevels
    ) -> ERC20s {
        let time_now = starknet::get_block_timestamp();
        let last_collection_time = get!(world, (planet_id, colony_id), ColonyResourceTimer)
            .last_collection;
        let time_elapsed = time_now - last_collection_time;

        let position = get!(world, (planet_id, colony_id), ColonyPosition).position;
        let temp = compound::calculate_avg_temperature(position.orbit);
        let speed = get!(world, constants::GAME_ID, GameSetup).speed;
        let steel_available = compound::production::steel(compounds.steel)
            * speed.into()
            * time_elapsed.into()
            / constants::HOUR.into();

        let quartz_available = compound::production::quartz(compounds.quartz)
            * speed.into()
            * time_elapsed.into()
            / constants::HOUR.into();

        let tritium_available = compound::production::tritium(compounds.tritium, temp, speed.into())
            * time_elapsed.into()
            / constants::HOUR.into();
        let energy_available = compound::production::energy(compounds.energy);
        let celestia_production = compound::celestia_production(position.orbit);
        let celestia_available = get!(
            world, (planet_id, colony_id, Names::Defence::CELESTIA), ColonyDefences
        )
            .count;
        let energy_required = compound::consumption::base(compounds.steel)
            + compound::consumption::base(compounds.quartz)
            + compound::consumption::base(compounds.tritium);
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
}

#[cfg(test)]
mod test {
    use starknet::testing::{set_contract_address, set_block_timestamp};
    use dojo::world::{IWorldDispatcherTrait, IWorldDispatcher};
    use nogame::colony::actions::{IColonyActionsDispatcher, IColonyActionsDispatcherTrait};
    use nogame::colony::models::{
        ColonyOwner, ColonyPosition, ColonyCount, ColonyResourceTimer, PlanetColoniesCount,
        ColonyResource, ColonyShips, ColonyDefences, ColonyCompounds
    };
    use nogame::libraries::{constants};
    use nogame::data::types::{Position, ShipBuildType, CompoundUpgradeType, DefenceBuildType};
    use nogame::libraries::names::Names;
    use nogame::compound::models::{PlanetCompounds};
    use nogame::game::models::{GameSetup};
    use nogame::planet::models::{PlanetPosition, PositionToPlanet,};
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
    fn test_generate_colony() {
        let (world, actions) = setup_world();
        actions.game.spawn(GAME_SPEED);

        set_contract_address(ACCOUNT_1());
        actions.planet.generate_planet();
        set!(world, PlanetTechs { planet_id: 1, name: Names::Tech::EXOCRAFT, level: 3 });

        actions.colony.generate_colony();

        let colony_owner = get!(world, 1001, ColonyOwner).planet_id;
        assert!(colony_owner == 1, "Colony: owner not set correctly");

        let total_colonies_count = get!(world, constants::GAME_ID, ColonyCount).count;
        assert!(total_colonies_count == 1, "Colony: count not set correctly");

        let planet_colonies_count = get!(world, 1, PlanetColoniesCount).count;
        assert!(planet_colonies_count == 1, "Colony: count not set correctly");

        let colony_position = get!(world, (1, 1), ColonyPosition).position;
        assert!(
            colony_position.system == 188 && colony_position.orbit == 10,
            "Colony: position not set correctly"
        );

        actions.colony.generate_colony();
        let colony_owner = get!(world, 1002, ColonyOwner).planet_id;
        assert!(colony_owner == 1, "Colony: owner not set correctly");

        let total_colonies_count = get!(world, constants::GAME_ID, ColonyCount).count;
        assert!(total_colonies_count == 2, "Colony: count not set correctly");

        let planet_colonies_count = get!(world, 1, PlanetColoniesCount).count;
        assert!(planet_colonies_count == 2, "Colony: count not set correctly");

        let colony_position = get!(world, (1, 2), ColonyPosition).position;
        assert!(
            colony_position.system == 182 && colony_position.orbit == 2,
            "Colony: position not set correctly"
        );
    }

    #[test]
    fn test_generate_colony_different_planets() {
        let (world, actions) = setup_world();
        actions.game.spawn(GAME_SPEED);

        set_contract_address(ACCOUNT_1());
        actions.planet.generate_planet();
        set!(world, PlanetTechs { planet_id: 1, name: Names::Tech::EXOCRAFT, level: 1 });
        actions.colony.generate_colony();

        let colony_owner = get!(world, 1001, ColonyOwner).planet_id;
        assert!(colony_owner == 1, "Colony: owner not set correctly");
        let total_colonies_count = get!(world, constants::GAME_ID, ColonyCount).count;
        assert!(total_colonies_count == 1, "Colony: count not set correctly");
        let planet_colonies_count = get!(world, 1, PlanetColoniesCount).count;
        assert!(planet_colonies_count == 1, "Colony: count not set correctly");
        let colony_position = get!(world, (1, 1), ColonyPosition).position;
        assert!(
            colony_position.system == 188 && colony_position.orbit == 10,
            "Colony: position not set correctly"
        );

        set_contract_address(ACCOUNT_2());
        actions.planet.generate_planet();
        set!(world, PlanetTechs { planet_id: 2, name: Names::Tech::EXOCRAFT, level: 1 });
        actions.colony.generate_colony();

        let colony_owner = get!(world, 2001, ColonyOwner).planet_id;
        assert!(colony_owner == 2, "Colony: owner not set correctly");
        let total_colonies_count = get!(world, constants::GAME_ID, ColonyCount).count;
        assert!(total_colonies_count == 2, "Colony: count not set correctly");
        let planet_colonies_count = get!(world, 2, PlanetColoniesCount).count;
        assert!(planet_colonies_count == 1, "Colony: count not set correctly");
        let colony_position = get!(world, (2, 1), ColonyPosition).position;
        assert!(
            colony_position.system == 182 && colony_position.orbit == 2,
            "Colony: position not set correctly"
        );
    }

    #[test]
    fn test_upgrade_colony_compound() {
        let (world, actions) = setup_world();
        actions.game.spawn(GAME_SPEED);

        set_contract_address(ACCOUNT_1());
        actions.planet.generate_planet();
        set!(world, PlanetTechs { planet_id: 1, name: Names::Tech::EXOCRAFT, level: 1 });
        actions.colony.generate_colony();
        set!(
            world,
            ColonyResource {
                planet_id: 1, colony_id: 1, name: Names::Resource::STEEL, amount: 10000
            }
        );
        set!(
            world,
            ColonyResource {
                planet_id: 1, colony_id: 1, name: Names::Resource::QUARTZ, amount: 10000
            }
        );
        set!(
            world,
            ColonyResource {
                planet_id: 1, colony_id: 1, name: Names::Resource::TRITIUM, amount: 10000
            }
        );

        actions.colony.process_colony_compound_upgrade(1, CompoundUpgradeType::SteelMine, 1);
        actions.colony.process_colony_compound_upgrade(1, CompoundUpgradeType::QuartzMine, 1);
        actions.colony.process_colony_compound_upgrade(1, CompoundUpgradeType::TritiumMine, 1);
        actions.colony.process_colony_compound_upgrade(1, CompoundUpgradeType::EnergyPlant, 1);
        actions.colony.process_colony_compound_upgrade(1, CompoundUpgradeType::Dockyard, 1);

        let steel_level = get!(world, (1, 1, Names::Compound::STEEL), ColonyCompounds).level;
        assert!(steel_level == 1, "Colony: steel mine not upgraded correctly");

        let quartz_level = get!(world, (1, 1, Names::Compound::QUARTZ), ColonyCompounds).level;
        assert!(quartz_level == 1, "Colony: quartz mine not upgraded correctly");

        let tritium_level = get!(world, (1, 1, Names::Compound::TRITIUM), ColonyCompounds).level;
        assert!(tritium_level == 1, "Colony: tritium mine not upgraded correctly");

        let energy_level = get!(world, (1, 1, Names::Compound::ENERGY), ColonyCompounds).level;
        assert!(energy_level == 1, "Colony: energy plant not upgraded correctly");

        let dockyard_level = get!(world, (1, 1, Names::Compound::DOCKYARD), ColonyCompounds).level;
        assert!(dockyard_level == 1, "Colony: dockyard not upgraded correctly");
    }

    #[test]
    fn test_build_colony_ships() {
        let (world, actions) = setup_world();
        actions.game.spawn(GAME_SPEED);

        set_contract_address(ACCOUNT_1());
        actions.planet.generate_planet();
        set!(world, PlanetTechs { planet_id: 1, name: Names::Tech::EXOCRAFT, level: 1 });
        actions.colony.generate_colony();
        set!(
            world,
            ColonyResource {
                planet_id: 1, colony_id: 1, name: Names::Resource::STEEL, amount: 100000
            }
        );
        set!(
            world,
            ColonyResource {
                planet_id: 1, colony_id: 1, name: Names::Resource::QUARTZ, amount: 100000
            }
        );
        set!(
            world,
            ColonyResource {
                planet_id: 1, colony_id: 1, name: Names::Resource::TRITIUM, amount: 100000
            }
        );
        set!(
            world,
            ColonyCompounds {
                planet_id: 1, colony_id: 1, name: Names::Compound::DOCKYARD, level: 7
            }
        );
        set!(world, PlanetTechs { planet_id: 1, name: Names::Tech::COMBUSTION, level: 6 });
        set!(world, PlanetTechs { planet_id: 1, name: Names::Tech::SHIELD, level: 2 });
        set!(world, PlanetTechs { planet_id: 1, name: Names::Tech::ION, level: 2 });
        set!(world, PlanetTechs { planet_id: 1, name: Names::Tech::THRUST, level: 4 });
        set!(world, PlanetTechs { planet_id: 1, name: Names::Tech::WARP, level: 4 });
        actions.colony.process_ship_build(1, ShipBuildType::Carrier, 1);
        actions.colony.process_ship_build(1, ShipBuildType::Scraper, 1);
        actions.colony.process_ship_build(1, ShipBuildType::Sparrow, 1);
        actions.colony.process_ship_build(1, ShipBuildType::Frigate, 1);
        actions.colony.process_ship_build(1, ShipBuildType::Armade, 1);

        let carrier_count = get!(world, (1, 1, Names::Fleet::CARRIER), ColonyShips).count;
        assert!(carrier_count == 1, "Colony: carrier not built correctly");
        let scraper_count = get!(world, (1, 1, Names::Fleet::SCRAPER), ColonyShips).count;
        assert!(scraper_count == 1, "Colony: scraper not built correctly");
        let sparrow_count = get!(world, (1, 1, Names::Fleet::SPARROW), ColonyShips).count;
        assert!(sparrow_count == 1, "Colony: sparrow not built correctly");
        let frigate_count = get!(world, (1, 1, Names::Fleet::FRIGATE), ColonyShips).count;
        assert!(frigate_count == 1, "Colony: frigate not built correctly");
        let armade_count = get!(world, (1, 1, Names::Fleet::ARMADE), ColonyShips).count;
        assert!(armade_count == 1, "Colony: armade not built correctly");
    }

    #[test]
    fn test_build_colony_defence() {
        let (world, actions) = setup_world();
        actions.game.spawn(GAME_SPEED);

        set_contract_address(ACCOUNT_1());
        actions.planet.generate_planet();
        set!(world, PlanetTechs { planet_id: 1, name: Names::Tech::EXOCRAFT, level: 1 });
        actions.colony.generate_colony();
        set!(
            world,
            ColonyResource {
                planet_id: 1, colony_id: 1, name: Names::Resource::STEEL, amount: 100_000
            }
        );
        set!(
            world,
            ColonyResource {
                planet_id: 1, colony_id: 1, name: Names::Resource::QUARTZ, amount: 100_000
            }
        );
        set!(
            world,
            ColonyResource {
                planet_id: 1, colony_id: 1, name: Names::Resource::TRITIUM, amount: 100_000
            }
        );
        set!(
            world,
            ColonyCompounds {
                planet_id: 1, colony_id: 1, name: Names::Compound::DOCKYARD, level: 8
            }
        );
        set!(world, PlanetTechs { planet_id: 1, name: Names::Tech::COMBUSTION, level: 1 });
        set!(world, PlanetTechs { planet_id: 1, name: Names::Tech::SHIELD, level: 1 });
        set!(world, PlanetTechs { planet_id: 1, name: Names::Tech::ENERGY, level: 6 });
        set!(world, PlanetTechs { planet_id: 1, name: Names::Tech::BEAM, level: 6 });
        set!(world, PlanetTechs { planet_id: 1, name: Names::Tech::WEAPONS, level: 3 });
        set!(world, PlanetTechs { planet_id: 1, name: Names::Tech::PLASMA, level: 7 });
        actions.colony.process_defence_build(1, DefenceBuildType::Celestia, 1);
        actions.colony.process_defence_build(1, DefenceBuildType::Blaster, 1);
        actions.colony.process_defence_build(1, DefenceBuildType::Beam, 1);
        actions.colony.process_defence_build(1, DefenceBuildType::Astral, 1);
        actions.colony.process_defence_build(1, DefenceBuildType::Plasma, 1);

        let celestia_count = get!(world, (1, 1, Names::Defence::CELESTIA), ColonyDefences).count;
        assert!(celestia_count == 1, "Colony: celestia not built correctly");
        let blaster_count = get!(world, (1, 1, Names::Defence::BLASTER), ColonyDefences).count;
        assert!(blaster_count == 1, "Colony: blaster not built correctly");
        let beam_count = get!(world, (1, 1, Names::Defence::BEAM), ColonyDefences).count;
        assert!(beam_count == 1, "Colony: beam not built correctly");
        let astral_count = get!(world, (1, 1, Names::Defence::ASTRAL), ColonyDefences).count;
        assert!(astral_count == 1, "Colony: astral not built correctly");
        let plasma_count = get!(world, (1, 1, Names::Defence::PLASMA), ColonyDefences).count;
        assert!(plasma_count == 1, "Colony: plasma not built correctly");
    }
}
