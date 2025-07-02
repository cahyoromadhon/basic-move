module program1::counter {

    // Struktur untuk menyimpan nilai counter dengan visibilitas public
    public struct Counter has key, store {
        id: UID,
        value: u64,
    }

    // Fungsi untuk membuat counter baru
    public entry fun create(ctx: &mut TxContext) {
        let counter = Counter {
            id: object::new(ctx),
            value: 0,
        };
        transfer::share_object(counter);
    }

    // Fungsi untuk menambah nilai counter
    public entry fun increment(counter: &mut Counter) {
        counter.value = counter.value + 1;
    }

    // Fungsi untuk mendapatkan nilai counter
    public fun get_value(counter: &Counter): u64 {
        counter.value
    }
}