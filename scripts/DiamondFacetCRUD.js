/* eslint prefer-const: "off" */
const {
  getSelectors,
  FacetCutAction
} = require('../scripts/libraries/diamond.js')
const { ethers } = require('ethers')
const { assert } = require('chai')


// 添加FacetA
async function addFacetToDiamond (diamondCutFacet, contract, notAddFuncArray) {
  let selectors
  if (notAddFuncArray === undefined || notAddFuncArray === null) {
    selectors = getSelectors(contract)
  } else {
    selectors = getSelectors(contract).remove(notAddFuncArray)
  }
  const tx = await diamondCutFacet.diamondCut(
    [{
      facetAddress: contract.address,
      action: FacetCutAction.Add,
      functionSelectors: selectors
    }],
    ethers.constants.AddressZero, '0x', { gasLimit: 800000 })
  const receipt = await tx.wait()
  if (!receipt.status) {
    throw Error(`Diamond upgrade failed: ${tx.hash}`)
  }
}

// "替换"的意思是将现有在钻石上的函数映射关系从拥有相同函数功能的 FacetA 替换到 FacetB 上(且FacetB有该函数)。
// 这一替换操作仅针对没有在钻石上预先存储映射关系的函数，它主要是修改了钻石存储中的函数映射。若要添加新的函数，则需要新增一个新的 Facet 合约。
async function replaceFacetFuncToDiamond (diamondCutFacet, contract, replaceFuncArray) {
  let selectors
  if (replaceFuncArray === undefined || replaceFuncArray === null) {
    throw Error('未指定要替换的函数选择器数组')
  } else {
    selectors = getSelectors(contract).get(replaceFuncArray)
  }
  console.log('replaceFacetFuncToDiamondselectors:', selectors)
  const tx = await diamondCutFacet.diamondCut(
    [{
      facetAddress: contract.address,
      action: FacetCutAction.Replace,
      functionSelectors: selectors
    }],
    ethers.constants.AddressZero, '0x', { gasLimit: 800000 })
  const receipt = await tx.wait()
  console.log('replaceFacetFuncToDiamondreceipt:', receipt)
  if (!receipt.status) {
    throw Error(`Diamond upgrade failed: ${tx.hash}`)
  }
}

// remove是删除facetA在钻石上的函数映射。
async function removeFacetFuncToDiamond (diamondCutFacet, contract, removeFuncArray) {
  let selectors
  if (removeFuncArray === undefined || removeFuncArray === null) {
    throw Error('未指定要移除的函数选择器数组')
  } else {
    selectors = getSelectors(contract).get(removeFuncArray)
  }
  const tx = await diamondCutFacet.diamondCut(
    [{
      facetAddress: ethers.constants.AddressZero,
      action: FacetCutAction.Remove,
      functionSelectors: selectors
    }],
    ethers.constants.AddressZero, '0x', { gasLimit: 800000 }
  )
  const receipt = await tx.wait()
  if (!receipt.status) {
    throw Error(`Diamond upgrade failed: ${tx.hash}`)
  }
}

exports.addFacetToDiamond = addFacetToDiamond
exports.replaceFacetFuncToDiamond = replaceFacetFuncToDiamond
exports.removeFacetFuncToDiamond = removeFacetFuncToDiamond
