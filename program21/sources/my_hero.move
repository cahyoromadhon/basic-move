// Sui Object Display Program

module program21::my_hero {
    use std::string::String;
    use sui::package;
    use sui::display;

    public struct Hero has key, store {
        id: UID,
        name: String,
        url: String,
    }

    public struct MY_HERO has drop {}

    fun init(otw: MY_HERO, ctx: &mut TxContext) { // otw = One Time Witness
        let keys = vector[
            b"name".to_string(),
            b"image_url".to_string(),
            b"description".to_string(),
            b"project_url".to_string(),
            b"creator".to_string(),
        ];

        let values = vector[
            b"{name}".to_string(),
            b"{url}".to_string(),
            b"Smart Contract Engineer on SUI".to_string(),
            b"https://cahyorom.dev".to_string(),
            b"Cahyo Romadhon".to_string(),
        ];

        let publisher = package::claim(otw, ctx);
        let mut display = display::new_with_fields<Hero>(&publisher, keys, values, ctx);

        display.update_version();

        transfer::public_transfer(publisher, ctx.sender());
        transfer::public_transfer(display, ctx.sender());
    }

    entry fun mint(name: String, url: String, ctx: &mut TxContext) {
        let hero = Hero {
            id: object::new(ctx),
            name,
            url,
        };
        sui::transfer::transfer(hero, tx_context::sender(ctx));
    }
}