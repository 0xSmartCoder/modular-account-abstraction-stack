# Account Abstraction Multichain Wallet

This project is a smart wallet built using Account Abstraction on both **Ethereum (ERC-4337)** and **zkSync**.

It allows users to interact with blockchain in a more flexible way using smart contract wallets instead of normal EOAs.

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

## 👨‍💻 Built by
[Abdullah Amr](https://github.com/0xSmartCoder)
