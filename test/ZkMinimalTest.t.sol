// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {Test} from "lib/forge-std/src/Test.sol";
import {ERC20Mock} from "@openzeppelin/contracts/mocks/token/ERC20Mock.sol";
import {   MemoryTransactionHelper
} from "lib/foundry-era-contracts/src/system-contracts/contracts/libraries/MemoryTransactionHelper.sol";
import {ACCOUNT_VALIDATION_SUCCESS_MAGIC} from "lib/foundry-era-contracts/src/system-contracts/contracts/interfaces/IAccount.sol";

import {
    BOOTLOADER_FORMAL_ADDRESS
} from "lib/foundry-era-contracts/src/system-contracts/contracts/Constants.sol";
import {
    Transaction
} from "lib/foundry-era-contracts/src/system-contracts/contracts/libraries/MemoryTransactionHelper.sol";
import {ZkMinimalAccount} from "../src/zkSync/ZkMinimalAccount.sol";

contract ZkMinimalTest is Test {
    ZkMinimalAccount minimalAccount;
    uint256 Amount = 1e18;
    bytes32 constant BYTES = bytes32(0);
        address constant ANVIL_DEFAULT_WALLET = 0x70997970C51812dc3A010C7d01b50e0d17dc79C8;

    ERC20Mock usdc;

    function setUp() public {
        usdc = new ERC20Mock();
        minimalAccount = new ZkMinimalAccount();
        minimalAccount.transferOwnership(ANVIL_DEFAULT_WALLET);
    }

    function testZkOwnerCanExecuteCommands() public {
        address to = address(usdc);
        uint256 value = 0;
        bytes memory functionData = abi.encodeWithSelector(
            ERC20Mock.mint.selector,
            address(minimalAccount),
            Amount
        );

        Transaction memory _transaction = _createUnsignedTransaction(
            address(minimalAccount.owner()),
            113,
            address(usdc),
            value,
            functionData
        );

        vm.prank(address(minimalAccount.owner()));
        minimalAccount.executeTransaction(BYTES, BYTES, _transaction);
        assertEq(usdc.balanceOf(address(minimalAccount)), Amount);
    }

    function signedTx(Transaction memory _transaction) public returns(Transaction memory){
        bytes32 hash = MemoryTransactionHelper.encodeHash(_transaction);
        uint8 v;
        bytes32 r;
        bytes32 s;
        uint256 ANVIL_DEFAULT_KEY = 0x59c6995e998f97a5a0044966f0945389dc9e86dae88c7a8412f4603b6b78690d;
        (v, r, s) = vm.sign(ANVIL_DEFAULT_KEY, hash);
        Transaction memory signedTransaction = _transaction;
        signedTransaction.signature = abi.encodePacked(r, s, v);
        return signedTransaction;
    }

    function testZkValidateTransaction() public {
        vm.deal(address(minimalAccount), 2e18);
         address to = address(usdc);
        uint256 value = 0;
        bytes memory functionData = abi.encodeWithSelector(
            ERC20Mock.mint.selector,
            address(minimalAccount),
            Amount
        );

        Transaction memory _transaction = _createUnsignedTransaction(
            address(minimalAccount.owner()),
            113,
            address(usdc),
            value,
            functionData
        );
        _transaction = signedTx(_transaction);

        vm.prank(BOOTLOADER_FORMAL_ADDRESS);
        bytes4 magic = minimalAccount.validateTransaction(BYTES, BYTES, _transaction);
        assertEq(magic, ACCOUNT_VALIDATION_SUCCESS_MAGIC);

    }

    function _createUnsignedTransaction(
        address from,
        uint8 txType,
        address to,
        uint256 value,
        bytes memory data
) internal returns (Transaction memory) {
        uint256 _nonce = vm.getNonce(address(minimalAccount));
        bytes32[] memory _factoryDeps = new bytes32[](1);
        return (Transaction({
            txType: txType,
            from: uint256(uint160(from)),
            to: uint256(uint160(to)),
            gasLimit: 1611125,
            gasPerPubdataByteLimit: 1611125,
            maxFeePerGas: 1611125,
            maxPriorityFeePerGas: 1611125,
            paymaster: 0,
            nonce: _nonce,
            value: value,
            reserved: [uint256(0), uint256(0), uint256(0), uint256(0)],
            data: data,
            signature: hex"",
            factoryDeps: _factoryDeps,
            paymasterInput: hex"",
            reservedDynamic: hex""
        }));
    }
}
