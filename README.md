# Oracle MLOps

Oracle MLOps is a modular, on-chain Machine Learning Operations (MLOps) framework that provides verifiable model and dataset provenance, tokenized model versions (NFTs), and an incentive pool for validator rewards. Built with Solidity, Hardhat, and OpenZeppelin, the project demonstrates a production-oriented architecture to integrate blockchain guarantees into ML lifecycle management.

Key features
- ModelRegistry: register models, link immutable dataset hashes and metadata.
- ModelNFT: tokenized model versions (ERC-721) to represent model ownership and provenance.
- DataHashProof: small library and utilities for dataset hash proofs and attestations.
- IncentivePool: fund and distribute rewards to validators/auditors.

Repository architecture
- contracts/: Solidity smart contracts (modular and role-based).
  - tokens/: ERC-721 NFT contract representing model versions.
  - interfaces/: interface abstractions for inter-contract composability.
  - libs/: small libraries and shared structs.
- scripts/: deployment and utility scripts (Node.js + Hardhat).
- test/: automated tests using Hardhat (Mocha + Chai + Ethers).
- docs/: architecture and design notes.

Quickstart

Requirements
- Node.js >= 16
- npm or yarn

Installation
1. Clone the repository
   git clone <repo>
   cd oracle-mlops

2. Install dependencies
   npm install

3. Run tests (local Hardhat network)
   npm test

4. Deploy to local network
   npx hardhat node
   node scripts/deploy.js --network localhost

Usage examples
- Register a model (example script): scripts/registerModel.js
- Query model metadata: call ModelRegistry.getModel(modelId)
- Minted ModelNFTs prove ownership and link back to registry entries.

Security & Notes
- Contracts use OpenZeppelin primitives (AccessControl, ERC721).
- This repository is a reference architecture; do security audits before production deployment.

Further reading
See docs/architecture.md for design rationale, data flows, and integration patterns with off-chain ML tooling.
