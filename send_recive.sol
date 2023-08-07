/// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.5.0 <=0.9.0;
contract send{
  mapping (address=>uint)ladger;
  event money_send(address sender , uint amount , address recever, string msgs);
  enum Unit{WEI,GWEI,ETHER}
  Unit Units;
  address manger;
//   constructor(){
//       manger = msg.sender;
//   }
  function GET_money_value(address payable _to)public payable{
      //require(msg.sender==manger,"enter real owner address");
      require(_to>address(0),"enter real sender address");
      require((msg.value< msg.sender.balance)||(msg.value>0),"entre real value");
      ladger[_to]+=msg.value;
  }
  function withdraw(address payable _to,uint money_val,Unit unt)public payable{
     require(_to>address(0),"enter real sender address");
     require(money_val<=ladger[_to],"send larger mony");
     uint withdraw_amount;
     if(unt==Unit.WEI)
     {
       ladger[_to]-=money_val;
       (bool sent,)=msg.sender.call{value:money_val}("");
     }
     else  if(unt==Unit.GWEI){
         withdraw_amount=money_val*1000000000;
ladger[_to]-=withdraw_amount;
(bool sent,)=msg.sender.call{value:withdraw_amount}("");
     }
     else if(unt==Unit.ETHER){
         withdraw_amount=money_val*1000000000000000000;
ladger[_to]-=withdraw_amount;
(bool sent,)=msg.sender.call{value:withdraw_amount}("");
     }
  }
  function SENd_ETHER(address payable _to)public payable{
     require(_to>address(0),"enter real sender address");
     (bool send,)=_to.call{value:ladger[_to]}("");
     require(send,"transaction did not happen");
     emit money_send(msg.sender,ladger[_to],_to,"transfer done");
     ladger[_to]=0; 
  }
}
contract recvive{
struct recvedata{
    uint time;
    uint amount;
}
recvedata receve_data;

mapping(address=>recvedata) public receve_ladger;
event log(address sender , uint timeing, uint amountval );
fallback()external payable{
    receve_ladger[msg.sender]=recvedata(block.timestamp,msg.value);
    emit log(msg.sender,block.timestamp,msg.value);
}
}