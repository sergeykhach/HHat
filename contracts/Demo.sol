//https://github.com/bodrovis-learning/Solidity-YT-Series/commit/98a3e7e9b5ff967f8dff3b473cf5e70f77b70dbe#diff-d892f6679ee82d4bf70cfc08c28bc2d658eda828d21205a8dff9d5ae9550f143

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Demo {
    // require 2аргумента ындунум arajiny paymany erkrordy patasxany ete sxala
    // revert  1 argument menak patasxany  paymanay piti if -ov du gres
    // assert  1 menak paymany yndunum ete sxala panic tipi patasxana talis dra hamar qich en ogtagorcummmenak en depqerum erb petqa erbeq inch vor ban teghi chunena

    address owner;

    event Paid(address indexed _from, uint _amount, uint _timestamp); // sobitiya enq haytararum u asum enq inch dashter uni, ete dahsty indexed a tvac apa ed dashtov sobitiyaneri jurnalum karanq poisk anenq, indexed nshumnery mi sobitiayi mej pti ereqic qich linen

    constructor() {
        owner = msg.sender;
    }

    receive() external payable {
        pay();
    }

    function pay() public payable {
        emit Paid(msg.sender, msg.value, block.timestamp); // stegh ed sobityan poradit enq anum
    }

    modifier onlyOwner(address _to) { // sepakan modificator
        require(msg.sender == owner, "you are not an owner!");
        require(_to != address(0), "incorrect address!");
        _; // cuyca talis vor modificatoric dur enq ekel hajogh u sharunakum enq func anel
        //require(...); karogh enq ed nshanic heto el senc grenq
    }

    function withdraw(address payable _to) external onlyOwner(_to) {
        // Panic
        // assert(msg.sender == owner);
        // Error
        // require(msg.sender == owner, "you are not an owner!");
        // if(msg.sender == owner) {
        //     revert("you are not an owner!");
        // } else {}

        _to.transfer(address(this).balance);
    }
}


