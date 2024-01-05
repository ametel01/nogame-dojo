mod actions {
    mod game_actions;
}

mod data {
    mod traits;
    mod types;
}

mod libraries {
    mod auction;
    mod constants;
    mod names;
    mod position;
}

mod models {
    mod fleet_models;
    mod game_models;
    mod planet_models;
}

mod token {
    mod erc721 {
        mod interface;
        mod erc721;
    }
}

mod utils {
    #[cfg(test)]
    mod test_utils;
}

