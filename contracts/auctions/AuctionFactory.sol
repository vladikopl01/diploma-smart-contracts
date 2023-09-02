// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.20;

contract AuctionFactory {
    mapping(address => bool) public allowedDepositTokens;
    mapping(address => bool) public allowedRewardTokens;
}
