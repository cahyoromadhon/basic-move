module program18::coinflip {
    use sui::{
        event, // Allows the contract to emit events, which are useful for logging and tracking actions.
        random::Random, // Provides random number generation capabilities. essential for simulating a coin flip.
    };

    // Stuct Definition Flip
    public struct Flip has copy, drop, store {
        player: address, // Address of the player who initiated the flip
        player_won: bool, // true if the player won, false otherwise
        bet: bool, // true for heads, false for tails
    }    

    // Private Function
    fun flip_coin(random: &Random, bet: bool, ctx: &mut TxContext): bool {
        let mut gen = random.new_generator(ctx);
        let result = gen.generate_bool();
        result == bet
    }

    // Entry Function
    entry fun flip(random: &Random, bet: bool, ctx: &mut TxContext) {
        let (player_won) = flip_coin(random, bet, ctx);
        let player = ctx.sender();

        event::emit(Flip {
            player,
            player_won,
            bet,
        });
    }
}

// copy artinya Instance Flip dapat disalin
// drop artinya Instance Flip dapat dihapus
// store artinya Instance Flip dapat disimpan di Sui Blockchain

// Deklarasi mutable variabel gen dengan value random.new_generator(ctx) artinya random sebagai module nya dan new_generator(ctx) sebagai functionnya
// Deklarasi variabel result yang berisi hasil dari gen.generate_bool()
// Fungsi generate_bool() menghasilkan nilai boolean acak (true atau false)
// Fungsi flip_coin mengembalikan true jika hasil koin (result) sesuai dengan taruhan pemain (bet), dan false sebaliknya

// Fungsi entry bernama flip dengan paramater random, bet, dan ctx
// random dengan referensi immutable ke Random module
// bet dengan tipe boolean yang menunjukkan pilihan taruhan pemain (true untuk kepala, false untuk ekor)
// ctx dengan referensi mutable ke TxContext yang menyediakan konteks transaksi saat ini
// deklarasi variabel player_won yang berisi hasil dari pemanggil fungsi flip_coin
// deklarasi variabel player yang berisi alamat pengirim transaksi (ctx.sender())
// Fungsi event::emit digunakan untuk memancarkan (emit) sebuah event Flip yang mencatat detail dari flip koin, termasuk alamat pemain, apakah pemain menang, dan pilihan taruhan mereka