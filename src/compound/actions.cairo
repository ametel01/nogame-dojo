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
    use nogame::libraries::shared;
    use starknet::{ContractAddress, get_caller_address};
    use debug::PrintTrait;

    #[abi(embed_v0)]
    impl CompoundActionsImpl of super::ICompoundActions<ContractState> {
        fn process_upgrade(ref self: ContractState, component: CompoundUpgradeType, quantity: u8) {
            let world = self.world_dispatcher.read();
            let caller = get_caller_address();
            let planet_id = get!(world, caller, GamePlanet).planet_id;
            upgrade_component(world, planet_id, component, quantity);
        }
    }

    fn upgrade_component(
        world: IWorldDispatcher, planet_id: u32, component: CompoundUpgradeType, quantity: u8
    ) -> ERC20s {
        let compounds = shared::get_compound_levels(world, planet_id);
        shared::collect(world, planet_id);
        let available_resources = shared::get_resources_available(world, planet_id);
        let mut cost: ERC20s = Default::default();
        match component {
            CompoundUpgradeType::SteelMine => {
                cost = compound::cost::steel(compounds.steel, quantity);
                assert!(available_resources >= cost, "Compound: Not enough resources");
                shared::pay_resources(world, planet_id, available_resources, cost);
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
                shared::pay_resources(world, planet_id, available_resources, cost);
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
                shared::pay_resources(world, planet_id, available_resources, cost);
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
                shared::pay_resources(world, planet_id, available_resources, cost);
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
                shared::pay_resources(world, planet_id, available_resources, cost);
                set!(
                    world,
                    (
                        PlanetCompounds {
                            planet_id, name: Names::Compound::LAB, level: compounds.lab + quantity
                        },
                    )
                );
            },
            CompoundUpgradeType::Dockyard => {
                cost = compound::cost::dockyard(compounds.dockyard, quantity);
                assert!(available_resources >= cost, "Compound: Not enough resources");
                shared::pay_resources(world, planet_id, available_resources, cost);
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
        let (world, actions, nft, eth) = setup_world();
        actions.game.spawn(OWNER(), nft, eth, constants::MIN_PRICE_UNSCALED, GAME_SPEED,);

        set_contract_address(ACCOUNT_1());
        actions.planet.generate_planet();

        actions.compound.process_upgrade(CompoundUpgradeType::SteelMine(()), 1);
        let steel_mine = get!(world, (1, Names::Compound::STEEL), PlanetCompounds).level;
        let steel_after = get!(world, (1, Names::Resource::STEEL), PlanetResource).amount;
        let quartz_after = get!(world, (1, Names::Resource::QUARTZ), PlanetResource).amount;
        assert(steel_mine == 1, 'Steel mine level should be 1');
        assert(steel_after == 440, 'Steel amount should be 440');
        assert(quartz_after == 285, 'Quartz amount should be 285');
    }

    #[test]
    fn test_upgrade_quartz_mine_success() {
        let (world, actions, nft, eth) = setup_world();
        actions.game.spawn(OWNER(), nft, eth, constants::MIN_PRICE_UNSCALED, GAME_SPEED,);

        set_contract_address(ACCOUNT_1());
        actions.planet.generate_planet();

        actions.compound.process_upgrade(CompoundUpgradeType::QuartzMine(()), 1);
        let quartz_mine = get!(world, (1, Names::Compound::QUARTZ), PlanetCompounds).level;
        assert(quartz_mine == 1, 'Quartz mine level should be 1');
    }

    #[test]
    fn test_upgrade_tritium_mine_success() {
        let (world, actions, nft, eth) = setup_world();
        actions.game.spawn(OWNER(), nft, eth, constants::MIN_PRICE_UNSCALED, GAME_SPEED,);

        set_contract_address(ACCOUNT_1());
        actions.planet.generate_planet();

        actions.compound.process_upgrade(CompoundUpgradeType::TritiumMine(()), 1);
        let tritium_mine = get!(world, (1, Names::Compound::TRITIUM), PlanetCompounds).level;
        assert(tritium_mine == 1, 'Tritium mine level should be 1');
    }

    #[test]
    fn test_upgrade_energy_plant_success() {
        let (world, actions, nft, eth) = setup_world();
        actions.game.spawn(OWNER(), nft, eth, constants::MIN_PRICE_UNSCALED, GAME_SPEED,);

        set_contract_address(ACCOUNT_1());
        actions.planet.generate_planet();

        actions.compound.process_upgrade(CompoundUpgradeType::EnergyPlant(()), 1);
        let energy_plant = get!(world, (1, Names::Compound::ENERGY), PlanetCompounds).level;
        assert(energy_plant == 1, 'Energy plant level should be 1');
    }

    #[test]
    fn test_upgrade_lab_success() {
        let (world, actions, nft, eth) = setup_world();
        actions.game.spawn(OWNER(), nft, eth, constants::MIN_PRICE_UNSCALED, GAME_SPEED,);

        set_contract_address(ACCOUNT_1());
        actions.planet.generate_planet();

        set!(world, PlanetResource { planet_id: 1, name: Names::Resource::QUARTZ, amount: 400 });
        set!(world, PlanetResource { planet_id: 1, name: Names::Resource::TRITIUM, amount: 200 });

        actions.compound.process_upgrade(CompoundUpgradeType::Lab(()), 1);
        let lab = get!(world, (1, Names::Compound::LAB), PlanetCompounds).level;
        assert(lab == 1, 'Lab level should be 1');
    }

    #[test]
    fn test_upgrade_dockyard_success() {
        let (world, actions, nft, eth) = setup_world();
        actions.game.spawn(OWNER(), nft, eth, constants::MIN_PRICE_UNSCALED, GAME_SPEED,);

        set_contract_address(ACCOUNT_1());
        actions.planet.generate_planet();

        actions.compound.process_upgrade(CompoundUpgradeType::Dockyard(()), 1);
        let dockyard = get!(world, (1, Names::Compound::DOCKYARD), PlanetCompounds).level;
        assert(dockyard == 1, 'Dockyard level should be 1');
    }
}
