// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

contract MyEpicNFT is ERC721URIStorage{
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIDs;

    constructor() ERC721 ("TestSigmaNFT", "TEST_SIGMA_NFT") {
        console.log("This is my NFT contract. Whoa!");
    }

    // A function our user to get their NFT
    function makeAnEpicNFT() public {
        // Get Current tokenID. start from 0
        uint256 newItemID = _tokenIDs.current();

        // Safemint
        _safeMint(msg.sender , newItemID);

        // Set the NFTs Data
        _setTokenURI(newItemID, "https://jsonkeeper.com/b/C448");
        console.log("An NFT w/ ID %s has been minted to %s", newItemID, msg.sender);
        // Increment the counter for when the next NFT is minted
        _tokenIDs.increment();
    }
}