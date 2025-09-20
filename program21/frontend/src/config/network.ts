import { getFullnodeUrl } from '@mysten/sui/client';
import { createNetworkConfig } from '@mysten/dapp-kit';

// Konfigurasi networks yang tersedia 
const { networkConfig, useNetworkVariable, useNetworkVariables } =
  createNetworkConfig({
    localnet: {
      url: getFullnodeUrl('localnet'),
      variables: {
        packageId: '0x0', // Ganti dengan package ID setelah deploy
      },
    },
    devnet: {
      url: getFullnodeUrl('devnet'),
      variables: {
        packageId: '0x0', // Ganti dengan package ID setelah deploy
      },
    },
    testnet: {
      url: getFullnodeUrl('testnet'),
      variables: {
        packageId: '0x267bccee2e5c3276ccdb8968a706b9112ae829137bf2f73be47dd462cc41b8c7', // Ganti dengan package ID setelah deploy
      },
    },
    mainnet: {
      url: getFullnodeUrl('mainnet'),
      variables: {
        packageId: '0x0', // Ganti dengan package ID setelah deploy
      },
    },
  });

export { useNetworkVariable, useNetworkVariables, networkConfig };