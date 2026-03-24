# TokenBank DApp

一个功能完整的Web3 DApp（Token Bank）项目，包含智能合约和前端界面，演示代币银行存取功能。

---

## 目录

- [特性](#特性)
- [快速开始](#快速开始)
- [项目结构](#项目结构)
- [功能对比](#功能对比)
- [已部署合约](#已部署合约-sepolia)
- [技术栈](#技术栈)
- [开发命令](#开发命令)

---

## 特性

- **完整的合约实现** - ERC20代币 + TokenBank存取合约
- **现代化前端** - Next.js 16 + TypeScript + Tailwind CSS
- **多版本支持** - V1(基础版) + V2(Hook回调版) + EIP-712(Permit签名版) + Permit2(Uniswap签名版) + EIP-7702(批量执行版)
- **易于定制** - 模块化设计，方便替换合约和页面
- **生产就绪** - 安全最佳实践和完整的错误处理

---

## 快速开始

### 环境要求

- Node.js 18+
- Foundry (forge, cast)
- Git

### 安装 Foundry

```bash
curl -L https://foundry.paradigm.xyz | bash
foundryup
```

### 前端运行

```bash
cd frontend
npm install
npm run dev
```

访问 http://localhost:3000

### 合约开发

```bash
cd contracts
forge build
forge test
```

---

## 项目结构

```
TokenBank/
├── contracts/              # Foundry智能合约
│   ├── src/
│   │   ├── EricToken.sol          # ERC20代币 (V1)
│   │   ├── EricTokenV2.sol        # 带Hook的ERC20 (V2)
│   │   ├── EricTokenPermit.sol    # 带EIP-2612 Permit的ERC20
│   │   ├── IPermit2.sol         # Uniswap Permit2接口
│   │   ├── Delegate.sol         # EIP-7702批量执行合约
│   │   ├── TokenBank.sol        # V1存取合约
│   │   ├── TokenBankV2.sol      # V2存取合约
│   │   ├── TokenBankPermit.sol  # EIP-712 Permit存取合约
│   │   └── TokenBankPermit2.sol # Uniswap Permit2存取合约
│   └── script/
│       ├── DeployTokenAndBank.s.sol         # V1部署脚本
│       ├── DeployTokenAndBankV2.s.sol       # V2部署脚本
│       ├── DeployPermit.s.sol   # Permit版部署脚本
│       ├── DeployPermit2.s.sol  # Permit2版部署脚本
│       └── DeployDelegate.s.sol # Delegate部署脚本
│
└── frontend/               # Next.js前端
    ├── src/
    │   ├── app/                 # 页面路由
    │   │   ├── tokenbank-v1/    # V1页面
    │   │   ├── tokenbank-v2/    # V2页面
    │   │   ├── tokenbank-permit/ # EIP-712页面
    │   │   ├── tokenbank-permit2/ # Permit2页面
    │   │   └── tokenbank-7702/  # EIP-7702页面
    │   ├── components/          # 组件
    │   ├── config/              # Wagmi配置
    │   └── constants/           # 合约配置 (重要!)
    │       ├── abis.ts          # ABI定义
    │       └── addresses.ts     # 合约地址
    └── package.json
```

---

## 功能对比

### TokenBank V1 (基础版)
- Approve + TransferFrom 模式
- Deposit: 存入代币
- Withdraw: 提取代币
- 查看余额和授权额度
- 交易链接展示

### TokenBank V2 (增强版)
- **所有V1功能**
- **transferWithCallback**: 一步完成存款（无需approve！）
- Hook接口 (ITokenReceiver)
- 向后兼容V1方式

### TokenBank EIP-712 (Permit签名版)
- **所有V1功能**
- **Gasless Approve**: 使用EIP-2612 Permit签名授权
- **permitDeposit**: 签名后一次性完成授权+存款
- 节省gas费用（无需单独approve交易）
- 离线签名，提升用户体验

### TokenBank Permit2 (Uniswap签名版)
- **所有V1功能**
- **批量授权**: 一次性授权Permit2合约，支持多个应用
- **depositWithPermit2**: 使用Permit2签名进行存款
- 更灵活的nonce管理（bitmap模式）
- 支持部分授权和过期时间控制
- 基于Uniswap生产级Permit2标准

### TokenBank EIP-7702 (批量执行版)
- **批量操作**: 在单个交易中执行多个操作
- **executeBatch**: 通过Delegate合约批量执行approve + deposit
- **节省时间和Gas**: 一次交易完成两个操作
- **防重入保护**: ReentrancyGuard安全机制
- **灵活调用**: 支持任意目标合约和调用数据

---

## 已部署示例合约 (Sepolia)

### V1 合约
| 合约 | 地址 |
|------|------|
| EricToken | `0x7276E230a0cBcBF18310a8c66CFE4e007002dC1B` |
| TokenBank | `0xE7C4329D1efcf7823B61667BDc14D800D74DE701` |

### V2 合约
| 合约 | 地址 |
|------|------|
| EricTokenV2 | `0x76efB80cE493E8611a60231f1DFF35b9dAceD4EC` |
| TokenBankV2 | `0x63F39444b67151A28d0dD57B70DD3ce412F19D18` |

### Permit (EIP-712) 合约
| 合约 | 地址 |
|------|------|
| EricTokenPermit | `0xA8Fc93ED0cc3447F0Da76F498d35740BbF7D9dB7` |
| TokenBankPermit | `0xcd27F3A1eF04F8B0EA30f4B5Eaee2E7Cfc56a5d8` |

### Permit2 (Uniswap) 合约
| 合约 | 地址 |
|------|------|
| EricToken | `0x4e3fBDae470E157b5646B02b1efFB41B154104b8` |
| TokenBankPermit2 | `0xeAf870A41557D530CA9b903CCdD0C1C1aF4F292C` |
| Permit2 (Official) | `0x000000000022D473030F116dDEE9F6B43aC78BA3` |

### EIP-7702 (Delegate) 合约
| 合约 | 地址 |
|------|------|
| Delegate | `0xB8d4D1bf8a41d4Ee29e4BfB34468cbCE524af854` |

[在Etherscan上查看](https://sepolia.etherscan.io/)

---

## 技术栈

### 智能合约
- **Solidity** ^0.8.20
- **Foundry** (Forge, Cast)
- **OpenZeppelin** Contracts
- **安全特性**: ReentrancyGuard, SafeERC20, Custom Errors

### 前端
- **Next.js** 16 (App Router)
- **TypeScript**
- **Tailwind CSS** 4
- **Wagmi** v2 + **Viem** v2
- **RainbowKit** (钱包连接)
- **React Query** (状态管理)

---

## 开发命令

### 合约
```bash
forge build          # 编译
forge test           # 测试
forge script         # 部署
forge verify-contract # 验证
```

### 前端
```bash
npm run dev          # 开发模式
npm run build        # 生产构建
npm run start        # 启动生产服务器
npm run lint         # 代码检查
```

---

## 安全特性

- ReentrancyGuard 防重入攻击
- SafeERC20 安全转账
- Checks-Effects-Interactions 模式
- Custom Errors 节省gas
- 完整的事件日志
- 输入验证

---

## License

MIT License - 自由使用和修改

---
