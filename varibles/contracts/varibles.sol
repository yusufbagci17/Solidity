// SPDX-License-Identifier: Unlicensed
pragma solidity ^0.8.0;

contract Degiskenler {
    // Sabit Boyutlu Tipler (Fixed-Size Types)
    
    bool dogruMu; // Varsayılan = false

    // Degisken-turu;   degisken-turu = deger;

    int sayi = 12; // Varsayılan tür -> int256 (-2^256 ile 2^256 arası)
    uint sayi2 = 12; // Varsayılan tür -> uint256 (0 ile 2^256 arası)

    address adresim = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4; // 20 byte'lık bir adres

    bytes32 isim1 = "Emre"; // Sabit uzunluklu byte dizisi

    // Dinamik Boyutlu Tipler (Dynamic-Size Types)

    string isim2 = "Emre"; // Dinamik uzunluklu string

    bytes isim3 = "Emre3"; // Dinamik uzunluklu byte dizisi

    uint[] dizi = [1, 2, 3, 4, 5]; // Dinamik boyutlu uint dizisi

    mapping(uint => address) liste; // Key-value yapısında bir mapping

    // Kullanıcı Tanımlı Tipler (User Defined Value Types)

    struct Insan {
        uint ID;         // Kimlik numarası
        string isim;     // İsim
        uint yas;        // Yaş
        address adresi;  // Adres
    }
    
    /* Insan yapısının bir örneği:
    
       Insan kisi1;
       kisi1.ID = 15324685246;
       kisi1.isim = "Emre";
       kisi1.yas = 20;
       kisi1.adresi = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;
    */

    enum TrafikLambasi {
        Kirmizi,  // RED
        Sari,     // Yellow
        Yesil     // Green
    }
    
    // TrafikLambasi.Kirmizi;

    // Koşullu Yapılar (if) 
    // if(kosul) {}

    /* Birim Donusumleri (Ether ve Zaman)
       Ether:
       1 wei = 1
       1 ether = 10^18 wei
       1 gwei = 10^9 wei

       Zaman:
       1 saniye = 1
       1 dakika = 60 saniye
       1 saat = 60 dakika = 3600 saniye
       1 gun = 24 saat
       1 hafta = 7 gun
       vb.
    */

    // Durum Değişkenleri (State Variables)
    string public enIyiKulup = "Genesis Codes"; // Kontrat durumu içinde saklanır

    function goster() public view returns (string memory) {
        return enIyiKulup; // enIyiKulup degiskenini döndürür
    }

    // Yerel Değişkenler (Local Variables)
    function goster2() public pure returns (uint) {
        uint sayi3 = 17; // Fonksiyon içinde tanımlı bir yerel değişken
        return sayi3;
    }

    function goster3() public view returns (uint) {
        // Global Degiskenler (Global Variables)
        return block.number; // Şu anki blok numarasını döndürür
        /* Diğer global değişkenler:
           block.difficulty; // Blok zorluğu
           block.gaslimit;   // Gaz limiti
           block.timestamp;  // Blok zaman damgası
           msg.sender;       // Fonksiyonu çağıran adres
        */
        
        // return sayi3; // Bu degisken bu kapsamda erişilebilir değil
    }
}
