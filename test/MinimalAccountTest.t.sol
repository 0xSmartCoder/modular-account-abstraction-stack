// // SPDX-License-Identifier: MIT
// pragma solidity ^0.8.28;

// import {DeployMinimal} from "../script/DeployMinimal.s.sol";
// import {HelperConfig} from "../script/HelperConfig.s.sol";
// import {ECDSA} from "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
// import {MinimalAccount} from "../src/ethereum/MinimalAccount.sol";
// import {Test} from "lib/forge-std/src/Test.sol";
// import {
//     MessageHashUtils
// } from "@openzeppelin/contracts/utils/cryptography/MessageHashUtils.sol";
// import {
//     IEntryPoint
// } from "lib/account-abstraction/contracts/interfaces/IEntryPoint.sol";
// import {ERC20Mock} from "@openzeppelin/contracts/mocks/token/ERC20Mock.sol";
// import {
//     SendPackedOperation,
//     PackedUserOperation
// } from "../script/SendPackedUserOp.s.sol";

// contract MinimalAccountTest is Test {
//     using MessageHashUtils for bytes32;

//     HelperConfig helperConfig;
//     MinimalAccount minimalAccount;
//     SendPackedOperation sendPackedUserOp;
//     ERC20Mock usdc;
//     uint256 Amount = 1e18;
//     address randomUser = makeAddr("randomUser");

//     function setUp() public {
//         DeployMinimal deployMinimal = new DeployMinimal();
//         (helperConfig, minimalAccount) = deployMinimal.deployMinimalAccount();
//         usdc = new ERC20Mock();
//         sendPackedUserOp = new SendPackedOperation();
//     }

//     function testOwnerCanExecuteAmount() public {
//         // mint
//         // USDC approval
//         assertEq(usdc.balanceOf(address(minimalAccount)), 0);
//         address des = address(usdc);
//         bytes memory functionData = abi.encodeWithSelector(
//             ERC20Mock.mint.selector,
//             address(minimalAccount),
//             Amount
//         );
//         uint256 value = 0;
//         vm.prank(minimalAccount.owner());
//         minimalAccount.execute(des, value, functionData);
//         assertEq(usdc.balanceOf(address(minimalAccount)), Amount);
//     }

//     function testNonOwnerCannotExecuteAmount() public {
//         // mint
//         // USDC approval
//         assertEq(usdc.balanceOf(address(minimalAccount)), 0);
//         address des = address(usdc);
//         bytes memory functionData = abi.encodeWithSelector(
//             ERC20Mock.mint.selector,
//             address(minimalAccount),
//             Amount
//         );
//         uint256 value = 0;
//         vm.prank(randomUser);
//         vm.expectRevert(
//             MinimalAccount.MinimalAccount_NotFromEntryPointOrOwner.selector
//         );
//         minimalAccount.execute(des, value, functionData);
//     }

//     function testRecoverSignedOp() public {
//         assertEq(usdc.balanceOf(address(minimalAccount)), 0);
//         address des = address(usdc);
//         bytes memory functionData = abi.encodeWithSelector(
//             ERC20Mock.mint.selector,
//             address(minimalAccount),
//             Amount
//         );
//         uint256 value = 0;
//         bytes memory executeCalldata = abi.encodeWithSelector(
//             MinimalAccount.execute.selector,
//             des,
//             value,
//             functionData
//         );

//         PackedUserOperation memory packedUserOperation = sendPackedUserOp
//             .generatedSignedOperation(
//                 executeCalldata,
//                 address(minimalAccount),
//                 helperConfig.getConfig()
//             );

//         bytes32 userOperationHash = IEntryPoint(
//             helperConfig.getConfig().entryPoint
//         ).getUserOpHash(packedUserOperation);

//         address actualSigner = ECDSA.recover(
//             userOperationHash.toEthSignedMessageHash(),
//             packedUserOperation.signature
//         );

//         assertEq(actualSigner, minimalAccount.owner());
//     }

//     function testValidationOfUserOp() public {
//         assertEq(usdc.balanceOf(address(minimalAccount)), 0);
//         address des = address(usdc);
//         bytes memory functionData = abi.encodeWithSelector(
//             ERC20Mock.mint.selector,
//             address(minimalAccount),
//             Amount
//         );
//         uint256 value = 0;
//         bytes memory executeCalldata = abi.encodeWithSelector(
//             MinimalAccount.execute.selector,
//             des,
//             value,
//             functionData
//         );

//         PackedUserOperation memory packedUserOperation = sendPackedUserOp
//             .generatedSignedOperation(
//                 executeCalldata,
//                 address(minimalAccount),
//                 helperConfig.getConfig()
//             );

//         bytes32 userOperationHash = IEntryPoint(
//             helperConfig.getConfig().entryPoint
//         ).getUserOpHash(packedUserOperation);

//         // act
//         uint256 missingAccountFunds = 1e18;
//         vm.prank(helperConfig.getConfig().entryPoint);
//         uint256 validationData = minimalAccount.validateUserOp(
//             packedUserOperation,
//             userOperationHash,
//             missingAccountFunds
//         );

//         assertEq(validationData, 0);
//     }

//     function testEntryPointCanExecuteCommand() public {
//         assertEq(usdc.balanceOf(address(minimalAccount)), 0);
//         address des = address(usdc);
//         bytes memory functionData = abi.encodeWithSelector(
//             ERC20Mock.mint.selector,
//             address(minimalAccount),
//             Amount
//         );
//         uint256 value = 0;
//         bytes memory executeCalldata = abi.encodeWithSelector(
//             MinimalAccount.execute.selector,
//             des,
//             value,
//             functionData
//         );

//         PackedUserOperation memory packedUserOperation = sendPackedUserOp
//             .generatedSignedOperation(
//                 executeCalldata,
//                 address(minimalAccount),
//                 helperConfig.getConfig()
//             );

//         vm.deal(address(minimalAccount), 1e18);
//         PackedUserOperation[] memory ops = new PackedUserOperation[](1);
//         ops[0] = packedUserOperation;
//         // vm.prank(randomUser);
//         IEntryPoint(helperConfig.getConfig().entryPoint).handleOps(
//             ops,
//             payable(randomUser)
//         );
//         assertEq(usdc.balanceOf(address(minimalAccount)), 1e18);
//     }
// }
