// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.20;

import {IStakingPool} from "../interfaces/IStakingPool.sol";
import {ICharityToken} from "../interfaces/ICharityToken.sol";

contract StakingPool is IStakingPool {
    ICharityToken public charityToken;
    mapping(address => StakePosition) public stakePositions;
    uint256 public minAmountToStake;
    uint256 public maxAmountToStake;
    uint256 public totalStaked;
    uint256 public totalRewarded;
    uint256 public epochTime;

    constructor(address _charityToken) {
        charityToken = ICharityToken(_charityToken);
        epochTime = 30 days;
        _updateMinMaxAmounts();
    }

    function stake(uint256 _amount) external {
        if (_amount == 0) revert InvalidAmount();

        StakePosition storage position = stakePositions[msg.sender];
        if (position.amount == 0) {
            if (_amount < minAmountToStake || _amount > maxAmountToStake) revert InvalidAmount();
            _stake(msg.sender, _amount);
        } else {
            uint256 newAmount = position.amount + _amount;
            if (newAmount > maxAmountToStake) revert InvalidStakeAmount();
            _stake(msg.sender, _amount);
        }
    }

    function unstake(uint256 _amount) external {
        StakePosition storage position = stakePositions[msg.sender];
        if (position.amount == 0) revert NoStakePosition();
        _unstake(msg.sender, _amount);
    }

    function claim() external {
        StakePosition storage position = stakePositions[msg.sender];
        if (position.amount == 0) revert NoStakePosition();
        _claim(msg.sender);
    }

    function compound() external {
        StakePosition storage position = stakePositions[msg.sender];
        if (position.amount == 0) revert NoStakePosition();
        _compound(msg.sender);
    }

    function calculateReward() external view returns (uint256) {
        return _calculateReward(msg.sender);
    }

    function _stake(address _account, uint256 _amount) internal {
        StakePosition storage position = stakePositions[_account];
        position.amount += _amount;
        position.startTimestamp = block.timestamp;
        totalStaked += _amount;

        charityToken.transferFrom(_account, address(this), _amount);
        _updateMinMaxAmounts();
        emit Staked(_account, _amount);
    }

    function _unstake(address _account, uint256 _amount) internal {
        StakePosition storage position = stakePositions[_account];
        if (position.amount < _amount) revert InvalidAmount();

        uint256 newAmount = position.amount - _amount;
        if (newAmount != 0 && newAmount < minAmountToStake) revert InvalidStakeAmount();

        position.amount -= _amount;
        totalStaked -= _amount;

        charityToken.transfer(_account, _amount);
        _updateMinMaxAmounts();
        emit Unstaked(_account, _amount);
    }

    function _claim(address _account) internal {
        uint256 reward = _calculateReward(_account);
        if (reward == 0) revert NothingToClaim();

        StakePosition storage position = stakePositions[_account];
        position.startTimestamp = block.timestamp;
        position.lastClaimedReward = reward;
        position.totalReward += reward;
        totalRewarded += reward;

        charityToken.mint(_account, reward);
        _updateMinMaxAmounts();
        emit Claimed(_account, reward);
    }

    function _compound(address _account) internal {
        uint256 reward = _calculateReward(_account);
        if (reward == 0) revert NothingToCompound();

        StakePosition storage position = stakePositions[_account];
        position.amount += reward;
        position.startTimestamp = block.timestamp;
        position.lastClaimedReward = reward;
        position.totalReward += reward;
        totalRewarded += reward;

        charityToken.mint(_account, reward);
        _updateMinMaxAmounts();
        emit Compounded(_account, reward);
    }

    function _calculateReward(address _account) internal view returns (uint256) {
        StakePosition storage position = stakePositions[_account];
        uint256 rewardByTime = position.amount * _timeMultiplier(position.startTimestamp) - position.amount;
        uint256 rewardBySupply = _supplyMultiplier(position.amount);
        return rewardByTime + rewardBySupply;
    }

    function _updateMinMaxAmounts() internal {
        uint256 totalSupply = charityToken.totalSupply();
        uint256 diffSupply = totalSupply - totalStaked;
        uint256 stakedPercent = (totalStaked * 100) / totalSupply;
        uint256 diffPercent = 100 - stakedPercent;

        minAmountToStake = (diffSupply ** (stakedPercent / 100)) / (diffSupply ** (diffPercent / 100));
        maxAmountToStake = diffSupply ** (stakedPercent / 100);
        emit MinMaxAmountsUpdated(minAmountToStake, maxAmountToStake);
    }

    function _timeMultiplier(uint256 _lastClaim) internal view returns (uint256) {
        uint256 epochsPassed = (block.timestamp - _lastClaim) / epochTime;
        return (epochsPassed * epochsPassed * 5) / 1000 + (epochsPassed * 25) / 1000 + 1;
    }

    function _supplyMultiplier(uint256 _stakedAmount) internal view returns (uint256) {
        return (_stakedAmount * _stakedAmount) / totalStaked;
    }
}
