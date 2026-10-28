// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

interface IModelNFT {
    function mint(address to, uint256 tokenId, string calldata tokenURI) external;
}
