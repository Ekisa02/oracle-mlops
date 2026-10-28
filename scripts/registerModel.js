const hre = require("hardhat");

async function main() {
  const [deployer] = await hre.ethers.getSigners();
  const registryAddress = process.env.REGISTRY || "";
  if (!registryAddress) {
    console.error("Provide REGISTRY env var pointing to deployed registry contract");
    return;
  }

  const ModelRegistry = await hre.ethers.getContractFactory("ModelRegistry");
  const registry = ModelRegistry.attach(registryAddress);

  // Example: dataset hash & metadata hash computed off-chain (keccak256 of canonical bytes)
  const datasetHash = hre.ethers.utils.keccak256(hre.ethers.utils.toUtf8Bytes("dataset-v1-cid-or-hash"));
  const metadataHash = hre.ethers.utils.keccak256(hre.ethers.utils.toUtf8Bytes(JSON.stringify({framework: "PyTorch", arch: "ResNet50"})));

  const tx = await registry.registerModel(deployer.address, "ipfs://bafybeie...example", datasetHash, metadataHash);
  const receipt = await tx.wait();
  console.log("registerModel tx hash:", receipt.transactionHash);
}

main().catch((err) => {
  console.error(err);
  process.exit(1);
});
