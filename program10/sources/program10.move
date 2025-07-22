// Hari ini kita akan mempelajari konsep Sui Framework di Move yaitu sui::coin untuk membuat token fungible yang dapat kita customize sesuai kebutuhan kita layaknya ERC20 di Ethereum.
// Dimulai dengan mendeklarasikan module
module program10::token {
    use sui::balance::Balance;

    // struct untuk Custom Token
    public struct CustomToken has drop {}

    // struct untuk menyimpan informasi admin
    public struct AdminCap has key { id: UID }

    // struct untuk menyimpan saldo treasury
    public struct Treasury has key {
        id: UID,
        balance: Balance<CustomToken>,
    }

}