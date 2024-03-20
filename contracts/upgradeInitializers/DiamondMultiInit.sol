// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


import { LibDiamond } from "../libraries/LibDiamond.sol";

error AddressAndCalldataLengthDoNotMatch(uint256 _addressesLength, uint256 _calldataLength);

contract DiamondMultiInit {

    // 这个函数是在 `diamondCut` 函数的第三个参数中提供的。
    // `diamondCut` 函数执行此函数以执行单次升级的多个初始化器函数。

    function multiInit(address[] calldata _addresses, bytes[] calldata _calldata) external {        
        if(_addresses.length != _calldata.length) {
            revert AddressAndCalldataLengthDoNotMatch(_addresses.length, _calldata.length);
        }
        for(uint i; i < _addresses.length; i++) {
            LibDiamond.initializeDiamondCut(_addresses[i], _calldata[i]);            
        }
    }
}
