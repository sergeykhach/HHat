//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

//pozvolyaet xranit dopolntelnuyu info o nashix NFT
import "./ERC721.sol"; //asum enq vor jarangum a mer standartic

abstract contract ERC721URIStorage is ERC721 {
    mapping(uint => string) private _tokenURIs;// uint da IDnerna toki, stringnery silkanerne en mer tokenneru
//es funkcina unenq dra hanar stegh peretarspridelit u overide enq anum u virtual
//aysinqn ir himqi vra miqich aveli bard enq anum    

    function tokenURI(uint tokenId) public view virtual override _requireMinted(tokenId) returns(string memory) {
        string memory _tokenURI = _tokenURIs[tokenId]; //vercnum enq 
        string memory base = _baseURI(); //baseviy UI

        if(bytes(base).length == 0) {//ete bazan =0-veradzrdznum enq tokem uri 
            return _tokenURI;
        }

        if(bytes(_tokenURI).length > 0) {
            return string(abi.encodePacked(base, _tokenURI));//ete meca kpcnum enq irar
        }

        return super.tokenURI(tokenId); //ete voch ena uremn verevmenq gcum togh mtaci
    }

    function _setTokenURI(uint tokenId, string memory _tokenURI) internal virtual _requireMinted(tokenId) {
        _tokenURIs[tokenId] = _tokenURI;//lracucich info vortegh karanq iran gtnenq, ira dopinfon pahum enq dop mappingum
    }

//etet varum enq apa stegh el enq hanum
    function _burn(uint tokenId) internal virtual override {
        super._burn(tokenId);

        if(bytes(_tokenURIs[tokenId]).length != 0) {//stugum enq ete 0chi token id 
            delete _tokenURIs[tokenId]; //kareli ajnjel
        }
    }
}
