// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.20;

import {ICharityToken} from "./ICharityToken.sol";

interface IStakingPool {
    struct StakePosition {
        uint256 amount;
        uint256 startTimestamp;
        uint256 lastClaimedReward;
        uint256 totalReward;
    }

    error InvalidAmount();
    error InvalidStakeAmount();
    error NoStakePosition();
    error NothingToClaim();
    error NothingToCompound();

    event Staked(address indexed _account, uint256 _amount);
    event Unstaked(address indexed _account, uint256 _amount);
    event Claimed(address indexed _account, uint256 _amount);
    event Compounded(address indexed _account, uint256 _amount);
    event MinMaxAmountsUpdated(uint256 _minAmountToStake, uint256 _maxAmountToStake);

    function stake(uint256 _amount) external;

    function unstake(uint256 _amount) external;

    function claim() external;

    function compound() external;

    function charityToken() external view returns (ICharityToken);

    function epochTime() external view returns (uint256);

    function stakePositions(address _account) external view returns (uint256, uint256, uint256, uint256);

    function minAmountToStake() external view returns (uint256);

    function maxAmountToStake() external view returns (uint256);

    function totalStaked() external view returns (uint256);

    function totalRewarded() external view returns (uint256);

    function calculateReward() external view returns (uint256);
}
