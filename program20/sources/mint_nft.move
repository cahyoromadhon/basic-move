// Minting NFT Program
module program20::mint_nft {
    use std::string::String;
    use sui::url::Url;

    // Define the structure of an NFT
    public struct TestnetNFT has key, store {
        id: UID,
        name: String,
        description: String,
        url: Url,
    }

    // Function to mint a new NFT
    entry fun new_mint(
        name: vector<u8>,
        description: vector<u8>,
        url: vector<u8>,
        ctx: &mut TxContext
    ) {
        let nft = TestnetNFT {
            id: object::new(ctx),
            name: std::string::utf8(name),
            description: std::string::utf8(description),
            url: sui::url::new_unsafe_from_bytes(url),
        };
        transfer::transfer(nft, tx_context::sender(ctx));
    }
}

// alasan mengapa (name) dan (description) itu karena di Sui, String itu harus di convert ke vector<u8> dulu
// jadi biar gampang, langsung aja pake vector<u8> di parameter function nya
// dan untuk url, di Sui itu ada module url sendiri, jadi kita pake itu aja
// arti dari new_unsafe_from_bytes itu adalah bikin url dari vector<u8> tanpa validasi
// maksudnya tanpa validasi itu adalah kita harus yakin kalo vector<u8> itu beneran url yang valid
// kalo misalnya vector<u8> itu isinya bukan url yang valid, nanti bakal error waktu dijalanin
// jadi kita harus hati-hati kalo pake new_unsafe_from_bytes ini