// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.20;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import {IStakingPool} from "../interfaces/IStakingPool.sol";
import {ICharityToken} from "../interfaces/ICharityToken.sol";

contract StakingPool is IStakingPool {
    ICharityToken public immutable charityToken;
    uint256 public immutable epochTerm;

    mapping(address => StakePosition) public stakes;
    uint256 public minAmountToStake;
    uint256 public maxAmountToStake;
    uint256 public totalStaked;

    constructor(address _charityToken) {
        charityToken = ICharityToken(_charityToken);
    }
}
