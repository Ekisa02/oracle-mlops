// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "./interfaces/IModelNFT.sol";
import "./libs/DataHashProof.sol";

contract ModelRegistry is AccessControl {
    using DataHashProof for DataHashProof.Proof;

    bytes32 public constant REGISTRAR_ROLE = keccak256("REGISTRAR_ROLE");

    IModelNFT public immutable modelNFT;

    uint256 private _nextModelId = 1;

    struct ModelEntry {
        uint256 id;
        address owner;
        string ipfsCid; // pointer to model weights/metadata (IPFS CID or other)
        DataHashProof.Proof proof;
        uint256 nftId; // linked NFT id, 0 if not minted
        uint256 timestamp;
    }

    mapping(uint256 => ModelEntry) private _models;

    event ModelRegistered(uint256 indexed modelId, address indexed owner, string ipfsCid);
    event ModelNFTLinked(uint256 indexed modelId, uint256 indexed nftId, address indexed owner);

    constructor(address nftAddress, address admin) {
        require(nftAddress != address(0), "ModelRegistry: zero nft address");
        modelNFT = IModelNFT(nftAddress);
        _setupRole(DEFAULT_ADMIN_ROLE, admin);
        _setupRole(REGISTRAR_ROLE, admin);
    }

    function registerModel(address owner, string calldata ipfsCid, bytes32 datasetHash, bytes32 metadataHash) external onlyRole(REGISTRAR_ROLE) returns (uint256) {
        uint256 modelId = _nextModelId++;
        DataHashProof.Proof memory p = DataHashProof.buildProof(datasetHash, metadataHash);

        _models[modelId] = ModelEntry({
            id: modelId,
            owner: owner,
            ipfsCid: ipfsCid,
            proof: p,
            nftId: 0,
            timestamp: block.timestamp
        });

        emit ModelRegistered(modelId, owner, ipfsCid);
        return modelId;
    }

    function linkNFT(uint256 modelId, uint256 nftId, string calldata tokenURI) external onlyRole(REGISTRAR_ROLE) {
        ModelEntry storage m = _models[modelId];
        require(m.id != 0, "ModelRegistry: model not found");
        require(m.nftId == 0, "ModelRegistry: NFT already linked");

        // Mint NFT via the modelNFT contract; registry must have MINTER_ROLE on NFT contract
        modelNFT.mint(m.owner, nftId, tokenURI);
        m.nftId = nftId;

        emit ModelNFTLinked(modelId, nftId, m.owner);
    }

    function getModel(uint256 modelId) external view returns (ModelEntry memory) {
        require(_models[modelId].id != 0, "ModelRegistry: model not found");
        return _models[modelId];
    }

    function verifyDataset(uint256 modelId, bytes32 datasetHash, bytes32 metadataHash) external view returns (bool) {
        ModelEntry storage m = _models[modelId];
        require(m.id != 0, "ModelRegistry: model not found");
        DataHashProof.Proof memory provided = DataHashProof.buildProof(datasetHash, metadataHash);
        return m.proof.equals(provided);
    }
}
