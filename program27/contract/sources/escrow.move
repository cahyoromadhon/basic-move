module contract::escrow;
use sui::dynamic_object_field as dof;
use sui::event;

public struct LockedObjectKey has copy, drop, store {}

// A wrapper that locked access to object by requiring a key
public struct Locked<phantom T: key + store> has key, store {
    id: UID,
    key: ID,
}

// Key to open locked object
public struct Key has key, store { id: UID }

public struct LockCreated has copy, drop {
    lock_id: ID,
    key_id: ID,
    creator: address,
    item_id: ID,
}

public struct LockDestroyed has copy, drop {
    lock_id: ID,
}

const ELockKeyMismatch: u64 = 0;

public fun lock<T: key + store>(obj: T, ctx: &mut TxContext): (Locked<T>, Key) {
    let key = Key { id: object::new(ctx) };
    let mut lock = Locked {
        id: object::new(ctx),
        key: object::id(&key),
    };
    
    event::emit(LockCreated {
        lock_id: object::id(&lock),
        key_id: object::id(&key),
        creator: ctx.sender(),
        item_id: object::id(&obj),
    });

    dof::add(&mut lock.id, LockedObjectKey {}, obj);

    (lock, key)
}

public fun unlock<T: key + store>(mut locked: Locked<T>, key: Key): T {
    assert!(locked.key == object::id(&key), ELockKeyMismatch);
    let Key { id } = key;
    id.delete();

    let obj = dof::remove<LockedObjectKey, T>(&mut locked.id, LockedObjectKey {});

    event::emit(LockDestroyed { lock_id: object::id(&locked) });

    let Locked { id, key: _ } = locked;
    id.delete();
    obj
}

#[test_only]
use sui::coin::{Self, Coin};
#[test_only]
use sui::sui::SUI;
#[test_only]
use sui::test_scenario::{Self as ts, Scenario};

#[test_only]
fun test_coin(ts: &mut Scenario): Coin<SUI> {
    coin::mint_for_testing<SUI>(42, ts.ctx())
}

#[test]
fun test_lock_unlock() {
    let mut ts = ts::begin(@0xA);
    let coin = test_coin(&mut ts);

    let (lock, key) = lock(coin, ts.ctx());
    let coin = lock.unlock(key);

    coin.burn_for_testing();
    ts.end();
}

#[test]
#[expected_failure(abort_code = ELockKeyMismatch)]
fun test_lock_key_mismatch() {
    let mut ts = ts::begin(@0xA);
    let coin = test_coin(&mut ts);
    let another_coin = test_coin(&mut ts);
    let (l, _k) = lock(coin, ts.ctx());
    let (_l, k) = lock(another_coin, ts.ctx()); 

    let _key = l.unlock(k);
    abort 1337
}