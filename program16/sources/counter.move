module program16::counter {

    public struct Counter has key {
        id: UID,
        value: u64,
    }

    fun init(ctx: &mut TxContext) {
        transfer::share_object(Counter { id: object::new(ctx), value: 0 });
    }

    entry fun increment(c: &mut Counter) {
        c.value = c.value + 1;
    }

    public fun get_value(c: &Counter): u64 {
        c.value
    }
}