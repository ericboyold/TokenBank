// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script, console} from "forge-std/Script.sol";
import {Delegate} from "../src/Delegate.sol";

contract DeployDelegate is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY_TEST");
        vm.startBroadcast(deployerPrivateKey);

        // Deploy Delegate contract
        Delegate delegate = new Delegate();

        console.log("Delegate deployed to:", address(delegate));

        vm.stopBroadcast();
    }
}