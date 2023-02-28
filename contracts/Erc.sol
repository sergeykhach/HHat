//bazayin kontrakt vorin kareli a arden jarangel u anun ban dnel

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./IERC20.sol";

contract ERC20 is IERC20 { // interface miacrecinq
    uint totalTokens;
    address owner; 
    mapping(address => uint) balances; // uchet tokenneri qanaky yst hasceneri
    mapping(address => mapping(address => uint)) allowances; //(uinty by def. 0-ya dra hamar minchev chtoghem voch mi pogh chi gna)pahum enq info vor inch vor qsakic ayl hascei kareli a poxancel inch vor qanaki tok
    string _name; // anuny tokeni
    string _symbol; //simvoly

//kardum enq anuny u veradzrdznum
    function name() external view returns(string memory) {
        return _name;
    }
//nuyny simvoly
    function symbol() external view returns(string memory) {
        return _symbol;
    }

    function decimals() external pure returns(uint) {
        return 18; // 1 token = 1 wei , aysinqn 18 hat 0 storaketic heto
    }

    function totalSupply() external view returns(uint) {
        return totalTokens;
    }

// ardyooq ka bavarar token
    modifier enoughTokens(address _from, uint _amount) {
        require(balanceOf(_from) >= _amount, "not enough tokens!");
        _;
    }
// miayn tery 
    modifier onlyOwner() {
        require(msg.sender == owner, "not an owner!");
        _;
    }
// kanchum a mi angam deployi jamanak
    constructor(string memory name_, string memory symbol_, uint initialSupply, address shop) {
        _name = name_;
        _symbol = symbol_;
        owner = msg.sender;
        mint(initialSupply, shop); //mint enq anum skzbnakan mtcvac tokenneri qanaky ev xanuti hascen vory ed tokennery taracelu a(verjiny standartum chka)
    }
// balanc stugum anpayman publiq, interfacum externala
    function balanceOf(address account) public view returns(uint) {
        return balances[account];
    }
// token em ugharkum ayl hascein, skzbic stugum em bavarar qanaky enoughtToke..
    function transfer(address to, uint amount) external enoughTokens(msg.sender, amount) {
        _beforeTokenTransfer(msg.sender, to, amount); //taky ka pastaci es pahin ban chi anum
        balances[msg.sender] -= amount; // im balansic pakasacnum em
        balances[to] += amount; // ira balansin avelacnum em, ira balansi masin infon pahac unem
        emit Transfer(msg.sender, to, amount); // transfer event em emit anum
    }

    function mint(uint amount, address shop) public onlyOwner {
        _beforeTokenTransfer(address(0), shop, amount); //taky ka
        balances[shop] += amount;
        totalTokens += amount;
        emit Transfer(address(0), shop, amount);
    }
// varum enq menak tery kara
    function burn(address _from, uint amount) public onlyOwner {
        _beforeTokenTransfer(_from, address(0), amount); //taky ka , oyakan hasce enq ugharkum
        balances[_from] -= amount; //vercnum enq ed hasceyic varvac tokennery 
        totalTokens -= amount; // yndhanurn el enq pakasacnum
    }

// kogtagorcenq kharcnenq ardyoq qsaki tery ayl hascei ogtin inch vor ban poxancel
    function allowance(address _owner, address spender) public view returns(uint) {
        return allowances[_owner][spender]; // veradardznum en tokenneri qanaky vory tuyl enq talis poxancel
    }

//kkanchvi vor tuyl tan indznic inch vor qanaki token spisat anenq
    function approve(address spender, uint amount) public {// um em es toghnum vercnel im tokennery u inchqan
        _approve(msg.sender, spender, amount);
    }
// Opn Zep-y delagate anum u sra mijocov a kanchum eli internal u virtual
//karogha petq lini ayl teghic kanchel u hastatel sender spender    
    function _approve(address sender, address spender, uint amount) internal virtual {
        allowances[sender][spender] = amount;
        emit Approve(sender, spender, amount); //event hastatum
    }
// kvercni nshvac hasceic ayl hascei ogtin inch vor qanaki token
    function transferFrom(address sender, address recipient, uint amount) public enoughTokens(sender, amount) {
        _beforeTokenTransfer(sender, recipient, amount); //taky ka
        //require(allowances[sender][recipient] >= amount, "check allowance!"); // karanq anenq, bayc partadir chi
        allowances[sender][recipient] -= amount; // error! qani vor unit a u bacasakan tiv chi kara lini // hanumenq mer balances

        balances[sender] -= amount; // karanq mas mas hanenq alowenci chapov yndhanur
        balances[recipient] += amount; //avelacnu enq
        emit Transfer(sender, recipient, amount);
    }
// OPZEp-y senc lrarcucich funkcia en anum slujebni nerqin funkcia, orinak karanq inch proverkaner anenq
// baci ed virtual en anum vor takic karananq iran ogtagorcenq
    function _beforeTokenTransfer(
        address from,
        address to,
        uint amount
    ) internal virtual {}
}


