// deklarasi module
// import library package dan display dari sui
// struct nft dengan field nama, deskripsi, url
// struct one time witness (otw) dengan ability drop
// fungsi init dengan parameter otw dan ctx
// deklarasi vector keys dan values untuk metadata nft
// std:string::utf8(b"Nama NFT for ex") untuk mengkonversi byte array ke string
// package claim untuk mengklaim otw sebagai publisher
// display new with fields berguna untuk membuat objek display dengan metadata dan paramater by default pub, fileds, values, ctx
// display update version untuk mengupdate versi metadata
// public transfer untuk package dan display ke address pengirim
// fungsi entry mint dengan struct dari nft tadi seperti name, url, description, ctx
// public transfer ke address pengirim

module program21::mintnft {
    use std::string::String;
    use sui::package;
    use sui::display;

    public struct NFT has key, store {
        id: UID,
        nama: String,
        deskripsi: String,
        url: String,
    }

    public struct MY_OTW has drop {}

    fun init(otw: MY_OTW, ctx: &mut TxContext) {
        let keys = vector[
            std::string::utf8(b"Name"),
            std::string::utf8(b"Description"),
            std::string::utf8(b"Image"),
            std::string::utf8(b"Creator"),
        ];
        let values = vector[
            std::string::utf8(b"{nama}"),
            std::string::utf8(b"{deskripsi}"),
            std::string::utf8(b"{url}"),
            std::string::utf8(b"@cahyorom"),
        ];

        let publisher = package::claim(otw, ctx);
        let mut metadata = display::new_with_fields<NFT>(
            &publisher,
            keys,
            values,
            ctx,
        );
        metadata.update_version();

        transfer::public_transfer(publisher, ctx.sender());
        transfer::public_transfer(metadata, ctx.sender());
    }

    entry fun mint(
        nama: String,
        deskripsi: String,
        url: String,
        ctx: &mut TxContext,
    ) {
        let nft = NFT {
            id: object::new(ctx),
            nama,
            deskripsi,
            url,
        };
        transfer::public_transfer(nft, tx_context::sender(ctx));
    }
}