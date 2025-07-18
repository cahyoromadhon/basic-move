// Hari ini kita akan mempelajari sebuah konsep bernama Object Wrapping
#[allow(unused_field)]

module program7::example { 

    public struct Wrapper has key {
        id: UID,
        inner_object: InnerObject,
    }

    public struct InnerObject has store {
        value: u64,
    }
}

// Karena ini adalah contoh saja maka aku akan mendeklarasikannya program ini sebagai unused agar tetap dapat berjalan
// Deklarasikan module dengan nama pacakage program7 dan nama module example
// deklarasikan struct dengan visibility public dan Wrapper sebagai identifier
// object Wrapper memiliki ability key yang berarti object ini dapat disimpan diblockchain dengan ID unik
// if struct = has (ability) key
//    struct = object
// deklarasikan field bernama id dengan value UID agar object dapat menyimpan id unik
// deklarasikan field bernama inner_object dengan Value InnerObject
// nantinya InnerObject yang ada di dalam object Wrapper akan dideklarasikan diluar dari object Wrapper
// deklarasikan struct/object bernama InnerObject dan berikan ability nya cukup store saja agar object nya bisa disimpan di dalam object Wrapper
// object InnerObject juga memiliki field yaitu value dengan nilai uint 64bytes
// simply cara kerjanya adalah dengan melakukan deklarasi field dengan value object dan object ini nantinya akan dideklarasikan dan akan menjadi object wrapped atau object yang dibungkus
// dalam kehidupan nyata bagaimana pengimplementasian dari konsep Object Wrapping ini?
// implementasinya akan dijelaskan secara terpisah pada module lain namun masih satu package