// stegh konkret MCStoken steghcogh kontraktna
contract MCSToken is ERC20 { // jarangum  a verevinic, deligate a anum
    constructor(address shop) ERC20("MCSToken", "MCT", 20, shop) {} // asum a mi makardak verev hel u constructorin kanchi es argumentnerov
//orinak verivi virtualy vonc kareli a kirarel
/*
   function _beforeTokenTransfer(
        address from,
        address to,
        uint amount
    ) internal override { //override qani vor verevy virtuala
        require(from != address(0)) //stugum enq ardyoq zroyakan hasce chi
    }
 */
}


// xanuti contractna vory pti es tokennery arni caxsi
contract MShop { //voch mekic vochinch chi jarangum inqy ira hamar khanuta
    IERC20 public token; // asum enq vor es interfaci {u inqy obyekta} tokeny pti arnenq cax u daje ete contracty chunenayinq miayn inter-ov karainq es sagh funkcianery ogtagorceinq
    address payable public owner; //khanuty terna payable 
    event Bought(uint _amount, address indexed _buyer); //ova arel inchqan
    event Sold(uint _amount, address indexed _seller);  // ova caxel inchqan

    constructor() {
        token = new MCSToken(address(this)); //stegh cnum enq tokeny konkrety new(...) operation of deploy of potostorenniy smart contract 
        // pastorn verevinov mez heriqa vor xanuty deploy anenq mcs tokeny arden iny deploy kani, anun manun obort sagh kberi verevic
        // da el ira hertin ira verevi funkcionalic kogtvi
        owner = payable(msg.sender);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "not an owner!");
        _;
    }
//inch vor meky uzum a caxi
    function sell(uint _amountToSell) external {
        require(
            _amountToSell > 0 &&
            token.balanceOf(msg.sender) >= _amountToSell,
            "incorrect amount!"//vor avel chuzi caxi qan uni
        );
//minchev inch vor ban caxely, iniciatory pti tuyl ta xanutin iranvercni tokennery
        uint allowance = token.allowance(msg.sender, address(this));
        require(allowance >= _amountToSell, "check allowance!"); // pti tuyl tvaci chapy mec kam havasar lini qan vacharqy

        token.transferFrom(msg.sender, address(this), _amountToSell); // vercnum enq xanuti balancin vacharvogh tokennery 

        payable(msg.sender).transfer(_amountToSell); //vcharum enq ira ugharkaci hamar arden wei-ov qani vor mer mot 1wei=1 token

        emit Sold(_amountToSell, msg.sender); //sold event
    }

    receive() external payable { // fallback
        uint tokensToBuy = msg.value; // 1 wei = 1 token decimelic a!
        require(tokensToBuy > 0, "not enough funds!"); //stugumm enq vor uzacy

        require(tokenBalance() >= tokensToBuy, "not enough tokens!"); //karogha chunenq edqan

        token.transfer(msg.sender, tokensToBuy); //dimum enq token obyektin u anum transfer papayi papayic msg.sender -in ays mez pogh tvoghin
        emit Bought(tokensToBuy, msg.sender); //event arav
    }
// inchqan xanutum token ka
    function tokenBalance() public view returns(uint) {
        return token.balanceOf(address(this));
    }
// sa karogha anchtutyunner el unena, avelacrel em
    function withdraw() external onlyOwner() {
        owner.transfer(address(this).balance);
    } 
}