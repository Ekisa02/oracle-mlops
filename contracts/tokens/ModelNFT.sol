// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract ModelNFT is ERC721, AccessControl {
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    mapping(uint256 => string) private _tokenURIs;

    constructor(string memory name_, string memory symbol_, address admin) ERC721(name_, symbol_) {
        _setupRole(DEFAULT_ADMIN_ROLE, admin);
    }

    function mint(address to, uint256 tokenId, string calldata tokenURI_) external onlyRole(MINTER_ROLE) {
        _safeMint(to, tokenId);
        _tokenURIs[tokenId] = tokenURI_;
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        require(_exists(tokenId), "ModelNFT: URI query for nonexistent token");
        return _tokenURIs[tokenId];
    }
}
