// Modul untuk mendefinisikan koin kustom MYCOIN
module program10::mycoin {
    use sui::coin::{Self, TreasuryCap};

    /// Mendefinisikan tipe koin kustom MYCOIN
    public struct MYCOIN has drop {}

    /// Inisialisasi koin kustom saat modul dideploy (internal)
    fun init(witness: MYCOIN, ctx: &mut TxContext) {
        let (treasury_cap, metadata) = coin::create_currency(
            witness,
            6,                          // Desimal (precision)
            b"MYCOIN",                  // Simbol
            b"My Custom Coin",          // Nama
            b"MYCOIN for testing",      // Deskripsi
            option::none(),             // Ikon (opsional)
            ctx
        );
        transfer::public_transfer(treasury_cap, tx_context::sender(ctx));
        transfer::public_share_object(metadata);
    }

    /// Fungsi untuk mencetak koin (hanya pemilik treasury_cap yang bisa)
    entry fun mint(
        treasury_cap: &mut TreasuryCap<MYCOIN>,
        amount: u64,
        recipient: address,
        ctx: &mut TxContext
    ) {
        let coin = coin::mint(treasury_cap, amount, ctx);
        transfer::public_transfer(coin, recipient);
    }
}

// Modul untuk mengelola wallet dengan koin MYCOIN
module program10::simple_wallet {
    use sui::coin::{Self, Coin};
    use sui::balance::{Self, Balance};
    use program10::mycoin::MYCOIN;

    /// Struktur untuk menyimpan wallet
    public struct Wallet has key, store {
        id: UID,
        balance: Balance<MYCOIN>,
    }

    /// Membuat wallet baru
    entry fun create_wallet(ctx: &mut TxContext) {
        let wallet = Wallet {
            id: object::new(ctx),
            balance: balance::zero(),
        };
        transfer::transfer(wallet, tx_context::sender(ctx));
    }

    /// Menyetor koin ke wallet
    entry fun deposit(wallet: &mut Wallet, coin: Coin<MYCOIN>) {
        let coin_balance = coin::into_balance(coin);
        balance::join(&mut wallet.balance, coin_balance);
    }

    /// Menarik koin dari wallet
    entry fun withdraw(wallet: &mut Wallet, amount: u64, ctx: &mut TxContext) {
        assert!(balance::value(&wallet.balance) >= amount, 0); // Validasi saldo
        let withdrawn_balance = balance::split(&mut wallet.balance, amount);
        let coin = coin::from_balance(withdrawn_balance, ctx);
        transfer::public_transfer(coin, tx_context::sender(ctx));
    }

    /// Mengecek saldo wallet
    public fun check_balance(wallet: &Wallet): u64 {
        balance::value(&wallet.balance)
    }
}