// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.20;

interface IStakingPool {
    struct StakePosition {
        uint256 amount;
        uint256 startTimestamp;
        uint256 lastClaimedTimestamp;
        uint256 lastClaimedReward;
        uint256 totalReward;
    }

    error InvalidAmount();
    error NoStakePosition();
    error NothingToClaim();
    error StakeNotEnded();

    event Staked(address indexed _account, uint256 _amount);
    event Unstaked(address indexed _account, uint256 _amount);
    event Claimed(address indexed _account, uint256 _amount);
    event Compounded(address indexed _account, uint256 _amount);

    function stake(uint256 _amount) external;
    function unstake(uint256 _amount) external;
    function claim() external;
    function compound() external;

    function calculateReward() external view returns (uint256);
    function stakes(address _account) external view returns (uint256, uint256, uint256, uint256, uint256);
    function totalStaked() external view returns (uint256);
}
