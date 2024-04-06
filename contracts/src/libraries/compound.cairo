use dojo::world::{IWorldDispatcherTrait, IWorldDispatcher};
use nogame::data::types::{Resources, CompoundUpgradeType};
use nogame::libraries::{constants, names::Names, shared};
use nogame::models::{compound::{PlanetCompounds, PlanetCompoundTimer}, game::GameSetup};
use nogame_fixed::f128::types::{Fixed, FixedTrait, ONE_u128 as ONE};

fn upgrade_component(
    world: IWorldDispatcher, planet_id: u32, component: CompoundUpgradeType, quantity: u8
) -> Resources {
    let compounds = shared::get_compound_levels(world, planet_id);
    shared::collect(world, planet_id, 0, compounds);
    let available_resources = shared::get_resources_available(world, planet_id, 0);
    let mut cost: Resources = Default::default();
    let time_now = starknet::get_block_timestamp();
    let queue_status = get!(world, planet_id, PlanetCompoundTimer).time_end;
    assert!(queue_status.is_zero(), "Compound: Already building");
    let game_speed = get!(world, constants::GAME_ID, GameSetup).speed;
    match component {
        CompoundUpgradeType::SteelMine => {
            cost = cost::steel(compounds.steel, quantity);
            assert!(available_resources >= cost, "Compound: Not enough resources");
            shared::pay_resources(world, planet_id, 0, available_resources, cost);
            let built_time = shared::build_time_is_seconds(
                cost.steel + cost.quartz, compounds.cybernetics, game_speed
            );
            set!(
                world,
                (
                    PlanetCompoundTimer {
                        planet_id,
                        name: component,
                        levels: quantity,
                        time_end: time_now + built_time
                    },
                )
            );
        },
        CompoundUpgradeType::QuartzMine => {
            cost = cost::quartz(compounds.quartz, quantity);
            assert!(available_resources >= cost, "Compound: Not enough resources");
            shared::pay_resources(world, planet_id, 0, available_resources, cost);
            let built_time = shared::build_time_is_seconds(
                cost.steel + cost.quartz, compounds.cybernetics, game_speed
            );
            set!(
                world,
                (
                    PlanetCompoundTimer {
                        planet_id,
                        name: component,
                        levels: quantity,
                        time_end: time_now + built_time
                    },
                )
            );
        },
        CompoundUpgradeType::TritiumMine => {
            cost = cost::tritium(compounds.tritium, quantity);
            assert!(available_resources >= cost, "Compound: Not enough resources");
            shared::pay_resources(world, planet_id, 0, available_resources, cost);
            let built_time = shared::build_time_is_seconds(
                cost.steel + cost.quartz, compounds.cybernetics, game_speed
            );
            set!(
                world,
                (
                    PlanetCompoundTimer {
                        planet_id,
                        name: component,
                        levels: quantity,
                        time_end: time_now + built_time
                    },
                )
            );
        },
        CompoundUpgradeType::EnergyPlant => {
            cost = cost::energy(compounds.energy, quantity);
            assert!(available_resources >= cost, "Compound: Not enough resources");
            shared::pay_resources(world, planet_id, 0, available_resources, cost);
            let built_time = shared::build_time_is_seconds(
                cost.steel + cost.quartz, compounds.cybernetics, game_speed
            );
            set!(
                world,
                (
                    PlanetCompoundTimer {
                        planet_id,
                        name: component,
                        levels: quantity,
                        time_end: time_now + built_time
                    },
                )
            );
        },
        CompoundUpgradeType::Lab => {
            cost = cost::lab(compounds.lab, quantity);
            assert!(available_resources >= cost, "Compound: Not enough resources");
            shared::pay_resources(world, planet_id, 0, available_resources, cost);
            let built_time = shared::build_time_is_seconds(
                cost.steel + cost.quartz, compounds.cybernetics, game_speed
            );
            set!(
                world,
                (
                    PlanetCompoundTimer {
                        planet_id,
                        name: component,
                        levels: quantity,
                        time_end: time_now + built_time
                    },
                )
            );
        },
        CompoundUpgradeType::Dockyard => {
            assert!(compounds.cybernetics >= 2, "Compound: Cybernetics level too low, required 2");
            cost = cost::dockyard(compounds.dockyard, quantity);
            assert!(available_resources >= cost, "Compound: Not enough resources");
            shared::pay_resources(world, planet_id, 0, available_resources, cost);
            let built_time = shared::build_time_is_seconds(
                cost.steel + cost.quartz, compounds.cybernetics, game_speed
            );
            set!(
                world,
                (
                    PlanetCompoundTimer {
                        planet_id,
                        name: component,
                        levels: quantity,
                        time_end: time_now + built_time
                    },
                )
            );
        },
        CompoundUpgradeType::Cybernetics => {
            cost = cost::cybernetics(compounds.cybernetics, quantity);
            assert!(available_resources >= cost, "Compound: Not enough resources");
            shared::pay_resources(world, planet_id, 0, available_resources, cost);
            let built_time = shared::build_time_is_seconds(
                cost.steel + cost.quartz, compounds.cybernetics, game_speed
            );
            set!(
                world,
                (
                    PlanetCompoundTimer {
                        planet_id,
                        name: component,
                        levels: quantity,
                        time_end: time_now + built_time
                    },
                )
            );
        },
    };
    cost
}

fn complete_upgrade(world: IWorldDispatcher, planet_id: u32) {
    let time_now = starknet::get_block_timestamp();
    let queue_status = get!(world, planet_id, PlanetCompoundTimer);
    assert!(!queue_status.time_end.is_zero(), "Compound: No upgrade in progress");
    assert!(time_now >= queue_status.time_end, "Compound: Upgrade not finished");
    let compounds = shared::get_compound_levels(world, planet_id);
    match queue_status.name {
        CompoundUpgradeType::SteelMine => {
            set!(
                world,
                (
                    PlanetCompounds {
                        planet_id,
                        name: Names::Compound::STEEL,
                        level: compounds.steel + queue_status.levels
                    },
                    PlanetCompoundTimer {
                        planet_id,
                        name: queue_status.name,
                        levels: Zeroable::zero(),
                        time_end: Zeroable::zero()
                    },
                )
            );
        },
        CompoundUpgradeType::QuartzMine => {
            set!(
                world,
                (
                    PlanetCompounds {
                        planet_id,
                        name: Names::Compound::QUARTZ,
                        level: compounds.quartz + queue_status.levels
                    },
                    PlanetCompoundTimer {
                        planet_id,
                        name: queue_status.name,
                        levels: Zeroable::zero(),
                        time_end: Zeroable::zero()
                    },
                )
            );
        },
        CompoundUpgradeType::TritiumMine => {
            set!(
                world,
                (
                    PlanetCompounds {
                        planet_id,
                        name: Names::Compound::TRITIUM,
                        level: compounds.tritium + queue_status.levels
                    },
                    PlanetCompoundTimer {
                        planet_id,
                        name: queue_status.name,
                        levels: Zeroable::zero(),
                        time_end: Zeroable::zero()
                    },
                )
            );
        },
        CompoundUpgradeType::EnergyPlant => {
            set!(
                world,
                (
                    PlanetCompounds {
                        planet_id,
                        name: Names::Compound::ENERGY,
                        level: compounds.energy + queue_status.levels
                    },
                    PlanetCompoundTimer {
                        planet_id,
                        name: queue_status.name,
                        levels: Zeroable::zero(),
                        time_end: Zeroable::zero()
                    },
                )
            );
        },
        CompoundUpgradeType::Lab => {
            set!(
                world,
                (
                    PlanetCompounds {
                        planet_id,
                        name: Names::Compound::LAB,
                        level: compounds.lab + queue_status.levels
                    },
                    PlanetCompoundTimer {
                        planet_id,
                        name: queue_status.name,
                        levels: Zeroable::zero(),
                        time_end: Zeroable::zero()
                    },
                )
            );
        },
        CompoundUpgradeType::Dockyard => {
            set!(
                world,
                (
                    PlanetCompounds {
                        planet_id,
                        name: Names::Compound::DOCKYARD,
                        level: compounds.dockyard + queue_status.levels
                    },
                    PlanetCompoundTimer {
                        planet_id,
                        name: queue_status.name,
                        levels: Zeroable::zero(),
                        time_end: Zeroable::zero()
                    },
                )
            );
        },
        CompoundUpgradeType::Cybernetics => {
            set!(
                world,
                (
                    PlanetCompounds {
                        planet_id,
                        name: Names::Compound::CYBERNETICS,
                        level: compounds.cybernetics + queue_status.levels
                    },
                    PlanetCompoundTimer {
                        planet_id,
                        name: queue_status.name,
                        levels: Zeroable::zero(),
                        time_end: Zeroable::zero()
                    },
                )
            );
        },
    }
}


