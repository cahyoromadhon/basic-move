module program4::hello {

    public struct HelloWorldObject has key {
        id: UID,
        text: vector<u8>
    }

    public entry fun mint(ctx: &mut TxContext) {
        let object = HelloWorldObject {
            id: object::new(ctx),
            text: b"Hello World!"
        };
        transfer::transfer(object, tx_context::sender(ctx));
    }
}