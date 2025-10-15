module program26::distributed_counter{

    public struct Counter has key, store {
        id: UID,
        owner: address,
        value: u64,
    }

    public fun create(ctx: &mut TxContext) {
        let counter = Counter {
            id: object::new(ctx),
            owner: ctx.sender(),
            value: 0,
        };
        transfer::share_object(counter);
    }

    public fun increment(self: &mut Counter) {
        self.value = self.value + 1
    }

    public fun decrement(self: &mut Counter) {
        self.value = self.value - 1
    }

    public fun view(self: &Counter): u64 {
        self.value
    }

    public fun set_value(self: &mut Counter, new_value: u64, ctx: &mut TxContext) {
        assert!(self.owner == ctx.sender(), 1);
        self.value = new_value
    }
}