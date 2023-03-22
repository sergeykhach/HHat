//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
//es slujebni standarti interface karuma asi ardyoq ukazanni contracty poderjivayet kakoy to interfac ili net, realizuet ili ne realizuet
interface IERC165 {
    function supportsInterface(bytes4 interfaceId) external view returns(bool);
}