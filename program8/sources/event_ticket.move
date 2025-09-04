// Kita akan membuat sebuah smart contract yang mengelola tiket acara dengan menggunakan konsep Cappability Design
module program8::event_ticket {

    // Kapabilitas Admin untuk mengelola tiket acara
    public struct AdminCapability has key {
        id: UID,
    }

    // Struct untuk menyimpan konfigurasi acara (shared object)
    public struct EventConfig has key, store {
        id: UID,
        ticket_price: u64, // Harga tiket ditentukan dalam satuan MIST
    }

    // Struct yang hanya dipanggil sekali untuk menginisialisasi event
    public fun create_admin_cap(ctx: &mut TxContext) {
        let admin_cap = AdminCapability {
            id: object::new(ctx),
        };
        transfer::transfer(admin_cap, tx_context::sender(ctx));
    }

    // Membuat konfigurasi awal untuk harga tiket acara
    public fun create_event_config(ticket_price: u64, ctx: &mut TxContext) {
        let config = EventConfig {
            id: object::new(ctx),
            ticket_price,
        };
        transfer::share_object(config);
    }

    // Mengubah harga tiket acara
    public fun update_ticket_price(_: &AdminCapability, config: &mut EventConfig, new_price: u64) {
        config.ticket_price = new_price;
    }
    // makna dari underscore adalah "Kami hanya membutuhkan keberadaan AdminCapability dan tidak peduli dengan datanya"
    // hal ini penting untuk memastikan hanya admin yang bisa mengubah harga tiket

    // Membaca harga tiket acara
    public fun get_ticket_price(config: &EventConfig): u64 {
        config.ticket_price
    }
}

// logikanya cukup simple
// deklarasikan nama package bernama program8 lalu nama module bernama event_ticket
// deklarasikan struct bernama AdminCapability yang memiliki ability key
// deklarasikan struct bernama EventConfig yang memiliki abillity key dan store
// deklarasikan fungsi bernama create_admin_cap yang hanya bisa dipanggil sekali untuk menginisialisasi admin capability
// deklarasikan fungsi bernama create_event_config untuk membuat konfigurasi awal harga tiket acara
// dekarasika variabel lokal bernama config dengan value object bernama EventConfig dengan value membuat id baru dan mereturn ticket price sesuai parameter yang diberikan oleh fungsi
// tipe object nya adalah shared object
// deklarasikan fungsi bernama update_ticket_price untuk mengubah harga tiket acara namun hanya admin kapabilitas yang bisa memanggilnya
// deklarasikan fungsi bernama get_ticket_price untuk membaca harga tiket acara
// &EventConfig artinya immutable atau read-only dan mengembalikan tipe u64

// [ilmu baru]: ketika kita akan menulis ObjectID sebagai argumen maka kita tidak perlu menambahkan tanda kutip sebagai penanda string hal ini karena ObjectID masuk dalam kategori hexadecimal karena diawali dengan 0x maka sui akan mengenalinya sebagai hexadecimal