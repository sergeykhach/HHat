// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract AucEngine { //holandakan aukcion
    address public owner; // platformi, contracti terna vochte nersi apranqi konkret aukciony
    uint constant DURATION = 2 days; // 2 * 24 * 60 * 60, constant modifikatora nshanakum avor menak stegh enq arjeq talis heto ayl tegherum poxel chka
    uint constant FEE = 10; // 10% plashadki tiroj payna
    // immutable - ayl modificator partadir chi miangamic arjeqy tal, karanq heto el tanq ayd tvum costructorum
    struct Auction {
        address payable seller;//caxoghy
        uint startingPrice;
        uint finalPrice; 
        uint startAt;
        uint endsAt;
        uint discountRate; // inchqan enq amen vayrkyan gnic gcum
        string item; // nkaragrutyuuny apranqy
        bool stopped; // ardyoq aukciony prcav

    }

    Auction[] public auctions; // aukcionneri massiv

    event AuctionCreated(uint index, string itemName, uint startingPrice, uint duration);
    event AuctionEnded(uint index, uint finalPrice, address winner);

    constructor() {
        owner = msg.sender;
    }
    modifier onlyOwner(address _to) {
        require(msg.sender == owner, "you are not an owner!");
        require(_to != address(0), "incorrect address!");
        _;
    }
    function withdraw(address payable _to) external onlyOwner(_to) {
         _to.transfer(address(this).balance);
    }

// taki funkov amen meky hamapatasxan dashtery lracnelov kara es contr-i(plashadki) himanvra sepaka aukciony anckacni
    function createAuction(uint _startingPrice, uint _discountRate, string memory _item, uint _duration) external {
        uint duration = _duration == 0 ? DURATION : _duration; // turnery operator asum a ete aukcion steghcoghy jamanay 0 a drel apavercreq verevi 2 days-y

        require(_startingPrice >= _discountRate * duration, "incorrect starting price"); //skzbnakan giny ardyoq chi sparvi aukcioni yntacqum ete sxal a asum enq 

        Auction memory newAuction = Auction({ //en struct na
            seller: payable(msg.sender), // vacharoghin miangamic payable enq sarqum vor heto karananq pogh poxancenq    
            startingPrice: _startingPrice,
            finalPrice: _startingPrice,
            discountRate: _discountRate,
            startAt: block.timestamp, // now
            endsAt: block.timestamp + duration,
            item: _item,
            stopped: false
        });

        auctions.push(newAuction); // masivi mej a kokhum hertakan aukciony

        emit AuctionCreated(auctions.length - 1, _item, _startingPrice, duration); //skzbum nkaragrvac event-y emit enq anum argumentner(hamar, apranq , gin, tevoghutyun)
    }

//amen pahi karogh enq imananaq ed pahi apranqi giny
    function getPriceFor(uint index) public view returns(uint) {
        Auction memory cAuction = auctions[index]; // memory Auction typi masivic hanum a hamapatasxan indexov auktiony ev veragrum cAuctionin
        require(!cAuction.stopped, "stopped!"); // stugum a ardyoq chi verjacel cauctiony aylapes imast chuni
        uint elapsed = block.timestamp - cAuction.startAt; // inchqan jamanak ancel aukcioni startic 
        uint discount = cAuction.discountRate * elapsed; // hashvuma disconti chapy inchqan a ynkel ed pahin
        return cAuction.startingPrice - discount; // es pahi giny
    }

// gnelu funkcian
    function buy(uint index) external payable {
        Auction storage cAuction = auctions[index]; // storagum pahum enq, ayl voch memory teche sagh tvyalnery funci ashx-ic heto kkori Auction typi masivic hanum a hamapatasxan indexov auktiony ev veragrum cAuctionin
        require(!cAuction.stopped, "stopped!"); // stugum a ardyoq chi verjacel cauctiony aylapes imast chuni
        require(block.timestamp < cAuction.endsAt, "ended!");
        uint cPrice = getPriceFor(index); //giny ed pahi
        require(msg.value >= cPrice, "not enough funds!"); //ugharkac poghy piti aveli >= liny gnin
        cAuction.stopped = true; // ete amen inch normal a stop enq anum
        cAuction.finalPrice = cPrice; //verjnakan giny stanum enq
        uint refund = msg.value - cPrice; // parzum enq inchqan augharkac gumary aveli mec qan verjnakan  giny
        if(refund > 0) {
            payable(msg.sender).transfer(refund);//veradardznum enq avel chapy
        }
        cAuction.seller.transfer( // vacharoghi poghy ugharkum enq iran, pastoren fee-n mnuma contracti vra
            cPrice - ((cPrice * FEE) / 100) // tokosneri het ashxatanqi chisht dzevy qani vor soliditin kotorakneri het lav chi ashxatum
        ); // 500
        // 500 - ((500 * 10) / 100) = 500 - 50 = 450
        // Math.floor --> JS
        emit AuctionEnded(index, cPrice, msg.sender);//event vernakan vory,inchgnov, ov krec
    }
}