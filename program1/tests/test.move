#[test_only]
module program1::counter_tests {
    use sui::test_scenario;
    use program1::counter;

    #[test]
    fun test_counter() {
        let admin = @0x1;
        let scenario_val = test_scenario::begin(admin);
        let scenario = &mut scenario_val;

        // Membuat counter baru
        counter::create(test_scenario::ctx(scenario));

        // Pindah ke transaksi berikutnya
        test_scenario::next_tx(scenario, admin);

        // Ambil counter dan tambah nilainya
        let counter = test_scenario::take_shared<counter::Counter>(scenario);
        counter::increment(&mut counter);
        assert!(counter::get_value(&counter) == 1, 0);

        // Kembalikan counter dan akhiri tes
        test_scenario::return_shared(counter);
        test_scenario::end(scenario_val);
    }
}