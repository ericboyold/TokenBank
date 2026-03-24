// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {IERC20Permit} from "@openzeppelin/contracts/token/ERC20/extensions/IERC20Permit.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

/**
 * @title TokenBankPermit
 * @dev 支持EIP-2612 Permit的代币存取合约
 * 用户可使用传统approve流程存款，也可通过permit签名实现一步存款
 */
contract TokenBankPermit is ReentrancyGuard {
    using SafeERC20 for IERC20;

    error ZeroAmount();
    error ZeroAddress();
    error InsufficientBalance();
    error PermitFailed();

    IERC20 public immutable token;

    mapping(address => uint256) public balances;

    event Deposit(address indexed user, uint256 amount);
    event PermitDeposit(address indexed user, uint256 amount);
    event Withdraw(address indexed user, uint256 amount);

    constructor(address _token) {
        if (_token == address(0)) revert ZeroAddress();
        token = IERC20(_token);
    }

    /**
     * @dev 传统存款（需先approve）
     * @param amount 存入数量
     *
     * 要求:
     * - amount必须大于0
     * - 调用者必须已经approve足够的代币给此合约
     */
    function deposit(uint256 amount) external nonReentrant {
        if (amount == 0) revert ZeroAmount();

        token.safeTransferFrom(msg.sender, address(this), amount);

        balances[msg.sender] += amount;

        emit Deposit(msg.sender, amount);
    }

    /**
     * @dev 使用EIP-2612 Permit签名存款
     * @param amount 存入数量
     * @param deadline 签名有效期截止时间戳
     * @param v ECDSA签名参数
     * @param r ECDSA签名参数
     * @param s ECDSA签名参数
     *
     * 要求:
     * - amount必须大于0
     * - 签名必须在deadline前有效，且可被代币合约正确验证
     *
     * 该函数通过离线签名授权后直接完成转账与记账，无需单独发起approve交易。
     */
    function permitDeposit(uint256 amount, uint256 deadline, uint8 v, bytes32 r, bytes32 s) external nonReentrant {
        if (amount == 0) revert ZeroAmount();

        // 在代币合约上执行permit授权
        try IERC20Permit(address(token)).permit(msg.sender, address(this), amount, deadline, v, r, s) {
            // permit成功后执行转账
            token.safeTransferFrom(msg.sender, address(this), amount);

            balances[msg.sender] += amount;

            emit PermitDeposit(msg.sender, amount);
        } catch {
            revert PermitFailed();
        }
    }

    /**
     * @dev 从Bank提取代币
     * @param amount 提取数量
     *
     * 要求:
     * - amount必须大于0
     * - 调用者的存入余额必须足够
     */
    function withdraw(uint256 amount) external nonReentrant {
        if (amount == 0) revert ZeroAmount();
        if (balances[msg.sender] < amount) revert InsufficientBalance();

        // 先更新状态（防止重入攻击）
        balances[msg.sender] -= amount;

        // 再进行转账
        token.safeTransfer(msg.sender, amount);

        emit Withdraw(msg.sender, amount);
    }

    /**
     * @dev 查询用户在Bank中的余额
     * @param account 查询地址
     * @return 用户存入的代币数量
     */
    function balanceOf(address account) external view returns (uint256) {
        return balances[account];
    }
}
