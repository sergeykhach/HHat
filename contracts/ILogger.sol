// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
// interface -um asum enq inch funkcianer kan inch argumentrov u incha veradardznum
interface ILogger {
    function log(address _from, uint _amount) external; // iskakan funkciayi publici teghy misht external es grum

    function getEntry(address _from, uint _index) external view returns(uint);
}