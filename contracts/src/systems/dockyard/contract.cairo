#[dojo::interface]
trait IDockyardActions {
    fn start_build(component: u8, quantity: u32);
    fn complete_build();
}

#[dojo::contract]
mod dockyardactions {
    use nogame::data::types::{ShipBuildType, Resources};
    use nogame::libraries::{dockyard, shared};
    use nogame::models::game::GamePlanet;

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
        fn start_build(component: u8, quantity: u32) {
            let world = self.world_dispatcher.read();
            let caller = starknet::get_caller_address();
            let planet_id = get!(world, caller, GamePlanet).planet_id;
            let cost = dockyard::build_component(world, planet_id, component, quantity);
            shared::update_planet_resources_spent(world, planet_id, cost);
            emit!(world, FleetSpent { planet_id, quantity, spent: cost });
        }

        fn complete_build() {
            let world = self.world_dispatcher.read();
            let caller = starknet::get_caller_address();
            let planet_id = get!(world, caller, GamePlanet).planet_id;
            dockyard::complete_build(world, planet_id);
        }
    }
}