fn production_scaler(production: u128, available: u128, required: u128) -> u128 {
    if available > required {
        return production;
    } else {
        return ((((available * 100) / required) * production) / 100);
    }
}

fn calculate_avg_temperature(orbit: u8) -> u32 {
    if orbit == 1 {
        return 230;
    }
    if orbit == 2 {
        return 170;
    }
    if orbit == 3 {
        return 120;
    }
    if orbit == 4 {
        return 70;
    }
    if orbit == 5 {
        return 60;
    }
    if orbit == 6 {
        return 50;
    }
    if orbit == 7 {
        return 40;
    }
    if orbit == 8 {
        return 40;
    }
    if orbit == 9 {
        return 20;
    } else {
        return 10;
    }
}

fn celestia_production(orbit: u8) -> u32 {
    if orbit == 1 {
        return 48;
    }
    if orbit == 2 {
        return 41;
    }
    if orbit == 3 {
        return 36;
    }
    if orbit == 4 {
        return 32;
    }
    if orbit == 5 {
        return 27;
    }
    if orbit == 6 {
        return 24;
    }
    if orbit == 7 {
        return 21;
    }
    if orbit == 8 {
        return 17;
    }
    if orbit == 9 {
        return 14;
    } else {
        return 11;
    }
}

mod cost {
    use nogame::data::types::{Resources, erc20_mul};

    fn steel(level: u8, quantity: u8) -> Resources {
        assert(!quantity.is_zero(), 'quantity can not be zero');
        let costs: Array<Resources> = array![
            Resources { steel: 60, quartz: 15, tritium: 0 },
            Resources { steel: 90, quartz: 22, tritium: 0 },
            Resources { steel: 135, quartz: 33, tritium: 0 },
            Resources { steel: 202, quartz: 50, tritium: 0 },
            Resources { steel: 303, quartz: 75, tritium: 0 },
            Resources { steel: 455, quartz: 113, tritium: 0 },
            Resources { steel: 683, quartz: 170, tritium: 0 },
            Resources { steel: 1025, quartz: 256, tritium: 0 },
            Resources { steel: 1537, quartz: 384, tritium: 0 },
            Resources { steel: 2306, quartz: 576, tritium: 0 },
            Resources { steel: 3459, quartz: 864, tritium: 0 },
            Resources { steel: 5189, quartz: 1297, tritium: 0 },
            Resources { steel: 7784, quartz: 1946, tritium: 0 },
            Resources { steel: 11677, quartz: 2919, tritium: 0 },
            Resources { steel: 17515, quartz: 4378, tritium: 0 },
            Resources { steel: 26273, quartz: 6568, tritium: 0 },
            Resources { steel: 39410, quartz: 9852, tritium: 0 },
            Resources { steel: 59115, quartz: 14778, tritium: 0 },
            Resources { steel: 88673, quartz: 22168, tritium: 0 },
            Resources { steel: 133010, quartz: 33252, tritium: 0 },
            Resources { steel: 199515, quartz: 49878, tritium: 0 },
            Resources { steel: 299273, quartz: 74818, tritium: 0 },
            Resources { steel: 448909, quartz: 112227, tritium: 0 },
            Resources { steel: 673364, quartz: 168341, tritium: 0 },
            Resources { steel: 1010046, quartz: 252511, tritium: 0 },
            Resources { steel: 1515070, quartz: 378767, tritium: 0 },
            Resources { steel: 2272605, quartz: 568151, tritium: 0 },
            Resources { steel: 3408907, quartz: 852226, tritium: 0 },
            Resources { steel: 5113361, quartz: 1278340, tritium: 0 },
            Resources { steel: 7670042, quartz: 1917510, tritium: 0 },
            Resources { steel: 11505063, quartz: 2876265, tritium: 0 },
            Resources { steel: 17257595, quartz: 4314398, tritium: 0 },
            Resources { steel: 25886392, quartz: 6471598, tritium: 0 },
            Resources { steel: 38829589, quartz: 9707397, tritium: 0 },
            Resources { steel: 58244384, quartz: 14561096, tritium: 0 },
            Resources { steel: 87366576, quartz: 21841644, tritium: 0 },
            Resources { steel: 131049864, quartz: 32762466, tritium: 0 },
            Resources { steel: 196574796, quartz: 49143699, tritium: 0 },
            Resources { steel: 294862195, quartz: 73715548, tritium: 0 },
            Resources { steel: 442293292, quartz: 110573323, tritium: 0 },
            Resources { steel: 663439939, quartz: 165859984, tritium: 0 },
            Resources { steel: 995159908, quartz: 248789977, tritium: 0 },
            Resources { steel: 1492739863, quartz: 373184965, tritium: 0 },
            Resources { steel: 2239109794, quartz: 559777448, tritium: 0 },
            Resources { steel: 3358664692, quartz: 839666173, tritium: 0 },
            Resources { steel: 5037997038, quartz: 1259499259, tritium: 0 },
            Resources { steel: 7556995558, quartz: 1889248889, tritium: 0 },
            Resources { steel: 11335493337, quartz: 2833873334, tritium: 0 },
            Resources { steel: 17003240005, quartz: 4250810001, tritium: 0 },
            Resources { steel: 25504860008, quartz: 6376215002, tritium: 0 },
            Resources { steel: 38257290012, quartz: 9564322503, tritium: 0 },
            Resources { steel: 57385935019, quartz: 14346483754, tritium: 0 },
            Resources { steel: 86078902528, quartz: 21519725632, tritium: 0 },
            Resources { steel: 129118353793, quartz: 32279588448, tritium: 0 },
            Resources { steel: 193677530690, quartz: 48419382672, tritium: 0 },
            Resources { steel: 290516296035, quartz: 72629074008, tritium: 0 },
            Resources { steel: 435774444052, quartz: 108943611013, tritium: 0 },
            Resources { steel: 653661666078, quartz: 163415416519, tritium: 0 },
            Resources { steel: 980492499118, quartz: 245123124779, tritium: 0 },
            Resources { steel: 1470738748677, quartz: 367684687169, tritium: 0 },
            Resources { steel: 2206108123015, quartz: 551527030753, tritium: 0 },
            Resources { steel: 3309162184523, quartz: 827290546130, tritium: 0 },
            Resources { steel: 4963743276785, quartz: 1240935819196, tritium: 0 },
            Resources { steel: 7445614915178, quartz: 1861403728794, tritium: 0 },
            Resources { steel: 11168422372768, quartz: 2792105593192, tritium: 0 },
            Resources { steel: 16752633559152, quartz: 4188158389788, tritium: 0 },
            Resources { steel: 25128950338728, quartz: 6282237584682, tritium: 0 },
            Resources { steel: 37693425508093, quartz: 9423356377023, tritium: 0 },
            Resources { steel: 56540138262140, quartz: 14135034565535, tritium: 0 },
            Resources { steel: 84810207393210, quartz: 21202551848302, tritium: 0 },
            Resources { steel: 127215311089815, quartz: 31803827772453, tritium: 0 },
            Resources { steel: 190822966634722, quartz: 47705741658680, tritium: 0 },
            Resources { steel: 286234449952084, quartz: 71558612488021, tritium: 0 },
            Resources { steel: 429351674928126, quartz: 107337918732031, tritium: 0 },
            Resources { steel: 644027512392189, quartz: 161006878098047, tritium: 0 },
            Resources { steel: 966041268588283, quartz: 241510317147070, tritium: 0 },
            Resources { steel: 1449061902882425, quartz: 362265475720606, tritium: 0 },
            Resources { steel: 2173592854323638, quartz: 543398213580909, tritium: 0 },
            Resources { steel: 3260389281485456, quartz: 815097320371364, tritium: 0 },
            Resources { steel: 4890583922228185, quartz: 1222645980557046, tritium: 0 },
            Resources { steel: 7335875883342278, quartz: 1833968970835569, tritium: 0 },
            Resources { steel: 11003813825013418, quartz: 2750953456253354, tritium: 0 },
            Resources { steel: 16505720737520126, quartz: 4126430184380031, tritium: 0 },
            Resources { steel: 24758581106280188, quartz: 6189645276570047, tritium: 0 },
            Resources { steel: 37137871659420288, quartz: 9284467914855072, tritium: 0 },
            Resources { steel: 55706807489130424, quartz: 13926701872282606, tritium: 0 },
            Resources { steel: 83560211233695632, quartz: 20890052808423908, tritium: 0 },
            Resources { steel: 125340316850543456, quartz: 31335079212635864, tritium: 0 },
            Resources { steel: 188010475275815200, quartz: 47002618818953800, tritium: 0 },
            Resources { steel: 282015712913722816, quartz: 70503928228430704, tritium: 0 },
            Resources { steel: 423023569370584128, quartz: 105755892342646032, tritium: 0 },
            Resources { steel: 634535354055876224, quartz: 158633838513969056, tritium: 0 },
            Resources { steel: 951803031083814400, quartz: 237950757770953600, tritium: 0 },
            Resources { steel: 1427704546625721600, quartz: 356926136656430400, tritium: 0 },
            Resources { steel: 2141556819938582528, quartz: 535389204984645632, tritium: 0 },
            Resources { steel: 3212335229907873792, quartz: 803083807476968448, tritium: 0 },
            Resources { steel: 4818502844861809664, quartz: 1204625711215452416, tritium: 0 },
            Resources { steel: 7227754267292715008, quartz: 1806938566823178752, tritium: 0 },
            Resources { steel: 10841631400939073536, quartz: 2710407850234768384, tritium: 0 },
            Resources { steel: 16262447101408610304, quartz: 4065611775352152576, tritium: 0 },
            Resources { steel: 24393670652112912384, quartz: 6098417663028228096, tritium: 0 },
        ];
        let mut sum: Resources = Default::default();
        let mut i: usize = (level + quantity).into();
        loop {
            if i == level.into() {
                break;
            }
            sum = sum + (*costs.at(i - 1));
            i -= 1;
        };
        sum
    }

