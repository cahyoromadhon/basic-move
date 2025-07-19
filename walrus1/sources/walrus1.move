// Ini adalah sebuah program nft storage yang dikolaborasikan dengan Walrus
// Image disimpan menggunakan storage dari Walrus yang akan menghasilkan blob-id
// Kemudian Smart Contract ini bertugas untuk membuat sebuah nft dengan metadata yang diambil dari blob-id
module walrus1::nftStorage {

    public struct NFT has key, store { // Deklarasikan Object bernama NFT
        id: UID,
        name: vector<u8>,
        blob_id: vector<u8>,
    }

    public entry fun create_nft(name: vector<u8>, blob_id: vector<u8>, ctx: &mut TxContext) {
        let nft = NFT {
            id: object::new(ctx),
            name,
            blob_id,
        };
        transfer::transfer(nft, tx_context::sender(ctx));
    } // Deklarasikan Fungsi untuk membuat NFT baru

    public entry fun update_blob_id(nft: &mut NFT, new_blob_id: vector<u8>) {
        nft.blob_id = new_blob_id;
    }

    public fun get_blob_id(nft: &NFT): &vector<u8> {
        &nft.blob_id
    }
}

// deklarasi fungsi bernama update update_blob_id dengan parameter bernama nft yang dapat mengubah object NFT dan bernama new_blob_id dengan value vector<u8> agar kita bisa mengupdate blob id dengan yang baru
// logika nft.blob_id: cari object bernama NFT lalu masuk ke section fields bernama blob_id
// lalu masukkan new_blob_id agar bisa mengubahnya sesuai dengan parameter yang dimasukkan oleh penggunaa di argument fungsi
// deklarasikan fungsi bernama get_blob_id dengan parameter only-read &NFT atau alternatifnya adalah immutable
// &vector<u8> baca dengan vector lalu return &nft.blob_id agar bisa melihat id dari blob tanpa mengeditnya dan sebatas readable

// Command-CLI
// walrus blob-id <FILE>
// sui client objects (namun sedikit tricky, cek explorer untuk mudahnya)