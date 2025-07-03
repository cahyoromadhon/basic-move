module program2::message {

    public struct Pesan has key, store {
        id: UID,
        content: vector<u8>, // Menyimpan string sebagai vector<u8>
    }

    public entry fun create(content: vector<u8>, ctx: &mut TxContext) {
        let sms = Pesan {
            id: object::new(ctx),
            content,
        };
        transfer::transfer(sms, tx_context::sender(ctx));
    }

    public entry fun update(sms: &mut Pesan, new_content: vector<u8>) {
        sms.content = new_content;
    }
}

// Modul adalah sebuah unit kode yang berisikan sekelompok fungsi dan struktur data siap pakai
// module memungkinkan pendefinisian modul yang bernama message berada dibawah dari sms
// use sui::object::{Self, UID} yang berarti menggunakan/mengimpor modul object yang dalam kasus ini lebih spesifiknya adalah menggunakan object Self dan Unique Identifier dan semua modul ini diambil dari modul parent yaitu sui
// use sui::transfer menggunakan/mengimpor modul transfer dari library sui
// mengapa kita mengimpor? dengan kita mengimpor yang memungkinkan kita dapat menggunakan function atau data yang sudah ada dari library atau module tersebut (lebih efisien) daripada harus menulis ulang semua manual

// Fungsi dari struct adalah untuk memudahkan pengelompokan data terkait menjadi satu objek terstruktur. Tanpa struct, kita harus mendefinisikan dan mengelola setiap elemen data (misalnya, id dan content) secara terpisah, yang menyulitkan organisasi dan pengelolaan. Selain itu, dalam Move, struct dengan ability key memungkinkan data disimpan sebagai objek unik di blockchain Sui, sementara ability store memungkinkan objek tersebut disimpan atau ditransfer di storage global Sui

// id: UID ini disebut field yang dimana setiap object itu pasti memiliki sebuah field yang bebas developer tentukan dan id merupakan nama dari field yang telah dideklarasikan yang memuat Unique Identifier sehingga memudahkan dalam pembuatan id unik

// content: vector<u8>  mendefinisikan field bernama content dengan tipe vector
// vector disini cukup mirip dengan konsep array pada bahasa pemrograman lain
// u8 disini yang berarti setiap elemen pada vector adalah 8-byte yaitu bilangan bulat

// public entry fun create adalah sebuah function, coba perhatikan keyword fun itu adalah deklarasi function dan untuk public entry itu adalah sebuah visibilitas yang memungkinkan fungsi ini dapat dipanggil dari luar misalnya via transaksi di CLI
// content dan ctx adalah parameter dari function itu sendiri
// content berguna sebagai pesan awal
// ctx bertipe &mut (mutable) TxContent berguna untuk mengakses konteks transaksi (mutable reference)
