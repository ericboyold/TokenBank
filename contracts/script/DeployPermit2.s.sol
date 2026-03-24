// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script, console} from "forge-std/Script.sol";
import {EricToken} from "../src/EricToken.sol";
import {TokenBankPermit2} from "../src/TokenBankPermit2.sol";

contract DeployPermit2 is Script {
    // Permit2 contract address on Sepolia (officially deployed by Uniswap)
    address constant PERMIT2_ADDRESS = 0x000000000022D473030F116dDEE9F6B43aC78BA3;

    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY_TEST");

        vm.startBroadcast(deployerPrivateKey);

        // Deploy EricToken with 1,000,000 initial supply
        EricToken token = new EricToken(1_000_000);

        // Deploy TokenBankPermit2 using the official Permit2 contract
        TokenBankPermit2 bank = new TokenBankPermit2(address(token), PERMIT2_ADDRESS);

        vm.stopBroadcast();

        console.log("\n=== Permit2 Deployment Summary ===");
        console.log("EricToken:", address(token));
        console.log("TokenBankPermit2:", address(bank));
        console.log("Using Permit2 at:", PERMIT2_ADDRESS);
        console.log("Deployer:", vm.addr(deployerPrivateKey));
    }
}
