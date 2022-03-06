// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.1;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";
import "../libraries/Base64.sol";
// import {Base64} from './libraries/Base64.sol';

contract MyEpicNFT is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIDs;

    // This is our SVG code. All we need to change is the word that's displayed. Everything else stays the same.
    // So, we make a baseSvg variable here that all our NFTs can use.
    string baseSvg =
        "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='black' /><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";

    // I create three arrays, each with their own theme of random words.
    // Pick some random funny words, names of anime characters, foods you like, whatever!
    string[] firstWords = [
        "Vladimir",
        "Joe",
        "Angela",
        "Volodymyr",
        "Tayyip",
        "Boris"
    ];
    string[] secondWords = [
        "Putin",
        "Biden",
        "Merkel",
        "Zelenskyy",
        "Erdogan",
        "Johnson"
    ];
    string[] thirdWords = [
        "RUSSIA",
        "US",
        "GERMAN",
        "UKRAINE",
        "TURKEY",
        "ENGLAND"
    ];

    constructor() ERC721("TestSigmaNFT", "TEST_SIGMA_NFT") {
        console.log("This is my NFT contract. Whoa!");
    }

    // I create a function to randomly pick a word from each array.
    function pickRandomFirstWord(uint256 tokenId)
        public
        view
        returns (string memory)
    {
        // I seed the random generator. More on this in the lesson.
        uint256 rand = random(
            string(abi.encodePacked("FIRST_WORD", Strings.toString(tokenId)))
        );
        // Squash the # between 0 and the length of the array to avoid going out of bounds.
        rand = rand % firstWords.length;
        return firstWords[rand];
    }

    function pickRandomSecondWord(uint256 tokenId)
        public
        view
        returns (string memory)
    {
        uint256 rand = random(
            string(abi.encodePacked("SECOND_WORD", Strings.toString(tokenId)))
        );
        rand = rand % secondWords.length;
        return secondWords[rand];
    }

    function pickRandomThirdWord(uint256 tokenId)
        public
        view
        returns (string memory)
    {
        uint256 rand = random(
            string(abi.encodePacked("THIRD_WORD", Strings.toString(tokenId)))
        );
        rand = rand % thirdWords.length;
        return thirdWords[rand];
    }

    function random(string memory input) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(input)));
    }

    // A function our user to get their NFT
    function makeAnEpicNFT() public { 
        uint256 newItemID = _tokenIDs.current();

        // We go and randomly grab one word from each of the three arrays.
        string memory first = pickRandomFirstWord(newItemID);
        string memory second = pickRandomSecondWord(newItemID);
        string memory third = pickRandomThirdWord(newItemID);
        string memory combinedWord = string(abi.encodePacked(first,second,third));

        // I concatenate it all together, and then close the <text> and <svg> tags.
        string memory finalSvg = string(
            abi.encodePacked(baseSvg, combinedWord, "</text></svg>")
        );

        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name" : "',
                        combinedWord,
                        '", "description": "World Warlord.", "image": "data:image/svg+xml;base64,',
                        Base64.encode(bytes(finalSvg)),
                        '"}'
                    )
                )
            )
        );

        // Just like before, we prepend data:application/json;base64, to our data.
        string memory finalTokenUri = string(
            abi.encodePacked("data:application/json;base64,", json)
        );

        console.log("\n--------------------");
        console.log(finalTokenUri);
        console.log("--------------------\n");

        _safeMint(msg.sender, newItemID);
    
        // Update your URI!!!
        _setTokenURI(newItemID, finalTokenUri);

        _tokenIDs.increment();
        console.log("An NFT w/ ID %s has been minted to %s", newItemID, msg.sender);
    }
}
