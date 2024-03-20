// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title ERC-173 合同所有权标准
///  注意: 该接口的 ERC-165 标识符为 0x7f5828d0
/* 是 ERC165 */
interface IERC173 {
    /// @dev 当合同的所有权发生变化时触发此事件。
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /// @notice 获取合同所有者的地址
    /// @return owner_ 合同所有者的地址。
    function owner() external view returns (address owner_);

    /// @notice 设置合同的新所有者地址
    /// @dev 将 _newOwner 设置为 address(0) 以放弃所有权。
    /// @param _newOwner 合同的新所有者地址
    function transferOwnership(address _newOwner) external;
}
