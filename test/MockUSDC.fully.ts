/**
 * @file MockUSDC.fully.ts
 * @notice Minimal tests for the 6-decimal USDC mock.
 */

import { expect } from "./setup.js";
import { getConnection } from "./helpers.js";

describe("MockUSDC", function () {
  it("uses 6 decimals and supports minting", async function () {
    const { ethers } = await getConnection();
    const [admin, user1] = await ethers.getSigners();

    const usdc = await (await ethers.getContractFactory("MockUSDC", admin)).deploy();
    await usdc.waitForDeployment();

    expect(await usdc.decimals()).to.equal(6);

    await usdc.mint(user1.address, 1234567n);
    expect(await usdc.balanceOf(user1.address)).to.equal(1234567n);
  });
});
