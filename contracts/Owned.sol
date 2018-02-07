pragma solidity ^0.4.19;

contract Owned {
    
    address public owner;
    
    modifier requireOwner {
        require(owner == msg.sender);
        _;
    }
    
    event LogOwnerChanged(address oldOwner, address newOwner);
    
    function Owned() public {
        owner = msg.sender;
    }
    
    function changeOwner(address newOwner) public requireOwner returns(bool success){
        require(newOwner!=0);
        owner = newOwner;
        LogOwnerChanged(msg.sender,owner);
        return true;
    }
}