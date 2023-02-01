// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";


contract ERC721DynamicSoulbound is ERC721{
    error NonTransferible();
    using Counters for Counters.Counter;
    Counters.Counter private _idCounter;

    using Strings for uint256;

    uint256 public constant MINT_PRICE = 1 ether/100;


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


    function mint(string memory name, string memory description, string memory imageIPFS) external  payable returns(bool) {
        require(msg.value >= MINT_PRICE, "msgvalue<price");
        require(balanceOf(msg.sender)==0, "Caller already owns an NFT");
        _idCounter.increment();
        uint256 currentId = _idCounter.current();

        NFTStorage memory data = NFTStorage({
            name:name,
            description:description,
            imageIPFS : imageIPFS,
            certificates : "",
            experience : "",
            creationDate : block.timestamp
        });
        _tokensData[currentId] = data;
        _mint(msg.sender, currentId);
        return true;
    }

       
    function tokenURI(uint256 tokenId) public view  override returns (string memory) {
      NFTStorage memory data = _tokensData[tokenId];

      bytes memory tokenURI = abi.encodePacked(
        '{',
            '"name": "', data.name, '",',
            '"description": "', data.description, '",',
            '"image": "ipfs://', data.imageIPFS, '",',
            '"certificates": [', data.certificates, '],',
            '"experience": [', data.experience, '],',
            '"creationDate": "', data.creationDate.toString(), '",',
        '}'
      );

      return string(
        abi.encodePacked(
            "data:application/json;base64,",
            Base64.encode(tokenURI)    
        )
      );

    }


    function addCertificate(uint256 tokenId, string memory data) external{
        require(ownerOf(tokenId)==msg.sender, "You dont own this token");
        string memory str = string.concat('{',data, '},' );
        _tokensData[tokenId].certificates = string.concat(_tokensData[tokenId].experience, str);

    }

    function addExperience(uint256 tokenId, string memory data) external{
        require(ownerOf(tokenId)==msg.sender, "You dont own this token");
        string memory str = string.concat('{',data, '},' );
        _tokensData[tokenId].experience = string.concat(_tokensData[tokenId].experience, str);
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