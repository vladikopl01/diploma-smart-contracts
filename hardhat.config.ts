import "@nomicfoundation/hardhat-chai-matchers";
import '@nomicfoundation/hardhat-ethers';
import "@nomicfoundation/hardhat-network-helpers";
import "@nomicfoundation/hardhat-verify";
import "@nomiclabs/hardhat-solhint";
import "@typechain/ethers-v6";
import "@typechain/hardhat";
import "hardhat-gas-reporter";

import { HardhatUserConfig } from "hardhat/types";

const config: HardhatUserConfig = {
  solidity: "0.8.20",
  typechain: {
    outDir: "typechain",
  },
  gasReporter: {
    currency: "USD",
    gasPrice: 20,
    enabled: true,
    coinmarketcap: "e0b0b0a0-0b0b-0b0b-0b0b-0b0b0b0b0b0b",
  },
};

export default config;
