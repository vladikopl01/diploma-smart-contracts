// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.20;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

abstract contract Operatable is Ownable {
    mapping(address => bool) private _operators;

    error NotOperator(address caller);

    modifier onlyOperator() {
        if (!_operators[msg.sender]) {
            revert NotOperator(msg.sender);
        }
        _;
    }

    function setOperator(address operator, bool status) external onlyOwner {
        _operators[operator] = status;
    }
}
