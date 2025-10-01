module program23::coins {
    use sui::coin;

    public struct COINS has drop {}

    fun init(witness: COINS, ctx: &mut TxContext) {
        let (treasury, metadata) = coin::create_currency(
            witness,
            9,
            b"CAHYO",
            b"Cahyo Romadhon",
            b"Coin ini dibuat oleh Cahyo Romadhon pada program ke 23",
            option::none(),
            ctx
        );
        transfer::public_freeze_object(metadata);
        transfer::public_transfer(treasury, tx_context::sender(ctx));
    }

    entry fun mint(treasury: &mut coin::TreasuryCap<COINS>, amount: u64, recipient: address, ctx: &mut TxContext) {
        coin::mint_and_transfer(treasury, amount, recipient, ctx)
    }

    #[test_only]
    public fun test_init(ctx: &mut TxContext) {
        init(COINS {}, ctx)
    }
}