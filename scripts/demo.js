const { ethers } = require('hardhat')
const { deployDiamond } = require('../scripts/deploy.js')
const { deployFacet } = require('../scripts/deployFacet.js')
const { getSelectors } = require('../scripts/libraries/diamond.js')
const {
  addFacetToDiamond,
  replaceFacetFuncToDiamond,
  removeFacetFuncToDiamond
} = require('../scripts/DiamondFacetCRUD.js')

const main = async () => {
  let diamondAddress
  let diamondCutFacet
  let diamondLoupeFacet
  let facetASelectors
  let facetBSelectors
  console.log('=======初始化=========')
  diamondAddress = await deployDiamond()
  diamondCutFacet = await ethers.getContractAt('DiamondCutFacet', diamondAddress)
  diamondLoupeFacet = await ethers.getContractAt('DiamondLoupeFacet', diamondAddress)
  ownershipFacet = await ethers.getContractAt('OwnershipFacet', diamondAddress)

  console.log('=======添加facetA=========')
  const facetA = await deployFacet('FacetA')
  await addFacetToDiamond(diamondCutFacet, facetA)
  facetASelectors = await diamondLoupeFacet.facetFunctionSelectors(facetA.address)
  console.log('facetASelectors==>', facetASelectors)
  console.log('=======添加facetB=========')
  const facetB = await deployFacet('FacetB')
  const facetBNotAddArray = ['setDataA(bytes32)', 'getDataA()']
  await addFacetToDiamond(diamondCutFacet, facetB, facetBNotAddArray)
  facetBSelectors = await diamondLoupeFacet.facetFunctionSelectors(facetB.address)
  console.log('facetBSelectors==>', facetBSelectors)
  console.log('=======替换dataA的函数=========')
  await replaceFacetFuncToDiamond(diamondCutFacet, facetB, facetBNotAddArray)
  facetASelectors = await diamondLoupeFacet.facetFunctionSelectors(facetA.address)
  console.log('facetASelectors==>', facetASelectors)
  await addFacetToDiamond(diamondCutFacet, facetB, facetBNotAddArray)
  facetBSelectors = await diamondLoupeFacet.facetFunctionSelectors(facetB.address)
  console.log('facetBSelectors==>', facetBSelectors)
  // console.log('=======FacetA移除dataA的函数=========')
  // const removeDataAFuncArray = ['setDataA(bytes32)', 'getDataA()']
  // await removeFacetFuncToDiamond(diamondCutFacet, facetA, removeDataAFuncArray)
  // facetASelectors = await diamondLoupeFacet.facetFunctionSelectors(facetA.address)
  // console.log('facetASelectors==>', facetASelectors)

}

main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error)
    process.exit(1)
  })

