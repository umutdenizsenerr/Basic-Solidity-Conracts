
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;
import "@openzeppelin/contracts/access/Ownable.sol";
contract Lottery is Ownable{

uint nonce = 0;

address[] addresses;
address winnerAddress;
address amortizedAddress;

bool canWithdraw = false;

bool winnerWithdraw = false;
bool amortizedWithdraw = false;

function getBalance() public view returns (uint) {
        return address(this).balance;
}


function enterLottery() public payable {
    require(!canWithdraw, "there is an active lottery you should wait");
    require(msg.value == 1 ether, "you should send 1 ether to enter the lottery");
    addresses.push(msg.sender);

    if(address(this).balance == 10 ether){
        uint winnerIndex = randomGenerate(10);
        winnerAddress = addresses[winnerIndex];
        uint amortizedIndex = randomGenerate(10);
        while(winnerIndex == amortizedIndex){
            amortizedIndex = randomGenerate(10);
        }
        amortizedAddress = addresses[amortizedIndex];
        canWithdraw = true;
    }
}

function withdraw() public payable {
    require(canWithdraw, "the lottery is not done yet");
    if(canWithdraw){
        if(msg.sender == winnerAddress && !winnerWithdraw){
            sendEther(winnerAddress, 5);
            winnerWithdraw = true;
        } 
        else if(msg.sender == amortizedAddress && !amortizedWithdraw){
            sendEther(amortizedAddress, 1);
            amortizedWithdraw = true;
        }
        else if(msg.sender == owner() && winnerWithdraw && amortizedWithdraw){
            payable(owner()).transfer(address(this).balance);
            winnerWithdraw = false;
            amortizedWithdraw = false;
            canWithdraw = false;
            delete addresses;

        }
    }
}
function viewWinners() public view returns(address, address){
    return (winnerAddress, amortizedAddress);
}
function viewAdresses() public view returns(address[] memory){
    return addresses;
}
function sendEther(address _to, uint value) public payable {
        uint val = (1 ether/1 wei) * value;
        (bool sent, bytes memory data) = _to.call{value: val}("");
        require(sent, "Failed to send Ether");
    }


    function randomGenerate(uint mod) private returns(uint){
        nonce++;
        uint randomNumber = uint(keccak256(abi.encodePacked(block.timestamp, msg.sender, nonce))) % mod;
        return randomNumber;
    }

  
}