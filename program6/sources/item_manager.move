// Pengertian Object Deletion
// Object adalah sebuah entitas yang memiliki ID unik (UID)
// Object Deletion adalah sebuah proses dimana kita melakukan penghapusan object dari global storage

// Object hanya bisa dihapus ketika:
// 1. Object dapat dihapus ketika kita memiliki izin untuk menghapusnya
// 2. Object dapat dihapus ketika object tersebut tidak lagi digunakan 
// Tujuan: setiap object akan memakan ruang di global storage, dan penghapusan object dilakukan agar tidak membengkak

// Pengertian Struct Unpacking
// Sturct Unpacking adalah kondisi dimana kita melakukan destructing dengan tujuan hanya mengambil fieldnya saja
// Mengapa ini dilakukan? agar kita bisa mengambil nilai field dari sebuah struct tanpa harus mengaksesnya satu persatu menggunakan notasi titik (.)
// Selain itu juga, struct unpacking ini juga dapat digunakan untuk membuat kode menjadi lebih ringkas
// Unpacking itu sendiri menggunakan keyword 'let' untuk mengubah nilai dari sebuah field menjadi variabel lokal
// Namun syarat agar struct dapat diunpack adalah Struct itu sendiri harus memiliki ability 'drop' agar bisa diunpack

// Let's Code
module program6::item_manager {

    // Struct untuk mempresentasikan item
    public struct Item has key, store {
        id: UID,
        name: vector<u8>,
        value: u64,
    } // [ilmu baru]: setiap field harus diakhiri dengan koma, sekalipun itu field yang terakhir

    // Struct sementara yang nantinya akan dihapus
    public struct ItemConfig has drop { 
        name: vector<u8>,
        value: u64,
    } // [ilmu baru]: dalam deklarasi identifier nama struct harus dimulai dengan huruf kapital


    // Fungsi untuk item baru
    public entry fun create_item(name: vector<u8>, value: u64, ctx: &mut TxContext) {
    // [ilmu baru]:
    // TxContext adalah struct default dari sui yang memberikan informasi transaksi yang sedang dieksekusi blockchain
    // informasi ini penting agar object dapat melakukan opearasi pembuatan object baru ataupun kalau ingin melakukan transfer kepemilikan

        let item_config= ItemConfig {name, value}; // Membuat Konfigurasi sementara

        // Struct unpacking untuk menguraikan ke variabel lokal
        let ItemConfig {name: item_name, value: item_value} = item_config;

        // Membuat object Item Baru
        let item = Item {
            id: object::new(ctx),
            name: item_name,
            value: item_value,
        };
        transfer::transfer(item, tx_context::sender(ctx));
        // Transfer item ke pemilik
    }
    // deklarasi fungsi bernama create_item
    // dengan parameter deklarasi variabel denngan value yang disesuaikan dengan kebutuhan
    // name untuk string atau alternatifnya adalah menggunakan vector<u8>
    // value untuk angka dengan nilai u64
    // ctx untuk transfer kepemilikan dan menggunakan refrensi mutable agar bisa diubah kepemilikan tersebut

    // deklarasi variabel lokal bernama item_config dengan value struct ItemConfig
    // dengan fields name, value
    // proses melakukan struct unpacking dengan mengisi fields pada struct tersebut
    // kemudian dimasukkan kembali kedalam variabel lokal bernama item_config

    // deklarasi object bernama item dengan value dari struct bernama Item
    // fields id dibuat ulang menjadi baru dengan parameter ctx
    // name diisi dengan item_name seperti field baru yang sudah diisi dilokal
    // value juga diisi dengan item_value agar sesuai dengan field baru yang sudah diisi dilokal

    // lakukan transfer dengan fungsi transfer::transfer()
    // parameternya diisi dengan object yang telah dideklarasikan
    // dan kepemilikan dari object item dikirimkan kepada pengirim transaksi dengan fungsi tx_context::sender(ctx)
    // fungsi tersebut memiliki parameter ctx yang berarti memang dimaksudkan untuk diubah/dipindahkan kepemilkan dari object tersebut


    // Fungsi untuk menghapus item
    public entry fun delete_item(item: Item) {
        // Struct untuk menguraikan item untuk mengakses field nya
        let Item {id, name: _, value: _} = item;
        object::delete(id);
    }

    // deklarasi fungsi bernama delete_item
    // dengan parameter yang berisi deklarasi variabel bernama item dengan value struct bernama Item
    // ketika melakukan struct unpacking menggunakan sintaks 'let' maka kita harus menyebutkan semua field yang ada didalam struct tersebut
    // namun problemnya adalah ketika melakukan penghapusan object menggunakan fungsi object::delete(id)
    // fungsi tersebut hanya membutuhkan id nya saja, sementara dalam struct unpacking harusmenyebutkan semua fieldnya
    // nahh muncullah tanda Underscore "_" yang berarti abaikan
    // jadi arti dari "name: _, value: _" adalah mengebaikan field dari name dan value karena pada dasarnya kita hanya membutuhkan field id nya saja agar bisa menghapusnya
    // barulah panggil built-in fungsi object::delete(id)

}