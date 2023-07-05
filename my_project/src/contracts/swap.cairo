#[starknet::contract]

mod swaptoken {
    use starknet::ContractAddress;
    use starknet::{get_caller_address, get_contract_address, get_block_timestamp};
    use new_syntax::interfaces::IERC20DispatcherTrait;
    use new_syntax::interfaces::IERC20Dispatcher;
    use integer::Into;




    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event{
        TokenSwapped:TokenSwapped,
        TokenWithdraw:TokenWithdraw
    }

    #[derive(Drop, starknet::Event)]
    struct TokenSwapped{
        tokenContract: ContractAddress,
        user: ContractAddress,
        amount: u256
    }

    #[derive(Drop, starknet::Event)]
    struct TokenWithdraw{
        tokenContract: ContractAddress,
        amount: u256
    }


    const TOKEN_PER_USD: u8 = 4_u8;

    //STORAGE
    #[storage]
    struct storage {
        owner: ContractAddress,
        stableTokenAddress: ContractAddress,
        rewardTokenAddress: ContractAddress
    }

    fn constructor(_owner: ContractAddress, _stableTokenAddress:ContractAddress, _rewardTokenAddress:ContractAddress) {
        owner::write(_owner);
        stableTokenAddress::write(_stableTokenAddress);
        rewardTokenAddress::write(_rewardTokenAddress);
    }



    
    #[external]
    fn swap(ref self:ContractState, amount:u256){

        let caller:ContractAddress = get_caller_address();
        let address_this = get_contract_address();
        assert((IERC20Dispatcher{contract_address:stableTokenAddress}.get_balance_of(caller) >= amount), 'ERC20:Insufficient Bal');
        let status:bool = IERC20Dispatcher{contract_address:stableTokenAddress}.transfer_from(caller, address_this, amount);
        if status == true{
                let amount2get = amount * tokenPerUSD;
                IERC20Dispatcher{contract_address:rewardTokenAddress}.transfer(caller, amount);
            }else{
                revert("swap failed!");
                }

        self.emit(Event::TokenSwapped(TokenSwapped{caller, amount}));
    }

    #[external]
    fn withdrawContractToken(ref self:ContractState,amount:u256, token_address:ContractAddress){
        let caller:ContractAddress = get_caller_address();
        IERC20Dispatcher{contract_address:token_address}.transfer(owner, amount);
        self.emit(Event::TokenWithdraw(TokenWithdraw{caller, amount}));
}

    }












}