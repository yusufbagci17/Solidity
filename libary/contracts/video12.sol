// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;
library Math{
    //genelde kullanbirliği artırmak için 
    function plus(uint x, uint y)public pure returns(uint){
        return x+y;
    }
    function dvide(uint x, uint y)public pure returns(uint){
        require(y !=0,"bu sayiyi begenmedim");
        return x/y;
    }
    function min(uint a, uint b)public pure returns(uint){
        require(b !=0,"bu sayiyi begenmedim");
        if(a<=b){
            return a;
        }
        else{
            return b;
        }
    }

}
library search{
    function iNDEXoF(uint[] memory list ,uint data)public pure returns(uint){
       for (uint i=0;i<list.length;i++){
           if (list[i]==data){
            return i;
           } 
           }
           return list.length;
       }
    }

contract Libaryl{
    using Math for uint;
    function trial (uint[] memory x,uint y)public pure returns (uint){
   // return x.plus(y);
    return search.iNDEXoF(x,y) ; 
       // return Math.plus(x,y);
    }
 function trial3 (uint x,uint y)public pure returns (uint){
        return Math.min(x,y);
    }
     function trial4 (uint x,uint y)public pure returns (uint){
        return Math.dvide(x,y);
    }
}
    