pragma solidity ^0.4.6;

contract Splitter {
    address owner;
    mapping(address => uint) balances;

    function Splitter() {
        owner = msg.sender;
    }
    
    function kill() public {
        if (msg.sender != owner) revert();
        
        selfdestruct(owner);
    }
    
    function getBalance(address addr) public returns (uint balance) {
        return balances[addr];
    }
    
    function split(address addr1, address addr2) public payable returns (bool success) {
        if (addr1 == addr2) revert();
        if (addr1 == 0) revert();
        if (addr2 == 0) revert();
        if (msg.value == 0) return true;
        
        uint half = 0;
        
        if (msg.value % 2 == 0) {
            half = msg.value / 2;         
        } else {
            half = (msg.value - 1) / 2;
            
            // Refund sender the indivisible amount
            balances[msg.sender] += 1;
        }
        
        balances[addr1] = half;
        balances[addr2] = half;
        
        return true;
    }
    
    function withdraw() public returns (bool success) {
        uint balance = balances[msg.sender];
        
        if (balance > 0) {
            balances[msg.sender] = 0;
            msg.sender.transfer(balance);
        }
        
        return true;
    }
}
