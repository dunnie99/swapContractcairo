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


    // SWAPPING DETAILS
    #[derive(Drop,storage_access::StorageAccess)]
    struct SwapDetail{
        tokenContract: ContractAddress,
        tokenAmount: u256,
        status: bool,
    }


    const tokenPerUSD: u8 = 4_u8;

    //STORAGE
    struct storage {
        owner: ContractAddress,
        swapper : LegacyMap::<ContractAddress, SwapDetail>
        stableTokenAddress: ContractAddress,
    }

    fn constructor(_owner: ContractAddress, _stableTokenAddress:ContractAddress) {
        owner::write(_owner);
        stableTokenAddress::write(_stableTokenAddress);

    }



    
    #[external]
    fn swap(ref self:ContractState, amount:u256){
    
    
    }










}