//SPDX-License-Identifier: MIT
//primeri hamar arac mytokena
pragma solidity ^0.8.0;

import "./ERC721.sol";
import "./ERC721Enumerable.sol";
import "./ERC721URIStorage.sol";

contract MyToken is ERC721, ERC721Enumerable, ERC721URIStorage {//jarangumm enq srancic
    address public owner;
    uint currentTokenId; //hetevum enq tekushiy identificator tekushego tokena, vor amen mint-in 1-ov avelacnenq

    constructor() ERC721("MyToken", "MTK") { //anuny es a
        owner = msg.sender; //terna
    }

    function safeMint(address to, string calldata tokenId) public {
        require(owner == msg.sender, "not an owner!");

        _safeMint(to, currentTokenId);
        _setTokenURI(currentTokenId, tokenId);

        currentTokenId++;
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
//base uri IPFS-ova
    function _baseURI() internal pure override returns(string memory) {
        return "ipfs://";
    }

    function _burn(uint tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function tokenURI(
        uint tokenId
    ) public view override(ERC721, ERC721URIStorage) returns (string memory) {
        return super.tokenURI(tokenId);
    }

    function _beforeTokenTransfer(address from, address to, uint tokenId) internal override(ERC721, ERC721Enumerable) {
        super._beforeTokenTransfer(from, to, tokenId);
    }
}