import type { HardhatUserConfig } from "hardhat/config";
import base from "./hardhat.config.js";

// EDR emulation only: this is not evidence of Arc's actual hardfork history or precompiles.
const config: HardhatUserConfig = {
  ...base,
  chainDescriptors: {
    ...base.chainDescriptors,
    5042002: {
      name: "Arc Testnet - local Prague EVM emulation only",
      chainType: "generic",
      hardforkHistory: { prague: { blockNumber: 0 } },
    },
  },
};

export default config;
