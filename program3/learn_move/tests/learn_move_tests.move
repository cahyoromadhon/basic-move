#[test_only]
module learn_move::learn_move_tests;

use learn_move::counter;
use sui::test_scenario;

#[test]
fun test_increment() {
    let mut scenario = test_scenario::begin(@0x1);

    let mut counter = counter::create_counter_for_testing(scenario.ctx());

    // pastikan bahwa nilai awal counter adalah 0
    assert!(counter::get_value(&counter) == 0, 0x1);
    counter::increment(&mut counter);
    // pastikan bahwa nilai counter setelah increment adalah 1
    assert!(counter::get_value(&counter) == 1, 0x1);

    transfer::public_share_object(counter);
    scenario.end();
}