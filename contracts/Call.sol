// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract MyContract {
    address otherContract; //popoxakan
    event Response(string response);

    constructor(address _otherContract) {//asum enq ayl contracti hasce karas yndunes mi arajin angam
        otherContract = _otherContract;
    }

    function callReceive() external payable {
        (bool success, ) = otherContract.call{value: msg.value}("");
        require(success, "cant send funds!");
        // transfer --> 2300
    }

    function callSetName(string calldata _name) external {
        (bool success, bytes memory response) = otherContract.call(
           //taki erku toghery hamarjeq en ughaki verevi hmar karanq ev contractin manramasn hasaneliutyun chunenanq
            //abi.encodeWithSignature("setName(string)", _name) --stegh stringy grvac ayl contarcti funkciayi(setname) argumenti tipna -name henc argumenti arjqy
            abi.encodeWithSelector(AnotherContract.setName.selector, _name) //patasxann el misht biterov a galis
        );
// ooooooooooooooooooooooooooooooo1- true
        require(success, "cant set name!");
// ushadir linenq vor transferov response chainq stana, isk senc stanum enq
        emit Response(abi.decode(response, (string)));
    }
}

contract AnotherContract {
    string public name;
    mapping (address => uint) public balances;

    function setName(string calldata _name) external returns(string memory) {
        name = _name;
        return name;
    }

    receive() external payable {
        balances[msg.sender] += msg.value;
    }
}