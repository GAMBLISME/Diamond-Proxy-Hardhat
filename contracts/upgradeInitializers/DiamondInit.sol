// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


import { LibDiamond } from "../libraries/LibDiamond.sol";
import { IDiamondLoupe } from "../interfaces/IDiamondLoupe.sol";
import { IDiamondCut } from "../interfaces/IDiamondCut.sol";
import { IERC173 } from "../interfaces/IERC173.sol";
import { IERC165 } from "../interfaces/IERC165.sol";

// 预期通过自定义此合约来部署您的钻石，如果您想要使用部署脚本中的数据。
// 使用 init 函数初始化钻石的状态变量。如果需要，向 init 函数添加参数。

// 在此添加的 `init` 或其他函数中添加参数，可以使单个部署的 DiamondInit 合约在升级时可重用，
// 并且可以用于多个钻石。

contract DiamondInit {

    // 可以向此函数添加参数，以便传入数据以设置自己的状态变量
    function init() external {
        // 添加 ERC165 数据
        LibDiamond.DiamondStorage storage ds = LibDiamond.diamondStorage();
        ds.supportedInterfaces[type(IERC165).interfaceId] = true;
        ds.supportedInterfaces[type(IDiamondCut).interfaceId] = true;
        ds.supportedInterfaces[type(IDiamondLoupe).interfaceId] = true;
        ds.supportedInterfaces[type(IERC173).interfaceId] = true;

        // 添加您自己的状态变量
        // EIP-2535 指定 `diamondCut` 函数接受两个可选参数: address _init 和 bytes calldata _calldata
        // 这些参数用于使用 delegatecall 执行任意函数，以在钻石的部署或升级过程中设置状态变量
        // 更多信息请参阅: https://eips.ethereum.org/EIPS/eip-2535#diamond-interface
    }
}
