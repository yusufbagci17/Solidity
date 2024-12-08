// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*
    Kontrattaki veri depolama türleri:

    memory: Geçici hafıza. Fonksiyon çalışırken kullanılır ve fonksiyon tamamlandığında silinir. 
    storage: Kalıcı hafıza. Kontratta saklanan verilerdir, blockchain üzerinde kaydedilir.
    calldata: Dışarıdan gelen fonksiyon çağrıları sırasında, çağrıda kullanılan argümanların 
              bulunduğu alan. Değiştirilemez (immutable).

    Özel Tipler: bytes, string, array, struct
    - Değer tipleri (uint, int, bool, bytes32): Kontratta storage olarak, fonksiyon içinde memory olarak saklanır.
    - mapping'ler her zaman kontratta storage'dır ve başka bir yere kopyalanamaz.
*/

struct Student {
    uint8 yas;        // Yaş bilgisi (uint8)
    uint16 puan;      // Puan bilgisi (uint16)
    string isim;      // İsim bilgisi (string)
}

contract Okul {
    uint256 toplamOgrenci = 0;                // storage: Kalıcı hafıza
    mapping(uint256 => Student) ogrenciler;   // storage: mapping her zaman kontratta kalıcıdır

    /*
        Yeni öğrenci ekleyen fonksiyon. Bu fonksiyon bir "calldata" türünde string alır. 
        "calldata" immutable olduğu için parametre değeri değiştirilmez.
    */
    function ogrenciEkle(string calldata isim, uint8 yas, uint16 puan) external {
        uint256 mevcutId = toplamOgrenci++; // toplamOgrenci bir artırılır.
        ogrenciler[mevcutId] = Student(yas, puan, isim); // Yeni öğrenci storage'da kaydedilir.
    }

    /*
        Öğrencinin bilgilerini değiştiren fonksiyon.
        - Bu fonksiyon "Student" nesnesine storage referansı ile erişir, yani kalıcı değişiklikler yapılabilir.
        - "calldata" ile alınan isim sadece okuma amaçlıdır, değiştirilemez.
    */
    function ogrenciBilgisiDegistirStorage(
        uint256 id,               // memory: Bu parametre, sadece fonksiyon içinde kullanılır.
        string calldata yeniIsim, // calldata: Değiştirilemez veri.
        uint8 yeniYas,            // memory: Geçici olarak fonksiyon içinde kullanılır.
        uint16 yeniPuan           // memory: Geçici olarak fonksiyon içinde kullanılır.
    ) external {
        Student storage mevcutOgrenci = ogrenciler[id]; // storage referansı alınır.
        mevcutOgrenci.isim = yeniIsim;                 // İsim değiştirilir.
        mevcutOgrenci.yas = yeniYas;                   // Yaş değiştirilir.
        mevcutOgrenci.puan = yeniPuan;                 // Puan değiştirilir.
    }

    /*
        @dev Bu fonksiyon işe yaramaz, çünkü "Student" struct'ı memory olarak kullanılır.
        - Memory'deki değişiklikler fonksiyon tamamlandığında silinir.
    */
    function ogrenciBilgisiDegistirMemory(
        uint256 id,               // memory: Fonksiyon içi kullanım.
        string calldata yeniIsim, // calldata: Değiştirilemez veri.
        uint8 yeniYas,            // memory: Geçici kullanım.
        uint16 yeniPuan           // memory: Geçici kullanım.
    ) external {
        Student memory mevcutOgrenci = ogrenciler[id]; // memory'de bir kopya oluşturulur.
        mevcutOgrenci.isim = yeniIsim;                // Bu değişiklik storage'a yansımaz.
        mevcutOgrenci.yas = yeniYas;                  // Aynı şekilde değişiklik kalıcı değildir.
        mevcutOgrenci.puan = yeniPuan;                // Değişiklikler sadece memory'de kalır.
    }

    /*
        Öğrencinin ismini döndüren bir getter fonksiyon.
        - "memory" olarak döner çünkü string veriler memory'de tutulur.
    */
    function ogrenciIsmiAl(uint256 id) external view returns(string memory) { 
        return ogrenciler[id].isim;
    }
}
