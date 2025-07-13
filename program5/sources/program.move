// di sui move, ada satu spesial function yang hanya dieksekusi sekali dan function ini harus memiliki properti:
// name init, no return values, private

// Module Initializer Example
module program5::namaModul {

    public struct Once has key, store {
    id: UID,
    }

    fun init(ctx: &mut TxContext) {
    let on = Once {
        id: object::new(ctx)
    };
    transfer::transfer(on, tx_context::sender(ctx));
    }

    // Abilities:

    //// C can be duplicated, w/o copy, C mus be created via pack
    // struct C has copy {..} 

    //// D can be discarded, w/o drop, D must be eliminated via unpack
    // struct D has drop {..}

    //// K can appear in global storage
    // struct K has key {..}

    //// S can appear in a field of a key or store type
    // struct S has store {..}

    //// "Hot Potato" must be eliminated in the tx that created it
    // struct H has {..}


    // Ketika ingin mendeklarasikan sebuah struct, ada properti wajib yang ada didalamnya:       --(Mandatory artinya Wajib)

    // Mandatory key ability, yang menandakan bahwa struct tersebut adalah object di Sui
    // Mandatory id fields yang beguna untuk disimpan di globally unique identifier

    // 4 Tipe Object Ownership
    // Owned by address, (ini adalah tipe object yang paling sering digunakan karena bisa memungkinkan untuk melakukan transfer ownership dari object ke address)
    // Owned by another object, (tipe object yang ownership nya dapat dimiliki oleh object lain dengan pengaturan tambahan)
    // Immutable, (sekali dipublish tidak akan pernah bisa ditarik kembali dan bisa dibilang read-only)
    // Object Shared, (semua orang bisa menggunakannya tidak ada satupun entitas yang dapat memilikinya)


    // Owned by Address Ex:
    // fun address_owned_object<T: key>(t: T, addr: address) {
    //     transfer::transfer(t, addr)
    // }
    // note: sekarang, transaksi hanya bisa dilakukan oleh address

    // Object Shared / Shared Owner
    // fun shared_owner<T: key>(t: T) {
    // transfer::transfer(t, addr)
    // } 
    // note: sekarang, semua orang(address) dapat menggunakan object ini


    // Mari bahas owned object and shared object lebih dalam
    // pada owned object dibagi menjadi 2 yaitu: owned by an address & owned by another object

    // owned by an address, ini memungkinkan kepemilikan dari object ini dipindahkan ke alamat address
    // ex: transfer::transfer(TranscriptObject, tx_context::sender(ctx))
    // tx_context::sender(ctx) ini adalah penerima / recipient

    // owned by another project, kepemilikan dari object dipindahkan ke object yang lain dan object yang dimiliki ini dinamakan child object dan object yang memiliki adalah parent object (struktur hierarki) namun yang membuat sui ini special adalah tidak peduli apakah itu child object atau parent object sekalipun akan tetap disimpan di sui secara global storage dan memiliki id unik nya masing-masing tanpa bergabung kedalam struktur parent nya, hal ini memudahkan skalabilitas
    // ex: dynamic_object_field
    // akan dibahas lebih lanjut nanti

    // sekarang mari beralih ke shared object
    // shared immutable
    // seperti namanya sekali object ini dipublish maka tidak akan pernah bisa diubah lagi dan object ini bisa digunakan secara bebas oleh object lain
    // ex: transfer::freeze_object(obj;

    // shared mutable
    // object ini bisa digunakan oleh siapa saja, selain bisa dibaca mereka juga bisa mengubahnya namun agar bisa diubah membutuhkan global ordering melalui consensus layer protocol
    // ex: transfer::share_object(obj);
}