    fn quartz(level: u8, quantity: u8) -> Resources {
        assert(!quantity.is_zero(), 'quantity can not be zero');
        let costs: Array<Resources> = array![
            Resources { steel: 48, quartz: 24, tritium: 0 },
            Resources { steel: 76, quartz: 38, tritium: 0 },
            Resources { steel: 122, quartz: 61, tritium: 0 },
            Resources { steel: 196, quartz: 98, tritium: 0 },
            Resources { steel: 314, quartz: 157, tritium: 0 },
            Resources { steel: 503, quartz: 251, tritium: 0 },
            Resources { steel: 805, quartz: 402, tritium: 0 },
            Resources { steel: 1288, quartz: 644, tritium: 0 },
            Resources { steel: 2061, quartz: 1030, tritium: 0 },
            Resources { steel: 3298, quartz: 1649, tritium: 0 },
            Resources { steel: 5277, quartz: 2638, tritium: 0 },
            Resources { steel: 8444, quartz: 4222, tritium: 0 },
            Resources { steel: 13510, quartz: 6755, tritium: 0 },
            Resources { steel: 21617, quartz: 10808, tritium: 0 },
            Resources { steel: 34587, quartz: 17293, tritium: 0 },
            Resources { steel: 55340, quartz: 27670, tritium: 0 },
            Resources { steel: 88544, quartz: 44272, tritium: 0 },
            Resources { steel: 141670, quartz: 70835, tritium: 0 },
            Resources { steel: 226673, quartz: 113336, tritium: 0 },
            Resources { steel: 362677, quartz: 181338, tritium: 0 },
            Resources { steel: 580284, quartz: 290142, tritium: 0 },
            Resources { steel: 928455, quartz: 464227, tritium: 0 },
            Resources { steel: 1485528, quartz: 742764, tritium: 0 },
            Resources { steel: 2376844, quartz: 1188422, tritium: 0 },
            Resources { steel: 3802951, quartz: 1901475, tritium: 0 },
            Resources { steel: 6084722, quartz: 3042361, tritium: 0 },
            Resources { steel: 9735556, quartz: 4867778, tritium: 0 },
            Resources { steel: 15576890, quartz: 7788445, tritium: 0 },
            Resources { steel: 24923024, quartz: 12461512, tritium: 0 },
            Resources { steel: 39876839, quartz: 19938419, tritium: 0 },
            Resources { steel: 63802943, quartz: 31901471, tritium: 0 },
            Resources { steel: 102084710, quartz: 51042355, tritium: 0 },
            Resources { steel: 163335536, quartz: 81667768, tritium: 0 },
            Resources { steel: 261336857, quartz: 130668428, tritium: 0 },
            Resources { steel: 418138972, quartz: 209069486, tritium: 0 },
            Resources { steel: 669022355, quartz: 334511177, tritium: 0 },
            Resources { steel: 1070435769, quartz: 535217884, tritium: 0 },
            Resources { steel: 1712697231, quartz: 856348615, tritium: 0 },
            Resources { steel: 2740315569, quartz: 1370157784, tritium: 0 },
            Resources { steel: 4384504911, quartz: 2192252455, tritium: 0 },
            Resources { steel: 7015207859, quartz: 3507603929, tritium: 0 },
            Resources { steel: 11224332574, quartz: 5612166287, tritium: 0 },
            Resources { steel: 17958932119, quartz: 8979466059, tritium: 0 },
            Resources { steel: 28734291391, quartz: 14367145695, tritium: 0 },
            Resources { steel: 45974866225, quartz: 22987433112, tritium: 0 },
            Resources { steel: 73559785961, quartz: 36779892980, tritium: 0 },
            Resources { steel: 117695657538, quartz: 58847828769, tritium: 0 },
            Resources { steel: 188313052061, quartz: 94156526030, tritium: 0 },
            Resources { steel: 301300883298, quartz: 150650441649, tritium: 0 },
            Resources { steel: 482081413277, quartz: 241040706638, tritium: 0 },
            Resources { steel: 771330261244, quartz: 385665130622, tritium: 0 },
            Resources { steel: 1234128417990, quartz: 617064208995, tritium: 0 },
            Resources { steel: 1974605468785, quartz: 987302734392, tritium: 0 },
            Resources { steel: 3159368750056, quartz: 1579684375028, tritium: 0 },
            Resources { steel: 5054990000090, quartz: 2527495000045, tritium: 0 },
            Resources { steel: 8087984000145, quartz: 4043992000072, tritium: 0 },
            Resources { steel: 12940774400232, quartz: 6470387200116, tritium: 0 },
            Resources { steel: 20705239040371, quartz: 10352619520185, tritium: 0 },
            Resources { steel: 33128382464594, quartz: 16564191232297, tritium: 0 },
            Resources { steel: 53005411943351, quartz: 26502705971675, tritium: 0 },
            Resources { steel: 84808659109362, quartz: 42404329554681, tritium: 0 },
            Resources { steel: 135693854574980, quartz: 67846927287490, tritium: 0 },
            Resources { steel: 217110167319968, quartz: 108555083659984, tritium: 0 },
            Resources { steel: 347376267711949, quartz: 173688133855974, tritium: 0 },
            Resources { steel: 555802028339119, quartz: 277901014169559, tritium: 0 },
            Resources { steel: 889283245342591, quartz: 444641622671295, tritium: 0 },
            Resources { steel: 1422853192548146, quartz: 711426596274073, tritium: 0 },
            Resources { steel: 2276565108077035, quartz: 1138282554038517, tritium: 0 },
            Resources { steel: 3642504172923256, quartz: 1821252086461628, tritium: 0 },
            Resources { steel: 5828006676677210, quartz: 2914003338338605, tritium: 0 },
            Resources { steel: 9324810682683536, quartz: 4662405341341768, tritium: 0 },
            Resources { steel: 14919697092293658, quartz: 7459848546146829, tritium: 0 },
            Resources { steel: 23871515347669856, quartz: 11935757673834928, tritium: 0 },
            Resources { steel: 38194424556271768, quartz: 19097212278135884, tritium: 0 },
            Resources { steel: 61111079290034832, quartz: 30555539645017416, tritium: 0 },
            Resources { steel: 97777726864055744, quartz: 48888863432027872, tritium: 0 },
            Resources { steel: 156444362982489184, quartz: 78222181491244592, tritium: 0 },
            Resources { steel: 250310980771982720, quartz: 125155490385991360, tritium: 0 },
            Resources { steel: 400497569235172352, quartz: 200248784617586176, tritium: 0 },
            Resources { steel: 640796110776275840, quartz: 320398055388137920, tritium: 0 },
            Resources { steel: 1025273777242041344, quartz: 512636888621020672, tritium: 0 },
            Resources { steel: 1640438043587266304, quartz: 820219021793633152, tritium: 0 },
            Resources { steel: 2624700869739625984, quartz: 1312350434869812992, tritium: 0 },
            Resources { steel: 4199521391583401984, quartz: 2099760695791700992, tritium: 0 },
            Resources { steel: 6719234226533443584, quartz: 3359617113266721792, tritium: 0 },
            Resources { steel: 10750774762453510144, quartz: 5375387381226755072, tritium: 0 },
            Resources { steel: 17201239619925618688, quartz: 8600619809962809344, tritium: 0 },
            Resources { steel: 27521983391880990720, quartz: 13760991695940495360, tritium: 0 },
            Resources { steel: 44035173427009585152, quartz: 22017586713504792576, tritium: 0 },
            Resources { steel: 70456277483215339520, quartz: 35228138741607669760, tritium: 0 },
            Resources { steel: 112730043973144559616, quartz: 56365021986572279808, tritium: 0 },
            Resources { steel: 180368070357031321600, quartz: 90184035178515660800, tritium: 0 },
            Resources { steel: 288588912571250114560, quartz: 144294456285625057280, tritium: 0 },
            Resources { steel: 461742260114000183296, quartz: 230871130057000091648, tritium: 0 },
            Resources { steel: 738787616182400450560, quartz: 369393808091200225280, tritium: 0 },
            Resources { steel: 1182060185891840720896, quartz: 591030092945920360448, tritium: 0 },
            Resources { steel: 1891296297426945048576, quartz: 945648148713472524288, tritium: 0 },
            Resources { steel: 3026074075883112497152, quartz: 1513037037941556248576, tritium: 0 },
            Resources { steel: 4841718521412979785728, quartz: 2420859260706489892864, tritium: 0 },
            Resources { steel: 7746749634260768915456, quartz: 3873374817130384457728, tritium: 0 },
            Resources {
                steel: 12394799414817230684160, quartz: 6197399707408615342080, tritium: 0
            },
        ];
        let mut sum: Resources = Default::default();
        let mut i: usize = (level + quantity).into();
        loop {
            if i == level.into() {
                break;
            }
            sum = sum + (*costs.at(i - 1));
            i -= 1;
        };
        sum
    }

