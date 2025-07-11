module learn_move::counter;

public struct Counter has key, store {
    id: UID,
    value: u64,
}

// function spesial: yang hanya dieksekusi sekali saat publish
fun init(ctx: &mut TxContext) {
    let counter = create_counter(ctx);
    transfer::share_object(counter);
}

fun create_counter(ctx: &mut TxContext): Counter {
    let counter = Counter {
        id: object::new(ctx),
        value: 0,
    };
    
    counter
}

public fun get_value(counter: &Counter): u64 {
    counter.value
}

public fun increment(counter: &mut Counter) {
    counter.value = counter.value + 1;
}

// fungsi yang punya attribute #[test_only] hanya bisa dipanggil di dalam test
#[test_only]
public fun create_counter_for_testing(ctx: &mut TxContext): Counter {
    create_counter(ctx)
}