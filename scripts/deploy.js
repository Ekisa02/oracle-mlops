const hre = require("hardhat");

async function main() {
  const [deployer] = await hre.ethers.getSigners();
  console.log("Deploying with", deployer.address);

  const ModelNFT = await hre.ethers.getContractFactory("ModelNFT");
  const nft = await ModelNFT.deploy("ModelToken", "MOD", deployer.address);
  await nft.deployed();
  console.log("ModelNFT deployed to:", nft.address);

  const ModelRegistry = await hre.ethers.getContractFactory("ModelRegistry");
  const registry = await ModelRegistry.deploy(nft.address, deployer.address);
  await registry.deployed();
  console.log("ModelRegistry deployed to:", registry.address);

  // Grant registry the MINTER_ROLE on the NFT contract so registry can mint tokens
  const MINTER_ROLE = hre.ethers.utils.keccak256(hre.ethers.utils.toUtf8Bytes("MINTER_ROLE"));
  const tx = await nft.grantRole(MINTER_ROLE, registry.address);
  await tx.wait();
  console.log("Granted MINTER_ROLE to registry");

  const IncentivePool = await hre.ethers.getContractFactory("IncentivePool");
  const pool = await IncentivePool.deploy();
  await pool.deployed();
  console.log("IncentivePool deployed to:", pool.address);

  console.log("Deployment complete.");
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
