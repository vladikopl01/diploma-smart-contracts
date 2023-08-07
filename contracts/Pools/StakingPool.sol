// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.20;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import {IStakingPool} from "../interfaces/IStakingPool.sol";
import {ICharityToken} from "../interfaces/ICharityToken.sol";

contract StakingPool is IStakingPool {
    ICharityToken public immutable charityToken;
    uint256 public immutable epochTime;

    mapping(address => StakePosition) public stakes;
    uint256 public minAmountToStake;
    uint256 public totalStaked;

    constructor(address _charityToken, uint256 _minAmountToStake) {
        charityToken = ICharityToken(_charityToken);
        minAmountToStake = _minAmountToStake;
    }

    function stake(uint256 _amount) external override {
        if (_amount == 0 || _amount < minAmountToStake) revert InvalidAmount();
        StakePosition storage position = stakes[msg.sender];

        if (position.amount == 0) {
            position.startTimestamp = block.timestamp;
        } else {
            _claimReward();
        }

        position.amount += _amount;
        totalStaked += _amount;

        ICharityToken(charityToken).transferFrom(msg.sender, address(this), _amount);

        emit Staked(msg.sender, _amount);
    }

    function unstake(uint256 _amount) external {}

    function claimReward() public {
        StakePosition storage position = stakes[msg.sender];
        if (position.amount == 0) revert NoStakePosition();
        if (position.startTimestamp - position.lastClaimedTimestamp) {
            StakePosition storage position = stakes[msg.sender];
        }
        if (position.amount == 0) revert NoStakePosition();

        uint256 reward = _calculateReward(_position);

        ICharityToken(charityToken).mint(msg.sender, reward);
    }

    function calculateReward() external view returns (uint256) {
        return _calculateReward(stakes[msg.sender]);
    }

    function calculateReward(StakePosition calldata _position) external pure returns (uint256) {
        return _calculateReward(_position);
    }

    function _claimReward() internal {}

    function _calculateReward(StakePosition calldata _pos) internal view returns (uint256) {
        uint256 timeMultiplier = (block.timestamp - _pos.startTimestamp - _pos.lastClaimedTimestamp) / epochTime;
        uint256 supplyMultiplier = _pos.amount / ICharityToken(charityToken).totalSupply();
        return timeMultiplier * supplyMultiplier * _pos.amount;
    }

    function _updateMinAmountToStake() internal {}
}
