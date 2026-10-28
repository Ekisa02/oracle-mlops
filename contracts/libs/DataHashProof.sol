// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

library DataHashProof {
    // A tiny helper to combine and compare data hashes & metadata fingerprints.
    struct Proof {
        bytes32 datasetHash; // keccak256 of canonical dataset (or IPFS CID hashed)
        bytes32 metadataHash; // keccak256 of metadata JSON schema
    }

    function buildProof(bytes32 datasetHash, bytes32 metadataHash) internal pure returns (Proof memory) {
        return Proof({datasetHash: datasetHash, metadataHash: metadataHash});
    }

    function equals(Proof memory a, Proof memory b) internal pure returns (bool) {
        return (a.datasetHash == b.datasetHash && a.metadataHash == b.metadataHash);
    }
}
