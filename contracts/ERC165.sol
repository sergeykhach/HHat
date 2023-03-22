//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

//sa slujebni standarta, ardyoq 
import "./IERC165.sol";

contract ERC165 is IERC165 {
    function supportsInterface(bytes4 interfaceId) public view virtual returns(bool) {
        return interfaceId == type(IERC165).interfaceId;
    }
}//ardyoq poderjivaet ardyoq es interface te che erc721orinak