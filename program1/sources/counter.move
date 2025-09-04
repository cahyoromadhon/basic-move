module program1::counter {

    // Struktur untuk menyimpan nilai counter dengan visibilitas public
    public struct Counter has key, store {
        id: UID,
        value: u64,
    }

    // Fungsi untuk membuat counter baru
    entry fun create(ctx: &mut TxContext) {
        let counter = Counter {
            id: object::new(ctx),
            value: 0,
        };
        transfer::share_object(counter);
    }

    // Fungsi untuk menambah nilai counter
    entry fun increment(counter: &mut Counter) {
        counter.value = counter.value + 1;
    }

    // Fungsi untuk mendapatkan nilai counter
    public fun get_value(counter: &Counter): u64 {
        counter.value
    }
}

// Ini adalah module yang diberikan oleh mas nathan saat bootcamp pertama SUI Dev Indonesia dan hari ini aku akan menjelaskannya step by step apasaja yang dilakukan pada code ini
// deklarasi module bernama counter dengan nama package program1
// deklarasi struct bernama Counter dan memiliki visibilitas public yang artinya dapat diakses dari luar module ini
// fields didalam struct memiliki nama id dengan Value UID yang berguna membuat unique id dan fields bernama value dengan value u64 yaitu uninteger yang tidak memiliki nilai negative dan memiliki byte berjumlah 64
// deklarasi fungsi bernama create yang dapat diisi karena memiliki keyword entry dan parameternya ctx yaitu context transaksi berguna untuk memberikan kepemilikan objek ini kepada fungsi ini
// didalam fungsi terdapat deklarasi variabel lokal bernama counter dengan isi Struct dan disebutkan kembali fields nya dengan nama id dan value object::new(ctx) yang berguna untuk membuat id baru
// fields kedua adalah value dengan nilai 0
// kemudian fungsi transfer::share_object(object) yang berguna untuk membagikan kepemilikan objek ini kepada orang lain
// dekarasi fungsi bernama increment yang memiliki input dengan parameter deklarasi object bernama counter yang dapat diubah dengan menggunakan refrence &mut pada Struct bernama Counter
// didalam fungsi ini terdapat perintah untuk masuk kedalam struct counter dan cari fields bernama value dan tambahkan nilainya dengan 1
// deklarasi fungsi bernama get_value yang memiliki parameter untuk mendapatkan nilai dari counter namun tidak dapat diubah karena memiliki refrence immutable atau read-only yaitu &Counter
// return nilai dari fields value pada struct Counter yang sudah dideklarasikan sebelumnya