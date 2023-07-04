#[starknet::contract]

mod swaptoken {
    use starknet::ContractAddress;
    use starknet::{get_caller_address, get_contract_address, get_block_timestamp};
    use new_syntax::interfaces::IERC20DispatcherTrait;
    use new_syntax::interfaces::IERC20Dispatcher;
    use integer::Into;



    // SWAPPING DETAILS
    #[derive(Drop,storage_access::StorageAccess)]
    struct SwapDetail{
        tokenContract: ContractAddress,
        tokenAmount: u256,
        status: bool,
    }



    //STORAGE
    struct storage {
        owner: ContractAddress,
        swapper : LegacyMap::<ContractAddress, SwapDetail>
    }


    const tokenPerUSD: u8 = 4_u8;











}