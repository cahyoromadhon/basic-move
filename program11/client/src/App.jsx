import { useState } from 'react';
import { ConnectButton, useCurrentAccount, useSignAndExecuteTransaction } from '@mysten/dapp-kit';
import { Transaction } from '@mysten/sui/transactions';
import './index.css';

const PACKAGE_ID = 0xd211fc49ba783ec48c8106fa7641911bce1b1a7524f6fd21d7a0b81e02053bd3; // Ganti dengan Package ID
const OBJECT_ID = 0x946a627e202cb3430a28fc817b1ffdad8ae99e04117ab96e8533296d0e7fb51d;   // Ganti dengan Object ID

function App() {
  const currentAccount = useCurrentAccount();
  const { mutate: signAndExecute } = useSignAndExecuteTransaction();
  const [message, setMessage] = useState('');
  const [storedMessage, setStoredMessage] = useState('');

  const createMessage = async () => {
    if (!currentAccount) {
      alert("Please connect wallet first!");
      return;
    }
    const tx = new Transaction();
    tx.moveCall({
      target: `${PACKAGE_ID}::storage::create_message`,
      arguments: [tx.pure.string(message)],
    });
    signAndExecute(
      { transaction: tx },
      {
        onSuccess: (result) => {
          console.log("Create Result:", result);
          alert("Message created!");
        },
        onError: (error) => {
          console.error("Error creating message:", error);
          alert("Failed to create message: " + error.message);
        },
      }
    );
  };

  const updateMessage = async () => {
    if (!currentAccount) {
      alert("Please connect wallet first!");
      return;
    }
    const tx = new Transaction();
    tx.moveCall({
      target: `${PACKAGE_ID}::storage::update_message`,
      arguments: [tx.object(OBJECT_ID), tx.pure.string(message)],
    });
    signAndExecute(
      { transaction: tx },
      {
        onSuccess: (result) => {
          console.log("Update Result:", result);
          alert("Message updated!");
        },
        onError: (error) => {
          console.error("Error updating message:", error);
          alert("Failed to update message: " + error.message);
        },
      }
    );
  };

  const getMessage = async () => {
    try {
      const response = await fetch(getFullnodeUrl('testnet'), {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          jsonrpc: '2.0',
          id: 1,
          method: 'sui_getObject',
          params: [OBJECT_ID, { showContent: true }],
        }),
      });
      const { result } = await response.json();
      const message = result.data.content.fields.message;
      setStoredMessage(message);
    } catch (error) {
      console.error("Error getting message:", error);
      alert("Failed to get message: " + error.message);
    }
  };

  return (
    <div className="container">
      <h1>Sui Simple Storage</h1>
      <ConnectButton connectText="Connect Wallet" />
      <div>
        <input
          type="text"
          placeholder="Enter message"
          value={message}
          onChange={(e) => setMessage(e.target.value)}
        />
        <button onClick={createMessage} disabled={!currentAccount}>
          Create
        </button>
        <button onClick={updateMessage} disabled={!currentAccount}>
          Update
        </button>
        <button onClick={getMessage}>Get</button>
      </div>
      <p>Stored Message: {storedMessage}</p>
    </div>
  );
}

export default App;