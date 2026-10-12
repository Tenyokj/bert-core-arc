import { expect, hre } from "../setup.js";

describe("V3.1 CommunityTreasuryDeployer", function () {
  it("creates a Treasury whose Factory and global reserve are immutable", async function () {
    const { ethers } = await hre.network.connect();
    const [factory, outsider] = await ethers.getSigners();
    const token = await (await ethers.getContractFactory("MockUSDC", factory)).deploy();
    const reserve = await (
      await ethers.getContractFactory("MockV3GlobalBertReserve", factory)
    ).deploy(await token.getAddress());
    const deployer = await (await ethers.getContractFactory("CommunityTreasuryDeployer", factory)).deploy();

    const treasuryAddress = await deployer.deployCommunityTreasury.staticCall(
      await token.getAddress(),
      await reserve.getAddress(),
      factory.address,
    );
    await deployer.deployCommunityTreasury(await token.getAddress(), await reserve.getAddress(), factory.address);
    const treasury = await ethers.getContractAt("CommunityTreasury", treasuryAddress, factory);

    expect(await treasury.factory()).to.equal(factory.address);
    expect(await treasury.globalBertReserve()).to.equal(await reserve.getAddress());
    await expect(treasury.connect(outsider).setCommunityHub(outsider.address))
      .to.be.revertedWithCustomError(treasury, "NotCommunityFactory");
  });
});
