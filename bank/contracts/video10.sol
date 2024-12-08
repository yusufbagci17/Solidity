//SPDX-Licanse-Identifier: Unlicensed
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
contract Bank{
    mapping (address => uint)balances;
    function sendEtherTocontract() payable external {// payable demek bu fonksiyona bir gönderme işlemi yapılabilinir denir
        balances[msg.sender]=msg.value;
    }
    function showBalance() external view returns(uint){
         return balances[msg.sender];
    }
    function withdraw()external {
        payable (msg.sender).transfer(balances[msg.sender]);//herhangi birşeyin ether alaması için payble kullanmak gerekiyor
        balances[msg.sender]=0;
    }
    function transfer(address payable to,uint amount)external {
        require(balances[msg.sender]>=amount,"yetersiz bakiye");
        to.transfer(amount);
        balances[msg.sender]-=amount;
    }
    //transfer() : Eğer yeterli miktar yok ise isteği geri çeviriyor faydası
    // send() : Gerçekleşti ise true ,false dödürür;
    //call(): (bool sent,bytes memory data)=to.all{value:ammount} 
   uint public falcalisiyormu=0;
   uint public reccalisiyormu=0;

 receive() external payable {
reccalisiyormu++;
  }
  fallback() external payable {
falcalisiyormu++;
   }
}