mod systems {
    mod colony {
        mod contract;
        #[cfg(test)]
        mod tests;
    }
    mod compound {
        mod contract;
        #[cfg(test)]
        mod tests;
    }
}

mod models {
    mod colony;
    mod compound;
}

mod defence {
    mod actions;
    mod library;
    mod models;
}

mod dockyard {
    mod actions;
    mod library;
    mod models;
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
    mod colonypositions;
    mod compounds;
    mod constants;
    mod math;
    mod names;
    mod position;
    mod shared;
}

mod utils {
    #[cfg(test)]
    mod test_utils;
}

