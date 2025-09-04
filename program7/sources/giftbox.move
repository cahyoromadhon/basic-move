// [ilmu baru]: ketika kamu mendeklarasikan sebuah struct atau object, kamu belum benar-benar membuat object tersebut dan
// object baru bisa dibuat ketika fungsi dijalankan
// jadi selama fungsi tersebut belum berjalan, object tidak benar-benar belum dibuat, hanya sebatas disimpan saja di storage

module program7::giftbox {

    public struct GiftBox has key {
        id: UID,
        gift: Gift,
    }

    public struct Gift has store {
        value: u64,
    }

    public entry fun create_gift_box(value: u64, ctx: &mut TxContext) {
        let gift = Gift { value };
        let box = GiftBox {
            id: object::new(ctx),
            gift,
        };
        transfer::transfer(box, tx_context::sender(ctx));
    }

}

// deklarasi module dengan nama package program7 dan nama modul usecase
// deklarasi struct bernama GiftBox dengan ability key agar object dapat menyimpan id unik di blockchain
// deklarasikan fields bernama id dengan value UID
// deklarasikan fields bernama gift dengan value Gift (Gift ini nantinya akan dideklarasikan diluar dari object Gift secara terpisah dan menjadi object wrapped)
// deklarasikan object wrapped dengan nama yang sama seperti di fields GiftBox yaitu Gift dengan ability store agar dapat disimpan bersama dengan object parents nya yaitu GiftBox
// (note: Struct/Object selalu diawali dengan huruf kapital didepannya)
// deklarasikan fungsi dengan visibility public yang bernama create_gift_box
// tambahkan parameter yang berisi pendeklarasian variabel lokal bernama value dan ctx yang nantinya akan disimpan sebagai positif number dan context transaction
// dan semua parameter yang telah dideklarasikan akan digunakan sebagai instance/fields baru dari object lokal bernama GiftBox
// varibel lokal yang berada didalam fungsipun dideklarasikan yang bernama gift dan valuenya adalah object warpped yang sudah dideklarasikan diatas menggunakan struct dan ability storage
// setelah object wrapped didekalarsikan jangan lupa ikutkan juga fileds nya yang nanti akan digunakan dibawah
// setelah object lokal bernama GiftBox tadi dideklarasikan diatas kemudian panggil GiftBox versi lokal ini dengan membuat fileds baru
// isi dari fields baru ini berisikan id dengan value object::new(ctx) tujuannya adalah ini akan membuat id unik baru
// dan panggil juga gift yang dalam hal ini adalah sebuah variabel lokal namun sudah memiliki value object wrapped versi lokal yang telah dideklarasikan diatas
// setelah semua itu, aku menyadari beberapa hal, untuk bisa membuat object yang benar benar baru maka diperlukan untuk memasukkan bahan dari variabel yang telah didekalarasikan secara global dan akan "dibuat ulang" versi lokalnya dengan fungsi yang dideklarasikan namun tetap original karena id nya sudah dibuat ulang dan ini nanti akan menjadi sebuah object yang baru di global storage
// ketika kamu memanggil fungsi create_new_box ini akan membuat sebuah object baru bernama GiftBox dan fileds dari GiftBox ini itu diambil dari parameter fungsi, setelah itu didalam fungsi deklarasikan variabel lokal yang memiliki value object Gift yang nantinya kita bisa mengakses fields dari object tersebut yaitu Gift, lalu deklarasikan ulang object dengan fields id yang baru dan value number yang diambil dari variabel lokal
// object yang dibuat dari fungsi ini akan menjadi object independent yang artinya tak terikat apapun sementara ketika kita ingin mengakses Gift didalam GiftBox baru tersebut maka kita diharuskan mengakses GiftBox terlebih dahulu
// sehingga ini seperti implementasi dalam dunia nyata, agar kita bisa mencoba hadiah(Gift) kit harus membuka kotak hadiah(GiftBox) terlebih dahulu
// cmiiw

// ada perubahan terkait code nya karena ketika aku coba panggil fungsinya, memang benar fungsi berhasil dibuat namun tidak ada tindakan setelah fungsi dibuat
// karena di Move ketika object berhasil dibuat itu harus langsung ditangani entah dikirimkan ke alamat kita atau mungkin dibuang/dihapus
// dan karena tidak ada tindakan maka move mengira program ini akan dihapus namun jika kita menginginkan untuk menghapusnya maka dibutuhkan ability drop sementara kita tidak memilikinya maka terjadilah error

// code yang diubah: deklarasi object bernama GiftBox tidak langsung dideklarasikan setelah parameter selesai dideklarasikan dan semuanya sama menggunakan keyword let yang berarti ini dideklarasikan kedalam sebuah variabel bernama box
// dengan adanya perubahan ini maka code jauh lebih bisa untuk dibaca daripada harus membaca kode yang sebelumnya ditulis
// kemudian setelah object selesai dibuat maka masuk ke tahap fungsi selanjutnya yaitu transfer ownershipnya ke alamat pemanggil yang dalam hal ini sender atau alamat pemanggil fungsi itu sendiri
// logikanya seperti ini: deklarasikan built-in function dengan parameter (object, tx_context)
// sehingga ini memungkinkan pemindahan ownership kedalam object tersebut