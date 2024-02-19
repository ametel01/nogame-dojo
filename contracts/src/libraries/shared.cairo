use dojo::world::{IWorldDispatcherTrait, IWorldDispatcher};
use nogame::defence::models::PlanetDefences;
use nogame::game::models::GameSetup;
use nogame::planet::models::{
    PlanetResource, PlanetResourceTimer, PlanetPosition, PlanetResourcesSpent
};
use nogame::compound::models::PlanetCompounds;
use nogame::compound::library as compound;
use nogame::dockyard::models::PlanetShips;
use nogame::tech::models::PlanetTechs;
use nogame::libraries::names::Names;
use nogame::libraries::constants;
use nogame::data::types::{Resources, Fleet, TechLevels, CompoundsLevels, Defences};

fn pay_resources(world: IWorldDispatcher, planet_id: u32, available: Resources, cost: Resources) {
    if cost.steel > 0 {
        set!(
            world,
            (
                PlanetResource {
                    planet_id, name: Names::Resource::STEEL, amount: available.steel - cost.steel
                },
            )
        );
    }
    if cost.quartz > 0 {
        set!(
            world,
            (
                PlanetResource {
                    planet_id, name: Names::Resource::QUARTZ, amount: available.quartz - cost.quartz
                },
            )
        );
    }
    if cost.tritium > 0 {
        set!(
            world,
            (
                PlanetResource {
                    planet_id,
                    name: Names::Resource::TRITIUM,
                    amount: available.tritium - cost.tritium
                },
            )
        );
    }
    set!(world, PlanetResourcesSpent { planet_id, spent: cost.steel + cost.quartz });
}

fn receive_resources(
    world: IWorldDispatcher, planet_id: u32, available: Resources, amount: Resources
) {
    if amount.steel > 0 {
        set!(
            world,
            (
                PlanetResource {
                    planet_id, name: Names::Resource::STEEL, amount: available.steel + amount.steel
                },
            )
        );
    }
    if amount.quartz > 0 {
        set!(
            world,
            (
                PlanetResource {
                    planet_id,
                    name: Names::Resource::QUARTZ,
                    amount: available.quartz + amount.quartz
                },
            )
        );
    }
    if amount.tritium > 0 {
        set!(
            world,
            (
                PlanetResource {
                    planet_id,
                    name: Names::Resource::TRITIUM,
                    amount: available.tritium + amount.tritium
                },
            )
        );
    }
}

fn collect(world: IWorldDispatcher, planet_id: u32, compounds: CompoundsLevels) {
    let available = get_resources_available(world, planet_id);
    let collectible = calculate_production(world, planet_id, compounds);
    set!(
        world,
        (
            PlanetResource {
                planet_id, name: Names::Resource::STEEL, amount: available.steel + collectible.steel
            },
        )
    );
    set!(
        world,
        (
            PlanetResource {
                planet_id,
                name: Names::Resource::QUARTZ,
                amount: available.quartz + collectible.quartz
            },
        )
    );
    set!(
        world,
        (
            PlanetResource {
                planet_id,
                name: Names::Resource::TRITIUM,
                amount: available.tritium + collectible.tritium
            },
        )
    );
    set!(
        world,
        (PlanetResourceTimer { planet_id, last_collection: starknet::get_block_timestamp() },)
    );
}

fn get_resources_available(world: IWorldDispatcher, planet_id: u32) -> Resources {
    Resources {
        steel: get!(world, (planet_id, Names::Resource::STEEL), PlanetResource).amount,
        quartz: get!(world, (planet_id, Names::Resource::QUARTZ), PlanetResource).amount,
        tritium: get!(world, (planet_id, Names::Resource::TRITIUM), PlanetResource).amount
    }
}

