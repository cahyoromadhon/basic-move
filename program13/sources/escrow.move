module program13::escrow {
    use sui::balance::{Self, Balance};
    use sui::coin::{Self, Coin};

// Error Handling
    const EInactiveEscrow: u64 = 0; // Kode error 0 menunjukkan escrow tidak aktif saat aksi diminta.
    const ENotEnoughBalance: u64 = 1; // Kode error 1 menunjukkan koin pengambil tidak cukup untuk memenuhi expected_amount.

// Mendefinisikan struct Escrow berparameter jenis T (offered) dan Y (expected) sebagai phantom; memiliki ability key untuk shared object.
    public struct Escrow<phantom T, phantom Y> has key {
        id: UID,
        offeror: address, // Alamat pembuat penawaran (yang menawarkan token).
        offered_token: Balance<T>, // Saldo token yang ditawarkan, disimpan sebagai Balance<T> agar bisa berada dalam shared object.
        expected_amount: u64, // Jumlah token EXPECTED_TOKEN yang diminta penawar sebagai imbalan.
        active: bool, // Status escrow
    }

// Fungsi entry untuk membuat penawaran escrow antara OFFERED_TOKEN (ditawarkan) dan EXPECTED_TOKEN (diminta).
    entry fun create_offer<OFFERED_TOKEN, EXPECTED_TOKEN>( 

        // Parameter Fungsi: ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        offeror_coin: &mut Coin<OFFERED_TOKEN>, // Referensi mutable ke koin penawar dari jenis OFFERED_TOKEN (sumber dana yang akan ditahan).
        offered_amount: u64, // Jumlah OFFERED_TOKEN yang akan dimasukkan ke escrow.
        expected_amount: u64, // Jumlah EXPECTED_TOKEN yang diharapkan sebagai pembayaran dari pengambil.
        ctx: &mut TxContext, // Konteks transaksi
    ) {
        // Local Variable Declaration: ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        let sender = tx_context::sender(ctx); // Mendapatkan alamat pengirim transaksi (pencipta penawaran).
        let id = object::new(ctx); // Membuat UID baru untuk objek Escrow
        let offered_token = coin::split<OFFERED_TOKEN>(offeror_coin, offered_amount, ctx); // Memisahkan sejumlah offered_amount dari koin penawar menjadi koin baru (offered_token).

        // Fungsi Transfer ke Shared Storage: ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        transfer::share_object( // Men-share objek Escrow ke shared storage sehingga dapat diakses publik.
            Escrow<OFFERED_TOKEN, EXPECTED_TOKEN> { // Membangun instance Escrow dengan parameter jenis token.
                id, // Menetapkan UID yang baru dibuat.
                offeror: sender, // Menyimpan alamat penawar sebagai pemilik yang akan menerima EXPECTED_TOKEN.
                offered_token: coin::into_balance<OFFERED_TOKEN>(offered_token), // Mengonversi koin yang di-split menjadi Balance<T> untuk disimpan pada shared object.
                expected_amount: expected_amount, // Menyimpan jumlah EXPECTED_TOKEN yang diharapkan dari pengambil.
                active: true, // Menandai escrow masih aktif sehingga bisa diambil (take).
            }
        );
    }

    // Fungsi entry untuk mengambil penawaran escrow yang sudah dibuat
    entry fun take_offer<OFFERED_TOKEN, EXPECTED_TOKEN>( 
        // Parameter Fungsi: ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        escrow: &mut Escrow<OFFERED_TOKEN, EXPECTED_TOKEN>, // Referensi mutable ke objek Escrow shared (diambil dari storage oleh caller).
        taker_coin: &mut Coin<EXPECTED_TOKEN>, // Referensi mutable ke koin dari pengambil berjenis EXPECTED_TOKEN sebagai pembayaran.
        ctx: &mut TxContext, // Konteks transaksi
    ) {
        // Validasi dan Aksi Transaksi: ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        assert!(escrow.active != false, EInactiveEscrow); // Memastikan escrow masih aktif; jika tidak, gagal dengan EInactiveEscrow.
        assert!(coin::value<EXPECTED_TOKEN>(taker_coin) >= escrow.expected_amount, ENotEnoughBalance);
        // Memastikan saldo koin pengambil cukup untuk memenuhi expected_amount; jika tidak, gagal dengan ENotEnoughBalance.

        // Local Variable Declaration: ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        let expected_coin = coin::split<EXPECTED_TOKEN>(taker_coin, escrow.expected_amount, ctx); // Memisahkan expected_amount dari koin pengambil menjadi koin baru sebagai pembayaran.
        let sender = tx_context::sender(ctx); // Mendapatkan alamat pengambil (pengirim transaksi saat ini).
        transfer::public_transfer(expected_coin, escrow.offeror);
        // Mentransfer koin EXPECTED_TOKEN hasil split kepada alamat offeror (penawar).
        let offered_token_value = balance::value<OFFERED_TOKEN>(&escrow.offered_token);
        // Membaca nilai total saldo Balance<T> yang ditahan di escrow.
        let offered_token = balance::split<OFFERED_TOKEN>(&mut escrow.offered_token, offered_token_value);
        // Memisahkan seluruh Balance<T> dalam escrow menjadi Balance<T> yang akan dikeluarkan (mengosongkan escrow).

        // Transfer ke Taker: ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        transfer::public_transfer(coin::from_balance<OFFERED_TOKEN>(offered_token, ctx), sender);
        // Mengonversi Balance<T> menjadi Coin<T> dan mentransfernya kepada pengambil (taker).
        escrow.active = false;
        // Menandai escrow tidak aktif (selesai dipenuhi).


// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        // shared object deletation is not supported at the moment
        // this will be supported: https://github.com/MystenLabs/sui/issues/2083

        // let Escrow {
        //     id: id,
        //     offeror: offeror,
        //     offered_token: offered_token,
        //     expected_amount: expected_amount,
        // } = escrow;
        // object::delete(id);
    }
}