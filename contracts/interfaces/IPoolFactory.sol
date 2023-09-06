// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.20;

interface IPoolFactory {
    event CreatorStatusChanged(address indexed _account, bool _status);
    event PoolCreated(address indexed _pool, address indexed _account);

    error NotCreator();
    error AddressIsZero();
    error InvalidTimestamp();
    error InvalidRewardRatio();
    error EmptyTitle();
    error EmptyDescription();

    function createPool(
        address _depositReceiver,
        address _inputToken,
        uint256 _startTimestamp,
        uint256 _endTimestamp,
        uint256 _minDepositAmount,
        uint256 _rewardRatio,
        string calldata _title,
        string calldata _description
    ) external returns (address);

    function setCreator(address _account, bool _status) external;

    function charityToken() external view returns (address);

    function creators(address _account) external view returns (bool);

    function poolById(uint256 _id) external view returns (address);

    function poolsCount() external view returns (uint256);
}
