#[test_only]
module program23::program23_tests {
    use sui::test_scenario::{Self};
    use sui::coin::{Self, TreasuryCap, Coin};
    use program23::coins::{Self, COINS};

    // Test addresses
    const ADMIN: address = @0xA;
    const USER1: address = @0xB;
    const USER2: address = @0xC;

    #[test]
    fun test_init_coin_creation() {
        let mut scenario = test_scenario::begin(ADMIN);
        
        // Test init function
        {
            coins::test_init(test_scenario::ctx(&mut scenario));
        };
        
        // Check if treasury cap was created and transferred to admin
        test_scenario::next_tx(&mut scenario, ADMIN);
        {
            assert!(test_scenario::has_most_recent_for_sender<TreasuryCap<COINS>>(&scenario), 0);
        };
        
        test_scenario::end(scenario);
    }

    #[test]
    fun test_mint_coins() {
        let mut scenario = test_scenario::begin(ADMIN);
        
        // Initialize the coin
        {
            coins::test_init(test_scenario::ctx(&mut scenario));
        };
        
        // Admin gets the treasury cap
        test_scenario::next_tx(&mut scenario, ADMIN);
        {
            let mut treasury_cap = test_scenario::take_from_sender<TreasuryCap<COINS>>(&scenario);
            
            // Mint 1000 coins to USER1
            coins::mint(&mut treasury_cap, 1000, USER1, test_scenario::ctx(&mut scenario));
            
            test_scenario::return_to_sender(&scenario, treasury_cap);
        };
        
        // Check if USER1 received the coins
        test_scenario::next_tx(&mut scenario, USER1);
        {
            assert!(test_scenario::has_most_recent_for_sender<Coin<COINS>>(&scenario), 1);
            let coin = test_scenario::take_from_sender<Coin<COINS>>(&scenario);
            assert!(coin::value(&coin) == 1000, 2);
            test_scenario::return_to_sender(&scenario, coin);
        };
        
        test_scenario::end(scenario);
    }

    #[test]
    fun test_mint_multiple_times() {
        let mut scenario = test_scenario::begin(ADMIN);
        
        // Initialize the coin
        {
            coins::test_init(test_scenario::ctx(&mut scenario));
        };
        
        // Admin gets the treasury cap and mints to multiple users
        test_scenario::next_tx(&mut scenario, ADMIN);
        {
            let mut treasury_cap = test_scenario::take_from_sender<TreasuryCap<COINS>>(&scenario);
            
            // Mint to USER1 and USER2
            coins::mint(&mut treasury_cap, 500, USER1, test_scenario::ctx(&mut scenario));
            coins::mint(&mut treasury_cap, 750, USER2, test_scenario::ctx(&mut scenario));
            
            test_scenario::return_to_sender(&scenario, treasury_cap);
        };
        
        // Check USER1's balance
        test_scenario::next_tx(&mut scenario, USER1);
        {
            let coin = test_scenario::take_from_sender<Coin<COINS>>(&scenario);
            assert!(coin::value(&coin) == 500, 3);
            test_scenario::return_to_sender(&scenario, coin);
        };
        
        // Check USER2's balance
        test_scenario::next_tx(&mut scenario, USER2);
        {
            let coin = test_scenario::take_from_sender<Coin<COINS>>(&scenario);
            assert!(coin::value(&coin) == 750, 4);
            test_scenario::return_to_sender(&scenario, coin);
        };
        
        test_scenario::end(scenario);
    }

    #[test]
    fun test_mint_zero_amount() {
        let mut scenario = test_scenario::begin(ADMIN);
        
        // Initialize the coin
        {
            coins::test_init(test_scenario::ctx(&mut scenario));
        };
        
        // Admin gets the treasury cap and mints 0 coins
        test_scenario::next_tx(&mut scenario, ADMIN);
        {
            let mut treasury_cap = test_scenario::take_from_sender<TreasuryCap<COINS>>(&scenario);
            
            // Mint 0 coins to USER1
            coins::mint(&mut treasury_cap, 0, USER1, test_scenario::ctx(&mut scenario));
            
            test_scenario::return_to_sender(&scenario, treasury_cap);
        };
        
        // Check if USER1 received a coin with 0 value
        test_scenario::next_tx(&mut scenario, USER1);
        {
            let coin = test_scenario::take_from_sender<Coin<COINS>>(&scenario);
            assert!(coin::value(&coin) == 0, 5);
            test_scenario::return_to_sender(&scenario, coin);
        };
        
        test_scenario::end(scenario);
    }

    #[test]
    fun test_large_mint_amount() {
        let mut scenario = test_scenario::begin(ADMIN);
        
        // Initialize the coin
        {
            coins::test_init(test_scenario::ctx(&mut scenario));
        };
        
        // Admin gets the treasury cap and mints large amount
        test_scenario::next_tx(&mut scenario, ADMIN);
        {
            let mut treasury_cap = test_scenario::take_from_sender<TreasuryCap<COINS>>(&scenario);
            
            // Mint large amount (1 billion with 9 decimals)
            let large_amount = 1_000_000_000_000_000_000u64; // 1 billion * 10^9
            coins::mint(&mut treasury_cap, large_amount, USER1, test_scenario::ctx(&mut scenario));
            
            test_scenario::return_to_sender(&scenario, treasury_cap);
        };
        
        // Check if USER1 received the large amount
        test_scenario::next_tx(&mut scenario, USER1);
        {
            let coin = test_scenario::take_from_sender<Coin<COINS>>(&scenario);
            assert!(coin::value(&coin) == 1_000_000_000_000_000_000u64, 6);
            test_scenario::return_to_sender(&scenario, coin);
        };
        
        test_scenario::end(scenario);
    }

    #[test]
    fun test_treasury_cap_ownership() {
        let mut scenario = test_scenario::begin(ADMIN);
        
        // Initialize the coin
        {
            coins::test_init(test_scenario::ctx(&mut scenario));
        };
        
        // Only admin should have the treasury cap
        test_scenario::next_tx(&mut scenario, ADMIN);
        {
            assert!(test_scenario::has_most_recent_for_sender<TreasuryCap<COINS>>(&scenario), 7);
        };
        
        // USER1 should not have treasury cap
        test_scenario::next_tx(&mut scenario, USER1);
        {
            assert!(!test_scenario::has_most_recent_for_sender<TreasuryCap<COINS>>(&scenario), 8);
        };
        
        test_scenario::end(scenario);
    }
}
