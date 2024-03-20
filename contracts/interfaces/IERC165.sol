// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC165 {
    /// @notice 查询合约是否实现了某个接口
    /// @param interfaceId 接口标识符，如 ERC-165 中规定的
    /// @dev 接口标识在 ERC-165 中指定。此函数的执行消耗少于 30,000 气体。
    /// @return 如果合约实现了 `interfaceID` 并且 `interfaceID` 不是 0xffffffff，则返回 `true`，否则返回 `false`
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}
