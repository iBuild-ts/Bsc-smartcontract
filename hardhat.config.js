require("@nomiclabs/hardhat-ethers");

module.exports = {
  defaultNetwork: "localhost",
  networks: {
    localhost: {
      url: "http://127.0.0.1:8545"
    },
    testnet: {
      url: `https://data-seed-prebsc-1-s1.binance.org:8545/`, // BSC Testnet
      chainId: 97,
      accounts: [`0x${process.env.PRIVATE_KEY}`] // Replace with your private key
    },
    mainnet: {
      url: `https://bsc-dataseed.binance.org/`, // BSC Mainnet
      chainId: 56,
      accounts: [`0x${process.env.PRIVATE_KEY}`] // Replace with your private key
    },
  },
  solidity: {
    version: "0.8.4",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200,
      },
    },
  },
};
