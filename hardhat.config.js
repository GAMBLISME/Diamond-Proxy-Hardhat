require('@nomiclabs/hardhat-waffle')
require('hardhat-gas-reporter')
require('dotenv').config()
require('hardhat-tracer')
const PRIVATE_KEY = process.env.PRIVATE_KEY
const SEPOLIA_URL = process.env.SEPOLIA_URL

module.exports = {
  solidity: '0.8.17',
  settings: {
    optimizer: {
      enabled: true,
      runs: 200
    }
  },
  gasReporter: {
    enabled: false
  },
  defaultNetwork: 'hardhat',
  networks: {
    sepolia: {
      url: SEPOLIA_URL,
      accounts: [PRIVATE_KEY]
    }
  }

}
