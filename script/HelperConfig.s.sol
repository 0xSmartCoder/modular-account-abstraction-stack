// //SPDX-License-Identifier: MIT
// pragma solidity ^0.8.28;

// import {Script} from "lib/forge-std/src/Script.sol";
// import {EntryPoint} from "lib/account-abstraction/contracts/core/EntryPoint.sol";

// contract HelperConfig is Script {
//     error HelperConfig_InvalidChainId();

//     struct NetworkConfig {
//         address entryPoint;
//         address account;
//     }

//     uint256 constant ETH_SEPOLIA_CHAIN_ID = 11155111;
//     uint256 constant ZKSYNC_CHAIN_ID = 300;
//     uint256 constant LOCAL_CHAIN_ID = 31337;
//     address constant BURNER_WALLET = 0x7F6a4429ac431A7f0C5fb7d6FA63f973907d82E9;
//     address constant FOUNDRY_DEFAULT_WALLET = 0x1804c8AB1F12E6bbf3894d4083f33e07309d1f38;
//     address constant ANVIL_DEFAULT_WALLET = 0x70997970C51812dc3A010C7d01b50e0d17dc79C8;

//     NetworkConfig public localNetworkConfig;
//     mapping(uint256 => NetworkConfig) public networkConfigs;

//     constructor() {
//         networkConfigs[ETH_SEPOLIA_CHAIN_ID] = getEthSepoliaConfig();
//     }

//     function getConfig() public returns (NetworkConfig memory) {
//         return getNetworkConfig(block.chainid);
//     }

//     function getNetworkConfig(uint256 chainId) public returns (NetworkConfig memory) {
//         if (chainId == LOCAL_CHAIN_ID) {
//             return getOrCreateAnvilEthConfig();
//         } else if (networkConfigs[chainId].account != address(0)) {
//             return networkConfigs[chainId];
//         } else {
//             revert HelperConfig_InvalidChainId();
//         }
//     }

//     function getEthSepoliaConfig() public returns (NetworkConfig memory) {
//         return NetworkConfig({entryPoint: 0x5FF137D4b0FDCD49DcA30c7CF57E578a026d2789, account: BURNER_WALLET});
//     }

//     function getZksyncSepoliaConfig() public pure returns (NetworkConfig memory) {
//         return NetworkConfig({entryPoint: address(0), account: BURNER_WALLET});
//     }

//     function getOrCreateAnvilEthConfig() public returns (NetworkConfig memory) {
//         if (localNetworkConfig.account != address(0)) {
//             return localNetworkConfig;
//         }

//         // deploying Mock EntryPoint contract
//         vm.startBroadcast(ANVIL_DEFAULT_WALLET);
//         EntryPoint entryPoint = new EntryPoint();
//         vm.stopBroadcast();

//         localNetworkConfig = NetworkConfig({entryPoint: address(entryPoint), account: ANVIL_DEFAULT_WALLET});
//         return localNetworkConfig;
//     }
// }
