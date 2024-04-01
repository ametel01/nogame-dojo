#[dojo::interface]
trait ITechActions {
    fn process_upgrade(component: nogame::data::types::TechUpgradeType, quantity: u8);
}

#[dojo::contract]
mod techactions {
    use nogame::data::types::{TechUpgradeType, Resources};
    use nogame::libraries::{compound, tech, shared};
    use nogame::models::{
        compound::PlanetCompounds, game::{GamePlanet, GameSetup},
        planet::{PlanetResource, PlanetResourceTimer, PlanetPosition}
    };
    use nogame::systems::compound::contract::{
        ICompoundActionsDispatcher, ICompoundActionsDispatcherTrait
    };

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
            let caller = starknet::get_caller_address();
            let planet_id = get!(world, caller, GamePlanet).planet_id;
            let cost = tech::upgrade_component(world, planet_id, component, quantity);
            shared::update_planet_resources_spent(world, planet_id, cost);
            emit!(world, TechSpent { planet_id, quantity, spent: cost });
        }
    }
}

