// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./ILogger.sol";//ete liner Logger.sol import einq anum svodiy kod drugogo kontrakta, isk senc miayn interfacy

contract Demo {
    ILogger logger; //obyekt sc loggeri het kapvac

    constructor(address _logger) {
        logger = ILogger(_logger); 
    }
// polucheniye info o plateje po poryadkovomu nomeru
    function payment(address _from, uint _number) public view returns(uint) {
        return logger.getEntry(_from, _number);
    }
//stanum a u protokol a stanum
    receive() external payable {
        logger.log(msg.sender, msg.value);
    }
}