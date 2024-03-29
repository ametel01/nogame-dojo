fn ETH_ADDRESS() -> starknet::ContractAddress {
    starknet::contract_address_const::<
        0x049d36570d4e46f48e99674bd3fcc84644ddd6b96f7c741b1562b82f9e004dc7
    >()
}

const GAME_ID: u8 = 1;
const E18: u128 = 1_000_000_000_000_000_000;
const MAX_NUMBER_OF_PLANETS: u16 = 500;
const BANK_ADDRESS: felt252 =
    1860366167800154921415928660539590774912334121378072733158434352123488366392;
const _0_05: u128 = 922337203685477600;
const STARTING_PRICE_SCALED: u128 = 406274042958431000;
const MIN_PRICE_UNSCALED: u128 = 13214490000000000;
const PRECISION: u128 = 1_000_000_000_000_000_000;
const WEEK: u64 = 604800;
const DAY: u64 = 86400;
const HOUR: u64 = 3600;
