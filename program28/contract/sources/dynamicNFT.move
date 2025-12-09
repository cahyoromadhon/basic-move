module contract::dynamicNFT;

use std::string::String;
use sui::{package, display};


public struct HeroNFT has key, store {
    id: UID,
    name: String,
    description: String,
    url: Option<Url>,
    level: u8,
    exp: u64,
    rarity: String,
}

public struct RareShard has key, store { id: UID }

public struct DYNAMICNFT has drop {}

const ENotCommonRarity: u64 = 0;

fun init(otw: DYNAMICNFT, ctx: &mut TxContext) {
    let keys = vector[
        b"name".to_string(),
        b"description".to_string(),
        option::some(b"https://files.catbox.moe/ptlmkk.jpg"),
        b"level".to_string(),
        b"exp".to_string(),
        b"rarity".to_string()
    ];

    let values = vector[
        b"Dynamic Hero NFT".to_string(),
        b"A brave hero NFT".to_string(),
        option::some(b"https://files.catbox.moe/ptlmkk.jpg"),
        b"1".to_string(),
        b"0".to_string(),
        b"Common".to_string()
    ];

    // keys[] dan values[] adalah standarisasi dari sui agar platform external bisa membaca metadata kita karena mereka tidak memiliki kemampuan untuk memahami apa yang ada pada struct HeroNFT sehingga mereka membacanya melalaui key kemudian baru menampilkan valuenya

    // next time ketika akan membuat sebuah nft jangan lupa untuk mendeklarasikan 2 variabel lokal yaitu keys dan value yang berisi vector string dengan tujuan utnuk format standar dari sui

    let publisher = package::claim(otw, ctx); // proof of ownership NFT dan identifiernya bisa diubah kecuali isinya yang mengclaim kepemilikan NFT tersebut melalui otw
    let mut metadata = display::new_with_fields<HeroNFT>(&publisher, keys, values, ctx);
    // metadata variebl ini berguna memberitahu platform external tentang metadata apa saja yang ada pada NFT kita serta membuktikan kepemilkan nft ini orignal dari module kita melalui publisher
    // alasan mengapa fungsi ini mengikat sebuah struct karena struct inilah yang akan di jadikan metadata dari NFT kita
    // keys[] dan values[] hanya berfungsi sebagai alat untuk platform external membaca atau menscanning metadata kita sehingga jika kita ingin membuat sebuah nft asetnya akan kembali pada struct yang kita buat sebelumnya

    metadata.update_version();
    // memungkinkan kita untuk melakukan update pada metadata nft kita di kemudian hari jika kita telah melakukan proses deployment
    // fungsi ini diambil dari module display::update_version()

    transfer::public_transfer(publisher, ctx.sender());
    transfer::public_transfer(metadata, ctx.sender());
}

entry fun mint(
    name: String,
    description: String,
    ctx: &mut TxContext
) {
    let hero_nft = HeroNFT {
        id: object::new(ctx),
        name,
        description,
        ,
        1,
        0,
        rarity: b"Common".to_string()
    };
    transfer::public_transfer(hero_nft, ctx.sender());
}

entry fun mint_rare_shard(ctx: &mut TxContext) { // Consumable object
    let rare_shard = RareShard {
        id: object::new(ctx)
    };
    transfer::public_transfer(rare_shard, ctx.sender());
}

fun burn_rare_shard(shard: RareShard) { // Private Function Delete
    let RareShard { id } = shard;
    object::delete(id);
}

entry fun upgrade_rarity( // Main Function Upgrade NFT Rarity
    hero_nft: &mut HeroNFT,
    rare_shard: RareShard
) {
    assert!(hero_nft.rarity == b"Common".to_string(), ENotCommonRarity );
    hero_nft.rarity = b"Rare".to_string();
    burn_rare_shard(rare_shard);    
}
