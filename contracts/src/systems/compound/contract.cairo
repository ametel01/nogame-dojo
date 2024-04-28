#[dojo::interface]
trait ICompoundActions {
    fn start_upgrade(component: u8, quantity: u8);
    fn complete_upgrade();
}

#[dojo::contract]
mod compoundactions {
    use nogame::data::types::{CompoundUpgradeType, Resources};
    use nogame::libraries::compound;
    use nogame::libraries::shared;
    use nogame::models::game::GamePlanet;

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        CompoundSpent: CompoundSpent,
    }
    #[derive(Drop, starknet::Event)]
    struct CompoundSpent {
        planet_id: u32,
        quantity: u8,
        spent: Resources
    }

    #[abi(embed_v0)]
    impl CompoundActionsImpl of super::ICompoundActions<ContractState> {
        fn start_upgrade(component: u8, quantity: u8) {
            let world = self.world_dispatcher.read();
            let caller = starknet::get_caller_address();
            let planet_id = get!(world, caller, GamePlanet).planet_id;
            let cost = compound::upgrade_component(world, planet_id, component, quantity);
            shared::update_planet_resources_spent(world, planet_id, cost);
            emit!(world, CompoundSpent { planet_id, quantity, spent: cost });
        }

        fn complete_upgrade() {
            let world = self.world_dispatcher.read();
            let caller = starknet::get_caller_address();
            let planet_id = get!(world, caller, GamePlanet).planet_id;
            compound::complete_upgrade(world, planet_id);
        }
    }
}
