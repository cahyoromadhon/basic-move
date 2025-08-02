module program14::cahyo {
    use sui::coin::{Self, TreasuryCap};

    public struct CAHYO has drop {}

    fun init(witness: CAHYO, ctx: &mut TxContext) {
        let (treasury, metadata) = coin::create_currency(witness, 6, b"CAHYO", b"Cahyo Romadhon", b"ini adalah sebuah koin yang dicetak hanya untuk implementasian pembelajaran logika pemrograman", option::none(), ctx);
        transfer::public_freeze_object(metadata);
        transfer::public_transfer(treasury, ctx.sender());
    }

    public fun mint(
        treasury_cap: &mut TreasuryCap<CAHYO>,
        amount: u64,
        recipient: address,
        ctx: &mut TxContext
    ) {
        let coin = coin::mint(treasury_cap, amount, ctx);
        transfer::public_transfer(coin , recipient);
    }
}