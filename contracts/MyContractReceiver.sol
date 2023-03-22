//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
//senc funkcia piti unena smart contracty vor ynduni NFT
//hatuk reciverna interfacena ogtagorcum ev karum a ynduni NFT u veradardznuma 
import "./IERC721Receiver.sol";

contract MyContract is IERC721Receiver {
  function onERC721Received(
    address,
    address,
    uint,
    bytes calldata
  ) external pure returns(bytes4) {
    return IERC721Receiver.onERC721Received.selector; //ev veradardznum a henc es funkciayi selectory arajin 4 byte, pingi nman es contracty yndunuma 
  }
}