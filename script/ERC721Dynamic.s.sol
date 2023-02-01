// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
import "forge-std/Vm.sol";
import "../src/ERC721Dynamic.sol";
import "forge-std/Script.sol";

contract ConsoleScript is Script {
    ERC721DynamicSoulbound public nft;
    string public constant mintSelector = 'mint(string,string,string)';
    function setUp() public {
        nft = new ERC721DynamicSoulbound("Developers Soulbounds", "DS");
    }

    function run() public {
        vm.startBroadcast();
        uint256 mintPrice = nft.MINT_PRICE();
        address(nft).call{value:mintPrice}
            (abi.encodeWithSignature(mintSelector,"Vitalik Buterin", 'Co-founder of Ethereum', 'imageurl'));
        
        nft.addCertificate(1, '"name": "JS Bootcamp", "url":"certificateurl"' );
        nft.addCertificate(1, '"name": "Rust Crach Course", "url":"certificateurl"' );
        nft.addExperience(1, '"name": "Blockchain developer ", "url":"linkedin"' );
        nft.addExperience(1, '"name": "Co-founder", "url":"linkedin"' );
        console.log(nft.tokenURI(1));
    }
}
