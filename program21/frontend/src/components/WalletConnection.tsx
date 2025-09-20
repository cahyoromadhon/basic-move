import { 
  useCurrentAccount, 
  useConnectWallet, 
  useDisconnectWallet,
  ConnectButton,
  useWallets
} from '@mysten/dapp-kit';

const WalletConnection = () => {
  const currentAccount = useCurrentAccount();
  const { mutate: connect } = useConnectWallet();
  const { mutate: disconnect } = useDisconnectWallet();
  const wallets = useWallets();

  return (
    <div className="wallet-section">
      <h2>Koneksi Wallet</h2>
      
      {!currentAccount ? (
        <div className="wallet-connect">
          <p>Silahkan connect wallet Sui untuk melanjutkan</p>
          
          {/* Tombol connect otomatis dari dapp-kit */}
          <ConnectButton />
          
          {/* Atau buat tombol manual */}
          <div className="manual-connect" style={{ marginTop: '10px' }}>
            <p>Atau pilih wallet secara manual:</p>
            {wallets.map((wallet) => (
              <button
                key={wallet.name}
                onClick={() => connect({ wallet })}
                className="wallet-button"
                style={{ 
                  margin: '5px',
                  padding: '10px 15px',
                  backgroundColor: '#4CAF50',
                  color: 'white',
                  border: 'none',
                  borderRadius: '5px',
                  cursor: 'pointer'
                }}
              >
                Connect {wallet.name}
              </button>
            ))}
          </div>
        </div>
      ) : (
        <div className="wallet-connected">
          <p>✅ Wallet terhubung!</p>
          <div className="account-info">
            <p><strong>Address:</strong></p>
            <code style={{ 
              backgroundColor: '#f5f5f5', 
              padding: '5px',
              borderRadius: '3px',
              fontSize: '14px',
              wordBreak: 'break-all'
            }}>
              {currentAccount.address}
            </code>
          </div>
          
          <button
            onClick={() => disconnect()}
            className="disconnect-button"
            style={{
              marginTop: '10px',
              padding: '10px 15px',
              backgroundColor: '#f44336',
              color: 'white',
              border: 'none',
              borderRadius: '5px',
              cursor: 'pointer'
            }}
          >
            Disconnect Wallet
          </button>
        </div>
      )}
    </div>
  );
};

export default WalletConnection;