# Distributed Counter dApp

A decentralized counter application built on the Sui blockchain that demonstrates shared object functionality. This dApp allows multiple users to interact with a shared counter object, performing increment, decrement, and reset operations.

## Features

- **Shared Counter Object**: Multiple users can interact with the same counter
- **Increment/Decrement**: Change the counter value by +1 or -1
- **Reset Functionality**: Reset counter to 0 (owner-only operation)
- **Real-time Updates**: UI updates automatically after transactions
- **Wallet Integration**: Connect with Sui-compatible wallets

## Tech Stack

- [React](https://react.dev/) - UI framework
- [TypeScript](https://www.typescriptlang.org/) - Type safety
- [Vite](https://vitejs.dev/) - Build tooling
- [Radix UI](https://www.radix-ui.com/) - UI components
- [Move](https://docs.sui.io/concepts/sui-move-concepts) - Smart contract language
- [`@mysten/dapp-kit`](https://sdk.mystenlabs.com/dapp-kit) - Sui wallet integration
- [pnpm](https://pnpm.io/) - Package management

## Smart Contract Functions

The Move smart contract (`distributed_counter.move`) provides:
- `create()` - Creates a new shared counter object
- `increment()` - Increases counter value by 1
- `decrement()` - Decreases counter value by 1
- `view()` - Returns current counter value
- `set_value()` - Sets counter to specific value (owner only)

## Getting Started

### Prerequisites

Before deploying your Move code, ensure you have:
- [Sui CLI](https://docs.sui.io/build/install) installed
- A Sui wallet with testnet SUI tokens
- Node.js and pnpm installed

### Environment Setup

This project uses `testnet` by default. Set up your Sui CLI environment:

```bash
# Add testnet environment
sui client new-env --alias testnet --rpc https://fullnode.testnet.sui.io:443
sui client switch --env testnet

# Create new address if needed
sui client new-address secp256k1
sui client switch --address 0xYOUR_ADDRESS...
```

Get testnet SUI tokens from the [Sui Faucet](https://faucet.sui.io).

### Deploy the Smart Contract

Navigate to the project root and publish the Move package:

```bash
# From project root directory
sui client publish --gas-budget 100000000 sources
```

After successful deployment, you'll see output containing a `packageId`. Copy this value and update `src/constants.ts`:

```ts
export const TESTNET_COUNTER_PACKAGE_ID = "YOUR_PACKAGE_ID_HERE";
```

### Install Dependencies

```bash
cd frontend
pnpm install
```

### Run the Development Server

```bash
pnpm dev
```

The dApp will be available at `http://localhost:5173`

## Usage

1. **Connect Wallet**: Click the connect wallet button
2. **Create Counter**: Use the "Create Counter" button to deploy a new shared counter
3. **Interact with Counter**: 
   - Click "Increment" to add 1
   - Click "Decrement" to subtract 1
   - Click "Reset" to set counter to 0 (only available to counter owner)

## Building for Production

```bash
pnpm build
```

## Project Structure

```
program26/
├── sources/
│   └── program26.move          # Main Move smart contract
├── frontend/
│   ├── src/
│   │   ├── Counter.tsx         # Counter display and interaction component
│   │   ├── CreateCounter.tsx   # Counter creation component
│   │   ├── constants.ts        # Package ID configuration
│   │   └── networkConfig.ts    # Network configuration
│   └── package.json
└── Move.toml                   # Move package configuration
```

## Learn More

- [Sui Documentation](https://docs.sui.io/)
- [Move Language Guide](https://docs.sui.io/concepts/sui-move-concepts)
- [Sui dApp Kit](https://sdk.mystenlabs.com/dapp-kit)
- [Sui TypeScript SDK](https://sdk.mystenlabs.com/typescript)
