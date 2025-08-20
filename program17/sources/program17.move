// Module Declaration
module program17::first {
    
    // Struct Definitions
    public struct Sword has key, store {
        id: UID,
        magic: u64,
        attack: u64,
    }

    public struct Forge has key {
        id: UID,
        sword_created: u64,
    }

    // Module Initializer once it published
    fun init(ctx: &mut TxContext) {
        let admin = Forge {
            id: object::new(ctx),
            sword_created: 0,
        };
        transfer::transfer(admin, ctx.sender());
    }

    public fun magic(self: &Sword): u64 {
        self.magic 
    }
    // fungsi dari function ini berguna untuk membaca field struct dari struct bernama Sword ini dengan cara mengambilnya menggunakan function
    // dia mengambil field dengan cara memanggil struct dan dideklarasikan didalam parameternya tapi tidak hanya itu dia juga menggunakan reference agar read only
    // arti (parameter): nilai dari field struct yang berusaha diambil

    public fun attack(self: &Sword): u64 {
        self.attack
    }
    // same logic

    public fun sword_created(self: &Forge): u64 {
        self.sword_created
    }
    // Apakah bisa mengambil struct local didalam function? aku barutahu jika itu bisa dilakukan atau entah ini illegal moves?

}