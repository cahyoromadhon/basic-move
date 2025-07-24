// Simple Storage

module program11::storage {

    use std::ascii::String;

    public struct Storage has key, store {
        id: UID,
        message: String,
    }

    public entry fun create_message(message: String, ctx: &mut TxContext) {
        let storage = Storage {
            id: object::new(ctx),
            message: message,
        };
        transfer::transfer(storage, tx_context::sender(ctx));
    }

    public entry fun update_message(storage: &mut Storage, new_message: String) {
        storage.message = new_message;
    }
    // deklarasikan fungsi input untuk mengupdate pesan
    // isi parameter dengan kebutuhan pesan baru
    // masukkan object yang telah dibuat sebelumnya bernama storage kemudian deklarasikan pesan baru dengan menggunakan parameter bernama new_message dengan value String
    // didalam fungsi ini, ubah nilai message yang ada pada storage menjadi parameter new_message

    public fun get_message(storage: &Storage): String {
        storage.message
    }

}