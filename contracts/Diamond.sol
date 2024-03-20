// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { LibDiamond } from "./libraries/LibDiamond.sol";
import { IDiamondCut } from "./interfaces/IDiamondCut.sol";
import { IDiamondLoupe } from  "./interfaces/IDiamondLoupe.sol";
import { IERC173 } from "./interfaces/IERC173.sol";
import { IERC165} from "./interfaces/IERC165.sol";

// 当没有找到函数存在于被调用时
    error FunctionNotFound(bytes4 _functionSelector);

// 这在 diamond 构造函数中使用
// 更多的参数被添加到这个结构体
// 这避免了栈溢出错误
    struct DiamondArgs {
        address owner;
        address init;
        bytes initCalldata;
    }

contract Diamond {
    constructor(IDiamondCut.FacetCut[] memory _diamondCut, DiamondArgs memory _args) payable {
        LibDiamond.setContractOwner(_args.owner);
        LibDiamond.diamondCut(_diamondCut, _args.init, _args.initCalldata);

        // 可以在这里添加代码来执行操作并设置状态变量。
    }
    // 查找被调用函数的功能，如果找到则执行该函数并返回任何值。
    fallback() external payable {
        LibDiamond.DiamondStorage storage ds;
        bytes32 position = LibDiamond.DIAMOND_STORAGE_POSITION;
        // 获取 diamond 存储
        assembly {
            ds.slot := position
        }
        // 从函数选择器获取 facet
        address facet = ds.facetAddressAndSelectorPosition[msg.sig].facetAddress;
        if(facet == address(0)) {
            revert FunctionNotFound(msg.sig);
        }
        // 使用 delegatecall 执行 facet 中的外部函数并返回任何值。
        assembly {
        // 复制函数选择器和任何参数
            calldatacopy(0, 0, calldatasize())
        // 使用 facet 执行函数调用
            let result := delegatecall(gas(), facet, 0, calldatasize(), 0, 0)
        // 获取任何返回值
            returndatacopy(0, 0, returndatasize())
        // 返回任何返回值或错误给调用者
            switch result
            case 0 {
                revert(0, returndatasize())
            }
            default {
                return(0, returndatasize())
            }
        }
    }

    receive() external payable {}
}
