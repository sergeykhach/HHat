//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ERC165.sol"; //slujebni standart vor chtum a ardyoq inqy inch vor interfac poderjivayet te che
import "./IERC721.sol"; //ira interfacena
import "./IERC721Metadata.sol"; //es el metadata i tvyalnerov interfacena
import "./Strings.sol"; //library vor tuyl a talis uinty string sarqel nayev
import "./IERC721Receiver.sol"; //stugogh interfacena ardyoq karuma ynduni NFT te che
import "hardhat/console.sol";

contract ERC721 is ERC165, IERC721, IERC721Metadata {
    using Strings for uint;

    string private _name;
    string private _symbol;

    mapping(address => uint) private _balances; //inchqan ov uni NFT
    mapping(uint => address) private _owners; // Ov inch uni uint unikalni ID nashevo tokena
    mapping(uint => address) private _tokenApprovals; //rasparijat konkret es tokeny es hascen kara karavari
    mapping(address => mapping(address => bool)) private _operatorApprovals; //cuyc  talis vor konkret hascen kara kam chi kara rasp uni myus hasceyi bolor tokennery

//ardyoq konkret tokeny oboroty  mrj mtel a
    modifier _requireMinted(uint tokenId) { 
        require(_exists(tokenId), "not minted!");
        _;
    }

    constructor(string memory name_, string memory symbol_) {
        _name = name_; //yndunac arjeqnery veragrum enq mer popoxakannerin
        _symbol = symbol_;
    }

// teghapoxman funkcia
    function transferFrom(address from, address to, uint tokenId) external {
        require(_isApprovedOrOwner(msg.sender, tokenId), "not approved or owner!"); //taky es slujebni funkcian kaov vor uzum a perevod ani ardyoq uni dra iravunqy

        _transfer(from, to, tokenId); //deligate enq anum slujebni  funkcia transfer
    }

    // function safeTransferFrom(
    //     address from,
    //     address to,
    //     uint tokenId
    // ) public {
    //     safeTransferFrom(from, to, tokenId, "");
    // }

//anvtang perevod NFT
    function safeTransferFrom(
        address from,
        address to,
        uint tokenId,
        bytes memory data
    ) public {
        require(_isApprovedOrOwner(msg.sender, tokenId), "not owner!");
        _safeTransfer(from, to, tokenId, data); //heto es funkcian kgrenq
    }

    function name() external view returns(string memory) {
        return _name;
    }

    function symbol() external view returns(string memory) {
        return _symbol;
    }

    function balanceOf(address owner) public view returns(uint) {
        require(owner != address(0), "owner cannot be zero");

        return _balances[owner]; //mappingin enq dimum
    }

//ustanavlivayem fakt vladeniye NFT po ID
    function ownerOf(uint tokenId) public view _requireMinted(tokenId) returns(address) {
        return _owners[tokenId];
    }

//tuyalatvutyun em talis upravlyat moimi tokenami 
    function approve(address to, uint tokenId) public {
        address _owner = ownerOf(tokenId); //tery piti lini

        require(//ov kanchum a piti hnaravorutyun kam tern lini kam arden es tiroj sagh tokennery kara rasparijat ani 
            _owner == msg.sender || isApprovedForAll(_owner, msg.sender),
            "not an owner!"
        );

        require(to != _owner, "cannot approve to self"); //stugum enq iran chi talis 

        _tokenApprovals[tokenId] = to; //arden tvecinq

        emit Approval(_owner, to, tokenId); //sobitiya
    }

    function setApprovalForAll(address operator, bool approved) public {
        require(msg.sender != operator, "cannot approve to self");

        _operatorApprovals[msg.sender][operator] = approved;

        emit ApprovalForAll(msg.sender, operator, approved);
    }

// yst token ID veradzardznum a um a tvac razrisheniya 
    function getApproved(uint tokenId) public view _requireMinted(tokenId) returns(address) {
        return _tokenApprovals[tokenId]; //veravy nayev stugum a vor minted lini
    }

//chstum enq ardyoq operatory iravunq uni tiroj bolor NFT-nery rasparijat ani
    function isApprovedForAll(address owner, address operator) public view returns(bool) {
        return _operatorApprovals[owner][operator]; //mapingic boolnenq veradardznum mappingic
    }
//asum enq vor poderjivayem ERC721 ogtvelov slujebni ERC 165 standarti c
    function supportsInterface(bytes4 interfaceId) public view virtual override returns(bool) {
        return interfaceId == type(IERC721).interfaceId ||
            interfaceId == type(IERC721Metadata).interfaceId ||
            super.supportsInterface(interfaceId); //pastoren sranov urish cankacac smart contract kara mez harcni ardyoq du ERC721 poderjivayesh te voch.
    }
//nor token enq mtcnu oborot u asum enq vor tery address to-na
    function _safeMint(address to, uint tokenId) internal virtual {
        _safeMint(to, tokenId, "");
    }

//nor token enq mtcnu oborot u asum enq vor tery address to-na argumentneri tivy tarbera verevini het
    function _safeMint(address to, uint tokenId, bytes memory data) internal virtual {
        _mint(to, tokenId);

        require(_checkOnERC721Received(address(0), to, tokenId, data), "non-erc721 receiver");//nuyn stugumna ardyoq kara ynduni ed hascen
    }

//verevi safery stegh enq deligirovat anum
    function _mint(address to, uint tokenId) internal virtual {
        require(to != address(0), "zero address to"); //stugum enq 0-chi te che burn
        require(!_exists(tokenId), "this token id is already minted"); //pti chlini tenc ID arden

        _beforeTokenTransfer(address(0), to, tokenId);

        _owners[tokenId] = to; //asum enq tery to
        _balances[to]++; //1 token aveli uni balances

        emit Transfer(address(0), to, tokenId);

        _afterTokenTransfer(address(0), to, tokenId);
    }

//sa el varum enq 
    function burn(uint256 tokenId) public virtual {
        require(_isApprovedOrOwner(msg.sender, tokenId), "not owner!"); //ov uzum a vari irvunq uni kam terna kam operator

        _burn(tokenId); //slujebni
    }
//slujebni
    function _burn(uint tokenId) internal virtual {
        address owner = ownerOf(tokenId);

        _beforeTokenTransfer(owner, address(0), tokenId);//minchev varel karogha mi ban heto avelacnenq

        delete _tokenApprovals[tokenId]; //jnjum enq es sharqic
        _balances[owner]--; //balancy poqracnum enq 
        delete _owners[tokenId]; //ownersic hanum enq

        emit Transfer(owner, address(0), tokenId); 

        _afterTokenTransfer(owner, address(0), tokenId);//karogha mi ban avelacnenq vareluc heto
    }

   //ays base uri-y kam (ipfs://)123 kam (exam.com/nft/)123 pakagcerum eghac maserna, sa pti ustanavit ani en mardy vor konkret tokeny 
    function _baseURI() internal pure virtual returns(string memory) {
        return ""; //default datarky pti razrabochiky gri chisht prefiksy
    }

//funkcia vory cuyc a talis vortegh pti NFT gtnenq
    function tokenURI(uint tokenId) public view virtual _requireMinted(tokenId) returns(string memory) {
//veradardznum a hasarak togh
//ays base uri-y kam (ipfs://)123 kam (exam.com/nft/)123 pakagcerum eghac maserna, sa pti ustanavit ani en mardy vor konkret tokeny 
        string memory baseURI = _baseURI();

        return bytes(baseURI).length > 0 ?
            string(abi.encodePacked(baseURI, tokenId.toString())) : //es tostring yndunum a uint u string a sarqum
            ""; //ete prfiksi mec a 0-ic pti vercnenq u kcenq token ID-in string enq kpcnum, hakarak depqum prosto ankap datark tegh a veradardznum
    }

//slujebni funkcia ka token te che
    function _exists(uint tokenId) internal view returns(bool) {
        return _owners[tokenId] != address(0); //ete ter uni uremn ka
    }

//slujebni kara ardyoq es mardy NFT teghapoxi kam terna
    function _isApprovedOrOwner(address spender, uint tokenId) internal view returns(bool) {
        address owner = ownerOf(tokenId); //terna

        return(
            spender == owner ||
            isApprovedForAll(owner, spender) ||
            getApproved(tokenId) == spender
        );
    }

//nerqin funkcia kirarvac a verevum
    function _safeTransfer(
        address from,
        address to,
        uint tokenId,
        bytes memory data
    ) internal {
        _transfer(from, to, tokenId); //nuyn funkciana miayn tarberutyuny takinna

        require(
            _checkOnERC721Received(from, to, tokenId, data), //hesa kgrenq
            "transfer to non-erc721 receiver" //chistanum u chi karum
        ); //stugum enq ardyoq karogha es hascen unenal NFT te che, hakarak depqum het enq qashum, ardyoq ed smart contrakta u uni hamapatasxan funkcian
    }
//safe transferi hamar grvac slujebni proverka, nayum enq ova 
//poluchatela ete adresa apatrue, ete contra apa petqa chisht 
//patasxani mer zaprosin
    function _checkOnERC721Received(
        address from,
        address to,
        uint tokenId,
        bytes memory data
    ) private returns(bool) {
        if(to.code.length > 0) {//ete sxal lini sxaly kbrnenq
            try IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, data) returns(bytes4 retval) {
                return retval == IERC721Receiver.onERC721Received.selector; //stugum enq ardyoq retvaly havasar a aknkalvogh 4bytin, hatuk interface manaramsn grvaca hamapatasxa,
                //vereviny asmuma hetevyaly pordzum to hasceyov kachel onErc...ir argumentnerov ev aknkalum em vor kveradardzni 4byte ev da dnum em retval-i  mej
            } catch(bytes memory reason) { //ete chi stacvum, reasony verdarzi patcharna ete funkcia ka bayc chi yndunum u texta grel, ete chka urmen ayn zroya
                if(reason.length == 0) { //orinak stegh chuni stacoghy funkcia, ed depqum patchary chunenq
                    revert("Transfer to non-erc721 receiver"); //asum enq es
                } else {
                    assembly {//yul-y yndunum erku arg, vorteghic vortegh+-um enq arajin 32 bytum linelu a erkarutyan chapy, inch chi hetaqrqrum ayl texty, hishoghutyunic vercnum a henc
                        revert(add(32, reason), mload(reason)) //hakarak depqum yull ov patcharnenq talis inch stacel enq stacoghi patasxany
                    }
                }//atkat transfera sxali depqum u patcharna talis
            }
        } else {
            return true;
        }
    }
