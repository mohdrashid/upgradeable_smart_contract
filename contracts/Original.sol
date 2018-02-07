pragma solidity ^0.4.19;
import './Owned.sol';

contract Original is Owned {
    uint public version;
    mapping(uint => address) public contractRegistry;
    event LogNewContractAdded(uint version, address contractAddress);
    event LogChangingValue(uint val);
    
    struct TestStruct {
        uint id;
    }
    
    TestStruct public t;
    
    function Original() public {
        version = 1;
    }
    
    function newContract(uint newVersion, address newAddress) public requireOwner returns(bool){
        version = newVersion;
        contractRegistry[version] = newAddress;
        LogNewContractAdded(newVersion, newAddress);
        return true;
    }

    function accessStorage() public returns(bool){
        require(msg.sender==contractRegistry[version]);
        if (contractRegistry[version].delegatecall(bytes4(keccak256("accessStorage()")))){
            return true;
        }
        return false;
    }
    
}