// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Ownable {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    /*  //karainq senc aneinq
         constructor(address ownerOverride) {
        owner = ownerOverride == adress(0) ? msg.sender : ownerOverride; // tiroj hascen nermucelu hnaravorutyun enq talis
    }
    
    */

    modifier onlyOwner() {
        require(owner == msg.sender, "not an owner!");
        _;
    }

// virtual -y grum enq vor hnaravor lini popoxel jarangneric, override gorciqov
    function withdraw(address payable _to) public virtual onlyOwner {
        payable(owner).transfer(address(this).balance);
    }
}
//iskakan