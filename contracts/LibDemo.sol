// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

// bibliotekayic chi kareli jarangel
import "./Ext.sol"; // import enq anum bibliotekan u nshumm enq en data type vori hamar uzum enq ogtagorcenq

contract LibDemo {
    using StrExt for string; // kcum enq bibliatekan
    using ArrayExt for uint[]; // nshel enq miayn voch bacakan massivi hamar

//ashxatacnum enq funkcian ogtagorcelov librarii funkcian stugelu ka te che nman element
    function runnerArr(uint[] memory numbers, uint number) public pure returns(bool) {
        return numbers.inArray(number);
    }

//uzum em hamematem erku stringnery tenam havasar en te che
    function runnerStr(string memory str1, string memory str2) public pure returns(bool) {
        return str1.eq(str2); // ogtvum enq ext-i eq funkciayic
        //return StrExt.eq(str1, str2); // karainq nayev senc aneinq  
    }
}