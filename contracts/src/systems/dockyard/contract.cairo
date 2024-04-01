#[dojo::interface]
trait IDockyardActions {
    fn process_ship_build(component: nogame::data::types::ShipBuildType, quantity: u32);
}

#[dojo::contract]
mod dockyardactions {
    use nogame::data::types::{ShipBuildType, Resources};
    use nogame::game::models::GamePlanet;
    use nogame::libraries::{dockyard, shared};

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        FleetSpent: FleetSpent,
    }
    #[derive(Drop, starknet::Event)]
    struct FleetSpent {
        planet_id: u32,
        quantity: u32,
        spent: Resources
    }

    #[abi(embed_v0)]
    impl DockyardActionsImpl of super::IDockyardActions<ContractState> {
        fn process_ship_build(component: ShipBuildType, quantity: u32) {
            let world = self.world_dispatcher.read();
            let caller = starknet::get_caller_address();
            let planet_id = get!(world, caller, GamePlanet).planet_id;
            let cost = dockyard::build_component(world, planet_id, component, quantity);
            shared::update_planet_resources_spent(world, planet_id, cost);
            emit!(world, FleetSpent { planet_id, quantity, spent: cost });
        }
    }
}
