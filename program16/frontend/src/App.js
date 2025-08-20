import React, { useState, useEffect } from 'react';
import { getFullnodeUrl, SuiClient } from '@mysten/sui/client';
import { useWalletKit } from '@mysten/wallet-kit';

const App = () => {
  const { currentWallet, signAndExecuteTransactionBlock } = useWalletKit();
  const client = new SuiClient({ url: getFullnodeUrl('testnet') });
  const [value, setValue] = useState(0);

  // Ganti dengan Package ID dan Object ID dari publish smart contract
  const packageId = '0xfdb0e544a8bb9a4f7d3bd7f09ae80b30ea947cec74b6ea214a1d9233488b75c5'; // Masukkan Package ID
  const objectId = '0x54f5d1a8bdb0452fab52c26bd8f659747c85ad3ce6dd233560319bc80f2fc709'; // Masukkan Object ID

  // Query nilai counter dari blockchain
  const fetchValue = async () => {
    try {
      const obj = await client.getObject({ id: objectId, options: { showContent: true } });
      setValue(obj.data.content.fields.value || 0);
    } catch (error) {
      console.error('Error fetching value:', error);
    }
  };

  // Call fungsi increment di smart contract
  const incrementCounter = async () => {
    if (!currentWallet) {
      alert('Please connect wallet first!');
      return;
    }
    try {
      const tx = {
        kind: 'TransactionKind',
        transaction: {
          kind: 'ProgrammableTransaction',
          transactions: [
            {
              kind: 'MoveCall',
              target: `${packageId}::counter::increment`,
              arguments: [{ kind: 'Input', value: objectId, type: 'object' }],
              typeArguments: [],
            },
          ],
        },
      };
      await signAndExecuteTransactionBlock({ transactionBlock: tx });
      fetchValue(); // Update UI setelah increment
    } catch (error) {
      console.error('Error incrementing counter:', error);
    }
  };

  // Load nilai awal saat komponen mount
  useEffect(() => {
    fetchValue();
  }, []);

  return (
    <div style={{ padding: '20px' }}>
      <h1>Sui Counter: {value}</h1>
      <button onClick={fetchValue}>Refresh Value</button>
      <button onClick={incrementCounter} disabled={!currentWallet}>
        {currentWallet ? 'Increment' : 'Connect Wallet First'}
      </button>
    </div>
  );
};

export default App;