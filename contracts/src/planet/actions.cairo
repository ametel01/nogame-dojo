use nogame::data::types::ERC20s;

#[starknet::interface]
trait IPlanetActions<TContractState> {
    fn generate_planet(ref self: TContractState);
    fn get_planet_price(self: @TContractState) -> u128;
}


#[dojo::contract]
mod planetactions {
    use starknet::{
        ContractAddress, get_caller_address, get_block_timestamp, contract_address_const
    };
    use super::IPlanetActions;

    use openzeppelin::token::erc20::interface::{IERC20CamelDispatcher, IERC20CamelDispatcherTrait};
    use nogame::compound::models::PlanetCompounds;
    use nogame::compound::library as compound;
    use nogame::data::types::{Position, ERC20s};
    use nogame::defence::models::PlanetDefences;
    use nogame::game::models::{GameSetup, GamePlanetCount, GamePlanet, GamePlanetOwner};
    use nogame::planet::models::{
        PlanetPosition, PositionToPlanet, PlanetResource, PlanetResourceTimer
    };
    use nogame::libraries::{
        {auction::{LinearVRGDA, LinearVRGDATrait}}, names::Names, position, constants
    };
    use nogame_fixed::f128::types::{Fixed, FixedTrait, ONE_u128 as ONE};
    use debug::PrintTrait;

    #[external(v0)]
    impl PlanetActionsImpl of IPlanetActions<ContractState> {
        fn generate_planet(ref self: ContractState) {
            // Access the world dispatcher for reading.
            let world = self.world_dispatcher.read();
            let caller = get_caller_address();
            let planets = get!(world, constants::GAME_ID, GamePlanetCount);
            let game_setup = get!(world, constants::GAME_ID, GameSetup);
            let price: u256 = self.get_planet_price().into();
            // IERC20CamelDispatcher { contract_address: game_setup.eth_address }
            //     .transferFrom(caller, game_setup.owner, price);

            let planet_id = planets.count + 1;
            set!(world, GamePlanet { owner: caller, planet_id });
            set!(world, GamePlanetOwner { planet_id, owner: caller });

            let position = position::get_planet_position(planet_id);
            set!(world, PlanetPosition { planet_id, position });
            set!(world, PositionToPlanet { position, planet_id });

            set!(world, GamePlanetCount { game_id: constants::GAME_ID, count: planet_id });

            set!(world, PlanetResource { planet_id, name: Names::Resource::STEEL, amount: 500 });
            set!(world, PlanetResource { planet_id, name: Names::Resource::QUARTZ, amount: 300 });
            set!(world, PlanetResource { planet_id, name: Names::Resource::TRITIUM, amount: 100 });
            set!(world, PlanetResource { planet_id, name: Names::Resource::ENERGY, amount: 0 });

            set!(world, PlanetResourceTimer { planet_id, last_collection: get_block_timestamp() });
        }

        fn get_planet_price(self: @ContractState) -> u128 {
            let world = self.world_dispatcher.read();
            let game_setup = get!(world, constants::GAME_ID, GameSetup);
            let planet_count = get!(world, constants::GAME_ID, GamePlanetCount).count;

            let time_elapsed = (get_block_timestamp() - game_setup.start_time) / constants::DAY;
            let auction_price = get_price(game_setup.price, time_elapsed, planet_count);
            if auction_price < constants::MIN_PRICE_UNSCALED {
                return constants::MIN_PRICE_UNSCALED;
            } else {
                return auction_price;
            }
        }
    }

    fn get_price(price: u128, time_elapsed: u64, item_sold: u32) -> u128 {
        let auction = LinearVRGDA {
            target_price: FixedTrait::new(price, false),
            decay_constant: FixedTrait::new(constants::_0_05, true),
            per_time_unit: FixedTrait::new_unscaled(10, false),
        };
        auction
            .get_vrgda_price(
                FixedTrait::new_unscaled(time_elapsed.into(), false),
                FixedTrait::new_unscaled(item_sold.into(), false)
            )
            .mag
            * constants::E18
            / ONE
    }
}

