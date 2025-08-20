import React from 'react';
import ReactDOM from 'react-dom/client';
import { WalletKitProvider } from '@mysten/wallet-kit';
import App from './App';

const root = ReactDOM.createRoot(document.getElementById('root'));
root.render(
  <WalletKitProvider>
    <App />
  </WalletKitProvider>
);