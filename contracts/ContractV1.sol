pragma solidity ^0.4.19;
import './Original.sol';

contract ContractV1 is Original {
    address public originalContractAddress; 
    function ContractV1(address addr) public {
        originalContractAddress = addr;
    }
    
    function someUnsafeAction() public requireOwner returns (bool) {
        return originalContractAddress.call(bytes4(keccak256("accessStorage()")));
    }
    
    function accessStorage() public returns(bool) {
        t = TestStruct(456);
    }
}

