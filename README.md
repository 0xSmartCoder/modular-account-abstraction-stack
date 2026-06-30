# Account Abstraction Multichain Wallet

Ethereum
UserOperation
      │
      ▼
 EntryPoint
      │
      ▼
 MinimalAccount
      │
      ▼
 Smart Contract


zkSync
Transaction
      │
      ▼
 Bootloader
      │
      ▼
 ZkMinimalAccount
      │
      ▼
 Smart Contract

This project is a smart wallet built using Account Abstraction on both **Ethereum (ERC-4337)** and **zkSync**.

It allows users to interact with blockchain in a more flexible way using smart contract wallets instead of normal EOAs.

# Note

The Ethereum ERC-4337 implementation is temporarily disabled due to Foundry/zkSync compiler compatibility issues while both implementations are maintained in the same repository.

The zkSync native Account Abstraction implementation is fully functional and tested.

The repository will be split into separate Ethereum and zkSync implementations in a future update.
---

## 🚀 Features

- Smart contract wallet (Account Abstraction)
- Ethereum ERC-4337 support
- zkSync native Account Abstraction
- Gasless transactions (paymaster support)
- Modular wallet design
- Foundry-based testing

---

## 🧠 How it works

Instead of using a normal wallet (EOA), users interact through a **Smart Account**.

Flow:
User → UserOperation → EntryPoint → Smart Account → Execution

On zkSync, AA is handled natively by the protocol.

---

## 🛠 Tech Stack

- Solidity
- Foundry
- Ethereum (ERC-4337)
- zkSync Era
---


---

```md id="p9x4kd"
## ⚙️ Setup

```bash
forge install
forge build
forge test
```
## 👨‍💻 Built by
[Abdullah Amr](https://github.com/0xSmartCoder)
