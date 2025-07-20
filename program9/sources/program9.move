// Hari ini kita akan mempelajari konsep Event di Move menggunakan usecase transfer token
// Dimulai dengan mendeklarasikan module
// Dilanjutkan dengan mendeklarasikan struct Token
// Kemudian mendeklarasikan event TransferEvent
// Inisialiasi fungsi mint token untuk membuat token baru
// Lalu mendeklarasikan fungsi transfer yang akan mengeluarkan event TransferEvent
// dan terakhir mendeklarasikan fungsi cek saldo untuk mengecek saldo token
module program9::token {

    public struct Token has key, store {
        id: UID,
        balance: u64,
    }

    #[ext(event)]
    public struct TransferEvent has copy, drop {
        from: address,
        to: address,
        amount: u64,
    }
    // address adalah sebuah tipe data yang memungkinkan kita dapat menyimpan sebuah alamat address didalamnya

    #[allow(lint(self_transfer))]
    public fun mint(amount: u64, ctx: &mut TxContext) {
        let token = Token {
            id: object::new(ctx),
            balance: amount,
        };
        transfer::transfer(token, tx_context::sender(ctx));
    }
    // transfer mengalami warning yang disebabkan karena kita melakukan transfer kepemilikan kepada diri kita sendiri yang dimana itu tidak diperlukan karena by default semenjak object itu dibuat maka itu sudah berada dikepemilikan orang yang memanggilnya sehingga ini adalah hal yang tidak perlu dilakukan
    // solusinya adalah dengan menambahkan anotasi #[allow(lint(self_transfer))]
    // walaupun ini hanya menghapus warning, gas tetap terpotong sesuai yang dibutuhkan transfer ownership ini

    public fun transfer_token(token: &mut Token, amount: u64, to: address, ctx: &mut TxContext) {
        // pastikan saldo cukup
        assert!(token.balance >= amount, 0x1);
        // assert berguna untuk memastikan apakah kondisi terpenuhi, ini mirip seperti konsep if namun jika di assert tidak ada else seperti if dan jika kondisi tidak terpenuhi maka akan menyebabkan error dan kode dihentikan

        // kurangi saldo token pengirim
        token.balance = token.balance - amount;

        // buat token baru untuk penerima
        let new_token = Token {
            id: object::new(ctx),
            balance: amount,
        };
        transfer::transfer(new_token, to);

        // emit event transfer
        sui::event::emit(TransferEvent {
            from: tx_context::sender(ctx),
            to: to,
            amount: amount,
        });
    } // Mekanisme dalam pentransferan ternyata bukanlah mengirim secara harfiah namun dilakukan secara dihapus dan ditambahkan agar menimbulkan kesan seperti token ditransfer

    // fungsi untuk mengecek saldo token
    public fun check_balance(token: &Token): u64 {
        token.balance
    }

}