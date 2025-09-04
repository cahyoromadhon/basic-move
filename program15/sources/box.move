module program15::box {
    use std::string::String;
    use sui::url::Url;

    // Struct untuk NFT
    public struct Nft has key, store {
        id: UID,
        name: String,
        description: String,
        url: Url, // Url ini nantinya akan digunakan sebaga link metadata dari nft
    }

    // Deklarasi Struct Generik
    public struct Box<T: key + store> has key, store {
        id: UID,
        content: T,
    }

    // Fungsi untuk minting nft dan memasukkannya kedalam box
    public fun minting_box (name: vector<u8>, description: vector<u8>, url: vector<u8>, ctx: &mut TxContext): Box<Nft> {
        // Minting NFT
        let nft = Nft {
            id: object::new(ctx),
            name: std::string::utf8(name),
            description: std::string::utf8(description),
            url: sui::url::new_unsafe_from_bytes(url),
        };
        Box {
            id: object::new(ctx),
            content: nft,
        }
    }

    public fun unpack_box<T: key + store>(box: Box<T>): T {
        let Box { id, content } = box;
        object::delete(id); //Hapus UID Box
        content
    }
}