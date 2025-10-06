module program25::dex {
    use std::type_name::{get, TypeName};
    use sui::sui::SUI;
    use sui::clock::{Clock};
    use sui::balance::{Self, Supply};
    use sui::table::{Self, Table};
    use sui::dynamic_field as df;
    use sui::coin::{Self, TreasuryCap, Coin};
    use deepbook::clob_v2::{Self as clob, Pool};
    use deepbook::custodian_v2::AccountCap;
    use program25::eth;
    use program25::usdc;

    const CLIENT_ID: u64 = 122227; // Example client ID
    const MAX_U64: u64 = 18446744073709551615; // Maximum Value for u64, it used for infinity timestamp
    const NO_RESTRICTION: u8 = 0; // no restriction when placing limit order and used as a placeholder
    const FLOAT_SCALING: u64 = 1_000_000_000; // it used to convert between decimal and integer, contohnya adalah 1.5 menjadi 1_500_000_000
    const EAlreadyMintedThisEpoch: u64 = 0; // error code used in mint_function that user already minted in this epoch

    public struct DEX has drop {}

    public struct Data<phantom CoinType> has store {
        cap: TreasuryCap<CoinType>,
        faucet_lock: Table<address, u64>,
    }

    // Data dideklarsikan menggunakan Generic Type Parameter CoinType, ini memungkinkan kita untuk membuat instance Data untuk berbagai tipe koin seperti Data<ETH> dan Data<USDC>

    // phantom digunakan disini karena tidak semua field di struct Data menggunakan CoinType, hanya field cap yang menggunakannya, sedangkan field faucet_lock tidak menggunakannya

    // alasan mengapa kita bisa menggunakan berbagai tipe koin karena pada dasarnya TreasuryCap berasal dari module coin dan bisa dibilang TreasuryCap<T> ini adalah universal pattern yang bisa diimplementasikan untuk berbagai tipe koin, jadi kita bisa membuat TreasuryCap<ETH> untuk koin ETH, TreasuryCap<USDC> untuk koin USDC, TreasuryCap<DEX> untuk koin DEX, dan seterusnya

    // faucet_lock menggunakan Table<address, u64> yang berasal dari module table, ini adalah resource yang dapat menyimpan pasangan key-value, dalam kasus ini kita menggunakan address sebagai key dan u64 sebagai value, ini digunakan untuk menyimpan informasi kapan terakhir kali user melakukan minting koin DEX berdasarkan epoch

    public struct Storage has key {
        id: UID,
        dex_supply: Supply<DEX>, // represent total supply of DEX coin
        swaps: Table<address, u64>,
        account_cap: AccountCap,
        client_id: u64,
    }
    // Supply<T> berasal dari module balance, ini adalah resource yang dapat melacak total supply dari sebuah koin tertentu menggunakan tipe koin tersebut sebagai parameter generik dan dengan begitu kita dapat mengetahui total supply dari koin DEX

    // Table<K, V> berasal dari module table, ini adalah resource yang dapat menyimpan pasangan key-value, dalam kasus ini kita menggunakan address sebagai key dan u64 sebagai value, ini digunakan untuk menyimpan informasi swap yang telah dilakukan oleh user seperti berapa banyak swap yang telah dilakukan oleh user tertentu dengan menggunakan value u64 sebagai penghitungnya

    // AccountCap berasal dari module Deepbook custodian_v2, ini adalah resource yang memberikan kemampuan kepada contract untuk berinteraksi dengan Deepbook, seperti membuat pool baru, menempatkan order, dan lain-lain

    fun init(witness: DEX, ctx: &mut TxContext) {
        let (treasury_cap, metadata) = coin::create_currency(
        witness,
        9,
        b"DEX",
        b"Dex Coin", 
        b"", 
        option::none(), 
        ctx
        );
        transfer::public_freeze_object(metadata);
        transfer::share_object(Storage {
            id: object::new(ctx),
            dex_supply: coin::treasury_into_supply(treasury_cap), // Supply tracking
            swaps: table::new(ctx),                                    // Trading history
            account_cap: clob::create_account(ctx),                         // DeepBook integration
            client_id: CLIENT_ID,                                           // Protocol config
        });
    }

    // Alasan mengapa share_object menggunakan object Storage daripada treasury_cap secara langsung adalah karena program ini ditujukan untuk Defi yang dimana memberikan fungsionalitas tambahan dari pattern pada umumnya yang sebatas mint & burn dan pattern yang digunakan disini disebut Protocol Wrapper

    // treausry_into_supply digunakan untuk mengkonversi TreasuryCap<DEX> menjadi Supply<DEX> yang memungkinkan kita untuk melacak total supply dari koin DEX

    // table::new(ctx) digunakan untuk membuat Table baru yang akan digunakan untuk menyimpan informasi swap yang telah dilakukan oleh user

    // Table adalah resource on-chain yang dapat menyimpan data secara persisten sehingga pada usecase kali ini table digunakan pada level instance karena nantinya setiap Storage akan memiliki table masing-masing yang berguna untuk menyimpan data swap yang telah dilakukan oleh user

    // clob::create_account(ctx) digunakan untuk membuat akun Deepbook yang memungkinkan contract untuk berinteraksi dengan Deepbook

    // client_id adalah ID unik yang digunakan untuk mengidentifikasi client pada Deepbook, ini diperlukan untuk menghubungkan contract dengan akun Deepbook yang sesuai

    // pembuatan akun disini dilakukan sekali dan hanya dimiliki oleh contract saja, tidak untuk user, jadi contract inilah yang akan berinteraksi dengan Deepbook, bukan user secara langsung

    public fun user_last_mint_epoch<CoinType>(self: &Storage, user: address): u64 {
        let data = df::borrow<TypeName, data<CoinType>>(&self.id, get<CoinType>());

        if (table::contains(&data.faucet_lock, user)) return *table::borrow(&data.faucet_lock, user);
        0
    }

    public fun user_swap_count(self: &Storage, user: address): u64 {
        if table::contains(&self.swaps, user) return *table::borrow(&self.swaps, user);
        0
    }

    public fun entry_place_market_order(
        self: &mut Storage,
        pool: &mut Pool<ETH, USDC>,
        account_cap: &AccountCap,
        quantity: u64,
        is_bid: bool,
        base_coin: coin<ETH>,
        quote_coin: coin<USDC>,
        c: &Clock,
        ctx: &mut TxContext
    ) {
        let (eth, usdc, coin_dex) = place_market_order(self, pool, account_cap, quantity, is_bid, base_coin, quote_coin, c, ctx);
        let sender = tx_context::sender(ctx);
        transfer_coin(eth, sender),
        transfer_coin(usdc, sender),
        transfer_coin(dex_coin, sender)
    }

    public fun place_market_order(
        self: &mut Storage,
        pool: &mut Pool<ETH, USDC>,
        account_cap: &AccountCap,
        quantity: u64,
        is_bid: bool,
        base_coin: coin<ETH>,
        quote_coin: coin<USDC>,
        c: &Clock,
        ctx: &mut TxContext
        ): (coin<ETH>, coin<USDC>, coin<DEX>) {
        let sender = tx_context::sender(ctx);
        let client_order_id = 0;
        let dex_coin = coin::zero(ctx);

        if (table::contains(&self.swaps, sender)) {
            let total_swaps = table::borrow_mut(&mut self.swaps, sender);
            let new_total_swaps = *total_swaps + 1;
            *total_swaps = new_total_swaps;
            client_order_id = new_total_swaps;

            if ((new_total_swaps % 2) == 0) {
                coin::join(&mut dex_coin, coin::from_balance(balance::increase_supply(&mut self.dex_supply, FLOAT_SCALING), ctx));
            };
        } else {
            table::add(&mut self, swaps, sender, 1);
        };

        let (eth_coin, usdc_coin) = clob::place_market_order<ETH, USDC>(
            pool,
            account_cap, 
            client_order_id, 
            quantity,
            is_bid,
            base_coin,
            quote_coin,
            c,
            ctx
        );
        (eth_coin, usdc_coin, dex_coin)
    }

    public fun create_pool(fee: Coin<SUI>, ctx: &mut TxContext) {
        clob: create_pool<ETH, USDC>(1 * FLOAT_SCALING, 1, fee, ctx)
    }

    public fun fill_pool(
        self: &mut Storage,
        pool: &mut Pool<ETH, USDC>,
        c: &Clock,
        ctx: &mut TxContext
    ) {
        create_ask_orders(self, pool, c, ctx)
        create_bid_orders(self, pool, c, ctx)
    }
}