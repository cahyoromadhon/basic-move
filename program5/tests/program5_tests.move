#[test_only]
module program5::programTest {
    public fun add(a: u64, b: u64): u64 {
        a + b
    }
}

// by default, cara mendeklarasikan module adalah: module nama_package::nama_modul {kode modul}
// nama modul difolder tests tidak boleh sama dengan nama modul di folde utama yaitu sources, nama package boleh sama namun nama modul tidak
// nama modul juga tidak boleh ada nomor didepannya misalkan: 5pro (X)
// memang aturannya seperti itu :)

