// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script, console} from "forge-std/Script.sol";
import {EricTokenPermit} from "../src/EricTokenPermit.sol";
import {TokenBankPermit} from "../src/TokenBankPermit.sol";

contract DeployPermit is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY_TEST");
        vm.startBroadcast(deployerPrivateKey);

        EricTokenPermit token = new EricTokenPermit(1_000_000);

        TokenBankPermit bank = new TokenBankPermit(address(token));

        vm.stopBroadcast();

        console.log("\n=== Permit Deployment Summary ===");
        console.log("EricTokenPermit:", address(token));
        console.log("TokenBankPermit:", address(bank));
        console.log("Deployer:", vm.addr(deployerPrivateKey));
    }
}
