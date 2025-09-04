module program12::swap_token {
    use sui::coin::{Self, Coin};
    use sui::balance::{Self, Balance};

    // Struct untuk menyimpan liquidity pool
    public struct LiquidityPool<phantom T1, phantom T2> has key, store {
        id: UID,
        token1: Balance<T1>,
        token2: Balance<T2>,
    }
    // deklarasikan struct bernama LiquidityPool yang menyimpan ID unik dan dua jenis token
    // phantom digunakan untuk menunjukkan bahwa T1 dan T2 adalah tipe generik yang akan ditentukan saat runtime
    // struct ini memiliki abilitiy key dan store yang berarti dapat disimpan dan diakses dalam konteks Sui
    
    // Fungsi untuk membuat liquidity pool baru
    public fun create_pool<T1, T2>(
        ctx: &mut TxContext
    ): LiquidityPool<T1, T2> {
        LiquidityPool {
            id: object::new(ctx),
            token1: balance::zero<T1>(),
            token2: balance::zero<T2>(),
        }
    }
    // fungsi ini membuat liquidity pool baru dengan ID unik dan dua jenis token yang memiliki saldo awal nol
    // deklarasikan fungsi menggunakan visibilitas public sehingga dapat diakses dari luar modul
    // fungsi ini bernama create_pool
    // <T1, T2> adalah tipe generik yang akan ditentukan saat runtime
    // ctx adalah konteks transaksi
    // deklarasikan object LiquidityPool dengan ID unik menggunakan object::new(ctx)
    // dan saldo awal nol untuk kedua token menggunakan balance::zero<T1>() dan balance::zero<T2>()

    // Fungsi untuk menambahkan likuiditas ke pool
    public fun add_liquidity<T1: key + store, T2: key + store>(
        pool: &mut LiquidityPool<T1, T2>,
        coin1: Coin<T1>,
        coin2: Coin<T2>
    ) {
        let amount1 = coin::value(&coin1);
        let amount2 = coin::value(&coin2);
        balance::join(&mut pool.token1, coin::into_balance(coin1));
        balance::join(&mut pool.token2, coin::into_balance(coin2));
        // Logika untuk menghitung liquidity token, dsb.
    }
    

    // Fungsi untuk swap token
    public fun swap<T1: key + store, T2: key + store>(
        pool: &mut LiquidityPool<T1, T2>,
        input: Coin<T1>,
        ctx: &mut TxContext
    ): Coin<T2> {
        let input_amount = coin::value(&input);
        balance::join(&mut pool.token1, coin::into_balance(input));
        
        // Logika sederhana: 1:1 swap untuk contoh
        let output_amount = input_amount; // Ganti dengan logika AMM sebenarnya
        let output_balance = balance::split(&mut pool.token2, output_amount);
        coin::from_balance(output_balance, ctx)
    }

    // Fungsi untuk mengambil pool dan transfer ke pengguna
    public fun transfer_pool<T1, T2>(
        pool: LiquidityPool<T1, T2>,
        recipient: address
    ) {
        transfer::transfer(pool, recipient);
    }
}