fn calculate_production(
    world: IWorldDispatcher, planet_id: u32, compounds: CompoundsLevels
) -> Resources {
    let time_now = starknet::get_block_timestamp();
    let last_collection_time = get!(world, planet_id, PlanetResourceTimer).last_collection;
    let time_elapsed = time_now - last_collection_time;

    let position = get!(world, planet_id, PlanetPosition).position;
    let temp = compound::calculate_avg_temperature(position.orbit);
    let speed = get!(world, constants::GAME_ID, GameSetup).speed;
    let steel_available: u128 = compound::production::steel(compounds.steel)
        * speed.into()
        * time_elapsed.into()
        / constants::HOUR.into();

    let quartz_available: u128 = compound::production::quartz(compounds.quartz)
        * speed.into()
        * time_elapsed.into()
        / constants::HOUR.into();

    let tritium_available: u128 = compound::production::tritium(
        compounds.tritium, temp, speed.into()
    )
        * time_elapsed.into()
        / constants::HOUR.into();
    let energy_available = compound::production::energy(compounds.energy);
    let celestia_production = compound::celestia_production(position.orbit);
    let celestia_available = get!(world, (planet_id, Names::Defence::CELESTIA), PlanetDefences)
        .count;
    let energy_required = compound::consumption::base(compounds.steel)
        + compound::consumption::base(compounds.quartz)
        + compound::consumption::base(compounds.tritium);
    if energy_available
        + (celestia_production.into() * celestia_available).into() < energy_required {
        let _steel = compound::production_scaler(
            steel_available, energy_available, energy_required
        );
        let _quartz = compound::production_scaler(
            quartz_available, energy_available, energy_required
        );
        let _tritium = compound::production_scaler(
            tritium_available, energy_available, energy_required
        );

        return Resources { steel: _steel, quartz: _quartz, tritium: _tritium, };
    }

    Resources { steel: steel_available, quartz: quartz_available, tritium: tritium_available, }
}

fn get_ships_levels(world: IWorldDispatcher, planet_id: u32) -> Fleet {
    Fleet {
        carrier: get!(world, (planet_id, Names::Fleet::CARRIER), PlanetShips).count,
        scraper: get!(world, (planet_id, Names::Fleet::SCRAPER), PlanetShips).count,
        sparrow: get!(world, (planet_id, Names::Fleet::SPARROW), PlanetShips).count,
        frigate: get!(world, (planet_id, Names::Fleet::FRIGATE), PlanetShips).count,
        armade: get!(world, (planet_id, Names::Fleet::ARMADE), PlanetShips).count,
    }
}


fn get_tech_levels(world: IWorldDispatcher, planet_id: u32) -> TechLevels {
    TechLevels {
        energy: get!(world, (planet_id, Names::Tech::ENERGY), PlanetTechs).level,
        digital: get!(world, (planet_id, Names::Tech::DIGITAL), PlanetTechs).level,
        beam: get!(world, (planet_id, Names::Tech::BEAM), PlanetTechs).level,
        armour: get!(world, (planet_id, Names::Tech::ARMOUR), PlanetTechs).level,
        ion: get!(world, (planet_id, Names::Tech::ION), PlanetTechs).level,
        plasma: get!(world, (planet_id, Names::Tech::PLASMA), PlanetTechs).level,
        weapons: get!(world, (planet_id, Names::Tech::WEAPONS), PlanetTechs).level,
        shield: get!(world, (planet_id, Names::Tech::SHIELD), PlanetTechs).level,
        spacetime: get!(world, (planet_id, Names::Tech::SPACETIME), PlanetTechs).level,
        combustion: get!(world, (planet_id, Names::Tech::COMBUSTION), PlanetTechs).level,
        thrust: get!(world, (planet_id, Names::Tech::THRUST), PlanetTechs).level,
        warp: get!(world, (planet_id, Names::Tech::WARP), PlanetTechs).level,
        exocraft: get!(world, (planet_id, Names::Tech::EXOCRAFT), PlanetTechs).level,
    }
}

fn get_compound_levels(world: IWorldDispatcher, planet_id: u32) -> CompoundsLevels {
    CompoundsLevels {
        steel: get!(world, (planet_id, Names::Compound::STEEL), PlanetCompounds).level,
        quartz: get!(world, (planet_id, Names::Compound::QUARTZ), PlanetCompounds).level,
        tritium: get!(world, (planet_id, Names::Compound::TRITIUM), PlanetCompounds).level,
        energy: get!(world, (planet_id, Names::Compound::ENERGY), PlanetCompounds).level,
        lab: get!(world, (planet_id, Names::Compound::LAB), PlanetCompounds).level,
        dockyard: get!(world, (planet_id, Names::Compound::DOCKYARD), PlanetCompounds).level
    }
}

fn get_defences_levels(world: IWorldDispatcher, planet_id: u32) -> Defences {
    Defences {
        celestia: get!(world, (planet_id, Names::Defence::CELESTIA), PlanetDefences).count,
        blaster: get!(world, (planet_id, Names::Defence::BLASTER), PlanetDefences).count,
        beam: get!(world, (planet_id, Names::Defence::BEAM), PlanetDefences).count,
        astral: get!(world, (planet_id, Names::Defence::ASTRAL), PlanetDefences).count,
        plasma: get!(world, (planet_id, Names::Defence::PLASMA), PlanetDefences).count,
    }
}
