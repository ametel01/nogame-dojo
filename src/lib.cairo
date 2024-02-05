mod colony {
    mod actions;
    mod models;
}

mod compound {
    mod actions;
    mod library;
    mod models;
}

mod defence {
    mod actions;
    mod models;
}

mod dockyard {
    mod actions;
    mod models;
}

mod fleet {
    mod actions;
    mod models;
}

mod game {
    mod actions;
    mod models;
}

mod planet {
    mod actions;
    mod models;
}

mod tech {
    mod actions;
    mod models;
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
    mod math;
}

mod token {
    mod erc721 {
        mod interface;
        mod erc721;
    }
    mod erc20 {
        mod erc20;
    }
}

mod utils {
    #[cfg(test)]
    mod test_utils;
}

