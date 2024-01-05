#[starknet::interface]
trait IGameActions<TContractState> {
    fn spawn(
        self: @TContractState,
        owner: starknet::ContractAddress,
        nft_address: starknet::ContractAddress,
        price: u128,
        speed: usize
    );
    fn generate_planet(self: @TContractState);
}

// dojo decorator
#[dojo::contract]
mod actions {
    use starknet::{
        ContractAddress, get_caller_address, get_block_timestamp, contract_address_const
    };
    use super::IGameActions;

    use openzeppelin::token::erc20::interface::{IERC20CamelDispatcher, IERC20CamelDispatcherTrait};

    use nogame::data::types::Position;
    use nogame::models::game_models::{GameSetup, GamePlanetCount, GamePlanet, GamePlanetOwner};
    use nogame::models::planet_models::{
        PlanetPosition, PositionToPlanet, PlanetResource, PlanetResourceTimer
    };
    use nogame::libraries::{{auction::{LinearVRGDA, LinearVRGDATrait}}, names, position, constants};
    use nogame_fixed::f128::types::{Fixed, FixedTrait, ONE_u128 as ONE};

    #[external(v0)]
    impl GameActionsImpl of IGameActions<ContractState> {
        // ContractState is defined by system decorator expansion
        fn spawn(
            self: @ContractState,
            owner: ContractAddress,
            nft_address: ContractAddress,
            price: u128,
            speed: usize
        ) {
            let world = self.world_dispatcher.read();

            set!(
                world,
                (
                    GameSetup {
                        id: constants::GAME_ID,
                        owner,
                        nft_address,
                        price,
                        speed,
                        start_time: get_block_timestamp()
                    },
                    GamePlanetCount { id: constants::GAME_ID, count: 0 },
                )
            );
        }

        // Implementation of the move function for the ContractState struct.
        fn generate_planet(self: @ContractState) {
            // Access the world dispatcher for reading.
            let world = self.world_dispatcher.read();
            let caller = get_caller_address();
            let time_now = get_block_timestamp();
            let planets = get!(world, constants::GAME_ID, GamePlanetCount);

            let game_setup = get!(world, constants::GAME_ID, (GameSetup));
            let time_elapsed = (time_now - game_setup.start_time) / constants::DAY;
            // let price: u256 = get_planet_price(game_setup.price, time_elapsed.into(), planets.n)
            //     .into();
            // IERC20CamelDispatcher { contract_address: constants::ETH_ADDRESS() }
            //     .transferFrom(caller, game_setup.owner, price);

            let id = planets.count + 1;
            set!(world, GamePlanet { owner: caller, id });
            set!(world, GamePlanetOwner { id, owner: caller });

            let position = position::get_planet_position(id);
            set!(world, PlanetPosition { id, position });
            set!(world, PositionToPlanet { position, id });

            set!(world, GamePlanetCount { id: constants::GAME_ID, count: id });

            set!(world, PlanetResource { id, name: names::Resource::STEEL, amount: 500 });
            set!(world, PlanetResource { id, name: names::Resource::QUARTZ, amount: 300 });
            set!(world, PlanetResource { id, name: names::Resource::TRITIUM, amount: 100 });
            set!(world, PlanetResource { id, name: names::Resource::ENERGY, amount: 0 });

            set!(world, PlanetResourceTimer { id, timestamp: time_now });
        }
    }

    fn get_planet_price(price: u128, time_elapsed: u64, sold: u16) -> u128 {
        let auction = LinearVRGDA {
            target_price: FixedTrait::new(constants::PRICE, false),
            decay_constant: FixedTrait::new(constants::_0_05, true),
            per_time_unit: FixedTrait::new_unscaled(10, false),
        };
        auction
            .get_vrgda_price(
                FixedTrait::new_unscaled(time_elapsed.into(), false),
                FixedTrait::new_unscaled(sold.into(), false)
            )
            .mag
            * constants::E18
            / ONE
    }
}

#[cfg(test)]
mod tests {
    use starknet::testing::set_contract_address;
    use dojo::world::{IWorldDispatcherTrait, IWorldDispatcher};

    use nogame::libraries::{constants, names};
    use nogame::data::types::Position;
    use nogame::models::game_models::{GameSetup, GamePlanetCount};
    use nogame::models::planet_models::{
        PlanetPosition, PositionToPlanet, PlanetResource, PlanetResourceTimer
    };
    use nogame::utils::test_utils::{setup_world, OWNER, PRICE, GAME_SPEED, ACCOUNT_1};
    use super::{IGameActionsDispatcher, IGameActionsDispatcherTrait};

    #[test]
    fn test_spawn() {
        let (world, actions_system, nft) = setup_world();

        actions_system.spawn(OWNER(), nft, PRICE, GAME_SPEED);
        actions_system.generate_planet();

        let game_setup = get!(world, constants::GAME_ID, (GameSetup));
        assert!(game_setup.owner == OWNER(), "test_spawn wrong game owner");
        assert!(game_setup.price == PRICE, "test_spawn wrong game price");
        assert!(game_setup.speed == GAME_SPEED, "test_spawn wrong game speed");
        assert!(
            game_setup.start_time == starknet::get_block_timestamp(),
            "test_spawn: wrong game start time"
        );
    }

    #[test]
    fn test_generate_planet() {
        let (world, actions_system, nft) = setup_world();
        actions_system.spawn(OWNER(), nft, PRICE, GAME_SPEED);

        set_contract_address(ACCOUNT_1());
        actions_system.generate_planet();

        let planet_id = get!(world, constants::GAME_ID, (GamePlanetCount)).count;

        let position = get!(world, planet_id, (PlanetPosition)).position;
        assert!(
            position.system == 86 && position.orbit == 1,
            "test_generate_planet: wrong planet position"
        );

        let id_from_position = get!(world, position, (PositionToPlanet)).id;
        assert!(id_from_position == planet_id, "test_generate_planet: wrong position to planet");

        let steel = get!(world, (planet_id, names::Resource::STEEL), (PlanetResource)).amount;
        assert!(steel == 500, "test_generate_planet: wrong initial steel");
        let qurtz = get!(world, (planet_id, names::Resource::QUARTZ), (PlanetResource)).amount;
        assert!(qurtz == 300, "test_generate_planet: wrong initial qurtz");
        let tritium = get!(world, (planet_id, names::Resource::TRITIUM), (PlanetResource)).amount;
        assert!(tritium == 100, "test_generate_planet: wrong initial tritium");
        let energy = get!(world, (planet_id, names::Resource::ENERGY), (PlanetResource)).amount;
        assert!(energy == 0, "test_generate_planet: wrong initial energy");

        let time_start = get!(world, planet_id, (PlanetResourceTimer)).timestamp;
        assert!(
            time_start == starknet::get_block_timestamp(), "test_generate_planet: wrong time start"
        );
    }
}

