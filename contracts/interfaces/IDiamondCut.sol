// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;



import { IDiamond } from "./IDiamond.sol";

interface IDiamondCut is IDiamond {

    /// @notice 添加/替换/移除任意数量的函数，并可选择使用 delegatecall 执行函数
    /// @param _diamondCut 包含 facet 地址和函数选择器的 FacetCut 结构数组
    /// @param _init 要执行 _calldata 的合约或 facet 的地址
    /// @param _calldata 包括函数选择器和参数的函数调用 _calldata 将使用 delegatecall 在 _init 上执行
    function diamondCut(
        FacetCut[] calldata _diamondCut,
        address _init,
        bytes calldata _calldata
    ) external;
}
