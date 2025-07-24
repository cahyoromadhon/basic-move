const { WalletKitContext } = require("@mysten/wallet-kit");

// Impor Module dari Sui SDK
const { JsonRpcProvider, testnetConnection, SignerWithProvider, Ed25519Keypair } = window.suiSDK;

const PackageID = '0xd211fc49ba783ec48c8106fa7641911bce1b1a7524f6fd21d7a0b81e02053bd3';
const ObjectID = '0x946a627e202cb3430a28fc817b1ffdad8ae99e04117ab96e8533296d0e7fb51d';
const walletKit = new WalletKit();

// Inisialisasi koneksi/provider ke Sui Testnet
const provider = new JsonRpcProvider(testnetConnection);
const keypair = Ed25519Keypair.fromSecretKey(Uint8AWalletKitContextrray.from(PrivateKey));
let signer = new SignerWithProvider(provider, keypair);

// Connect Wallet Sui
async function connectWallet() {
    try {
        await WalletKit.connectWallet();
        signer = WalletKit.getSginer();
        console.log('Wallet connected:', signer);
        alert('Wallet Connected Successfully!');
    } catch (error) {
        console.error('Error connecting wallet:', error);
        alert('Failed to connect wallet: ' + error.message);
    }
}

// Fungsi untuk membuat pesan baru
async function createMessage() {
    if (!signer) {
        await connectWallet();
        if (!signer) {
            alert('Please connect your wallet first.');
            return;
        }
    }
    const message = document.getElementById("messageInput").value;
    const tx = {
        packageObjectId: PackageID,
        module: 'storage',
        function: 'create_message',
        typeArguments: [],
        arguments: [message],
        gasBudget: 100000000,
    };

    try {
        const result = await signer.executeMoveCall(tx);
        console.log('Pesan Berhasil dibuat: ', result);
        alert('Message Created Succesfully!');
    } catch (error) {
        console.error('Error Creating Message: ', error);
        alert('Failed to create message: ' + error.message);
    }
}

// Fungsi untuk memperbarui pesan
async function updateMessage() {
     if (!signer) {
        await connectWallet();
        if (!signer) {
            alert('Please connect your wallet first.');
            return;
        }
    }
    
    const message = document.getElementById("messageInput").value;
    const tx = {
        packageObjectId: PackageID,
        module: 'storage',
        function: 'update_message',
        typeArguments: [],
        arguments: [ObjectID, message],
        gasBudget: 100000000,
    };

    try {
        const result = await signer.executeMoveCall(tx);
        console.log('Pesan diperbarui: ', result);
        alert('Message Updated Succesfully!');
    } catch (error) {
        console.error('Error Updating Message: ', error);
        alert('Failed to update message: ' + error.message);
    }
}

// Fungsi untuk membaca pesan
async function getMessage() {
     if (!signer) {
        await connectWallet();
        if (!signer) {
            alert('Please connect your wallet first.');
            return;
        }
    }

    try {
        const storage = await provider.getObject(ObjectID);
        const message = storage.data.content.fields.message;
        document.getElementById("storedMessage").innerText = message;
    } catch (error) {
        console.error('Error Reading Message: ', error);
        alert('Failed to read message: ' + error.message);
    }
}