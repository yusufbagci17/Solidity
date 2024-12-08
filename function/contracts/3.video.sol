// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

// `func` isminde bir kontrat tanımlıyoruz.
contract func {
    /*
    uint public luckynumber = 7; // Şanslı bir numarayı saklayan değişken.

    // Şanslı numarayı döndüren bir fonksiyon.
    // function showNumber() public view returns (uint) {
    //     return luckynumber;
    // }

    // Şanslı numarayı değiştiren bir fonksiyon.
    function NewNumber(uint NewLuckyNumber) public {
        luckynumber = NewLuckyNumber; // Yeni bir şanslı numara atar.
    }

    // Hiçbir giriş almayan ve sabit değerler döndüren bir fonksiyon.
    function nothing() public pure returns (uint x, bool y, bool z) {
        x = 6;      // `x` değişkenine 6 değeri atanır.
        y = true;   // `y` değişkenine `true` atanır.
        z = false;  // `z` değişkenine `false` atanır.
        // return (5, true, false); // Alternatif olarak bu şekilde de döndürülebilir.
    }
    */

    uint public x = 3; // Varsayılan olarak 3 değerine sahip bir değişken.

    // Kullanıcıdan bir `newx` alır ve `x` ile toplar, sonucu döner.
    function degisim(uint newx) public view returns (uint) {
        return x + newx; // `x` ve `newx` toplamını döner.
    }

    // İki sayıyı toplar ve mevcut blok zamanına (`block.timestamp`) ekler.
    function sayiTopla(uint a, uint b) public view returns (uint) {
        return a + b + block.timestamp; // Toplamı blok zamanı ile birlikte döner.
    }

    // İki sayıyı saf bir şekilde toplar. Blockchain'den veri okumaz veya yazmaz.
    function topla2(uint a, uint b) public pure returns (uint) {
        return a + b; // `a` ve `b` toplamını döner.
    }
}
