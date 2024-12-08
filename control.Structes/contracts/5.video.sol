// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

// IfElse ve Loops kontratlarının birleşimi
contract Combined {
    // IfElse kontratından gelen değişkenler ve işlemler
    bytes32 private hashcode; // Kullanıcının şifresinin hash kodu burada saklanır.
    uint256 private logincount; // Başarılı girişlerin sayısını tutar.

    // Loops kontratından gelen değişkenler
    uint256[15] public numbers0; // `for` döngüsü ile doldurulan dizi.
    uint256[15] public numbers1; // `while` döngüsü ile doldurulan dizi.

    // Yapıcı (constructor), başlangıçta hash kodu oluşturur.
    constructor(string memory _password) {
        hashcode = keccak256(abi.encode(_password)); // Şifreyi hash'ler ve saklar.
    }

    // Kullanıcının giriş yapmasını sağlayan fonksiyon
    function login(string memory _password) public returns (bool) {
        // Girilen şifrenin hash kodu kontrol edilir.
        if (hashcode == keccak256(abi.encode(_password))) {
            logincount++; // Eğer doğruysa giriş sayacı artırılır.
            return true;  // Giriş başarılı.
        } else {
            return false; // Giriş başarısız.
        }
    }

    // Giriş durumunu sorgulayan fonksiyon
    function loginStatus() public view returns (uint256) {
        if (logincount == 0) {
            return 0; // Hiç giriş yapılmamış.
        } else if (logincount > 0 && logincount != 1) {
            return 1; // Birden fazla giriş yapılmış.
        } else if (logincount == 1) {
            return 2; // Sadece bir kez giriş yapılmış.
        } else {
            return 0; // Varsayılan durum.
        }
    }

    // `for` döngüsü ile diziyi dolduran fonksiyon
    function listByFor() public {
        uint256[15] memory nums = numbers0; // Dizi bellekte kopyalanır.
        for (uint256 i = 0; i < nums.length; i++) {
            nums[i] = i * 2; // Diziyi 2'nin katları ile doldurur.
        }
        numbers0 = nums; // Bellekteki kopya diziyi `numbers0`'a atar.
    }

    // `numbers0` dizisini döndüren fonksiyon
    function getArr0() public view returns (uint256[15] memory) {
        return numbers0; // Diziyi döndürür.
    }

    // `while` döngüsü ile diziyi dolduran fonksiyon
    function listByWhile() public {
        uint256 i = 0; // Döngü başlangıç indeksi.
        while (i < numbers1.length) {
            numbers1[i] = i; // Diziyi 0'dan başlayarak sırayla doldurur.
            i++; // İndeksi bir artırır.
        }
    }
}

/*
### C++'ta Olmayan Solidity Özellikleri (Bu Kod için):

1. **`keccak256` ve Hashleme:**
   - Solidity'de `keccak256`, bir string veya veri girişini hash'lemek için kullanılır. Bu, blockchain'deki veri güvenliğini sağlar.
   - C++'ta hash işlemleri için bir standart yoktur; harici kütüphaneler (örneğin, SHA-256) kullanılmalıdır.
   - Bu kodda şifre güvenliği için hashleme kullanılmıştır.

2. **`msg.sender`:**
   - Solidity'de global bir değişkendir ve fonksiyonu çağıran kullanıcının (adresin) kimliğini temsil eder.
   - C++'ta böyle bir özellik yoktur çünkü merkezi bir çağırıcı yoktur.

3. **Blockchain Depolaması (`storage`):**
   - Solidity'de `numbers0` ve `numbers1` gibi değişkenler blockchain üzerinde kalıcı olarak saklanır.
   - C++'ta tüm veriler bellekte ya da dosyada saklanır ve blockchain'deki gibi kalıcı bir depolama otomatik olarak sağlanmaz.

4. **Erişim Modifikatörleri (`public`, `private`, `view`):**
   - Solidity'de `public`, bir değişken ya da fonksiyonun herkes tarafından erişilebilir olduğunu belirtir.
   - `view`, fonksiyonun yalnızca blockchain'den veri okumasına izin verir, değiştirmesine izin vermez.
   - C++'ta yalnızca `public`, `private` ve `protected` erişim belirteçleri bulunur. `view` ya da `pure` gibi modifikatörler yoktur.

5. **`constructor`:**
   - Solidity'de `constructor`, bir kontrat oluşturulurken yalnızca bir kez çalıştırılan özel bir fonksiyondur.
   - C++'ta ise bir sınıfın nesnesi oluşturulurken çalışan yapılandırıcı (constructor) mevcuttur ancak blockchain tabanlı değildir.

6. **Gas Ücretleri ve İşlem Maliyeti:**
   - Bu kodda kullanılan her bir işlem (örneğin, `login`, `listByFor`, `listByWhile`), Ethereum ağında "gas" adı verilen işlem maliyetine sahiptir.
   - C++'ta işlem maliyetlerini kontrol eden bir mekanizma yoktur çünkü işlemler ağ üzerinde değil, lokal olarak gerçekleştirilir.

7. **Dizilerin Blockchain Üzerinde Saklanması:**
   - Solidity'de `numbers0` ve `numbers1` gibi diziler blockchain'de saklanır.
   - Bu dizilere erişim sağlamak için `getArr0` gibi fonksiyonlar kullanılır.
   - C++'ta diziler genellikle RAM'de veya harici bir dosyada tutulur; blockchain tabanlı bir saklama bulunmaz.

### Bu Kodun Özeti:
- Bu kod, Solidity'nin blockchain tabanlı bir ortamda nasıl çalıştığını ve verileri nasıl yönettiğini göstermektedir.
- C++ gibi merkezi bir dilde bu tür işlevleri gerçekleştirmek için harici kütüphaneler ve API'ler gerekir.
- Blockchain üzerinde işlem yapan, kullanıcı girişlerini ve döngü işlemlerini yöneten bir yapıya sahiptir.
*/
