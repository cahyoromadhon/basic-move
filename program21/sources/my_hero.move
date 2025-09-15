// Sui Object Display Program

module program21::my_hero {
    use std::string::String;
    use sui::package;
    use sui::display;

    public struct Hero has key, store {
        id: UID,
        name: String,
        url: String,
        description: String,
        creator: String,
    }

    public struct MY_HERO has drop {}

    fun init(otw: MY_HERO, ctx: &mut TxContext) { // otw = One Time Witness
        let keys = vector[
            std::string::utf8(b"name"),
            std::string::utf8(b"image_url"),
            std::string::utf8(b"description"),
            std::string::utf8(b"project_url"),
            std::string::utf8(b"creator"),
        ];

        let values = vector[
            std::string::utf8(b"{name}"),
            std::string::utf8(b"{url}"),
            std::string::utf8(b"Smart Contract Engineer on SUI"),
            std::string::utf8(b"https://cahyorom.dev"),
            std::string::utf8(b"Cahyo Romadhon"),
        ];

        let publisher = package::claim(otw, ctx);
        let mut display = display::new_with_fields<Hero>(&publisher, keys, values, ctx);

        display.update_version();

        transfer::public_transfer(publisher, ctx.sender());
        transfer::public_transfer(display, ctx.sender());
    }

    entry fun mint(name: String, url: String, description: String, creator: String, ctx: &mut TxContext) {
        let hero = Hero {
            id: object::new(ctx),
            name,
            url,
            description,
            creator,
        };
        transfer::public_transfer(hero, tx_context::sender(ctx));
    }
}