// Contract addresses - Sepolia Testnet only

// V1 Contracts
export const CONTRACTS_V1 = {
  EricToken: '0x7276E230a0cBcBF18310a8c66CFE4e007002dC1B',
  TokenBank: '0xE7C4329D1efcf7823B61667BDc14D800D74DE701',
} as const;

// V2 Contracts
export const CONTRACTS_V2 = {
  EricTokenV2: '0x76efB80cE493E8611a60231f1DFF35b9dAceD4EC',
  TokenBankV2: '0x63F39444b67151A28d0dD57B70DD3ce412F19D18',
} as const;
// 默认导出V1（向后兼容）
export const CONTRACTS = CONTRACTS_V1;