    fn tritium(level: u8, quantity: u8) -> Resources {
        assert(!quantity.is_zero(), 'quantity can not be zero');
        let costs: Array<Resources> = array![
            Resources { steel: 225, quartz: 75, tritium: 0 },
            Resources { steel: 337, quartz: 112, tritium: 0 },
            Resources { steel: 506, quartz: 168, tritium: 0 },
            Resources { steel: 759, quartz: 253, tritium: 0 },
            Resources { steel: 1139, quartz: 379, tritium: 0 },
            Resources { steel: 1708, quartz: 569, tritium: 0 },
            Resources { steel: 2562, quartz: 854, tritium: 0 },
            Resources { steel: 3844, quartz: 1281, tritium: 0 },
            Resources { steel: 5766, quartz: 1922, tritium: 0 },
            Resources { steel: 8649, quartz: 2883, tritium: 0 },
            Resources { steel: 12974, quartz: 4324, tritium: 0 },
            Resources { steel: 19461, quartz: 6487, tritium: 0 },
            Resources { steel: 29192, quartz: 9730, tritium: 0 },
            Resources { steel: 43789, quartz: 14596, tritium: 0 },
            Resources { steel: 65684, quartz: 21894, tritium: 0 },
            Resources { steel: 98526, quartz: 32842, tritium: 0 },
            Resources { steel: 147789, quartz: 49263, tritium: 0 },
            Resources { steel: 221683, quartz: 73894, tritium: 0 },
            Resources { steel: 332525, quartz: 110841, tritium: 0 },
            Resources { steel: 498788, quartz: 166262, tritium: 0 },
            Resources { steel: 748182, quartz: 249394, tritium: 0 },
            Resources { steel: 1122274, quartz: 374091, tritium: 0 },
            Resources { steel: 1683411, quartz: 561137, tritium: 0 },
            Resources { steel: 2525116, quartz: 841705, tritium: 0 },
            Resources { steel: 3787675, quartz: 1262558, tritium: 0 },
            Resources { steel: 5681512, quartz: 1893837, tritium: 0 },
            Resources { steel: 8522269, quartz: 2840756, tritium: 0 },
            Resources { steel: 12783403, quartz: 4261134, tritium: 0 },
            Resources { steel: 19175105, quartz: 6391701, tritium: 0 },
            Resources { steel: 28762658, quartz: 9587552, tritium: 0 },
            Resources { steel: 43143988, quartz: 14381329, tritium: 0 },
            Resources { steel: 64715982, quartz: 21571994, tritium: 0 },
            Resources { steel: 97073973, quartz: 32357991, tritium: 0 },
            Resources { steel: 145610960, quartz: 48536986, tritium: 0 },
            Resources { steel: 218416440, quartz: 72805480, tritium: 0 },
            Resources { steel: 327624661, quartz: 109208220, tritium: 0 },
            Resources { steel: 491436992, quartz: 163812330, tritium: 0 },
            Resources { steel: 737155488, quartz: 245718496, tritium: 0 },
            Resources { steel: 1105733232, quartz: 368577744, tritium: 0 },
            Resources { steel: 1658599848, quartz: 552866616, tritium: 0 },
            Resources { steel: 2487899772, quartz: 829299924, tritium: 0 },
            Resources { steel: 3731849658, quartz: 1243949886, tritium: 0 },
            Resources { steel: 5597774487, quartz: 1865924829, tritium: 0 },
            Resources { steel: 8396661731, quartz: 2798887243, tritium: 0 },
            Resources { steel: 12594992596, quartz: 4198330865, tritium: 0 },
            Resources { steel: 18892488895, quartz: 6297496298, tritium: 0 },
            Resources { steel: 28338733342, quartz: 9446244447, tritium: 0 },
            Resources { steel: 42508100014, quartz: 14169366671, tritium: 0 },
            Resources { steel: 63762150021, quartz: 21254050007, tritium: 0 },
            Resources { steel: 95643225032, quartz: 31881075010, tritium: 0 },
            Resources { steel: 143464837548, quartz: 47821612516, tritium: 0 },
            Resources { steel: 215197256322, quartz: 71732418774, tritium: 0 },
            Resources { steel: 322795884483, quartz: 107598628161, tritium: 0 },
            Resources { steel: 484193826725, quartz: 161397942241, tritium: 0 },
            Resources { steel: 726290740087, quartz: 242096913362, tritium: 0 },
            Resources { steel: 1089436110131, quartz: 363145370043, tritium: 0 },
            Resources { steel: 1634154165197, quartz: 544718055065, tritium: 0 },
            Resources { steel: 2451231247795, quartz: 817077082598, tritium: 0 },
            Resources { steel: 3676846871693, quartz: 1225615623897, tritium: 0 },
            Resources { steel: 5515270307539, quartz: 1838423435846, tritium: 0 },
            Resources { steel: 8272905461309, quartz: 2757635153769, tritium: 0 },
            Resources { steel: 12409358191964, quartz: 4136452730654, tritium: 0 },
            Resources { steel: 18614037287947, quartz: 6204679095982, tritium: 0 },
            Resources { steel: 27921055931921, quartz: 9307018643973, tritium: 0 },
            Resources { steel: 41881583897881, quartz: 13960527965960, tritium: 0 },
            Resources { steel: 62822375846822, quartz: 20940791948940, tritium: 0 },
            Resources { steel: 94233563770233, quartz: 31411187923411, tritium: 0 },
            Resources { steel: 141350345655350, quartz: 47116781885116, tritium: 0 },
            Resources { steel: 212025518483025, quartz: 70675172827675, tritium: 0 },
            Resources { steel: 318038277724537, quartz: 106012759241512, tritium: 0 },
            Resources { steel: 477057416586806, quartz: 159019138862268, tritium: 0 },
            Resources { steel: 715586124880210, quartz: 238528708293403, tritium: 0 },
            Resources { steel: 1073379187320315, quartz: 357793062440105, tritium: 0 },
            Resources { steel: 1610068780980472, quartz: 536689593660157, tritium: 0 },
            Resources { steel: 2415103171470709, quartz: 805034390490236, tritium: 0 },
            Resources { steel: 3622654757206063, quartz: 1207551585735354, tritium: 0 },
            Resources { steel: 5433982135809095, quartz: 1811327378603031, tritium: 0 },
            Resources { steel: 8150973203713642, quartz: 2716991067904547, tritium: 0 },
            Resources { steel: 12226459805570462, quartz: 4075486601856821, tritium: 0 },
            Resources { steel: 18339689708355696, quartz: 6113229902785232, tritium: 0 },
            Resources { steel: 27509534562533544, quartz: 9169844854177848, tritium: 0 },
            Resources { steel: 41264301843800320, quartz: 13754767281266772, tritium: 0 },
            Resources { steel: 61896452765700472, quartz: 20632150921900156, tritium: 0 },
            Resources { steel: 92844679148550704, quartz: 30948226382850236, tritium: 0 },
            Resources { steel: 139267018722826064, quartz: 46422339574275360, tritium: 0 },
            Resources { steel: 208900528084239104, quartz: 69633509361413032, tritium: 0 },
            Resources { steel: 313350792126358592, quartz: 104450264042119536, tritium: 0 },
            Resources { steel: 470026188189537984, quartz: 156675396063179328, tritium: 0 },
            Resources { steel: 705039282284306944, quartz: 235013094094768992, tritium: 0 },
            Resources { steel: 1057558923426460544, quartz: 352519641142153472, tritium: 0 },
            Resources { steel: 1586338385139690496, quartz: 528779461713230144, tritium: 0 },
            Resources { steel: 2379507577709535744, quartz: 793169192569845248, tritium: 0 },
            Resources { steel: 3569261366564303872, quartz: 1189753788854767872, tritium: 0 },
            Resources { steel: 5353892049846456320, quartz: 1784630683282151936, tritium: 0 },
            Resources { steel: 8030838074769684480, quartz: 2676946024923228160, tritium: 0 },
            Resources { steel: 12046257112154525696, quartz: 4015419037384842240, tritium: 0 },
            Resources { steel: 18069385668231786496, quartz: 6023128556077262848, tritium: 0 },
            Resources { steel: 27104078502347681792, quartz: 9034692834115893248, tritium: 0 },
            Resources { steel: 40656117753521528832, quartz: 13552039251173840896, tritium: 0 },
            Resources { steel: 60984176630282289152, quartz: 20328058876760764416, tritium: 0 },
            Resources { steel: 91476264945423433728, quartz: 30492088315141140480, tritium: 0 },
        ];
        let mut sum: Resources = Default::default();
        let mut i: usize = (level + quantity).into();
        loop {
            if i == level.into() {
                break;
            }
            sum = sum + (*costs.at(i - 1));
            i -= 1;
        };
        sum
    }
    fn energy(level: u8, quantity: u8) -> Resources {
        assert(!quantity.is_zero(), 'quantity can not be zero');
        let costs: Array<Resources> = array![
            Resources { steel: 75, quartz: 30, tritium: 0 },
            Resources { steel: 112, quartz: 45, tritium: 0 },
            Resources { steel: 168, quartz: 67, tritium: 0 },
            Resources { steel: 253, quartz: 101, tritium: 0 },
            Resources { steel: 379, quartz: 151, tritium: 0 },
            Resources { steel: 569, quartz: 227, tritium: 0 },
            Resources { steel: 854, quartz: 341, tritium: 0 },
            Resources { steel: 1281, quartz: 512, tritium: 0 },
            Resources { steel: 1922, quartz: 768, tritium: 0 },
            Resources { steel: 2883, quartz: 1153, tritium: 0 },
            Resources { steel: 4324, quartz: 1729, tritium: 0 },
            Resources { steel: 6487, quartz: 2594, tritium: 0 },
            Resources { steel: 9730, quartz: 3892, tritium: 0 },
            Resources { steel: 14596, quartz: 5838, tritium: 0 },
            Resources { steel: 21894, quartz: 8757, tritium: 0 },
            Resources { steel: 32842, quartz: 13136, tritium: 0 },
            Resources { steel: 49263, quartz: 19705, tritium: 0 },
            Resources { steel: 73894, quartz: 29557, tritium: 0 },
            Resources { steel: 110841, quartz: 44336, tritium: 0 },
            Resources { steel: 166262, quartz: 66505, tritium: 0 },
            Resources { steel: 249394, quartz: 99757, tritium: 0 },
            Resources { steel: 374091, quartz: 149636, tritium: 0 },
            Resources { steel: 561137, quartz: 224454, tritium: 0 },
            Resources { steel: 841705, quartz: 336682, tritium: 0 },
            Resources { steel: 1262558, quartz: 505023, tritium: 0 },
            Resources { steel: 1893837, quartz: 757535, tritium: 0 },
            Resources { steel: 2840756, quartz: 1136302, tritium: 0 },
            Resources { steel: 4261134, quartz: 1704453, tritium: 0 },
            Resources { steel: 6391701, quartz: 2556680, tritium: 0 },
            Resources { steel: 9587552, quartz: 3835021, tritium: 0 },
            Resources { steel: 14381329, quartz: 5752531, tritium: 0 },
            Resources { steel: 21571994, quartz: 8628797, tritium: 0 },
            Resources { steel: 32357991, quartz: 12943196, tritium: 0 },
            Resources { steel: 48536986, quartz: 19414794, tritium: 0 },
            Resources { steel: 72805480, quartz: 29122192, tritium: 0 },
            Resources { steel: 109208220, quartz: 43683288, tritium: 0 },
            Resources { steel: 163812330, quartz: 65524932, tritium: 0 },
            Resources { steel: 245718496, quartz: 98287398, tritium: 0 },
            Resources { steel: 368577744, quartz: 147431097, tritium: 0 },
            Resources { steel: 552866616, quartz: 221146646, tritium: 0 },
            Resources { steel: 829299924, quartz: 331719969, tritium: 0 },
            Resources { steel: 1243949886, quartz: 497579954, tritium: 0 },
            Resources { steel: 1865924829, quartz: 746369931, tritium: 0 },
            Resources { steel: 2798887243, quartz: 1119554897, tritium: 0 },
            Resources { steel: 4198330865, quartz: 1679332346, tritium: 0 },
            Resources { steel: 6297496298, quartz: 2518998519, tritium: 0 },
            Resources { steel: 9446244447, quartz: 3778497779, tritium: 0 },
            Resources { steel: 14169366671, quartz: 5667746668, tritium: 0 },
            Resources { steel: 21254050007, quartz: 8501620002, tritium: 0 },
            Resources { steel: 31881075010, quartz: 12752430004, tritium: 0 },
            Resources { steel: 47821612516, quartz: 19128645006, tritium: 0 },
            Resources { steel: 71732418774, quartz: 28692967509, tritium: 0 },
            Resources { steel: 107598628161, quartz: 43039451264, tritium: 0 },
            Resources { steel: 161397942241, quartz: 64559176896, tritium: 0 },
            Resources { steel: 242096913362, quartz: 96838765345, tritium: 0 },
            Resources { steel: 363145370043, quartz: 145258148017, tritium: 0 },
            Resources { steel: 544718055065, quartz: 217887222026, tritium: 0 },
            Resources { steel: 817077082598, quartz: 326830833039, tritium: 0 },
            Resources { steel: 1225615623897, quartz: 490246249559, tritium: 0 },
            Resources { steel: 1838423435846, quartz: 735369374338, tritium: 0 },
            Resources { steel: 2757635153769, quartz: 1103054061507, tritium: 0 },
            Resources { steel: 4136452730654, quartz: 1654581092261, tritium: 0 },
            Resources { steel: 6204679095982, quartz: 2481871638392, tritium: 0 },
            Resources { steel: 9307018643973, quartz: 3722807457589, tritium: 0 },
            Resources { steel: 13960527965960, quartz: 5584211186384, tritium: 0 },
            Resources { steel: 20940791948940, quartz: 8376316779576, tritium: 0 },
            Resources { steel: 31411187923411, quartz: 12564475169364, tritium: 0 },
            Resources { steel: 47116781885116, quartz: 18846712754046, tritium: 0 },
            Resources { steel: 70675172827675, quartz: 28270069131070, tritium: 0 },
            Resources { steel: 106012759241512, quartz: 42405103696605, tritium: 0 },
            Resources { steel: 159019138862268, quartz: 63607655544907, tritium: 0 },
            Resources { steel: 238528708293403, quartz: 95411483317361, tritium: 0 },
            Resources { steel: 357793062440105, quartz: 143117224976042, tritium: 0 },
            Resources { steel: 536689593660157, quartz: 214675837464063, tritium: 0 },
            Resources { steel: 805034390490236, quartz: 322013756196094, tritium: 0 },
            Resources { steel: 1207551585735354, quartz: 483020634294141, tritium: 0 },
            Resources { steel: 1811327378603031, quartz: 724530951441212, tritium: 0 },
            Resources { steel: 2716991067904547, quartz: 1086796427161819, tritium: 0 },
            Resources { steel: 4075486601856821, quartz: 1630194640742728, tritium: 0 },
            Resources { steel: 6113229902785232, quartz: 2445291961114092, tritium: 0 },
            Resources { steel: 9169844854177848, quartz: 3667937941671139, tritium: 0 },
            Resources { steel: 13754767281266772, quartz: 5501906912506709, tritium: 0 },
            Resources { steel: 20632150921900156, quartz: 8252860368760063, tritium: 0 },
            Resources { steel: 30948226382850236, quartz: 12379290553140094, tritium: 0 },
            Resources { steel: 46422339574275360, quartz: 18568935829710144, tritium: 0 },
            Resources { steel: 69633509361413032, quartz: 27853403744565212, tritium: 0 },
            Resources { steel: 104450264042119536, quartz: 41780105616847816, tritium: 0 },
            Resources { steel: 156675396063179328, quartz: 62670158425271728, tritium: 0 },
            Resources { steel: 235013094094768992, quartz: 94005237637907600, tritium: 0 },
            Resources { steel: 352519641142153472, quartz: 141007856456861408, tritium: 0 },
            Resources { steel: 528779461713230144, quartz: 211511784685292064, tritium: 0 },
            Resources { steel: 793169192569845248, quartz: 317267677027938112, tritium: 0 },
            Resources { steel: 1189753788854767872, quartz: 475901515541907200, tritium: 0 },
            Resources { steel: 1784630683282151936, quartz: 713852273312860800, tritium: 0 },
            Resources { steel: 2676946024923228160, quartz: 1070778409969291264, tritium: 0 },
            Resources { steel: 4015419037384842240, quartz: 1606167614953936896, tritium: 0 },
            Resources { steel: 6023128556077262848, quartz: 2409251422430904832, tritium: 0 },
            Resources { steel: 9034692834115893248, quartz: 3613877133646357504, tritium: 0 },
            Resources { steel: 13552039251173840896, quartz: 5420815700469536768, tritium: 0 },
            Resources { steel: 20328058876760764416, quartz: 8131223550704305152, tritium: 0 },
            Resources { steel: 30492088315141140480, quartz: 12196835326056456192, tritium: 0 },
        ];
        let mut sum: Resources = Default::default();
        let mut i: usize = (level + quantity).into();
        loop {
            if i == level.into() {
                break;
            }
            sum = sum + (*costs.at(i - 1));
            i -= 1;
        };
        sum
    }
    fn lab(level: u8, quantity: u8) -> Resources {
        assert(!quantity.is_zero(), 'quantity can not be zero');
        let costs: Array<Resources> = array![
            Resources { steel: 200, quartz: 400, tritium: 200 },
            Resources { steel: 400, quartz: 800, tritium: 400 },
            Resources { steel: 800, quartz: 1600, tritium: 800 },
            Resources { steel: 1600, quartz: 3200, tritium: 1600 },
            Resources { steel: 3200, quartz: 6400, tritium: 3200 },
            Resources { steel: 6400, quartz: 12800, tritium: 6400 },
            Resources { steel: 12800, quartz: 25600, tritium: 12800 },
            Resources { steel: 25600, quartz: 51200, tritium: 25600 },
            Resources { steel: 51200, quartz: 102400, tritium: 51200 },
            Resources { steel: 102400, quartz: 204800, tritium: 102400 },
            Resources { steel: 204800, quartz: 409600, tritium: 204800 },
            Resources { steel: 409600, quartz: 819200, tritium: 409600 },
            Resources { steel: 819200, quartz: 1638400, tritium: 819200 },
            Resources { steel: 1638400, quartz: 3276800, tritium: 1638400 },
            Resources { steel: 3276800, quartz: 6553600, tritium: 3276800 },
            Resources { steel: 6553600, quartz: 13107200, tritium: 6553600 },
            Resources { steel: 13107200, quartz: 26214400, tritium: 13107200 },
            Resources { steel: 26214400, quartz: 52428800, tritium: 26214400 },
            Resources { steel: 52428800, quartz: 104857600, tritium: 52428800 },
            Resources { steel: 104857600, quartz: 209715200, tritium: 104857600 },
            Resources { steel: 209715200, quartz: 419430400, tritium: 209715200 },
            Resources { steel: 419430400, quartz: 838860800, tritium: 419430400 },
            Resources { steel: 838860800, quartz: 1677721600, tritium: 838860800 },
            Resources { steel: 1677721600, quartz: 3355443200, tritium: 1677721600 },
            Resources { steel: 3355443200, quartz: 6710886400, tritium: 3355443200 },
            Resources { steel: 6710886400, quartz: 13421772800, tritium: 6710886400 },
            Resources { steel: 13421772800, quartz: 26843545600, tritium: 13421772800 },
            Resources { steel: 26843545600, quartz: 53687091200, tritium: 26843545600 },
            Resources { steel: 53687091200, quartz: 107374182400, tritium: 53687091200 },
            Resources { steel: 107374182400, quartz: 214748364800, tritium: 107374182400 },
            Resources { steel: 214748364800, quartz: 429496729600, tritium: 214748364800 },
        ];
        let mut sum: Resources = Default::default();
        let mut i: usize = (level + quantity).into();
        loop {
            if i == level.into() {
                break;
            }
            sum = sum + (*costs.at(i - 1));
            i -= 1;
        };
        sum
    }

