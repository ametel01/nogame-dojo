use starknet::ContractAddress;

#[starknet::interface]
trait IERC721NoGame<TState> {
    fn mint(ref self: TState, to: ContractAddress, token_id: u256);
    fn token_of(self: @TState, address: ContractAddress) -> u256;
}

#[starknet::interface]
trait IERC721Metadata<TState> {
    fn name(self: @TState) -> felt252;
    fn symbol(self: @TState) -> felt252;
    fn token_uri(self: @TState, token_id: u256) -> Array<felt252>;
}

#[starknet::interface]
trait IERC721MetadataCamelOnly<TState> {
    fn tokenURI(self: @TState, tokenId: u256) -> Array<felt252>;
}
