// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract TokenMint is ERC20 {
    constructor() ERC20("UMUT", "UDS"){
        _mint(msg.sender, 250);
    }
}