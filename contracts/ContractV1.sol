pragma solidity ^0.4.19;
import './Upgradeable.sol';

contract ContractV1 is Upgradeable {
    address public originalContractAddress; 
    function ContractV1(address addr) public {
        originalContractAddress = addr;
    }
    
    function changeStuffInParent() public requireOwner returns (bool) {
        return originalContractAddress.call(bytes4(keccak256("invokeFunction(uint8,bytes4)")),6,bytes4(keccak256("accessStorage()")));
    }
    
    function accessStorage() public returns(bool) {
        t = TestStruct(456);
    }
}

