// //SPDX-License-Identifier: MIT
// pragma solidity ^0.8.28;

// import {IAccount} from "lib/account-abstraction/contracts/interfaces/IAccount.sol";
// import {PackedUserOperation} from "lib/account-abstraction/contracts/interfaces/PackedUserOperation.sol";
// import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
// import {MessageHashUtils} from "@openzeppelin/contracts/utils/cryptography/MessageHashUtils.sol";
// import {ECDSA} from "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
// import {SIG_VALIDATION_FAILED, SIG_VALIDATION_SUCCESS} from "lib/account-abstraction/contracts/core/Helpers.sol";
// import {IEntryPoint} from "lib/account-abstraction/contracts/interfaces/IEntryPoint.sol";

// contract MinimalAccount is IAccount, Ownable {
//     /*/////////////////////////////////////////////////////////
//                             ERRORS
//     /////////////////////////////////////////////////////////*/
//     error MinimalAccount_NotFromEntryPoint();
//     error MinimalAccount_NotFromEntryPointOrOwner();
//     error MinimalAccount_CallFailed(bytes);

//     /*/////////////////////////////////////////////////////////
//                            GLOBAL VARIABLES
//     /////////////////////////////////////////////////////////*/
//     IEntryPoint private immutable i_entryPoint;

//     /*/////////////////////////////////////////////////////////
//                             MODIFIERS
//     /////////////////////////////////////////////////////////*/
//     modifier requireFromEntryPoint() {
//         if (msg.sender != address(i_entryPoint)) {
//             revert MinimalAccount_NotFromEntryPoint();
//         }
//         _;
//     }

//     modifier requireFromEntryPointOrOwner() {
//         if (msg.sender != address(i_entryPoint) && msg.sender != owner()) {
//             revert MinimalAccount_NotFromEntryPointOrOwner();
//         }
//         _;
//     }

//     /*/////////////////////////////////////////////////////////
//                             FUNCTIONS
//     /////////////////////////////////////////////////////////*/
//     constructor(address _entryPoint) Ownable(msg.sender) {
//         i_entryPoint = IEntryPoint(_entryPoint);
//     }

//     receive() external payable {}

//     /*/////////////////////////////////////////////////////////
//                         EXTERNAL FUNCTIONS
//     /////////////////////////////////////////////////////////*/
//     function validateUserOp(PackedUserOperation calldata userOp, bytes32 userOpHash, uint256 missingAccountFunds)
//         external
//         requireFromEntryPoint
//         returns (uint256 validationData)
//     {
//         validationData = _validateSignature(userOp, userOpHash);
//         _payRefund(missingAccountFunds);
//         return validationData;
//     }

//     function _validateSignature(PackedUserOperation calldata userOp, bytes32 userOpHash)
//         internal
//         view
//         returns (uint256)
//     {
//         bytes32 ethSignedMessage = MessageHashUtils.toEthSignedMessageHash(userOpHash);
//         address signer = ECDSA.recover(ethSignedMessage, userOp.signature);
//         if (signer != owner()) {
//             return SIG_VALIDATION_FAILED;
//         }
//         return SIG_VALIDATION_SUCCESS;
//     }

//     function _payRefund(uint256 missingAccountFunds) internal {
//         if (missingAccountFunds != 0) {
//             (bool success,) = payable(msg.sender).call{value: missingAccountFunds, gas: type(uint256).max}("");
//             (success);
//         }
//     }

//     function execute(address destination, uint256 amount, bytes memory functionData)
//         external
//         requireFromEntryPointOrOwner
//     {
//         (bool success, bytes memory result) = destination.call{value: amount}(functionData);
//         require(success, "EXEC_FAILED");
//         if (!success) {
//             revert MinimalAccount_CallFailed(result);
//         }
//     }

//     /*/////////////////////////////////////////////////////////
//                             GETTERS
//     /////////////////////////////////////////////////////////*/
//     function getEntryPoint() external view returns (address) {
//         return address(i_entryPoint);
//     }
// }
