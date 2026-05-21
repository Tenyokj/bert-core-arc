/**
 * @file upgrade-proxy.ts
 * @notice Upgrades a single TransparentUpgradeableProxy via its ProxyAdmin.
 * @dev Uses OZ v5 ProxyAdmin.upgradeAndCall. Reads admin from EIP-1967 slot if not provided.
 * @dev Run with: npx hardhat run scripts/upgrade-proxy.ts --network localhost
 */
import { createRequire } from "module";
import { hre, type HardhatEthers } from "../../test/setup.js";

const require = createRequire(import.meta.url);
const proxyAdminArtifact = require(
  "@openzeppelin/contracts/build/contracts/ProxyAdmin.json"
);
const transparentProxyArtifact = require(
  "@openzeppelin/contracts/build/contracts/TransparentUpgradeableProxy.json"
);

// Вспомогательные функции
function getArg(flag: string): string | undefined {
  const idx = process.argv.indexOf(flag);
  if (idx === -1) return undefined;
  return process.argv[idx + 1];
}

function parseArgs() {
  /**
   * @notice Parse CLI args and env vars for upgrade settings.
   * @return Parsed args (proxy, impl, optional admin/call/args/gas)
   */
  const proxyAdminAddress = getArg("--proxyAdmin") || process.env.PROXY_ADMIN;
  const proxyAddress = getArg("--proxy") || process.env.PROXY;
  const implName = getArg("--impl") || process.env.IMPL;
  const call = getArg("--call") || process.env.CALL;
  const rawArgs = getArg("--args") || process.env.ARGS;
  const gasLimit = getArg("--gas") || process.env.GAS_LIMIT;

  if (!proxyAddress || !implName) {
    console.error(`
🚀 Usage: npx hardhat run scripts/upgrade-proxy.ts --network <network> -- [OPTIONS]

Required:
  --proxy <address>         Proxy contract address to upgrade
  --impl <ContractName>     Name of new implementation contract

Optional:
  --call <functionSig>      Function to call after upgrade (e.g., "postUpgradeSync")
  --args <jsonArray>        Arguments for the call (e.g., "[42, \\"newValue\\"]")
  --gas <number>           Gas limit for the transaction

Environment variables (fallback):
  PROXY_ADMIN, PROXY, IMPL, CALL, ARGS, GAS_LIMIT

Example:
  npx hardhat run scripts/upgrade-proxy.ts --network localhost -- \\
    --proxyAdmin 0x5FbDB2315678afecb367f032d93F642f64180aa3 \\
    --proxy 0x9A676e781A523b5d0C0e43731313A708CB607508 \\
    --impl MockVotingSystemV2 \\
    --call "postUpgradeSync" \\
    --args "[42]" \\
    --gas 500000
`);
    process.exit(1);
  }

  return {
    proxyAdminAddress,
    proxyAddress,
    implName,
    call,
    args: rawArgs ? JSON.parse(rawArgs) : [],
    gasLimit: gasLimit ? BigInt(gasLimit) : undefined,
  };
}

async function verifyProxyStructure(
  ethers: HardhatEthers,
  proxyAddress: string,
  expectedProxyAdmin?: string
) {
  /**
   * @notice Reads EIP-1967 admin/implementation slots for a proxy.
   * @param ethers Hardhat ethers instance
   * @param proxyAddress Proxy address
   * @param expectedProxyAdmin Optional expected admin address
   */
  console.log("🔍 Verifying proxy structure...");

  // Слоты EIP-1967
  const ADMIN_SLOT = ethers.keccak256(ethers.toUtf8Bytes("eip1967.proxy.admin"));
  const IMPL_SLOT = ethers.keccak256(ethers.toUtf8Bytes("eip1967.proxy.implementation"));

  const adminSlot = ethers.toBeHex(BigInt(ADMIN_SLOT) - 1n);
  const implSlot = ethers.toBeHex(BigInt(IMPL_SLOT) - 1n);

  try {
    const [adminStorage, implStorage] = await Promise.all([
      ethers.provider.getStorage(proxyAddress, adminSlot),
      ethers.provider.getStorage(proxyAddress, implSlot),
    ]);

    const adminFromSlot = ethers.getAddress(ethers.dataSlice(adminStorage, 12));
    const implFromSlot = ethers.getAddress(ethers.dataSlice(implStorage, 12));

    console.log(`📊 Proxy admin from slot: ${adminFromSlot}`);
    console.log(`📊 Current implementation: ${implFromSlot}`);
    if (expectedProxyAdmin) {
      console.log(`🎯 Expected admin: ${expectedProxyAdmin}`);
    }

    const isAdminValid = expectedProxyAdmin
      ? ethers.getAddress(adminFromSlot) === ethers.getAddress(expectedProxyAdmin)
      : true;

    if (!isAdminValid) {
      console.warn("⚠️  WARNING: Proxy admin slot doesn't match provided ProxyAdmin address!");
      console.warn("   This might indicate:");
      console.warn("   1. Wrong ProxyAdmin address provided");
      console.warn("   2. Proxy is not a TransparentUpgradeableProxy");
      console.warn("   3. Proxy was initialized with different admin");
    }

    return {
      adminFromSlot,
      implFromSlot,
      isAdminValid,
    };
  } catch (error) {
    console.error("❌ Failed to read proxy storage slots:", error);
    throw error;
  }
}

