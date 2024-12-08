// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Bir kontratın etkileşimle ilgili işlemlerini yöneten kontrat.
contract Interact {
    // Son arayanın adresini saklar.
    address public caller;
    // Her adresin çağrı sayısını takip eden bir harita.
    mapping(address => uint256) public counts;

    // Bu fonksiyon çağrıldığında `caller`'ı günceller ve çağrı sayısını artırır.
    function callThis() external {
        caller = msg.sender; // Fonksiyonu çağıran adresi kaydeder.
        counts[msg.sender]++; // Çağrı sayısını bir artırır.
    }
}

// Bir kullanıcının ETH yatırmasını ve bakiyesini takip eden kontrat.
contract Pay {
    // Her kullanıcının ETH bakiyesini saklar.
    mapping(address => uint256) public userBalances;

    // Kullanıcıdan ETH ödemesi alır ve bakiyesini artırır.
    function payEth(address _payer) external payable {
        userBalances[_payer] += msg.value; // Kullanıcının bakiyesine gelen ETH miktarını ekler.
    }
}

// msg.sender -> A (mesaj yollayan: msg.sender) -> B (mesaj yollayan: A adresi)

// Bu kontrat, diger kontratlar ile etkileşim kurmak için kullanılır.
contract Caller {
    // Interact kontratına erişim sağlamak için bir referans.
    Interact interact;

    // Constructor: Interact kontratınımın adresini alır ve kaydeder.
    constructor(address _interactContract) {
        interact = Interact(_interactContract);
    }

    // Interact kontratındaki `callThis` fonksiyonunu çağırır.
    function callInteract() external {
        interact.callThis();
    }

    // Interact kontratındaki son çağıranı döner.
    function readCaller() external view returns (address) {
        return interact.caller();
    }

    // Interact kontratında mevcut kullanıcının toplam çağrı sayısını döner.
    function readCallerCount() public view returns (uint256) {
        return interact.counts(msg.sender);
    }

    // Pay kontratına ETH göndermek için kullanılır.
    function payToPay(address _payAddress) public payable {
        Pay pay = Pay(_payAddress); // Pay kontratına referans alır.
        pay.payEth{value: msg.value}(msg.sender); // ETH gönderir ve göndereni kaydeder.

        // Alternatif olarak direkt şekilde de çağrılabilir:
        // Pay(_payAddress).payEth{value: msg.value}(msg.sender);
    }

    // Transfer yöntemi ile Interact kontratına ETH gönderir.
    function sendEthByTransfer() public payable {
        payable(address(interact)).transfer(msg.value); // Interact kontratına ETH gönderir.
    }
}
 