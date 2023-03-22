//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

//laracucci interface 
import "./IERC721.sol";

interface IERC721Metadata is IERC721 {
    //anun
    function name() external view returns(string memory);
    //simvol ili sticker
    function symbol() external view returns(string memory);
    //uri
    function tokenURI(uint tokenId) external view returns(string memory);
}