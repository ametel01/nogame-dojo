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
    mod defence {
        mod contract;
        #[cfg(test)]
        mod tests;
    }
    mod dockyard {
        mod contract;
        #[cfg(test)]
        mod tests;
    }
    mod fleet {
        mod contract;
        #[cfg(test)]
        mod tests;
    }
    mod game {
        mod contract;
        #[cfg(test)]
        mod tests;
    }
    mod planet {
        mod contract;
        #[cfg(test)]
        mod tests;
    }
    mod tech {
        mod contract;
        #[cfg(test)]
        mod tests;
    }
}

mod models {
    mod colony;
    mod compound;
    mod defence;
    mod dockyard;
    mod fleet;
    mod game;
    mod planet;
    mod tech;
}

mod data {
    mod types;
}

mod libraries {
    mod auction;
    mod colony;
    mod colonypositions;
    mod compound;
    mod constants;
    mod defence;
    mod dockyard;
    mod fleet;
    mod math;
    mod names;
    mod position;
    mod shared;
    mod tech;
}

mod utils {
    #[cfg(test)]
    mod test_utils;
}

