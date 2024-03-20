// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


// 镜片是用于观察钻石的小型放大镜。
// 这些函数用于查看钻石
interface IDiamondLoupe {
    /// 这些函数预计会被工具频繁调用。
    struct Facet {
        address facetAddress;
        bytes4[] functionSelectors;
    }
    /// @notice 获取所有 facet 地址及其四字节函数选择器。
    /// @return facets_ Facet 结构数组
    function facets() external view returns (Facet[] memory facets_);
    /// @notice 获取特定 facet 支持的所有函数选择器。
    /// @param _facet facet 地址。
    /// @return facetFunctionSelectors_
    function facetFunctionSelectors(address _facet) external view returns (bytes4[] memory facetFunctionSelectors_);
    /// @notice 获取钻石使用的所有 facet 地址。
    /// @return facetAddresses_
    function facetAddresses() external view returns (address[] memory facetAddresses_);
    /// @notice 获取支持给定选择器的 facet。
    /// @dev 如果找不到 facet，则返回 address(0)。
    /// @param _functionSelector 函数选择器。
    /// @return facetAddress_ facet 地址。
    function facetAddress(bytes4 _functionSelector) external view returns (address facetAddress_);
}
