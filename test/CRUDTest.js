/* global describe it before ethers */
const { assert } = require('chai')
const { deployDiamond } = require('../scripts/deploy.js')
const { deployFacet } = require('../scripts/deployFacet.js')
const { getSelectors } = require('../scripts/libraries/diamond.js')
const {
  addFacetToDiamond,
  replaceFacetFuncToDiamond,
  removeFacetFuncToDiamond
} = require('../scripts/DiamondFacetCRUD.js')

describe('My FacetCRUD Test', async function () {
  let diamondAddress
  let diamondCutFacet
  let diamondLoupeFacet
  let ownershipFacet
  let result
  const addresses = []

  before(async function () {
    diamondAddress = await deployDiamond()
    diamondCutFacet = await ethers.getContractAt('DiamondCutFacet', diamondAddress)
    diamondLoupeFacet = await ethers.getContractAt('DiamondLoupeFacet', diamondAddress)
    // eslint-disable-next-line no-unused-vars
    ownershipFacet = await ethers.getContractAt('OwnershipFacet', diamondAddress)
  })

  it('should have three facets -- call to facetAddresses function', async () => {
    for (const address of await diamondLoupeFacet.facetAddresses()) {
      addresses.push(address)
    }

    assert.equal(addresses.length, 3)
  })

  it('add FacetA to Diamond', async () => {
    const facetA = await deployFacet('FacetA')
    await addFacetToDiamond(diamondCutFacet, facetA)
    result = await diamondLoupeFacet.facetFunctionSelectors(facetA.address)
    const selectors = getSelectors(facetA)
    assert.sameMembers(result, selectors)
  })

  it('add FacetB to Diamond without some funcs which are related with dataA,then replace these funcs', async () => {
    const facetA = await deployFacet('FacetA')
    await addFacetToDiamond(diamondCutFacet, facetA)
    const facetB = await deployFacet('FacetB')
    const dataAFuncArray = ['setDataA(bytes32)', 'getDataA()']
    // const dataBFuncArray = ['setDataB(bytes32)', 'getDataB()']
    await addFacetToDiamond(diamondCutFacet, facetB, dataAFuncArray)
    await replaceFacetFuncToDiamond(diamondCutFacet, facetB, dataAFuncArray)
    const allFuncArray = ['setDataA(bytes32)', 'getDataA()', 'setDataB(bytes32)', 'getDataB()']
    result = await diamondLoupeFacet.facetFunctionSelectors(facetB.address)
    assert.sameMembers(result, allFuncArray)
  })

  it('remove funcs which are related with dataA from facetB ', async () => {
    const facetB = await deployFacet('FacetB')
    await addFacetToDiamond(diamondCutFacet, facetB)
    const dataAFuncArray = ['setDataA(bytes32)', 'getDataA()']
    const dataBFuncArray = ['setDataB(bytes32)', 'getDataB()']
    await removeFacetFuncToDiamond(diamondCutFacet, facetB, dataAFuncArray)
    result = await diamondLoupeFacet.facetFunctionSelectors(facetB.address)
    assert.sameMembers(result, dataBFuncArray)
  })
})
