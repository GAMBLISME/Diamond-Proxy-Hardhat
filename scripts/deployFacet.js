/* global ethers */

/* eslint prefer-const: "off" */

async function deployFacet (facetName) {
  const accounts = await ethers.getSigners()
  const user0 = accounts[0]

  const FacetFactory = await ethers.getContractFactory(facetName)
  const Facet = await FacetFactory.connect(user0).deploy()
  await Facet.deployed()
  console.log('facetA deployed:', Facet.address)
  return Facet
}

exports.deployFacet = deployFacet
