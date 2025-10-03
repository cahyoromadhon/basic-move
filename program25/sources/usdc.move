module program25::usdc {
    use sui::url;
    use sui::coin;

    public struct USDC has drop {}
  
    fun init(witness: USDC, ctx: &mut TxContext) {
			let (treasury_cap, metadata) = coin::create_currency<USDC>(
            witness, // One time witness
            9, // Decimals of the coin
            b"USDC", // Symbol of the coin
            b"USDC Coin", // Name of the coin
            b"A stable coin issued by Circle", // Description of the coin
            option::some(url::new_unsafe_from_bytes(b"https://s3.coinmarketcap.com/static-gravity/image/5a8229787b5e4c809b5914eef709b59a.png")), // An image of the Coin
            ctx
        );
        transfer::public_transfer(treasury_cap, tx_context::sender(ctx));
		transfer::public_share_object(metadata);
    }

    #[test_only]
    public fun init_for_testing(ctx: &mut TxContext) {
        init(USDC {}, ctx);
    }
}
