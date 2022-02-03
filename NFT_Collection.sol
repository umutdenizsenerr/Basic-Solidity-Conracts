// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "@openzeppelin/contracts@4.4.2/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts@4.4.2/security/Pausable.sol";
import "@openzeppelin/contracts@4.4.2/access/Ownable.sol";
import "@openzeppelin/contracts@4.4.2/utils/Counters.sol";

contract Universities is ERC721, Pausable, Ownable {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;

    uint mintFee = 0.02 ether;
    uint nonce = 1;
    mapping (address => uint) adressToRandom;
    mapping (uint => bool) indexUsedMap;

    constructor() ERC721("Universities", "UNI") {}
     function randomGenerate() public returns(uint){
        nonce++;
        uint randomNumber = uint(keccak256(abi.encodePacked(block.timestamp, msg.sender, nonce))) % 20;
        adressToRandom[msg.sender] = randomNumber;
        return randomNumber;
    }
     function viewrandomTokenId() public view returns(uint){
        return adressToRandom[msg.sender];
    }

    function _baseURI() internal pure override returns (string memory) {
        return "https://my-json-server.typicode.com/umutdenizsenerr/Calculator/tokens/";
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function buyNFT(address to) public payable {
        require(msg.value>=mintFee, "not enough ether sent");
        uint256 tokenId = randomGenerate();
        while(indexUsedMap[tokenId]){
            tokenId = randomGenerate();
        }
        indexUsedMap[tokenId] = true;
        _safeMint(to, tokenId);
    }
    function buyMultipleNFT(address to, uint amount) public payable {
        for(uint i = 0 ; i<amount; i++){
            buyNFT(to);
        }
    }
    function _beforeTokenTransfer(address from, address to, uint256 tokenId)
        internal
        whenNotPaused
        override
    {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    
}