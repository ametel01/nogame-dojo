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
}

#[dojo::contract]
mod colonyactions {
    use nogame::data::types::{
        Position, CompoundUpgradeType, ERC20s, ShipBuildType, DefenceBuildType, TechLevels,
        CompoundsLevels, Fleet, Defences
    };
    use nogame::colony::models::{
        ColonyCompounds, ColonyCount, ColonyResourceTimer, ColonyPosition, ColonyDefences,
        PlanetColoniesCount, ColonyResource, ColonyShips,
    };
    use nogame::colony::positions;
    use nogame::compound::library as compound;
    use nogame::defence::library as defence;
    use nogame::dockyard::library as dockyard;
    use nogame::game::models::{GamePlanet, GamePlanetCount, GameSetup};
    use nogame::libraries::constants;
    use nogame::libraries::names::Names;
    use nogame::libraries::shared;
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
                "Colony: max colonies {} reached, upgrade Exocraft tech to increase max colonies",
                max_colonies
            );
            let price: u256 = 0;
            if !price.is_zero() {
                let game_setup = get!(world, constants::GAME_ID, GameSetup);
                IERC20CamelDispatcher { contract_address: game_setup.eth_address }
                    .transferFrom(caller, game_setup.owner, price);
            }
            let position = positions::get_colony_position(current_count.into());
            let colony_id = current_planet_colonies + 1;
            let id = ((planet_id * 1000) + colony_id.into());
            set!(world, ColonyPosition { planet_id, colony_id, position });
            set!(
                world,
                ColonyResourceTimer { planet_id, colony_id, last_collection: get_block_timestamp() }
            );
            set!(world, PlanetColoniesCount { planet_id, count: colony_id });
            set!(world, ColonyCount { game_id: constants::GAME_ID, count: current_count + 1 });
            let current_number_of_planets = get!(world, constants::GAME_ID, GamePlanetCount).count;
            set!(
                world,
                GamePlanetCount {
                    game_id: constants::GAME_ID, count: current_number_of_planets + 1
                }
            );
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
        ) { // ...
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
        ERC20s {
            steel: get!(world, (planet_id, colony_id, Names::Resource::STEEL), ColonyResource)
                .amount,
            quartz: get!(world, (planet_id, colony_id, Names::Resource::QUARTZ), ColonyResource)
                .amount,
            tritium: get!(world, (planet_id, colony_id, Names::Resource::TRITIUM), ColonyResource)
                .amount
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
