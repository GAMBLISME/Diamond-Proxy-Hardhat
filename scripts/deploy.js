/* global ethers */
// noinspection LanguageDetectionInspection

const { getSelectors, FacetCutAction } = require('./libraries/diamond.js')

async function deployDiamond () {
  const accounts = await ethers.getSigners()
  const contractOwner = accounts[0]

  // 部署 DiamondInit
  // DiamondInit 提供了一个函数，当 Diamond 升级或部署时调用以初始化状态变量
  // 请阅读 EIP2535 Diamonds 标准中 diamondCut 函数的工作原理
  const DiamondInit = await ethers.getContractFactory('DiamondInit')
  const diamondInit = await DiamondInit.deploy()
  await diamondInit.deployed()
  console.log('已部署 DiamondInit:', diamondInit.address)

  // 部署 facets 并设置 `facetCuts` 变量
  console.log('')
  console.log('部署 facets')
  const FacetNames = [
    'DiamondCutFacet',
    'DiamondLoupeFacet',
    'OwnershipFacet'
  ]
  // `facetCuts` 变量是 FacetCut[]，其中包含在 Diamond 部署期间要添加的函数
  const facetCuts = []
  for (const FacetName of FacetNames) {
    const Facet = await ethers.getContractFactory(FacetName)
    const facet = await Facet.deploy()
    await facet.deployed()
    console.log(`${FacetName} 已部署: ${facet.address}`)
    facetCuts.push({
      facetAddress: facet.address,
      action: FacetCutAction.Add,
      functionSelectors: getSelectors(facet)
    })
  }

  // 创建一个函数调用
  // 此调用在部署期间执行，也可在升级时执行
  // 它通过 delegatecall 在 DiamondInit 地址上执行
  const functionCall = diamondInit.interface.encodeFunctionData('init')

  // 设置将在 diamond 构造函数中使用的参数
  const diamondArgs = {
    owner: contractOwner.address,
    init: diamondInit.address,
    initCalldata: functionCall
  }

  // 部署 Diamond
  const Diamond = await ethers.getContractFactory('Diamond')
  const diamond = await Diamond.deploy(facetCuts, diamondArgs)
  await diamond.deployed()
  console.log()
  console.log('已部署 Diamond:', diamond.address)

  // 返回 diamond 地址
  return diamond.address
}

// 我们建议使用此模式以便在任何地方使用 async/await 并正确处理错误。
if (require.main === module) {
  deployDiamond()
    .then(() => process.exit(0))
    .catch(error => {
      console.error(error)
      process.exit(1)
    })
}

exports.deployDiamond = deployDiamond
