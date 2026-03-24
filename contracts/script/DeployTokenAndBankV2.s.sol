// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script, console} from "forge-std/Script.sol";
import {EricTokenV2} from "../src/EricTokenV2.sol";
import {TokenBankV2} from "../src/TokenBankV2.sol";

contract DeployTokenAndBankV2 is Script {
    function run() external {
        // 读取私钥
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY_TEST");

        // 开始广播交易
        vm.startBroadcast(deployerPrivateKey);

        // 部署 EricTokenV2，初始供应量为 1,000,000 ETK
        EricTokenV2 tokenV2 = new EricTokenV2(1000000);

        // 部署 TokenBankV2
        TokenBankV2 bankV2 = new TokenBankV2(address(tokenV2));

        vm.stopBroadcast();

        // 输出部署信息
        console.log("\n=== V2 Deployment Summary ===");
        console.log("EricTokenV2:", address(tokenV2));
        console.log("TokenBankV2:", address(bankV2));
        console.log("Deployer:", vm.addr(deployerPrivateKey));
    }
}
