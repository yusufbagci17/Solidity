// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Taban (Base) kontrat
contract Base {

    uint public x; // x değişkeni
    uint public y; // y değişkeni

    // x değişkenini ayarlayan bir fonksiyon
    // Bu fonksiyon `virtual` olarak işaretlenmiştir, yani alt kontratlar (derived contracts) bu fonksiyonu yeniden tanımlayabilir (override edebilir).
    function setX(uint _x) virtual public {
        x = _x;
    }

    // y değişkenini ayarlayan bir fonksiyon
    // `virtual` olmadığı için, bu fonksiyon alt kontratlarda değiştirilemez.
    function setY(uint _y) public {
        y = _y;
    }
}

// Derived (Türeyen) kontrat
// Base kontratından miras alır.
// Derived, Base kontratındaki tüm `public` ve `internal` değişkenlere ve fonksiyonlara erişebilir.
contract Derived is Base {
    
    uint public z; // Derived kontratına özgü bir değişken

    // z değişkenini ayarlayan bir fonksiyon
    function setZ(uint _z) public {
        z = _z;
    }

    // Base kontratındaki `setX` fonksiyonunu yeniden tanımlıyoruz (override ediyoruz).
    // `override` anahtar kelimesi, bu fonksiyonun Base kontratındaki sanal (virtual) fonksiyonu değiştirdiğini belirtir.
    function setX(uint _x) override public {
        x = _x + 2; // Base'ten farklı olarak x'e +2 ekler
    }
}

// İnsan (Human) kontratı
contract Human {

    // Basit bir mesaj döndüren fonksiyon
    // Bu fonksiyon `virtual` olduğu için türeyen kontratlar tarafından değiştirilebilir.
    function sayHello() public pure virtual returns(string memory) {
        return "Welcome."; // Varsayılan mesaj
    }
}

// SuperHuman kontratı
// Human kontratından miras alır.
// SuperHuman, Human'ın tüm `public` ve `internal` fonksiyonlarını ve değişkenlerini kullanabilir.
contract SuperHuman is Human {
    
    // Human'daki `sayHello` fonksiyonunu yeniden tanımlıyoruz (override ediyoruz).
    function sayHello() public pure override returns(string memory) {
        return "Welcome back."; // Yeni bir mesaj döndürür
    }

    // Kullanıcı üye olup olmadığına göre mesaj döndüren bir fonksiyon
    function welcomeMsg(bool isMember) public pure returns(string memory) {
        // Eğer kullanıcı üye ise kendi `sayHello` fonksiyonunu çağır,
        // değilse üst kontratın (`Human`) `sayHello` fonksiyonunu çağır.
        return isMember ? sayHello() : super.sayHello();
    }
}

// OpenZeppelin'in Ownable kontratını kullanan cüzdan (Wallet) kontratı
// Ownable, bu kontrata sadece kontrat sahibinin belirli işlemleri yapabilmesi özelliğini kazandırır.

// OpenZeppelin'in Ownable kontratını import ediyoruz.
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";

// Wallet kontratı
// OpenZeppelin'in Ownable kontratını miras alır.
contract Wallet is Ownable {

    // Yapıcı fonksiyon
    constructor() Ownable(msg.sender) {}

    // Ether almak için kullanılan fallback fonksiyonlar
    receive() external payable { } // Sadece ether almak için
    fallback() external payable { } // Diğer çağrılar için

    // Sadece kontrat sahibi (owner) tarafından ether göndermek için kullanılan fonksiyon
    function sendEther(address payable _to, uint _amount) public onlyOwner {
        require(address(this).balance >= _amount, "Yetersiz bakiye"); // Bakiye kontrolü
        _to.transfer(_amount); // `_to` adresine `_amount` miktarında ether gönder
    }

    // Kontratın bakiyesini gösteren fonksiyon
    function showBalance() public view returns(uint) {
        return address(this).balance; // Kontratın toplam ether miktarını döndürür
    }
}

