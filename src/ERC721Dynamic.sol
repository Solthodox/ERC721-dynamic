// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";


contract ERC721DynamicSoulbound{
    error NonTransferible();
    using Counters for Counters.Counter;
    Counters.Counter private _idCounter;

    using Strings for uint256;

    uint256 public constant MINT_PRICE;


    struct NFTStorage{
        string name;
        string description;
        string imageIPFS;
        string certificates;
        string experience;
        uint256 creationDate;
    }

    mapping(uint256 => NFTStorage) private _tokensData;     

    constructor(string memory name, string memory symbol) ERC721(name,symbol){}


    function safeMint(string memory name, string memory description, string memory imageIPFS, string[] memory certificates, string[] memory education) external payable {
        require(msg.value >= MINT_PRICE, "msgvalue<price");
        _idCounter.increment();
        uint256 currentId = _idCounter.current();

        NFTStorage memory data = NFTStorage({
            name:name,
            description:description,
            imageIPFS : imageIPFS,
            creationData : bloc.timestamp;
        });
        _tokensData[currentId] = data;
        _safeMint(msg.sender, currentId);
    }

       
    function tokenURI(uint256 tokenId) public view  override returns (string memory) {
      NFTStorage memory data = _tokensData[tokenId];

      bytes memory tokenURI = abi.encodePacked(
        '{',
            '"name": "', data.name, '",",
            '"description": "', data.description, '",",
            '"image": "ipfs://', data.imageIPFS, '",",
            '"certificates": "', data.certificates, '",",
            '"experience": "', data.experience, '",",
            '"creationDate": "', data.creationDate.toString(), '",",
        '}'
      );

      return string(
        abi.encodePacked(
            "data:application/json;base64,",
            Base64.encodePacked(tokenURI)    
        )
      );

    }



    // override the transfer functions to make sure it cant be transferred
    
    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public virtual override {
        revert NonTransferible();
    }

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public virtual override {
        revert NonTransferible();
    }

   
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes memory data
    ) public virtual override {
        revert NonTransferible();
    }

}