// slujebni 
    function _transfer(address from, address to, uint tokenId) internal {
        require(ownerOf(tokenId) == from, "incorrect owner!"); //vroteghuc trans enq anum terna
        require(to != address(0), "to address is zero!"); //zroyakan chi 

        _beforeTokenTransfer(from, to, tokenId); //slujebni datark funkcian yst anhrajeshtutyan karanq anenq inch vor operacianer araj 

        delete _tokenApprovals[tokenId]; 
//takiny bun perevodna
        _balances[from]--;  //ugharkoghi balansic dursa galis
        _balances[to]++; //stacoghin avelanum a
        _owners[tokenId] = to; //ownerum el tokenID poxvum a nor hasceyi anunov

        emit Transfer(from, to, tokenId); //sobitian grancum enq

        _afterTokenTransfer(from, to, tokenId); //slujebni datark funkcian yst anhrajeshtutyan karanq anenq inch vor operacianer  heto transferic
    }
//karanq mi qani operacia anenq minchev transfer inheritanatnerum karanq anenq
    function _beforeTokenTransfer(
        address from, address to, uint tokenId
    ) internal virtual {}
//karanq mi qani operacia anenq transferic heto virtuala karanq potomoknerum anenq
    function _afterTokenTransfer(
        address from, address to, uint tokenId
    ) internal virtual {}
}