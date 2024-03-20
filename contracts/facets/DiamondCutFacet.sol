// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


import { IDiamondCut } from "../interfaces/IDiamondCut.sol";
import { LibDiamond } from "../libraries/LibDiamond.sol";

// 记得向钻石添加来自 DiamondLoupeFacet 的 loupe 函数。
// 这些 loupe 函数是 EIP2535 钻石标准所要求的。
contract DiamondCutFacet is IDiamondCut {
    /// @notice 添加/替换/移除任意数量的函数，并可选择使用 delegatecall 执行函数
    /// @param _diamondCut 包含 facet 地址和函数选择器的数组
    /// @param _init 要执行 _calldata 的合约或 facet 的地址
    /// @param _calldata 函数调用，包括函数选择器和参数
    /// _calldata 会在 _init 上使用 delegatecall 执行
    function diamondCut(
        FacetCut[] calldata _diamondCut,
        address _init,
        bytes calldata _calldata
    ) external override {
        LibDiamond.enforceIsContractOwner();
        LibDiamond.diamondCut(_diamondCut, _init, _calldata);
    }
}
