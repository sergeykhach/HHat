// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

contract Payments {
    // sarqum enq struktura tvyalnery anuny dnum enq Payment
    struct Payment {
        uint amount;
        uint timestamp;
        address from;
        string message;
    }
  
    // urish tvyalneri struktury Balance, vori mej mi tvjaly yndhanur vcharumner na myusy mappinga anuny payments

    struct Balance {
        uint totalPayments;
        mapping(uint => Payment) payments;
    }

    // mapping amen hascei hamar balance anuny balances

    mapping (address => Balance) public balances;

    function currentBalance() public view returns(uint){
        return address(this).balance;
    } //funkcian veradardznum a smart contrakti vra eghac gumari masin info

    //funkcia vory konkret hascei konkret poxancman masin infoya talis
   //_addr 23-mappingi na, _indexy 16-i hamary
    function getPayment(address _addr, uint _index) public view returns(Payment memory){
        return balances[_addr].payments[_index];
    }

    function pay(string memory massege) public payable {
        uint paymentNum = balances[msg.sender].totalPayments;// hamarna pahum poxancman paymentNum popoxakani mej arajin indexy 0-na
  
        balances[msg.sender].totalPayments++; // arajin masov gtnum a balances mappingi hamapataskhan hasceyi Balance strukturan u ira total paymentsy avelacnuma 1-ov;
  
        // takinov sarqum a jamanakavor struktura dannyx 18 toghi Paymenti mej newPayment informacia enq pahum blokchaynum konkret ed poxancman masin hamadzayn Payment structi isk massage texty vercvuma poxancoghic
        Payment memory newPayment = Payment(
            msg.value,
            block.timestamp,
            msg.sender,
            massege
        );
        //dimuama balancesi meji paymentsin u paymentNUm klyuchiki tak pahumma newPaymenty u gcum blokchain
        balances[msg.sender].payments[paymentNum] = newPayment;
    }
    
}