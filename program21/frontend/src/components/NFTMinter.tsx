import { useState, useEffect } from 'react';
import { 
  useCurrentAccount, 
  useSignAndExecuteTransaction,
  useDisconnectWallet,
  ConnectButton
} from '@mysten/dapp-kit';
import { Transaction } from '@mysten/sui/transactions';
import { useNetworkVariable } from '../config/network';

const NFTMinter = () => {
  const currentAccount = useCurrentAccount();
  const packageId = useNetworkVariable('packageId');
  const { mutate: signAndExecute } = useSignAndExecuteTransaction();
  const { mutate: disconnect } = useDisconnectWallet();
  
  const [nftData, setNftData] = useState({
    nama: '',
    deskripsi: '',
    url: ''
  });
  const [isLoading, setIsLoading] = useState(false);
  const [showSuccessModal, setShowSuccessModal] = useState(false);
  const [transactionHash, setTransactionHash] = useState<string>('');
  const [isExpanded, setIsExpanded] = useState(false);
  const [imageFile, setImageFile] = useState<File | null>(null);
  const [imageUrl, setImageUrl] = useState('');
  const [isUploading, setIsUploading] = useState(false);
  const [previewUrl, setPreviewUrl] = useState<string | null>(null);

  // Cleanup preview URL when component unmounts
  useEffect(() => {
    return () => {
      if (previewUrl) {
        URL.revokeObjectURL(previewUrl);
      }
    };
  }, []);

  const formatAddress = (address: string) => {
    return `${address.slice(0, 6)}...${address.slice(-4)}`;
  };

  const handleViewTransaction = () => {
    if (transactionHash) {
      window.open(`https://testnet.suivision.xyz/txblock/${transactionHash}`, '_blank');
      setShowSuccessModal(false);
    }
  };

  const handleCloseModal = () => {
    setShowSuccessModal(false);
  };



  const handleImageUpload = async (file: File) => {
    if (!file) return;
    
    // Validate file size (max 10MB for better compatibility)
    if (file.size > 10 * 1024 * 1024) {
      alert('File size too large. Please use a file smaller than 10MB.');
      return;
    }
    
    // Validate file type
    if (!file.type.startsWith('image/')) {
      alert('Please select a valid image file.');
      return;
    }
    
    // Create preview URL for the image
    const preview = URL.createObjectURL(file);
    setPreviewUrl(preview);
    
    setIsUploading(true);
    
    try {
      // Method 1: Try direct upload with CORS proxy
      let uploadUrl = '';
      
      try {
        console.log('Trying catbox.moe via CORS proxy...');
        
        const formData = new FormData();
        formData.append('reqtype', 'fileupload');
        formData.append('fileToUpload', file);
        
        // Using CORS proxy service
        const proxyUrl = 'https://api.allorigins.win/raw?url=';
        const targetUrl = encodeURIComponent('https://catbox.moe/user/api.php');
        
        const response = await fetch(proxyUrl + targetUrl, {
          method: 'POST',
          body: formData,
        });
        
        if (response.ok) {
          const responseText = await response.text();
          console.log('Proxy response:', responseText);
          
          if (responseText && responseText.includes('files.catbox.moe')) {
            uploadUrl = responseText.trim();
          }
        }
      } catch (proxyError) {
        console.log('Proxy method failed:', proxyError);
      }
      
      // Method 2: Fallback to temporary file hosting
      if (!uploadUrl) {
        try {
          console.log('Trying alternative upload service...');
          
          const formData = new FormData();
          formData.append('file', file);
          
          // Using temporary file hosting service
          const response = await fetch('https://tmpfiles.org/api/v1/upload', {
            method: 'POST',
            body: formData,
          });
          
          const data = await response.json();
          if (data.status === 'success') {
            // Convert to direct link
            uploadUrl = data.data.url.replace('tmpfiles.org/', 'tmpfiles.org/dl/');
            console.log('Alternative upload successful:', uploadUrl);
          }
        } catch (altError) {
          console.log('Alternative method failed:', altError);
        }
      }
      
      // Method 3: Use 0x0.st as last resort
      if (!uploadUrl) {
        try {
          console.log('Trying 0x0.st upload...');
          
          const formData = new FormData();
          formData.append('file', file);
          
          const response = await fetch('https://0x0.st', {
            method: 'POST',
            body: formData,
          });
          
          if (response.ok) {
            uploadUrl = await response.text();
            uploadUrl = uploadUrl.trim();
            console.log('0x0.st upload successful:', uploadUrl);
          }
        } catch (zeroError) {
          console.log('0x0.st method failed:', zeroError);
        }
      }
      
      if (uploadUrl) {
        // Update state with the returned URL
        setImageUrl(uploadUrl);
        setNftData({ ...nftData, url: uploadUrl });
        
        console.log('Final upload URL:', uploadUrl);
      } else {
        alert('All upload methods failed. This might be due to browser security policies. Please try using a different browser or manually upload your image to an image hosting service and paste the URL.');
      }
      
    } catch (error) {
      console.error('Upload error:', error);
      alert('Upload error: ' + (error as Error).message + '. Please try again or manually paste an image URL.');
    } finally {
      setIsUploading(false);
    }
  };

  const handleFileSelect = (event: React.ChangeEvent<HTMLInputElement>) => {
    const file = event.target.files?.[0];
    if (file) {
      // Only cleanup if we're selecting a different file
      if (previewUrl && imageFile && file.name !== imageFile.name) {
        URL.revokeObjectURL(previewUrl);
        setPreviewUrl(null);
      }
      
      setImageFile(file);
      handleImageUpload(file);
    }
  };

  const toggleExpanded = () => {
    setIsExpanded(!isExpanded);
  };

  const handleMintNFT = async () => {
    if (!currentAccount || !nftData.nama || !nftData.deskripsi || !nftData.url) {
      alert('Pastikan wallet terhubung dan semua field sudah diisi!');
      return;
    }

    if (packageId === '0x0') {
      alert('Package ID belum dikonfigurasi. Silahkan deploy smart contract terlebih dahulu dan update package ID di config/network.ts');
      return;
    }

    setIsLoading(true);

    try {
      const txb = new Transaction();
      
      // Panggil fungsi mint dari smart contract mintnft
      txb.moveCall({
        target: `${packageId}::mintnft::mint`,
        arguments: [
          txb.pure.string(nftData.nama),      // nama: String
          txb.pure.string(nftData.deskripsi), // deskripsi: String  
          txb.pure.string(nftData.url),       // url: String
        ],
      });

      signAndExecute(
        { transaction: txb },
        {
          onSuccess: (result) => {
            console.log('NFT berhasil dimint!', result);
            setTransactionHash(result.digest);
            // Reset form
            setNftData({ nama: '', deskripsi: '', url: '' });
            // Show success modal
            setShowSuccessModal(true);
          },
          onError: (error) => {
            console.error('Error minting NFT:', error);
            alert('Error minting NFT: ' + error.message);
          },
        }
      );
    } catch (error) {
      console.error('Error:', error);
      alert('Error: ' + (error as Error).message);
    } finally {
      setIsLoading(false);
    }
  };

  if (!currentAccount) {
    return (
      <div className="welcome-container">
        <div className="welcome-card">
          <h2>🎨 Mint Your NFT</h2>
          <p>Connect your wallet first to start Minting NFTs on Sui blockchain</p>
          <div className="connect-button-center">
            <ConnectButton />
          </div>
        </div>
      </div>
    );
  }

  return (
    <div className="modal-overlay">
      <div className={`modal-container ${isExpanded ? 'expanded' : ''}`}>
        
        {/* Expanded Panel */}
        {isExpanded && (
          <div className="expanded-panel">
            <div className="expanded-header">
              <h3>🛠️ Image Tools</h3>
            </div>
            <div className="expanded-body">
              <div className="tool-section">
                <h4>Convert Image to URL</h4>
                <p>Upload your image to get a URL for your NFT</p>
                
                <div className="file-upload-area">
                  <input
                    type="file"
                    id="image-upload"
                    accept="image/*"
                    onChange={handleFileSelect}
                    style={{ display: 'none' }}
                  />
                  <label htmlFor="image-upload" className="file-upload-btn">
                    {isUploading ? (
                      <>
                        <span style={{animation: 'spin 1s linear infinite'}}>⟳</span>
                        Uploading...
                      </>
                    ) : (
                      <>
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                          <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/>
                          <polyline points="7,10 12,15 17,10"/>
                          <line x1="12" y1="15" x2="12" y2="3"/>
                        </svg>
                        Select Image
                      </>
                    )}
                  </label>
                </div>
                
                {imageFile && previewUrl && (
                  <div className="image-preview">
                    <img 
                      src={previewUrl} 
                      alt="Selected image preview" 
                      className="preview-image"
                    />
                  </div>
                )}
                
                {imageUrl && (
                  <div className="url-result">
                    <label>Generated URL:</label>
                    <input
                      type="text"
                      value={imageUrl}
                      readOnly
                      className="url-input"
                      onClick={(e) => e.currentTarget.select()}
                    />
                    <button
                      onClick={() => {
                        navigator.clipboard.writeText(imageUrl);
                        alert('URL copied to clipboard!');
                      }}
                      className="copy-btn"
                      title="Copy URL"
                    >
                      <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                        <rect x="9" y="9" width="13" height="13" rx="2" ry="2"/>
                        <path d="M5 15H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9a2 2 0 0 1 2 2v1"/>
                      </svg>
                      Copy
                    </button>
                  </div>
                )}
              </div>
            </div>
          </div>
        )}
        
        {/* Main Content */}
        <div className="main-content">
          <div className="modal-header">
          <div className="modal-title-section">
            <h2>🎨 Mint NFT</h2>
            <div className="wallet-info-section">
              <div className="wallet-address-display">
                {formatAddress(currentAccount.address)}
              </div>
              <div className="network-badge">
                (Testnet)
              </div>
            </div>
          </div>
          <button 
            className="disconnect-btn"
            onClick={() => disconnect()}
            title="Disconnect Wallet"
          >
            ✕
          </button>
        </div>
        
        <div className="modal-body">
          <div className="form-group">
            <label className="form-label">Nama NFT:</label>
            <input
              type="text"
              className="form-input"
              value={nftData.nama}
              onChange={(e) => setNftData({ ...nftData, nama: e.target.value })}
              placeholder="Masukkan nama NFT"
            />
          </div>

          <div className="form-group">
            <label className="form-label">Deskripsi:</label>
            <textarea
              className="form-textarea"
              value={nftData.deskripsi}
              onChange={(e) => setNftData({ ...nftData, deskripsi: e.target.value })}
              placeholder="Masukkan deskripsi NFT"
              rows={3}
            />
          </div>

          <div className="form-group">
            <div className="url-field-label">
              <label className="form-label">URL Gambar:</label>
              <a 
                className="convert-image-link" 
                onClick={toggleExpanded}
                title="Convert image to URL using image upload tools"
              >
                Convert Image to URL
              </a>
            </div>
            <input
              type="url"
              className="form-input"
              value={nftData.url}
              onChange={(e) => setNftData({ ...nftData, url: e.target.value })}
              placeholder="https://example.com/image.jpg"
            />
          </div>

          <button
            className="btn-primary"
            onClick={handleMintNFT}
            disabled={isLoading || !nftData.nama || !nftData.deskripsi || !nftData.url}
          >
            {isLoading ? 'Minting...' : 'Mint NFT'}
          </button>
          </div>
        </div> {/* End of main-content */}
      </div> {/* End of modal-container */}

      {/* Success Modal */}
      {showSuccessModal && (
        <div className="success-modal-overlay">
          <div className="success-modal-container">
            <div className="success-modal-content">
              <div className="success-icon">🎉</div>
              <h3>NFT Minted Successfully!</h3>
              <p>Your NFT has been successfully minted on Sui blockchain.</p>
              <div className="success-modal-buttons">
                <button 
                  className="btn-view-transaction"
                  onClick={handleViewTransaction}
                >
                  View on SuiVision
                </button>
                <button 
                  className="btn-close-modal"
                  onClick={handleCloseModal}
                >
                  Close
                </button>
              </div>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};

export default NFTMinter;