// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script, console} from "forge-std/Script.sol";
import {EricToken} from "../src/EricToken.sol";
import {TokenBank} from "../src/TokenBank.sol";

contract DeployTokenAndBank is Script {
    function run() external {
        uint256 deployPrivateKey = vm.envUint("PRIVATE_KEY_TEST");
        vm.startBroadcast(deployPrivateKey);

        EricToken token = new EricToken(1000000);
        console.log("EricToken deployed to:", address(token));

        TokenBank bank = new TokenBank(address(token));
        console.log("TokenBank deployed to:", address(bank));

        vm.stopBroadcast();
    }
}
