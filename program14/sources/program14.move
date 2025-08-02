module program14::my_coin;

use sui::coin::{Self, TreasuryCap};

public struct MY_COIN has drop {}

fun init(witness: MY_COIN, ctx: &mut TxContext) {
    let (treasury, metadata) = coin::create_currency(
            witness,
            6,
            b"MY_COIN",
            b"",
            b"",
            option::none(),
            ctx,
    );
    transfer::public_freeze_object(metadata);
    transfer::public_transfer(treasury, ctx.sender())
}

public fun mint(
    treasury_cap: &mut TreasuryCap<MY_COIN>,
    amount: u64,
    recipient: address,
    ctx: &mut TxContext,
) {
    let coin = coin::mint(treasury_cap, amount, ctx);
    transfer::public_transfer(coin, recipient)
}

// deklarasi module bernama my_coin
// import library atau modul officail bernama coi dipackage sui
// deklarasi struct bernama MY_COIN dengan ability drop
// deklarasi fungsi init dengan parameter witness yang memiliki value struct dan berikan ctx dengan reference ability
// deklarasi local variabel dengan 2 parameter yaitu treasury, meteadata yang sepertinya adalah default deklarasi dari module ini
// masukkan parameter tadi kedalam coin::create_currency dan object default darinya juga
// jika sudah berikan titik koma dan lanjut bekukan object metadata agar tidak dapat diubah kembali
// transfer kepemilikan object  treasury kepada penerimanya yaitu sang ppengirim transaksi
// deklarasi fungsi mint dengan parameter yang lumayan banyak yang semuanya adalah default dan jika tidak maka akan error
// treasury_cap diberi value mutable dan TreasuryCap menyertakan nama coin yaitu <MY_COIN>
// TreasuryCap memberikan hak untuk mengelola pasokan seperti mint atau burn dan jangan lupa ikut sertakan <NAMA_COIN>
// amount nya atau jumlah yang ingin di mint berapa banyak
// penerimanya siapa
// dan terakhir masukkan ctx untuk memberikan cotext trasaksi agar ownershipnya dapat diubah
// deklarasikan local variabel bernama coin dan gunakan fungsi dari module coin yaitu coin::mint(cap, value, ctx)
// dan parameter recipient berguna untuk memudahkan penerimaan token agar langsung dimasukkan ke address tujuan tanpa harus menambahkan logika
// gunakan fungsi public_transfer dengan parameter (object, reciepent)