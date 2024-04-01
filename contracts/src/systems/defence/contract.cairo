#[dojo::interface]
trait IDefenceActions {
    fn process_defence_build(component: nogame::data::types::DefenceBuildType, quantity: u32);
}

#[dojo::contract]
mod defenceactions {
    use nogame::data::types::{DefenceBuildType, Resources};
    use nogame::game::models::GamePlanet;
    use nogame::libraries::defence;
    use nogame::libraries::shared;

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        DefenceSpent: DefenceSpent,
    }
    #[derive(Drop, starknet::Event)]
    struct DefenceSpent {
        planet_id: u32,
        quantity: u32,
        spent: Resources
    }

    #[abi(embed_v0)]
    impl DefenceActionsImpl of super::IDefenceActions<ContractState> {
        fn process_defence_build(component: DefenceBuildType, quantity: u32) {
            let world = self.world_dispatcher.read();
            let caller = starknet::get_caller_address();
            let planet_id = get!(world, caller, GamePlanet).planet_id;
            let cost = defence::build_component(world, planet_id, component, quantity);
            shared::update_planet_resources_spent(world, planet_id, cost);
            emit!(world, DefenceSpent { planet_id, quantity, spent: cost });
        }
    }
}

