#[starknet::contract]
mod ERC20 {
    use starknet::ContractAddress;
    use openzeppelin::token::erc20::erc20::ERC20Component;
    use openzeppelin::token::erc20::interface::{IERC20CamelOnly};
    use debug::PrintTrait;

    component!(path: ERC20Component, storage: erc20, event: ERC20Event);

    #[abi(embed_v0)]
    impl ERC20Impl = ERC20Component::ERC20Impl<ContractState>;

    impl ERC20CamelOnly = ERC20Component::ERC20CamelOnlyImpl<ContractState>;

    #[abi(embed_v0)]
    impl ERC20MetadataImpl = ERC20Component::ERC20MetadataImpl<ContractState>;

    impl InternalImpl = ERC20Component::InternalImpl<ContractState>;

    #[storage]
    struct Storage {
        #[substorage(v0)]
        erc20: ERC20Component::Storage,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        #[flat]
        ERC20Event: ERC20Component::Event,
    }

    #[constructor]
    fn constructor(
        ref self: ContractState,
        name: felt252,
        symbol: felt252,
        supply: u256,
        receiver: ContractAddress
    ) {
        self.erc20.initializer(name, symbol);
        self.erc20._mint(receiver, supply);
    }

    #[external(v0)]
    impl ERC20CamelOnlyImpl of IERC20CamelOnly<ContractState> {
        fn totalSupply(self: @ContractState) -> u256 {
            self.erc20.totalSupply()
        }
        fn balanceOf(self: @ContractState, account: ContractAddress) -> u256 {
            self.erc20.balanceOf(account)
        }

        fn transferFrom(
            ref self: ContractState,
            sender: ContractAddress,
            recipient: ContractAddress,
            amount: u256
        ) -> bool {
            self.erc20.transferFrom(sender, recipient, amount)
        }
    }
}
