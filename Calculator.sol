
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract Calculator {
function calculate(int _a, int _b, string memory _operator) public pure returns(int){
     
     int result;
      if (keccak256(bytes(_operator)) == keccak256("+")){
          result = _a + _b;
      }
      else if (keccak256(bytes(_operator)) == keccak256("-")){
          result = _a - _b;
      }    
      else if (keccak256(bytes(_operator)) == keccak256("*")){
          result = _a * _b;
      }   
      else if (keccak256(bytes(_operator)) == keccak256("/")){
          result = _a / _b;
      }   
      return (result);
      
   }
uint nonce = 1;
    mapping (address => uint) adressToRandom;

    function randomGenerate() public returns(uint){
        nonce++;
        uint randomNumber = uint(keccak256(abi.encodePacked(block.timestamp, msg.sender, nonce))) % 1000;
        adressToRandom[msg.sender] = randomNumber;
        return randomNumber;
    }

    function viewRandom() public view returns(uint){
        return adressToRandom[msg.sender];
    }
}