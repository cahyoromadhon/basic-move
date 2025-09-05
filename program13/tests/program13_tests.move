module program13::escrow_test {
    use program13::escrow::{Self, Escrow};
    use sui::coin::{Self, Coin};
    use sui::test_scenario;

    // Test-only structs
    public struct CANDY has drop {}
    public struct PIE has drop {}

    #[test]
    public fun test_offer_and_take() {
        // create test addresses
        let admin = @0xBABE;
        let offeror = @0x0FFE;
        let taker = @0x4CCE;

        let scenario_val = test_scenario::begin(admin);
        let mut scenario = scenario_val;

        {
            let minted_candy_coin = coin::mint_for_testing<CANDY>(1000, test_scenario::ctx(&mut scenario));
            transfer::public_transfer(minted_candy_coin, offeror);

            let minted_pie_coin = coin::mint_for_testing<PIE>(20, test_scenario::ctx(&mut scenario));
            transfer::public_transfer(minted_pie_coin, offeror);

            let minted_pie_coin = coin::mint_for_testing<PIE>(1000, test_scenario::ctx(&mut scenario));
            transfer::public_transfer(minted_pie_coin, taker);
        };

        test_scenario::next_tx(&mut scenario, offeror);
        {
            let mut candy_coin = test_scenario::take_from_sender<Coin<CANDY>>(&scenario);
            
            escrow::create_offer<CANDY, PIE>(
                &mut candy_coin,
                100,
                1000,
                test_scenario::ctx(&mut scenario)
            );

            assert!(coin::value<CANDY>(&candy_coin) == 900, 2);
            test_scenario::return_to_sender(&scenario, candy_coin);
        };

        test_scenario::next_tx(&mut scenario, taker);
        {
            let mut escrow = test_scenario::take_shared<Escrow<CANDY, PIE>>(&scenario);

            let mut pie_coin = test_scenario::take_from_sender<Coin<PIE>>(&scenario);

            escrow::take_offer<CANDY, PIE>(
                &mut escrow,
                &mut pie_coin,
                test_scenario::ctx(&mut scenario)
            );

            test_scenario::return_to_sender(&scenario, pie_coin);
            test_scenario::return_shared<Escrow<CANDY, PIE>>(escrow);
        };

        test_scenario::next_tx(&mut scenario, admin);
        {
            let mut ids = test_scenario::ids_for_address<Coin<PIE>>(offeror);
            let mut sum = 0;

            while (!vector::is_empty(&ids)) {
                let id = vector::pop_back(&mut ids);
                let offeror_pie_coin = test_scenario::take_from_address_by_id<Coin<PIE>>(
                    &scenario,
                    offeror,
                    id
                );
                sum = sum + coin::value<PIE>(&offeror_pie_coin);
                test_scenario::return_to_address(offeror, offeror_pie_coin);
            };

            assert!(sum == 1020, 4);
        };

        test_scenario::end(scenario);
    }
}