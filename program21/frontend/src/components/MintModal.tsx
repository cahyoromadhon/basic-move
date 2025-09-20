import { useState } from 'react';
import { 
  useCurrentAccount, 
  useSignAndExecuteTransaction 
} from '@mysten/dapp-kit';
import { Transaction } from '@mysten/sui/transactions';
import { useNetworkVariable } from '../config/network';

interface MintModalProps {
  isOpen: boolean;
  onClose: () => void;
}

const MintModal = ({ isOpen, onClose }: MintModalProps) => {
  const currentAccount = useCurrentAccount();
  const packageId = useNetworkVariable('packageId');
  const { mutate: signAndExecute } = useSignAndExecuteTransaction();
  
  const [nftData, setNftData] = useState({
    nama: '',
    deskripsi: '',
    url: ''
  });
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const handleMintNFT = async () => {
    if (!currentAccount || !nftData.nama || !nftData.deskripsi || !nftData.url) {
      setError('Pastikan semua field sudah diisi!');
      return;
    }

    if (packageId === '0x0') {
      setError('Package ID belum dikonfigurasi. Silahkan deploy smart contract terlebih dahulu.');
      return;
    }

    setIsLoading(true);
    setError(null);

    try {
      const txb = new Transaction();
      
      txb.moveCall({
        target: `${packageId}::mintnft::mint`,
        arguments: [
          txb.pure.string(nftData.nama),
          txb.pure.string(nftData.deskripsi),
          txb.pure.string(nftData.url),
        ],
      });

      signAndExecute(
        { transaction: txb },
        {
          onSuccess: (result) => {
            console.log('NFT berhasil dimint!', result);
            setNftData({ nama: '', deskripsi: '', url: '' });
            onClose();
            // Show success notification
            alert('🎉 NFT berhasil dimint!');
          },
          onError: (error) => {
            console.error('Error minting NFT:', error);
            setError('Error: ' + error.message);
          },
        }
      );
    } catch (error) {
      console.error('Error:', error);
      setError('Error: ' + (error as Error).message);
    } finally {
      setIsLoading(false);
    }
  };

  if (!isOpen) return null;

  return (
    <div className="modal-overlay" onClick={onClose}>
      <div className="modal-container" onClick={(e) => e.stopPropagation()}>
        <div className="modal-header">
          <h2>Mint Your NFT</h2>
          <button className="modal-close" onClick={onClose}>
            <svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
              <path d="M18 6L6 18M6 6l12 12" stroke="currentColor" strokeWidth="2" strokeLinecap="round"/>
            </svg>
          </button>
        </div>

        <div className="modal-body">
          {error && (
            <div className="error-message">
              <svg width="20" height="20" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                <circle cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="2"/>
                <path d="M15 9l-6 6M9 9l6 6" stroke="currentColor" strokeWidth="2" strokeLinecap="round"/>
              </svg>
              {error}
            </div>
          )}

          <div className="form-group">
            <label htmlFor="nama">NFT Name</label>
            <input
              id="nama"
              type="text"
              value={nftData.nama}
              onChange={(e) => setNftData({ ...nftData, nama: e.target.value })}
              placeholder="Enter your NFT name"
              className="form-input"
            />
          </div>

          <div className="form-group">
            <label htmlFor="deskripsi">Description</label>
            <textarea
              id="deskripsi"
              value={nftData.deskripsi}
              onChange={(e) => setNftData({ ...nftData, deskripsi: e.target.value })}
              placeholder="Describe your NFT"
              className="form-textarea"
              rows={3}
            />
          </div>

          <div className="form-group">
            <label htmlFor="url">Image URL</label>
            <input
              id="url"
              type="url"
              value={nftData.url}
              onChange={(e) => setNftData({ ...nftData, url: e.target.value })}
              placeholder="https://example.com/image.jpg"
              className="form-input"
            />
          </div>

          {/* Preview */}
          {nftData.url && (
            <div className="image-preview">
              <img 
                src={nftData.url} 
                alt="NFT Preview" 
                onError={(e) => {
                  (e.target as HTMLImageElement).style.display = 'none';
                }}
              />
            </div>
          )}
        </div>

        <div className="modal-footer">
          <button 
            className="btn-secondary" 
            onClick={onClose}
            disabled={isLoading}
          >
            Cancel
          </button>
          <button 
            className="btn-primary" 
            onClick={handleMintNFT}
            disabled={isLoading || !nftData.nama || !nftData.deskripsi || !nftData.url}
          >
            {isLoading ? (
              <>
                <div className="spinner"></div>
                Minting...
              </>
            ) : (
              'Mint NFT'
            )}
          </button>
        </div>
      </div>
    </div>
  );
};

export default MintModal;