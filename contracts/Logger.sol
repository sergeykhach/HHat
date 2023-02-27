// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./ILogger.sol"; //interface import enq anum

// infoya pahum ekogh paymentsneri masin
contract Logger is ILogger {
    mapping(address => uint[]) payments;

// funkcian grancum a addr u paymentsi chapy
    function log(address _from, uint _amount) public {
        require(_from != address(0), "zero address!"); //stugum a vor 0-addr chlni

        payments[_from].push(_amount); //push a anum from keyov dinamik massivi mej
    }
//info rnq stanum
    function getEntry(address _from, uint _index) public view returns(uint) {
        return payments[_from][_index];
    }
}