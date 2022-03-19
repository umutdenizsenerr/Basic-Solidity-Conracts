// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";

contract Buyable is Ownable {

    IERC20 public token;
    uint price;
    bool paused = false;
    uint unlockTime;
    uint maxAmount = 50;
    mapping (address => uint) addressTokenCount;
    constructor(address _token, uint _unlockTime) public {
        token = IERC20(_token);
        price = 1 ether;
        unlockTime = _unlockTime;
    }
    function buy(uint amount) public payable  {
        require(unlockTime<block.timestamp, "locked");
        require(msg.value>amount*price, "not enough balance");
        require(addressTokenCount[msg.sender] < maxAmount, "you have reached the max amount");
        require(paused == false);
        token.transfer(msg.sender, amount);
        addressTokenCount[msg.sender] += amount;
	       
	    }
    function pause() public onlyOwner{
        paused = true;
    }
    function unpause() public onlyOwner{
        paused = false;
    }
}