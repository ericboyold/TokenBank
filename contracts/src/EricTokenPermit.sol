// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {ERC20Permit} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";
import {ERC20Burnable} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title EricTokenPermit
 * @dev 一个安全的ERC20代币实现，支持铸造、销毁和Permit功能
 * 使用ERC20Permit（EIP-2612）功能，可以允许用户在不需要持有代币的情况下进行交易
 * 使用ERC20Burnable（EIP-20）功能，可以允许用户销毁代币
 * 使用Ownable（EIP-173）功能，可以允许owner铸造新代币
 */
contract EricTokenPermit is ERC20, ERC20Permit, ERC20Burnable, Ownable {
    uint8 private _decimals;

    /**
     * @dev 构造函数
     * @param initialSupply 初始供应量（不含精度）
     */
    constructor(uint256 initialSupply)
        ERC20("EricTokenPermit", "ETP")
        ERC20Permit("EricTokenPermit")
        Ownable(msg.sender)
    {
        _decimals = 18;
        _mint(msg.sender, initialSupply * 10 ** decimals());
    }

    /**
     * @dev 返回代币精度
     */
    function decimals() public view virtual override returns (uint8) {
        return _decimals;
    }

    /**
     * @dev 铸造新代币，仅限owner
     * @param to 接收地址
     * @param amount 铸造数量
     */
    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }
}