#[cfg(test)]
mod tests {
    use starknet::testing::{set_contract_address, set_block_timestamp};
    use dojo::world::{IWorldDispatcherTrait, IWorldDispatcher};

    use nogame::libraries::{constants, names::Names};
    use nogame::data::types::{Position};
    use nogame::game::models::{GameSetup, GamePlanetCount,};
    use nogame::planet::models::{
        PlanetPosition, PositionToPlanet, PlanetResource, PlanetResourceTimer
    };
    use nogame::utils::test_utils::{
        setup_world, OWNER, GAME_SPEED, ACCOUNT_1, ACCOUNT_2, ACCOUNT_3, ACCOUNT_4, ACCOUNT_5, DAY,
        PRICE
    };
    use super::{IPlanetActionsDispatcher, IPlanetActionsDispatcherTrait};
    use nogame::game::actions::{IGameActionsDispatcher, IGameActionsDispatcherTrait};
    use debug::PrintTrait;

    #[test]
    fn test_generate_planet() {
        let (world, actions, nft, eth) = setup_world();
        actions.game.spawn(OWNER(), nft, eth, PRICE, GAME_SPEED,);

        set_contract_address(ACCOUNT_1());
        actions.planet.generate_planet();

        let planet_id = get!(world, constants::GAME_ID, (GamePlanetCount)).count;

        let position = get!(world, planet_id, (PlanetPosition)).position;
        assert!(
            position.system == 86 && position.orbit == 1,
            "test_generate_planet: wrong planet position"
        );

        let id_from_position = get!(world, position, (PositionToPlanet)).planet_id;
        assert!(id_from_position == planet_id, "test_generate_planet: wrong position to planet");

        let steel = get!(world, (planet_id, Names::Resource::STEEL), (PlanetResource)).amount;
        assert!(steel == 500, "test_generate_planet: wrong initial steel");
        let qurtz = get!(world, (planet_id, Names::Resource::QUARTZ), (PlanetResource)).amount;
        assert!(qurtz == 300, "test_generate_planet: wrong initial qurtz");
        let tritium = get!(world, (planet_id, Names::Resource::TRITIUM), (PlanetResource)).amount;
        assert!(tritium == 100, "test_generate_planet: wrong initial tritium");
        let energy = get!(world, (planet_id, Names::Resource::ENERGY), (PlanetResource)).amount;
        assert!(energy == 0, "test_generate_planet: wrong initial energy");

        let time_start = get!(world, planet_id, (PlanetResourceTimer)).last_collection;
        assert!(
            time_start == starknet::get_block_timestamp(), "test_generate_planet: wrong time start"
        );
    }

    #[test]
    fn test_get_planet_price() {
        let (world, actions, nft, eth) = setup_world();
        actions.game.spawn(OWNER(), nft, eth, constants::STARTING_PRICE_SCALED, GAME_SPEED,);
        assert(actions.planet.get_planet_price() == 22024160000000002, 'wrong price-1');

        set_contract_address(ACCOUNT_1());
        actions.planet.generate_planet();
        assert(actions.planet.get_planet_price() == 22134556560993767, 'wrong price-2');

        set_contract_address(ACCOUNT_2());
        actions.planet.generate_planet();
        assert(actions.planet.get_planet_price() == 22245506487155662, 'wrong price-3');

        set_contract_address(ACCOUNT_3());
        actions.planet.generate_planet();

        set_block_timestamp(DAY * 13);

        assert(actions.planet.get_planet_price() == constants::MIN_PRICE_UNSCALED, 'wrong price-4');
        set_contract_address(ACCOUNT_4());

        assert(actions.planet.get_planet_price() == constants::MIN_PRICE_UNSCALED, 'wrong price-5');
        set_contract_address(ACCOUNT_5());
    }
}
