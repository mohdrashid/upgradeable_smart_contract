# Upgradeable Contracts

This is a sample (to be tested) approach to implement upgradeable contracts using delegatecall functionality offered by ethereum

## Explanation

This approach tries to separate data storage from business logic making use of delegate calls and a contract version management system

```solidity
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
```

This is the main contract which keeps tracks of all future versions of the program and at the same allows to invoke functions in the caller contract while letting you to modify data defined in this contract.

Any future upgrades of this contract can access storage of this contract easily by inheriting this contract and calling the invoke function with appropriate version number and identifier of the fucntion to be called of the calling contract. In order for the function to calling to work, the calling contract have to be register in this contract. Which is done by invoking addNewVersion function using appropriate version number and the address of the contract.


The below contract is a new smart contract inheriting the above contract and making use of call and delegatecall to modify data in the parent contract
```solidity
pragma solidity ^0.4.19;
import './Upgradeable.sol';

contract ContractV1 is Upgradeable {
    address public originalContractAddress; 
    function ContractV1(address addr) public {
        originalContractAddress = addr;
    }
    
    /*
    Changes value of t defined in deployed 'Upgradeable' contract by invoking accessStorage() function in this deployed
    as a delegatecall from the 'Upgadeable' contract
    */ 
    function changeStuffInParent() public requireOwner returns (bool) {
        return originalContractAddress.call(bytes4(keccak256("invokeFunction(uint8,bytes4)")),6,bytes4(keccak256("accessStorage()")));
    }
    
    function accessStorage() public returns(bool) {
        t = TestStruct(456);
    }
}


```