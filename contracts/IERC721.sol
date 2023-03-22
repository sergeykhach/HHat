//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC721 {
    event Transfer(address indexed from, address indexed to, uint indexed tokenId); //poxancman tvyalneri sob
    event Approval(address indexed owner, address indexed approved, uint indexed tokenId);  //tuyl aenq talis inch vor mekin im NFT mer ghekavari xanut
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved); // tuyl enq talis inch vor mekin ghekavarel mer sagh NFTnery xanut

// inchqan NFT ka es mardu balancin
    function balanceOf(address owner) external view returns(uint);

// ov a es tokeny tery
    function ownerOf(uint tokenId) external view returns(address);

    // function safeTransferFrom( //stegh tarber qanaki argumentner ov kareli nuyn anun dnel
    //     address from,
    //     address to,
    //     uint tokenId
    // ) external;

//aveli bezapasni transfer 
    function safeTransferFrom(
        address from,
        address to,
        uint tokenId,
        bytes calldata data
    ) external;

//aveli qich anvtag transfor
    function transferFrom(
        address from,
        address to,
        uint tokenId
    ) external;

// mihat tokenkara ogtagorci tuyl enq talis
    function approve(
        address to,
        uint tokenId
    ) external;

//tuyl enq talis mer sagh tokennery karavari
    function setApprovalForAll(
        address operator,
        bool approved
    ) external;

//harcnum enq es token id ov kara rasparijat ani
    function getApproved(
        uint tokenId
    ) external view returns(address);

//ardyoq ays hascen kara es mardu tokeennerov rasparijani ani
    function isApprovedForAll(
        address owner,
        address operator
    ) external view returns(bool);
}
