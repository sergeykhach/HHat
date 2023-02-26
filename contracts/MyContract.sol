// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./Ownable.sol"; //sovorakan import

// abstract kisat kontrakt menak iran ches kara deploy anes, abstract aqni vor piti stanar ownableic (owerridde) tvyal bayc chi stanum
abstract contract Balances is Ownable { //nasledovannost inharitance, dzagin deploy aneluc hkariq chka cnoghin deploy anel
    function getBalance() public view onlyOwner returns(uint) {
        return address(this).balance;
    }
// papayi virtuali patcharo override enq grum vor funkciayi argumenty karanqapoxenq stegh el ka virtual qani vor taky eli jarang ka kara poxi 
    function withdraw(address payable _to) public override virtual onlyOwner {
        _to.transfer(getBalance());
    }
}

contract MyContract is Ownable, Balances { // mi qani jarang, hertakanutyuny shat karevora
    constructor(address _owner) { //sranov veragrum enq Ownebleic ekogh adders owner-y nermucmamb
        owner = _owner;
    }

    // papayi virtuali patcharo override enq grum vor funkcian karanq pereraspredelyat anenq. override(Ownable, Balances)
 //qani vor erku teghum el virtual ka drac mi tegh vor liner cheinq gri    
 function withdraw(address payable _to) public override(Ownable, Balances) onlyOwner {
        //Balances.withdraw(_to); //sranov jarangic karanq imenno papaneric inch vor meki konkret funkcian kanchenq
        //Ownable.withdraw(_to);
        require(_to != address(0), "zero addr"); //lracucich stugum lracucich funkcional
        super.withdraw(_to); // super nshanakum a konkret mi makardak verev pti gnanq cnogh konkret es depqum Balances(ayl voch Ownable) u nuyn funkcian kanchumm enq
    }
}
// irakan lav ownable-y https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol ays hasceyum 