    fn dockyard(level: u8, quantity: u8) -> Resources {
        assert(!quantity.is_zero(), 'quantity can not be zero');
        let costs: Array<Resources> = array![
            Resources { steel: 400, quartz: 200, tritium: 100 },
            Resources { steel: 800, quartz: 400, tritium: 200 },
            Resources { steel: 1600, quartz: 800, tritium: 400 },
            Resources { steel: 3200, quartz: 1600, tritium: 800 },
            Resources { steel: 6400, quartz: 3200, tritium: 1600 },
            Resources { steel: 12800, quartz: 6400, tritium: 3200 },
            Resources { steel: 25600, quartz: 12800, tritium: 6400 },
            Resources { steel: 51200, quartz: 25600, tritium: 12800 },
            Resources { steel: 102400, quartz: 51200, tritium: 25600 },
            Resources { steel: 204800, quartz: 102400, tritium: 51200 },
            Resources { steel: 409600, quartz: 204800, tritium: 102400 },
            Resources { steel: 819200, quartz: 409600, tritium: 204800 },
            Resources { steel: 1638400, quartz: 819200, tritium: 409600 },
            Resources { steel: 3276800, quartz: 1638400, tritium: 819200 },
            Resources { steel: 6553600, quartz: 3276800, tritium: 1638400 },
            Resources { steel: 13107200, quartz: 6553600, tritium: 3276800 },
            Resources { steel: 26214400, quartz: 13107200, tritium: 6553600 },
            Resources { steel: 52428800, quartz: 26214400, tritium: 13107200 },
            Resources { steel: 104857600, quartz: 52428800, tritium: 26214400 },
            Resources { steel: 209715200, quartz: 104857600, tritium: 52428800 },
            Resources { steel: 419430400, quartz: 209715200, tritium: 104857600 },
            Resources { steel: 838860800, quartz: 419430400, tritium: 209715200 },
            Resources { steel: 1677721600, quartz: 838860800, tritium: 419430400 },
            Resources { steel: 3355443200, quartz: 1677721600, tritium: 838860800 },
            Resources { steel: 6710886400, quartz: 3355443200, tritium: 1677721600 },
            Resources { steel: 13421772800, quartz: 6710886400, tritium: 3355443200 },
            Resources { steel: 26843545600, quartz: 13421772800, tritium: 6710886400 },
            Resources { steel: 53687091200, quartz: 26843545600, tritium: 13421772800 },
            Resources { steel: 107374182400, quartz: 53687091200, tritium: 26843545600 },
            Resources { steel: 214748364800, quartz: 107374182400, tritium: 53687091200 },
            Resources { steel: 429496729600, quartz: 214748364800, tritium: 107374182400 },
        ];
        let mut sum: Resources = Default::default();
        let mut i: usize = (level + quantity).into();
        loop {
            if i == level.into() {
                break;
            }
            sum = sum + (*costs.at(i - 1));
            i -= 1;
        };
        sum
    }


