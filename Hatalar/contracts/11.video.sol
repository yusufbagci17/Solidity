// SPDX-License-Identifier: Unlicensed

pragma solidity ^0.8.7;

contract Hatalar {
    error Reddedildi(string sebep);
    error FazlaMiktar(address kullanici, uint256 fazlaMiktar);

    receive() external payable {
        revert Reddedildi("Dogrudan odemeler kabul edilmiyor.");
    }

    fallback() external payable {
        revert Reddedildi("Dogrudan odemeler kabul edilmiyor.");
    }

    uint256 public toplamBakiye;
    mapping(address => uint256) public kullaniciBakiye;

    modifier sifirDegil(uint256 miktar) {
        require(miktar != 0, "Gecerli bir miktar giriniz.");
        _;
    }

    function odemeYap() external payable sifirDegil(msg.value) {
        require(msg.value == 1 ether, "Lutfen tam olarak 1 Ether gonderin.");
        toplamBakiye += 1 ether;
        kullaniciBakiye[msg.sender] += 1 ether;
    }

    function cekimYap(uint256 miktar) external {
        uint256 baslangicBakiye = toplamBakiye;

        if (kullaniciBakiye[msg.sender] < miktar) {
            revert FazlaMiktar(msg.sender, miktar - kullaniciBakiye[msg.sender]);
        }

        toplamBakiye -= miktar;
        kullaniciBakiye[msg.sender] -= miktar;
        payable(msg.sender).transfer(miktar);

        assert(toplamBakiye < baslangicBakiye);
    }
}
