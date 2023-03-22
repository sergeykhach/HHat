// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

//hatuk interface mihat funciayov, yndunum a operatori masin miqani lrac info
//inch tokean voorteghic agalis ev ayln 
//petqa veradardzni byte4 
//
interface IERC721Receiver {
    function onERC721Received(
        address operator,
        address from,
        uint tokenId,
        bytes calldata data
    ) external returns(bytes4);
}