    fn cybernetics(level: u8, quantity: u8) -> Resources {
        assert(!quantity.is_zero(), 'quantity can not be zero');
        let costs: Array<Resources> = array![
            Resources { steel: 200, quartz: 60, tritium: 100 },
            Resources { steel: 400, quartz: 120, tritium: 200 },
            Resources { steel: 800, quartz: 240, tritium: 400 },
            Resources { steel: 1600, quartz: 480, tritium: 800 },
            Resources { steel: 3200, quartz: 960, tritium: 1600 },
            Resources { steel: 6400, quartz: 1920, tritium: 3200 },
            Resources { steel: 12800, quartz: 3840, tritium: 6400 },
            Resources { steel: 25600, quartz: 7680, tritium: 12800 },
            Resources { steel: 51200, quartz: 15360, tritium: 25600 },
            Resources { steel: 102400, quartz: 30720, tritium: 51200 },
            Resources { steel: 204800, quartz: 61440, tritium: 102400 },
            Resources { steel: 409600, quartz: 122880, tritium: 204800 },
            Resources { steel: 819200, quartz: 245760, tritium: 409600 },
            Resources { steel: 1638400, quartz: 491520, tritium: 819200 },
            Resources { steel: 3276800, quartz: 983040, tritium: 1638400 },
            Resources { steel: 6553600, quartz: 1966080, tritium: 3276800 },
            Resources { steel: 13107200, quartz: 3932160, tritium: 6553600 },
            Resources { steel: 26214400, quartz: 7864320, tritium: 13107200 },
            Resources { steel: 52428800, quartz: 15728640, tritium: 26214400 },
            Resources { steel: 104857600, quartz: 31457280, tritium: 52428800 },
            Resources { steel: 209715200, quartz: 62914560, tritium: 104857600 },
            Resources { steel: 419430400, quartz: 125829120, tritium: 209715200 },
            Resources { steel: 838860800, quartz: 251658240, tritium: 419430400 },
            Resources { steel: 1677721600, quartz: 503316480, tritium: 838860800 },
            Resources { steel: 3355443200, quartz: 1006632960, tritium: 1677721600 },
            Resources { steel: 6710886400, quartz: 2013265920, tritium: 3355443200 },
            Resources { steel: 13421772800, quartz: 4026531840, tritium: 6710886400 },
            Resources { steel: 26843545600, quartz: 8053063680, tritium: 13421772800 },
            Resources { steel: 53687091200, quartz: 16106127360, tritium: 26843545600 },
            Resources { steel: 107374182400, quartz: 32212254720, tritium: 53687091200 },
        ];
        let mut sum: Resources = Default::default();
        let mut i: usize = (level + quantity).into();
        loop {
            if i == level.into() {
                break;
            }
            sum = sum + (*costs.at(i - 1));
            i -= 1;
        };
        sum
    }
}

