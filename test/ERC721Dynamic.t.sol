// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
import "forge-std/Test.sol";
import "forge-std/Vm.sol";
import "../src/ERC721Dynamic.sol";

contract ERC721DynamicTestt is Test {
    ERC721DynamicSoulbound public nft;
    string public constant mintSelector = 'mint(string,string,string)';
    string public constant addCertSelector = 'addCertificate(uint256,string)';
    string public constant addExperience = 'addCertificate(uint256,string)';
    
    function setUp() public {
        nft = new ERC721DynamicSoulbound("Developers Soulbounds", "DS");
    }

    function testMint( string memory name , uint256 msgValue) public payable{
        uint256 mintPrice = nft.MINT_PRICE();
        vm.assume(bytes(name).length < 10); 
        vm.assume(msgValue < mintPrice);
        (bool correctTransactionOutput, ) = address(nft).call{value:mintPrice}
            (abi.encodeWithSignature(mintSelector,name, 'description example', 'imageurl'));

        (bool wrongTransactionOutput, ) = address(nft).call(abi.encodeWithSignature(mintSelector,name, 'description example', 'imageurl'));
        assertTrue(correctTransactionOutput, "minted correctly: call did not revert"); // should pass when sending the correct msg.value
        assertFalse(wrongTransactionOutput, "not minted : call reverted"); // should fail else
        assertEq(nft.balanceOf(address(this)),1);
        assertEq(nft.ownerOf(1), address(this));

        (bool correctTransactionRepeatOutput, ) = address(nft).call{value:mintPrice}
            (abi.encodeWithSignature(mintSelector,name, 'description example', 'imageurl'));

        assertFalse(correctTransactionRepeatOutput, "Should not be able to mint again ");
    }

    function testAddCertificateOrExperience(string memory input) public {
         uint256 mintPrice = nft.MINT_PRICE();
        vm.assume(bytes(input).length < 20);
        (bool success, ) = address(nft).call{value:mintPrice}
            (abi.encodeWithSignature(mintSelector,"Gavin Woods", 'description example', 'imageurl'));
        assertTrue(success, "SHould mint");
        (bool correctTransactionOutput, ) = address(nft).call(abi.encodeWithSignature(addCertSelector,1,'"name": "JS Bootcamp", "url":"certificateurl"' ));
        assertTrue(correctTransactionOutput, "Should be able to add a certificate");

    }

    


    
    

}
