# Program7: GiftBox Mini-Program on Move
Ini adalah modul smart contract Sui Move bernama `program7::usecase` yang mengimplementasikan konsep ObjectWrapping dengan menggunakan usecase GiftBox sederhana. Kontrak ini memungkinkan pengguna untuk membuat object pembungkus bernama `GiftBox` yang berisi object yang dibungkus bernama `Gift` dengan nilai tertentu dan mentransfernya ke pengirim transaksi.

## Detail Modul
- **Nama Modul**: `program7::usecase`
- **Tujuan**: Membuat dan mengelola objek `GiftBox` yang menyimpan `Gift` dengan nilai numerik.
- **Bahasa**: Sui Move

## Struktur Data
### `GiftBox`
- **Deskripsi**: Struktur yang mewakili kotak hadiah yang berisi `Gift` dan pengenal unik.
- **Atribut**:
  - `id: UID` - Pengenal unik untuk `GiftBox`.
  - `gift: Gift` - Hadiah yang disimpan di dalam kotak.
- **Kemampuan**: `key` (dapat digunakan sebagai objek di Sui).

### `Gift`
- **Deskripsi**: Struktur yang mewakili hadiah dengan nilai numerik.
- **Atribut**:
  - `value: u64` - Nilai hadiah (bilangan bulat tak bertanda 64-bit).
- **Kemampuan**: `store` (dapat disimpan di dalam struktur lain).

## Fungsi
### `create_gift_box`
- **Tanda Tangan**: `public entry fun create_gift_box(value: u64, ctx: &mut TxContext)`
- **Deskripsi**: Membuat `GiftBox` baru yang berisi `Gift` dengan nilai yang ditentukan dan mentransfer kepemilikannya ke pengirim transaksi.
- **Parameter**:
  - `value: u64` - Nilai yang akan diberikan ke `Gift`.
  - `ctx: &mut TxContext` - Konteks transaksi untuk mengakses informasi pengirim dan membuat ID objek baru.
- **Perilaku**:
  1. Membuat `Gift` baru dengan nilai yang diberikan.
  2. Membuat `GiftBox` baru dengan ID unik dan `Gift` yang telah dibuat.
  3. Mentransfer `GiftBox` ke pengirim transaksi.

## Penggunaan
1. **Terapkan Kontrak**: Terapkan modul `program7::usecase` ke blockchain Sui.
2. **Buat GiftBox**:
   - Panggil fungsi `create_gift_box` dengan nilai `value` (misalnya, `100`) untuk membuat `GiftBox`.
   - `GiftBox` akan ditransfer ke alamat pengirim.
3. **Interaksi dengan GiftBox**:
   - `GiftBox` dapat dikelola sebagai objek di blockchain Sui, dengan nilai `Gift` yang dapat diakses sesuai kebutuhan.

## Contoh
```move
// Panggil fungsi untuk membuat GiftBox dengan nilai 100
program7::usecase::create_gift_box(100, ctx);