mod production {
    use nogame::data::types::Resources;
    use nogame::libraries::math::{BitShift};
    use nogame_fixed::f128::types::{Fixed, FixedTrait, ONE_u128 as ONE};

    const _1_36: u128 = 25087571940244990000;
    const _0_004: u128 = 73786976294838210;

    fn steel(level: u8) -> u128 {
        let costs = array![
            10,
            33,
            72,
            119,
            175,
            241,
            318,
            409,
            514,
            636,
            778,
            941,
            1129,
            1346,
            1594,
            1879,
            2205,
            2577,
            3002,
            3486,
            4036,
            4662,
            5372,
            6178,
            7091,
            8126,
            9296,
            10619,
            12113,
            13800,
            15704,
            17850,
            20269,
            22992,
            26058,
            29507,
            33385,
            37744,
            42640,
            48139,
            54311,
            61235,
            69002,
            77709,
            87468,
            98402,
            110647,
            124358,
            139704,
            156876,
            176086,
            197568,
            221586,
            248433,
            278432,
            311947,
            349381,
            391182,
            437849,
            489938,
            548066,
            612921,
            685266,
            765950,
            855919,
            956222,
            1068027,
            1192630,
            1331474,
            1486160,
            1658468,
            1850377,
            2064082,
            2302025,
            2566916,
            2861764,
            3189913,
            3555074,
            3961369,
            4413371,
            4916160,
            5475373,
            6097268,
            6788787,
            7557638,
            8412371,
            9362474,
            10418474,
            11592049,
            12896154,
            14345161,
            15955006,
            17743370,
            19729856,
            21936205,
            24386526,
            27107549,
            30128912,
            33483471,
            37207653,
            41341837,
        ];
        *costs.at(level.into())
    }
    fn quartz(level: u8) -> u128 {
        let costs = array![
            10,
            22,
            48,
            79,
            117,
            161,
            212,
            272,
            342,
            424,
            518,
            627,
            753,
            897,
            1063,
            1253,
            1470,
            1718,
            2001,
            2324,
            2690,
            3108,
            3581,
            4118,
            4727,
            5417,
            6197,
            7079,
            8075,
            9200,
            10469,
            11900,
            13512,
            15328,
            17372,
            19671,
            22257,
            25162,
            28427,
            32092,
            36207,
            40823,
            46001,
            51806,
            58312,
            65601,
            73765,
            82905,
            93136,
            104584,
            117390,
            131712,
            147724,
            165622,
            185621,
            207965,
            232920,
            260788,
            291899,
            326625,
            365377,
            408614,
            456844,
            510633,
            570613,
            637481,
            712018,
            795087,
            887649,
            990773,
            1105645,
            1233584,
            1376055,
            1534683,
            1711277,
            1907843,
            2126609,
            2370049,
            2640912,
            2942247,
            3277440,
            3650249,
            4064845,
            4525858,
            5038425,
            5608247,
            6241649,
            6945649,
            7728032,
            8597436,
            9563440,
            10636671,
            11828913,
            13153237,
            14624137,
            16257684,
            18071699,
            20085941,
            22322314,
            24805102,
            27561224,
        ];
        *costs.at(level.into())
    }
    fn tritium(current_level: u8, avg_temp: u32, uni_speed: u128) -> u128 {
        let base: u256 = 10;
        let raw_production = (base
            * current_level.into()
            * BitShift::fpow(11.into(), current_level.into())
            / BitShift::fpow(10.into(), current_level.into()))
            .low
            * uni_speed;

        let production_fp = FixedTrait::new_unscaled(raw_production, false);
        let temp = FixedTrait::new_unscaled(avg_temp.into(), false);
        let f1 = FixedTrait::new(_1_36, false);
        let f2 = FixedTrait::new(_0_004, false);
        (production_fp * (f1 - f2 * temp)).mag / ONE
    }

