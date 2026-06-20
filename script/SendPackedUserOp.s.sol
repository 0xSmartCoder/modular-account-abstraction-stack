// // SPDX-License-Identifier: MIT
// pragma solidity ^0.8.28;

// import {Script} from "lib/forge-std/src/Script.sol";
// import {MessageHashUtils} from "@openzeppelin/contracts/utils/cryptography/MessageHashUtils.sol";
// import {PackedUserOperation} from "lib/account-abstraction/contracts/interfaces/PackedUserOperation.sol";
// import {IEntryPoint} from "lib/account-abstraction/contracts/interfaces/IEntryPoint.sol";
// import {HelperConfig} from "./HelperConfig.s.sol";
// import {IERC20} from "@openzeppelin/contracts/interfaces/IERC20.sol";
// import {MinimalAccount} from "../src/ethereum/MinimalAccount.sol";

// contract SendPackedOperation is Script {
//     using MessageHashUtils for bytes32;

//     function run() public {
//         HelperConfig helperConfig = new HelperConfig();
//         address des = 0xf08A50178dfcDe18524640EA6618a1f965821715;
//         address minimalAcc = 0x7EC6b3Eba4116B1af77Ca742cDe7D9428ffC367A;
//         uint256 value = 0;
//         bytes memory functionData = abi.encodeWithSelector(IERC20.approve.selector, minimalAcc, 1e18);
//         bytes memory ececuteCallData = abi.encodeWithSelector(MinimalAccount.execute.selector, des, value, functionData);

//         PackedUserOperation memory userOp =
//             generatedSignedOperation(ececuteCallData, minimalAcc, helperConfig.getConfig());

//         PackedUserOperation[] memory ops = new PackedUserOperation[](1);
//         ops[0] = userOp;

//         vm.startBroadcast();
//         IEntryPoint(helperConfig.getConfig().entryPoint).handleOps(ops, payable(helperConfig.getConfig().account));
//     }

//     function generatedSignedOperation(
//         bytes memory data,
//         address minimalAccount,
//         HelperConfig.NetworkConfig memory config
//     ) public returns (PackedUserOperation memory) {
//         // uint256 nonce = vm.getNonce(config.account);
//         uint256 nonce = IEntryPoint(config.entryPoint).getNonce(minimalAccount, 0);
//         PackedUserOperation memory userOp = generateUnsignedUserOperation(data, minimalAccount, nonce);
//         bytes32 userOpHash = IEntryPoint(config.entryPoint).getUserOpHash(userOp);
//         bytes32 digest = userOpHash.toEthSignedMessageHash();
//         uint8 v;
//         bytes32 r;
//         bytes32 s;
//         if (block.chainid == 31337) {
//             uint256 ANVIL_DEFAULT_KEY = 0x59c6995e998f97a5a0044966f0945389dc9e86dae88c7a8412f4603b6b78690d;
//             (v, r, s) = vm.sign(ANVIL_DEFAULT_KEY, digest);
//         } else {
//             uint256 pk = vm.envUint("PRIVATE_KEY");
//             (v, r, s) = vm.sign(pk, digest);
//         }
//         userOp.signature = abi.encodePacked(r, s, v);
//         return userOp;
//     }

//     function generateUnsignedUserOperation(bytes memory data, address sender, uint256 nonce)
//         public
//         returns (PackedUserOperation memory)
//     {
//         uint128 verificationGasLimit = 300000;
//         uint128 callGasLimit = 200000;
//         uint128 preVerificationGas = 100000;
//         uint128 maxPriorityFeePerGas = 1 gwei;
//         uint128 maxFeePerGas = 20 gwei;
//         return (PackedUserOperation({
//                 sender: sender,
//                 nonce: nonce,
//                 initCode: hex"",
//                 callData: data,
//                 accountGasLimits: bytes32((uint256(verificationGasLimit) << 128) | callGasLimit),
//                 preVerificationGas: preVerificationGas,
//                 gasFees: bytes32((uint256(maxFeePerGas) << 128) | maxPriorityFeePerGas),
//                 paymasterAndData: hex"",
//                 signature: hex""
//             }));
//     }
// }
