pragma solidity ^0.4.19;
import './Owned.sol';

contract Upgradeable is Owned {
    uint8 public version;
    mapping(uint8 => address) public contractRegistry;
    event LogNewContractAdded(uint version, address contractAddress);
    event LogChangingValue(uint val);

    struct TestStruct {
        uint id;
    }
    
    TestStruct public t;
    
    function Upgradeable() public {
    }
    
    function addNewVersion(uint8 newVersion, address newAddress) public requireOwner returns(bool){
        require(contractRegistry[newVersion]==0);
        version = newVersion;
        contractRegistry[version] = newAddress;
        LogNewContractAdded(newVersion, newAddress);
        return true;
    }

    function invokeFunction(uint8 callVersion,bytes4 functionName) public returns(bool){
        require(msg.sender==contractRegistry[callVersion]);
        if (contractRegistry[callVersion].delegatecall(functionName)){
            return true;
        }
        return false;
    }
    
}