    fn energy(level: u8) -> u128 {
        let costs = array![
            0,
            22,
            48,
            79,
            117,
            161,
            212,
            272,
            342,
            424,
            518,
            627,
            753,
            897,
            1063,
            1253,
            1470,
            1718,
            2001,
            2324,
            2690,
            3108,
            3581,
            4118,
            4727,
            5417,
            6197,
            7079,
            8075,
            9200,
            10469,
            11900,
            13512,
            15328,
            17372,
            19671,
            22257,
            25162,
            28427,
            32092,
            36207,
            40823,
            46001,
            51806,
            58312,
            65601,
            73765,
            82905,
            93136,
            104584,
            117390,
            131712,
            147724,
            165622,
            185621,
            207965,
            232920,
            260788,
            291899,
            326625,
            365377,
            408614,
            456844,
            510633,
            570613,
            637481,
            712018,
            795087,
            887649,
            990773,
            1105645,
            1233584,
            1376055,
            1534683,
            1711277,
            1907843,
            2126609,
            2370049,
            2640912,
            2942247,
            3277440,
            3650249,
            4064845,
            4525858,
            5038425,
            5608247,
            6241649,
            6945649,
            7728032,
            8597436,
            9563440,
            10636671,
            11828913,
            13153237,
            14624137,
            16257684,
            18071699,
            20085941,
            22322314,
            24805102,
            27561224,
        ];
        *costs.at(level.into())
    }
}

mod consumption {
    fn base(level: u8) -> u128 {
        let costs = array![
            0,
            11,
            24,
            39,
            58,
            80,
            106,
            136,
            171,
            212,
            259,
            313,
            376,
            448,
            531,
            626,
            735,
            859,
            1000,
            1162,
            1345,
            1554,
            1790,
            2059,
            2363,
            2708,
            3098,
            3539,
            4037,
            4600,
            5234,
            5950,
            6756,
            7664,
            8686,
            9835,
            11128,
            12581,
            14213,
            16046,
            18103,
            20411,
            23000,
            25903,
            29156,
            32800,
            36882,
            41452,
            46568,
            52292,
            58695,
            65856,
            73862,
            82811,
            92810,
            103982,
            116460,
            130394,
            145949,
            163312,
            182688,
            204307,
            228422,
            255316,
            285306,
            318740,
            356009,
            397543,
            443824,
            495386,
            552822,
            616792,
            688027,
            767341,
            855638,
            953921,
            1063304,
            1185024,
            1320456,
            1471123,
            1638720,
            1825124,
            2032422,
            2262929,
            2519212,
            2804123,
            3120824,
            3472824,
            3864016,
            4298718,
            4781720,
            5318335,
            5914456,
            6576618,
            7312068,
            8128842,
            9035849,
            10042970,
            11161157,
            12402551,
            13780612,
        ];
        *costs.at(level.into())
    }
    fn tritium(level: u8) -> u128 {
        let costs = array![
            0,
            22,
            48,
            79,
            117,
            161,
            212,
            272,
            342,
            424,
            518,
            627,
            753,
            897,
            1063,
            1253,
            1470,
            1718,
            2001,
            2324,
            2690,
            3108,
            3581,
            4118,
            4727,
            5417,
            6197,
            7079,
            8075,
            9200,
            10469,
            11900,
            13512,
            15328,
            17372,
            19671,
            22257,
            25162,
            28427,
            32092,
            36207,
            40823,
            46001,
            51806,
            58312,
            65601,
            73765,
            82905,
            93136,
            104584,
            117390,
            131712,
            147724,
            165622,
            185621,
            207965,
            232920,
            260788,
            291899,
            326625,
            365377,
            408614,
            456844,
            510633,
            570613,
            637481,
            712018,
            795087,
            887649,
            990773,
            1105645,
            1233584,
            1376055,
            1534683,
            1711277,
            1907843,
            2126609,
            2370049,
            2640912,
            2942247,
            3277440,
            3650249,
            4064845,
            4525858,
            5038425,
            5608247,
            6241649,
            6945649,
            7728032,
            8597436,
            9563440,
            10636671,
            11828913,
            13153237,
            14624137,
            16257684,
            18071699,
            20085941,
            22322314,
            24805102,
            27561224,
        ];
        *costs.at(level.into())
    }
}
