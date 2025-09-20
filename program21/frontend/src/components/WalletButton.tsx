import { 
  useCurrentAccount, 
  useDisconnectWallet,
  ConnectButton
} from '@mysten/dapp-kit';

const WalletButton = () => {
  const currentAccount = useCurrentAccount();
  const { mutate: disconnect } = useDisconnectWallet();

  const formatAddress = (address: string) => {
    return `${address.slice(0, 6)}...${address.slice(-4)}`;
  };

  if (!currentAccount) {
    return (
      <div className="wallet-connect-wrapper">
        <ConnectButton />
      </div>
    );
  }

  return (
    <div className="wallet-connected-wrapper">
      <div className="wallet-info">
        <div className="wallet-address">
          {formatAddress(currentAccount.address)}
        </div>
        <button 
          onClick={() => disconnect()}
          className="disconnect-btn"
          title="Disconnect Wallet"
        >
          <svg width="16" height="16" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
            <path d="M9 21H5a2 2 0 01-2-2V5a2 2 0 012-2h4m7 14l5-5-5-5m5 5H9" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"/>
          </svg>
        </button>
      </div>
    </div>
  );
};

export default WalletButton;