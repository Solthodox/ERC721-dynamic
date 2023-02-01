# ERC721Dynamic

ERC721Dynamic allows user to : 
  - Fetch the whole metadata from chain
  - Dynamically change this metadata
 Thanks to OpenZeppelin's Base64 library, we can compute the metadata JSON object, and encode it to Base64. Then, the contract will return the encoded JSON,
 and with the browser, user will be able to read what's in the metadata.

## Use case
For this example it has been used to build a NFT soulbound token contract. Soulbound tokens are unique tokens, each linked to an account, just like NFTs, and they can store metadata in them. But ther's
one big difference : soulbound tokens can't be transferred. The idea of soulbound tokens is being able to have some kind of resume stored on blockchain.

## Getting started
After cloning the repo and installing the dependencies , run : 

```bash
forge script "ConsoleScript.sol"
```
