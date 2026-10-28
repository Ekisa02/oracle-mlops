const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("ModelRegistry + ModelNFT integration", function () {
  let nft, registry, deployer, alice;

  beforeEach(async function () {
    [deployer, alice] = await ethers.getSigners();

    const NFT = await ethers.getContractFactory("ModelNFT");
    nft = await NFT.deploy("ModelToken", "MOD", deployer.address);
    await nft.deployed();

    const Registry = await ethers.getContractFactory("ModelRegistry");
    registry = await Registry.deploy(nft.address, deployer.address);
    await registry.deployed();

    const MINTER_ROLE = ethers.utils.keccak256(ethers.utils.toUtf8Bytes("MINTER_ROLE"));
    await nft.grantRole(MINTER_ROLE, registry.address);
  });

  it("should register a model and mint an NFT linked to it", async function () {
    const datasetHash = ethers.utils.keccak256(ethers.utils.toUtf8Bytes("datasetx"));
    const metadataHash = ethers.utils.keccak256(ethers.utils.toUtf8Bytes("metadatax"));

    // register model
    const tx = await registry.registerModel(alice.address, "ipfs://cid123", datasetHash, metadataHash);
    const r = await tx.wait();
    const modelIdEvent = r.events?.find(e => e.event === 'ModelRegistered');
    expect(modelIdEvent).to.not.be.undefined;

    // model id should be 1
    const modelId = 1;
    const entry = await registry.getModel(modelId);
    expect(entry.owner).to.equal(alice.address);
    expect(entry.ipfsCid).to.equal("ipfs://cid123");

    // link NFT
    await registry.linkNFT(modelId, 1001, "https://metadata.example/1001.json");

    const updated = await registry.getModel(modelId);
    expect(updated.nftId).to.equal(1001);

    // check NFT owner
    expect(await nft.ownerOf(1001)).to.equal(alice.address);

    // verify dataset equals
    const ok = await registry.verifyDataset(modelId, datasetHash, metadataHash);
    expect(ok).to.be.true;
  });
});