async function main() {
  /**
   * @notice Deploys new implementation and upgrades proxy via ProxyAdmin.
   * @dev Requires proxy + impl name; proxyAdmin optional (auto-detected).
   */
  const args = parseArgs();
  
  const connection = await hre.network.connect();
  const { ethers } = connection;
  const { network } = hre;
  const [deployer] = await ethers.getSigners();

  let networkName = "unknown";

  try {
    const network = await ethers.provider.getNetwork();
    networkName = network.name;
    if (networkName === "unknown" && network.chainId) {
      networkName = `chain-${network.chainId}`;
    }
  } catch (e2) {
    const networkArgIndex = process.argv.indexOf("--network");
    if (networkArgIndex !== -1 && process.argv[networkArgIndex + 1]) {
      networkName = process.argv[networkArgIndex + 1];
    }
  }

  console.log("🚀 Starting proxy upgrade");
  console.log("=========================");
  console.log(`Network: ${networkName}`);
  console.log(`Deployer: ${deployer.address}`);
  console.log(`Proxy: ${args.proxyAddress}`);
  if (args.proxyAdminAddress) {
    console.log(`ProxyAdmin (provided): ${args.proxyAdminAddress}`);
  }
  console.log(`New implementation: ${args.implName}`);
  if (args.call) {
    console.log(`Post-upgrade call: ${args.call}(${args.args.join(", ")})`);
  }
  console.log("");

  // 1. Проверяем структуру прокси
  const { adminFromSlot, isAdminValid, implFromSlot } =
    await verifyProxyStructure(
      ethers,
      args.proxyAddress,
      args.proxyAdminAddress
    );

  // 2. Получаем ProxyAdmin контракт
  console.log("\n🔗 Connecting to ProxyAdmin...");
  const effectiveProxyAdmin = args.proxyAdminAddress && isAdminValid
    ? args.proxyAdminAddress
    : adminFromSlot;
  if (args.proxyAdminAddress && !isAdminValid) {
    console.warn(
      `⚠️  Using proxy admin from slot instead: ${effectiveProxyAdmin}`
    );
  }
  const proxyAdmin = new ethers.Contract(
    effectiveProxyAdmin,
    proxyAdminArtifact.abi,
    deployer
  );

  // Проверяем права
  try {
    const owner = await proxyAdmin.owner();
    const isOwner = ethers.getAddress(owner) === ethers.getAddress(deployer.address);
    
    console.log(`👑 ProxyAdmin owner: ${owner}`);
    console.log(`   Deployer is owner: ${isOwner ? "✅" : "❌"}`);

    if (!isOwner) {
      console.error("❌ ERROR: Deployer is not the owner of ProxyAdmin!");
      console.error("   Upgrade will fail. Transfer ownership or use correct signer.");
      process.exit(1);
    }
  } catch (error) {
    console.error("❌ Failed to get ProxyAdmin owner:", error);
    process.exit(1);
  }

  // 3. Деплоим новую имплементацию
  console.log("\n📦 Deploying new implementation...");
  const implFactory = await ethers.getContractFactory(args.implName, deployer);
  const newImpl = await implFactory.deploy();
  await newImpl.waitForDeployment();
  const newImplAddress = await newImpl.getAddress();
  console.log(`✅ New implementation deployed at: ${newImplAddress}`);

  // 4. Подготавливаем данные для вызова (если нужно)
  let callData = "0x";
  if (args.call) {
    try {
      callData = implFactory.interface.encodeFunctionData(args.call, args.args);
      console.log(`📞 Encoded call data for ${args.call}: ${callData.slice(0, 100)}...`);
    } catch (error: any) {
      console.error(`❌ Failed to encode function call ${args.call}:`, error.message);
      console.error("   Check function signature and arguments");
      process.exit(1);
    }
  }

  // 5. Выполняем апгрейд
  console.log("\n⚡ Executing upgrade...");
  
  const txOptions: any = {};
  if (args.gasLimit) {
    txOptions.gasLimit = args.gasLimit;
    console.log(`⛽ Using gas limit: ${args.gasLimit}`);
  }

    let tx: any = null;

  try {
    let tx;
    if (args.call && callData !== "0x") {
      console.log("🔄 Upgrading and calling...");
      tx = await proxyAdmin.upgradeAndCall(
        args.proxyAddress,
        newImplAddress,
        callData,
        txOptions
      );
    } else {
      console.log("🔄 Upgrading...");
      tx = await proxyAdmin.upgradeAndCall(
        args.proxyAddress,
        newImplAddress,
        "0x",
        txOptions
      );
    }

    console.log(`⏳ Transaction sent: ${tx.hash}`);
    console.log("   Waiting for confirmation...");

    const receipt = await tx.wait();
    console.log(`✅ Transaction confirmed in block ${receipt?.blockNumber}`);
    console.log(`   Gas used: ${receipt?.gasUsed?.toString()}`);

  } catch (error: any) {
    console.error("\n❌ Upgrade failed!");
    console.error("Error:", error.message || error);
    
    if (error.transactionHash) {
      console.error(`Transaction hash: ${error.transactionHash}`);
      
      // Пробуем декодировать ошибку
      if (error.data) {
        try {
          const decodedError = implFactory.interface.parseError(error.data);
          console.error("Decoded error:", decodedError?.name);
        } catch {
          // Не удалось декодировать
        }
      }
    }
    
    if (error.code === "CALL_EXCEPTION") {
      console.error("\n💡 Tips for CALL_EXCEPTION:");
      console.error("1. Check if the function exists in the new implementation");
      console.error("2. Verify argument types match the function signature");
      console.error("3. Ensure the function is not restricted (e.g., by initializer)");
    }
    
    process.exit(1);
  }

  // 6. Проверяем результат
  console.log("\n🔍 Verifying upgrade result...");
  
  const IMPL_SLOT = ethers.keccak256(ethers.toUtf8Bytes("eip1967.proxy.implementation"));
  const implSlot = ethers.toBeHex(BigInt(IMPL_SLOT) - 1n);
  
  const currentImplStorage = await ethers.provider.getStorage(args.proxyAddress, implSlot);
  const currentImplAddress = ethers.getAddress(ethers.dataSlice(currentImplStorage, 12));
  
  console.log(`📊 Old implementation: ${implFromSlot}`);
  console.log(`📊 New implementation: ${currentImplAddress}`);
  console.log(`🎯 Target implementation: ${newImplAddress}`);
  
  const upgradeSuccessful = ethers.getAddress(currentImplAddress) === ethers.getAddress(newImplAddress);
  
  if (upgradeSuccessful) {
    console.log("\n🎉 UPGRADE SUCCESSFUL!");
    console.log("=====================");
    console.log(`Proxy: ${args.proxyAddress}`);
    console.log(`New implementation: ${newImplAddress}`);
    console.log(`Network: ${networkName}`);
    console.log(`Transaction: ${tx?.hash}`);
    
    // Если был вызов функции, проверяем её выполнение
    if (args.call) {
      console.log(`\n📞 Post-upgrade call executed: ${args.call}(${args.args.join(", ")})`);
      
      try {
        // Пробуем проверить, что функция была вызвана успешно
        const proxyContract = new ethers.Contract(
          args.proxyAddress,
          implFactory.interface,
          deployer
        );
        
        if (implFactory.interface.getFunction(args.call)) {
          console.log(`✅ Function ${args.call} is available on the upgraded proxy`);
        }
      } catch (error) {
        // Игнорируем ошибки проверки
      }
    }
  } else {
    console.error("\n❌ UPGRADE FAILED!");
    console.error("Implementation address didn't change");
    process.exit(1);
  }

  // 7. Сохраняем информацию об апгрейде (опционально)
  console.log("\n💾 Upgrade summary:");
  console.log(JSON.stringify({
    timestamp: new Date().toISOString(),
    network: networkName,
    proxy: args.proxyAddress,
    oldImplementation: implFromSlot,
    newImplementation: newImplAddress,
    proxyAdmin: args.proxyAdminAddress,
    deployer: deployer.address,
    postUpgradeCall: args.call || null,
    callArgs: args.args || [],
    transactionHash: tx?.hash,
  }, null, 2));
}

main().catch((error) => {
  console.error("\n💥 Script execution failed:");
  console.error(error);
  process.exit(1);
});
