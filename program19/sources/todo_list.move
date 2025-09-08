module program19::todo_list {
    use std::string::String;

    // Mendeklarasikan struct TodoList dengan ability key dan store agar bisa disimpan di blockchain
    // Key untuk mengidentifikasi resource, artinya setiap account bisa memiliki satu instance dari resource ini
    // Store untuk menyimpan resource di dalam account
    public struct TodoList has key, store {
        id: UID,
        items: vector<String>, // vector dengan tipe String untuk menyimpan daftar todo, <> menandakan generic type artinya bisa diisi dengan tipe data apapun
    }

    public fun new(ctx: &mut TxContext): TodoList { // deklarasi fungsi dengan parameter ctx agar bisa mengakses context transaksi atau simplenya mengubah kepemilikan resource
        let list = TodoList { // deklarasi variabel local bernama list dengan value struct TodoList
            id: object::new(ctx), // id dibuat ulang
            items: vector[], // sekarang items memiliki value vector kosong dengan array dan generic type String mengikuti struct TodoList
        };
        (list) // Return the new TodoList instance
    }

    public fun add(list: &mut TodoList, item: String) { // fungsi add dengan parameter variabel local dengan mutable agar bisa mengubah value resource dan item dengan tipe String
        list.items.push_back(item); // .push_back adds an item to the end of the vector
    } // .push_back merupakan built-in function dari vector

    // Remove todo
    public fun remove(list: &mut TodoList, index: u64): String { // fungsi dengan parameter mutabel list agar bisa diubah value resource nya dan index dengan tipe u64 untuk menentukan index item yang akan dihapus namun fungsi ini mengembalikan String
        list.items.remove(index) // .remove removes and returns the item at the specified index
    } // .remove merupakan built-in function dari vector

    public fun delete(list: TodoList) { // fungsi bernama delete dengan parameter list yang valuenya mengambil dair struct
        let TodoList { id, items: _ } = list; // destructuring assignment untuk mengambil id dari struct TodoList, sedangkan items diabaikan dengan _
        id.delete(); // menghapus id dari resource
        // items diabaikan karena vector akan otomatis dibersihkan ketika resource dihapus
    }

    public fun length(list: &TodoList): u64 { // ini adalah fungsi yang hanya membaca panjang vector items tanpa mengubahnya sehingga refrence immutable digunakan pada TodoList dan tentunya fungsi ini mengembalikan nilai u64 atau integer
        list.items.length() // list mengakses variabel, items mengakses properti struct, dan .length() adalah built-in function dari vector yang mengembalikan panjang vector
    }
}