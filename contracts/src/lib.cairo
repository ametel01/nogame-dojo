mod colony {
    mod actions;
    mod models;
    mod positions;
}

mod compound {
    mod actions;
    mod library;
    mod models;
}

mod defence {
    mod actions;
    mod library;
    mod models;
}

mod dockyard {
    mod actions;
    mod models;
    mod library;
}

mod fleet {
    mod actions;
    mod library;
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
    mod library;
    mod models;
}

mod data {
    mod types;
}

mod libraries {
    mod auction;
    mod constants;
    mod names;
    mod position;
    mod math;
    mod shared;
}

mod utils {
    #[cfg(test)]
    mod test_utils;
}

