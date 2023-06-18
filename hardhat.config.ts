import "@nomicfoundation/hardhat-toolbox";
import "@nomiclabs/hardhat-solhint";
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
