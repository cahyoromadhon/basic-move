#[test_only]
module program24::program24_tests {
    use program24::add::{plus, plusplus};
    use std::unit_test::assert_eq;

    #[test]
    fun test_add() {
        let result = plus(2, 3);
        assert_eq!(result, 5);
    }

    #[test]
    fun test_add1() {
        let result = plus(10, 15);
        assert_eq!(result, 25);
    }

    #[test]
    fun test_add2() {
        let result = plusplus(10, 10, 20);
        assert!(result == 40, 2);
    }

    // mau berapapun parameter yang ada pada fungsi, assert hanya akan mengembalikan 2 parameter
    // parameter pertama adalah boolean expression yang akan di cek benar atau salah
    // parameter kedua adalah angka yang akan ditampilkan jika assert gagal
    // jadi assert hanya menerima 2 parameter saja
    // jika lebih atau kurang maka akan error

    // #[test] harus ada diatas fungsi test
    // jika tidak ada maka akan error

    // alasan mengapa ada angka 1 dibelakang koma adalah
    // untuk membedakan dengan test yang pertama
    // karena jika ada assert yang gagal maka akan menampilkan angka tersebut
    // sehingga kita bisa tahu test mana yang gagal
    // jadi angka tersebut adalah identifier untuk test tersebut
    // bisa diisi dengan angka berapapun yang unik untuk setiap test
    // misal 0, 1, 2, dst
    // atau bisa juga diisi dengan angka yang sama asalkan tidak ada assert yang gagal pada test tersebut

    // ada 2 metode dalam melakukan unit test menggunakan assert
    // yang pertama adalah manual dengan menulis assert!(boolean_expression, error_code);
    // yang kedua adalah otomatis dengan menulis assert_eq!(actual, expected);
    // assert_eq! hanya untuk membandingkan equality saja
    // sedangkan assert! bisa untuk membandingkan apapun yang menghasilkan boolean
    // keduanya bisa digunakan sesuai kebutuhan
}
