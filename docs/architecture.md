# Architecture Overview

Oracle MLOps is designed as a minimal but extensible on-chain substrate for MLOps workflows that require tamper-evident provenance and tokenized model artifacts.

Core components

- ModelRegistry
  - Purpose: Canonical on-chain registry of model artifacts that stores an IPFS CID (or other immutable pointer) together with a dataset hash & metadata fingerprint.
  - Roles: REGISTRAR_ROLE to control registrations. The contract stores lightweight proofs (keccak256 hashes) that link off-chain artifacts to an on-chain identifier.

- ModelNFT (ERC-721)
  - Purpose: Tokenize model versions to represent ownership, licensing, and transferability of model artifacts.
  - Minting: Only authorized minters (the registry) can mint, ensuring tokens are backed by on-chain registry entries.

- IncentivePool
  - Purpose: Hold funds and distribute rewards to validators/auditors that perform checks (example: dataset validation, fairness/audit reporting).

Design patterns
- Role-based access control (OpenZeppelin AccessControl) for separation of duties.
- Minimal on-chain storage: store cryptographic hashes and pointers (IPFS CIDs) rather than large binary blobs.
- Off-chain canonicalization: before registering, datasets and metadata should be canonicalized and hashed off-chain in a deterministic manner.

Integration with ML pipelines
1. Off-chain CI/ML training computes canonical dataset hash and model artifact IPFS CID.
2. The CI system calls ModelRegistry.registerModel with the computed hashes and owner.
3. Optionally, the registry mints a ModelNFT to represent the version.
4. Validators can be remunerated from IncentivePool when they attest to dataset/model properties.

Security & privacy
- Confidential models/datasets should not be uploaded on-chain; the chain stores only non-reversible fingerprints and immutable pointers.
- Sensitive IP should be handled via access-controlled storage; use zk or secure enclaves for sensitive proofs if necessary.

Extensibility
- Add oracle feeds (e.g., Chainlink) to anchor model performance metrics.
- Add on-chain registrable attestations (signed proofs) from validators.
- Integrate on-chain license logic to govern model usage.
