#[contract]
mod myERC20token {
    use zeroable::Zeroable;
    use starknet::get_caller_address;
    use starknet::ContractAddress;
    use starknet::contract_address::ContractAddressZeroable;
    

    struct Storage {
        name: felt252,
        symbol: felt252,
        decimal: u8,
        total_supply: u256,
        balances: LegacyMap::<ContractAddress, u256>,
        allowances: LegacyMap::<(ContractAddress, ContractAddress), u256>,
        owner: ContractAddress,
    }

    #[event]
    fn Transfer(from: ContractAddress, to: ContractAddress, value: u256) {}

    #[event]
    fn Approval(owner: ContractAddress, spender: ContractAddress, value: u256) {}

    #[constructor]
    fn constructor(_name: felt252, _symbol: felt252, _decimal: u8, _amount: u256, _owner: ContractAddress) {
        name::write(_name);
        symbol::write(_symbol);
        decimal::write(_decimal);
        total_supply::write(_amount);
        owner::write(_owner);
        assert(!_owner.is_zero(), 'ERC20: mint to addr 0!');
        mint(_owner, _amount);
    }

    #[view]
    fn get_name() -> felt252 {
        name::read()
    }

    #[view]
    fn get_symbol() -> felt252 {
        symbol::read()
    }

    #[view]
    fn get_decimals() -> u8 {
        decimal::read()
    }

    #[view]
    fn get_totalSupply() -> u256 {
        total_supply::read()
    }
     

    #[view]
    fn get_owner() -> ContractAddress {
        owner::read()
    
    }

    #[view]
    fn get_allowance(owner: ContractAddress, spender: ContractAddress) -> u256 {
        allowances::read((owner, spender))
    }

    #[view]
    fn balanceOf(account: ContractAddress) -> u256 {
        balances::read(account)
    }

    #[external]
    fn mint(to: ContractAddress, amount: u256) {
        assert(get_caller_address() == owner::read(), 'Invalid caller');
        let new_total_supply = total_supply::read() + amount;
        total_supply::write(new_total_supply);
        let new_balance = balances::read(to) + amount;
        balances::write(to, new_balance);
    }

    #[external]
    fn transfer(recipient: ContractAddress, amount: u256) {
        let sender = get_caller_address();
        transfer_(sender, recipient, amount);
    }

    #[internal]
    fn transfer_(sender: ContractAddress, recipient: ContractAddress, amount: u256) {
        assert(!recipient.is_zero(), 'ERC20: transfer to addr 0!');
        assert(balances::read(sender) >= amount, 'Insufficient bal');
        balances::write(sender, balances::read(sender) - amount);
        balances::write(recipient, balances::read(recipient) + amount);
        Transfer(sender, recipient, amount);
    }

    #[external]
    fn transfer_from(sender: ContractAddress, recipient: ContractAddress, amount: u256) {
        let caller = get_caller_address();
        assert(allowances::read((sender, caller)) >= amount, 'No allowance');
        transfer_(sender, recipient, amount);
        allowances::write((sender, caller), allowances::read((sender, caller)) - amount);
        
    }

    #[external]
    fn approve(spender: ContractAddress, amount: u256) {
        let caller = get_caller_address();
        approve_(caller, spender, amount);
    }

    #[internal]
    fn approve_(owner: ContractAddress, spender: ContractAddress, amount: u256) {
        assert(!spender.is_zero(), 'ERC20: approve from 0');
        allowances::write((owner, spender), amount);
        Approval(owner, spender, amount);
    }

    #[external]
    fn increase_allowance(spender: ContractAddress, added_value: u256) {
        let caller = get_caller_address();
        approve_(caller, spender, allowances::read((caller, spender)) + added_value);
    }

    #[external]
    fn decrease_allowance(spender: ContractAddress, subtracted_value: u256) {
        let caller = get_caller_address();
        approve_(caller, spender, allowances::read((caller, spender)) - subtracted_value);
    }


    

    
    
}

