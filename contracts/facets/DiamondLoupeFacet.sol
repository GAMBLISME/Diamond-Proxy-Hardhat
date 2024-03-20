// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
// 必须向钻石添加 DiamondLoupeFacet 中的函数。
// EIP-2535 钻石标准要求这些函数。

import { LibDiamond } from  "../libraries/LibDiamond.sol";
import { IDiamondLoupe } from "../interfaces/IDiamondLoupe.sol";
import { IERC165 } from "../interfaces/IERC165.sol";

contract DiamondLoupeFacet is IDiamondLoupe, IERC165 {
    // 钻石Loupe函数
    ////////////////////////////////////////////////////////////////////
    /// 这些函数预计由工具频繁调用。
    //
    // struct Facet {
    //     address facetAddress;
    //     bytes4[] functionSelectors;
    // }
    /// @notice 获取所有 facet 及其选择器。
    /// @return facets_ Facet
    function facets() external override view returns (Facet[] memory facets_) {
        LibDiamond.DiamondStorage storage ds = LibDiamond.diamondStorage();
        uint256 selectorCount = ds.selectors.length;
        // 创建一个数组，大小设置为可能的最大值
        facets_ = new Facet[](selectorCount);
        // 创建一个数组用于计算每个 facet 的选择器数量
        uint16[] memory numFacetSelectors = new uint16[](selectorCount);
        // 总的 facet 数量
        uint256 numFacets;
        // 遍历函数选择器
        for (uint256 selectorIndex; selectorIndex < selectorCount; selectorIndex++) {
            bytes4 selector = ds.selectors[selectorIndex];
            address facetAddress_ = ds.facetAddressAndSelectorPosition[selector].facetAddress;
            bool continueLoop = false;
            // 查找与选择器相关的函数选择器数组，并将选择器添加到其中
            for (uint256 facetIndex; facetIndex < numFacets; facetIndex++) {
                if (facets_[facetIndex].facetAddress == facetAddress_) {
                    facets_[facetIndex].functionSelectors[numFacetSelectors[facetIndex]] = selector;
                    numFacetSelectors[facetIndex]++;
                    continueLoop = true;
                    break;
                }
            }
            // 如果函数选择器数组存在，则继续循环
            if (continueLoop) {
                continueLoop = false;
                continue;
            }
            // 为选择器创建一个新的函数选择器数组
            facets_[numFacets].facetAddress = facetAddress_;
            facets_[numFacets].functionSelectors = new bytes4[](selectorCount);
            facets_[numFacets].functionSelectors[0] = selector;
            numFacetSelectors[numFacets] = 1;
            numFacets++;
        }
        for (uint256 facetIndex; facetIndex < numFacets; facetIndex++) {
            uint256 numSelectors = numFacetSelectors[facetIndex];
            bytes4[] memory selectors = facets_[facetIndex].functionSelectors;
            // 设置选择器数量
            assembly {
                mstore(selectors, numSelectors)
            }
        }
        // 设置 facet 数量
        assembly {
            mstore(facets_, numFacets)
        }
    }

    /// @notice 获取特定 facet 支持的所有函数选择器。
    /// @param _facet facet 地址。
    /// @return _facetFunctionSelectors 与 facet 地址关联的选择器。
    function facetFunctionSelectors(address _facet) external override view returns (bytes4[] memory _facetFunctionSelectors) {
        LibDiamond.DiamondStorage storage ds = LibDiamond.diamondStorage();
        uint256 selectorCount = ds.selectors.length;
        uint256 numSelectors;
        _facetFunctionSelectors = new bytes4[](selectorCount);
        // 遍历函数选择器
        for (uint256 selectorIndex; selectorIndex < selectorCount; selectorIndex++) {
            bytes4 selector = ds.selectors[selectorIndex];
            address facetAddress_ = ds.facetAddressAndSelectorPosition[selector].facetAddress;
            if (_facet == facetAddress_) {
                _facetFunctionSelectors[numSelectors] = selector;
                numSelectors++;
            }
        }
        // 在数组中设置选择器数量
        assembly {
            mstore(_facetFunctionSelectors, numSelectors)
        }
    }

    /// @notice 获取钻石使用的所有 facet 地址。
    /// @return facetAddresses_
    function facetAddresses() external override view returns (address[] memory facetAddresses_) {
        LibDiamond.DiamondStorage storage ds = LibDiamond.diamondStorage();
        uint256 selectorCount = ds.selectors.length;
        // 创建一个数组，大小设置为可能的最大值
        facetAddresses_ = new address[](selectorCount);
        uint256 numFacets;
        // 遍历函数选择器
        for (uint256 selectorIndex; selectorIndex < selectorCount; selectorIndex++) {
            bytes4 selector = ds.selectors[selectorIndex];
            address facetAddress_ = ds.facetAddressAndSelectorPosition[selector].facetAddress;
            bool continueLoop = false;
            // 看看我们是否已经收集了地址，并在我们已经收集时跳出循环
            for (uint256 facetIndex; facetIndex < numFacets; facetIndex++) {
                if (facetAddress_ == facetAddresses_[facetIndex]) {
                    continueLoop = true;
                    break;
                }
            }
            // 如果已经有了地址，则继续循环
            if (continueLoop) {
                continueLoop = false;
                continue;
            }
            // 包括地址
            facetAddresses_[numFacets] = facetAddress_;
            numFacets++;
        }
        // 在数组中设置 facet 地址数量
        assembly {
            mstore(facetAddresses_, numFacets)
        }
    }

    /// @notice 获取支持给定选择器的 facet 地址。
    /// @dev 如果未找到 facet，则返回 address(0)。
    /// @param _functionSelector 函数选择器。
    /// @return facetAddress_ facet 地址。
    function facetAddress(bytes4 _functionSelector) external override view returns (address facetAddress_) {
        LibDiamond.DiamondStorage storage ds = LibDiamond.diamondStorage();
        facetAddress_ = ds.facetAddressAndSelectorPosition[_functionSelector].facetAddress;
    }

    // 这实现了 ERC-165。
    function supportsInterface(bytes4 _interfaceId) external override view returns (bool) {
        LibDiamond.DiamondStorage storage ds = LibDiamond.diamondStorage();
        return ds.supportedInterfaces[_interfaceId];
    }
}
