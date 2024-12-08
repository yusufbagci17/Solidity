// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

// Mapping kontratı, kullanıcıların kayıt durumu ve favori numaralarını saklar.
contract Mapping {
    // Kullanıcıların kayıtlı olup olmadığını belirten mapping.
    mapping(address => bool) public registered;

    // Kullanıcıların favori numaralarını saklayan mapping.
    mapping(address => int256) public favNUMBS;

    // Kullanıcıyı kayıt eden fonksiyon.
    // Kullanıcıdan favori numarası alır ve bu numarayı kaydeder.
    function register(int256 _favNUMBS) public {
        require(!registered[msg.sender], "Kullanici zaten kayitli"); // Kullanıcının zaten kayıtlı olmadığını kontrol eder.
        // registered[msg.sender] = true; // Bu satır kapatılmış, kayıt işareti yapılmıyor.
        favNUMBS[msg.sender] = _favNUMBS; // Kullanıcının favori numarasını kaydeder.
    }

    // Kullanıcının kayıtlı olup olmadığını sorgulayan fonksiyon.
    // Kullanıcı adresine göre true veya false döner.
    function isRegis() public view returns (bool) {
        return registered[msg.sender]; // Kullanıcının kayıtlı olup olmadığını döner.
    }

    // Kullanıcının kaydını ve favori numarasını silen fonksiyon.
    function deleteReg() public {
        require(registered[msg.sender], "Kullanici kayitli degil"); // Kullanıcının kayıtlı olduğunu kontrol eder.
        delete registered[msg.sender]; // Kullanıcının kayıt durumunu siler.
        delete favNUMBS[msg.sender]; // Kullanıcının favori numarasını siler.
    }
}

// NestedMapping kontratı, kullanıcıların birbirlerine olan borç bilgilerini saklar.
contract NestedMapping {
    // Kullanıcıların borç bilgilerini saklayan iç içe mapping.
    // Bir adresin (msg.sender) başka bir adrese (alacaklı) olan borcu miktar olarak saklanır.
    mapping(address => mapping(address => uint256)) public borclar;

    // Belirli bir alacaklıya olan borcu artıran fonksiyon.
    function borcArtir(address alacakli, uint256 miktar) public {
        borclar[msg.sender][alacakli] += miktar; // Gönderen adresin (msg.sender) alacaklıya olan borcunu artırır.
    }

    // Belirli bir alacaklıya olan borcu azaltan fonksiyon.
    function borcAzalt(address alacakli, uint256 miktar) public {
        require(
            borclar[msg.sender][alacakli] >= miktar, // Kullanıcının borcunun azaltılacak miktardan fazla olup olmadığını kontrol eder.
            "Yeterli borcunuz yok." // Eğer borç yetersizse hata mesajı döner.
        );
        borclar[msg.sender][alacakli] -= miktar; // Gönderen adresin (msg.sender) borcunu belirtilen miktar kadar azaltır.
    }

    // Belirli bir alacaklıya olan borç miktarını sorgulayan fonksiyon.
    function borcSorgula(address alacakli) public view returns (uint256) {
        return borclar[msg.sender][alacakli]; // Gönderen adresin (msg.sender) alacaklıya olan borcunu döner.
    }
}

// Mapping Yapısının Genel Açıklaması:
// 1. Mapping, Solidity'de bir veri yapısıdır ve anahtar-değer (key-value) çiftlerini saklar.
// 2. Mapping'in anahtar kısmı (key) bir veri türünden olabilir (örneğin: `address`, `uint` gibi).
// 3. Değer kısmı (value) ise başka bir veri türünü veya yine bir `mapping`'i içerebilir.
// 4. Mapping, bir tür "hash tablosu" gibi çalışır ve yalnızca belirli bir anahtar üzerinden veriye erişim sağlar.
// 5. Mapping'ler, varsayılan olarak sıfır durumundadır. Eğer bir anahtar atanmadıysa, varsayılan değer döner (örneğin: `bool` için `false`, `uint` için `0`).
// 6. Nested Mapping: Mapping içerisinde bir başka mapping saklamayı ifade eder. Bu yapı, bir adresin (örneğin, `msg.sender`) başka bir adresle ilişkili verilerini (örneğin borç miktarı) tutmak için kullanılır.
// 7. Mapping, Solidity'nin verimli ve basit veri saklama araçlarından biridir, ancak döngü ile iterasyon yapılamaz.

