module program6::program {
    // Contoh Parameter Passing by Value
    // Sebelum itu deklarasikan terlebih dahulu struct nya
    public struct TranscriptObject has key, store {
        id: UID,
        value: u8,
    }

    // Kamu diizinkan untuk memanggilnya namun tidak bisa mengubahnya
    // karena & adalah tanda Immutable
    public fun update_score(transcriptObject: &TranscriptObject): u8{
        transcriptObject.value
    }

    // Kamu diizinkan untuk mengubah struct namun tidak bisa menghapusnya
    public fun updatee_score(transcriptObject: &mut TranscriptObject, score: u8){
        transcriptObject.value = score
    }
}

// ilmu baru
// transcriptObject adalah nama variabel yang dideklrasikan didalam parameter menggunakan titik dua (:)
// ini sesuatu yang cukup baru menurutku karena bisa melakukan deklarasi variabel didalam sebuah parameter fungsi
// titik dua dan koma adalah 2 hal yang berbeda
// deklarasi tipe refrensi pun juga sedikit unik yaitu '&' yang berarti immutable
// deklarasi tipe refrensi mutable (&mut) juga dipisah berbeda dengan immutable yang digabung dengan nama struct