require("@nomiclabs/hardhat-waffle");
require("@nomiclabs/hardhat-ethers");
require("@nomiclabs/hardhat-etherscan");
const fs = require('fs');
require('dotenv').config();

const ETHERSCAN_API_KEY = process.env.ETHERSCAN_API_KEY || "";

task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
});

module.exports = {
  defaultNetwork: "hardhat",
  networks: {
    hardhat: {
      chainId: 1337
    },
    "optimisticEthereum": {
      url: process.env.OPTIMISTIC_ALCHEMY_URL,
      accounts: [ process.env.PRIVATE_KEY ]
    }
  },
  etherscan: {
    apiKey: {
        optimisticEthereum: ETHERSCAN_API_KEY,
    },
  },
  solidity: {
    version: "0.8.4",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200
      }
    }
  }
};
