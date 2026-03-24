// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title IPermit2
 * @notice 基于签名的代币授权与转账 Permit2 接口
 * @dev 这是 Uniswap Permit2 合约的简化接口
 * 完整实现: https://github.com/Uniswap/permit2
 */
interface IPermit2 {
    /// @notice permitTransfer 签名中包含的代币与额度信息
    struct TokenPermissions {
        // ERC20 代币地址
        address token;
        // 可被花费的最大数量
        uint256 amount;
    }

    /// @notice 单代币转账的签名许可消息
    struct PermitTransferFrom {
        TokenPermissions permitted;
        // 每个 owner 签名唯一值，用于防重放
        uint256 nonce;
        // 签名过期时间
        uint256 deadline;
    }

    /// @notice 指定转账接收地址与请求数量（批量场景复用）
    /// @dev 接收地址与数量应与签名中代币权限数组的索引一一对应
    /// @dev 当请求数量超过签名许可额度时会回退
    struct SignatureTransferDetails {
        // 接收地址
        address to;
        // spender 请求转出的数量
        uint256 requestedAmount;
    }

    /// @notice 用于重建多代币转账的签名许可消息
    /// @dev 无需传入 spender 地址，因为强制要求为 msg.sender
    /// @dev 但用户签名消息中仍包含 spender 地址
    struct PermitBatchTransferFrom {
        // 允许转账的代币与对应额度
        TokenPermissions[] permitted;
        // 每个 owner 签名唯一值，用于防重放
        uint256 nonce;
        // 签名过期时间
        uint256 deadline;
    }

    /// @notice token owner 与调用方指定 word 索引到位图的映射，用于防签名重放
    /// @dev 使用无序 nonce，因此 permit 消息不要求按顺序消费
    /// @dev 该映射先按 owner 索引，再按 nonce 中指定的索引定位
    /// @dev 返回 uint256 位图
    /// @dev 索引（wordPosition）上限为 type(uint248).max
    function nonceBitmap(address, uint256) external view returns (uint256);

    /// @notice 使用签名许可消息转移单个代币
    /// @param permit owner 签名的 permit 数据
    /// @param transferDetails spender 请求的转账明细
    /// @param owner 被扣减代币的所有者
    /// @param signature 用于校验的签名
    function permitTransferFrom(
        PermitTransferFrom memory permit,
        SignatureTransferDetails calldata transferDetails,
        address owner,
        bytes calldata signature
    ) external;

    /// @notice 使用签名许可消息批量转移多个代币
    /// @param permit owner 签名的 permit 数据
    /// @param transferDetails spender 请求的批量转账明细
    /// @param owner 被扣减代币的所有者
    /// @param signature 用于校验的签名
    function permitTransferFrom(
        PermitBatchTransferFrom memory permit,
        SignatureTransferDetails[] calldata transferDetails,
        address owner,
        bytes calldata signature
    ) external;

    /// @notice 返回当前链的 EIP-712 域分隔符
    function DOMAIN_SEPARATOR() external view returns (bytes32);
}
