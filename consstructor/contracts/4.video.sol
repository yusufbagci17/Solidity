// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

// Kontrat ismi: constreucter
// Bu kontrat, bir token'ın adı (`tokenname`) ve toplam arzını (`totalsupply`) başlangıçta ayarlamak için tasarlanmıştır.
contract constreucter {
    // Token'ın adını tutan bir değişken (örneğin: "MyToken").
    string public tokenname;

    // Token'ın toplam arzını (total supply) tutan bir değişken.
    uint public totalsupply;

    // Constructor: Kontrat oluşturulduğunda bir kez çalışan özel bir fonksiyon.
    // Bu fonksiyon, `tokenname` ve `totalsupply` değişkenlerini başlatmak için kullanılır.
    constructor(string memory name, uint number) {
        tokenname = name; // Token adını (örneğin: "MyToken") başlatır.
        totalsupply = number; // Token toplam arzını (örneğin: 1000) başlatır.
    }
}
