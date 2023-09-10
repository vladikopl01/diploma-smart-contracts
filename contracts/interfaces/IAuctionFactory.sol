// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.20;

interface IAuctionFactory {
    event AuctionCreated(address indexed _creator, address indexed _auction);
    event CreatorStatusChanged(address indexed _account, bool _status);
    event DepositTokenStatusChanged(address indexed _token, bool _status);
    event RewardTokenStatusChanged(address indexed _token, bool _status);

    error NotCreator();
    error AddressIsZero();
    error InvalidTimestamp();
    error InvalidMinBidAmount();
    error InvalidBuyPrice();
    error EmptyTitle();
    error EmptyDescription();

    function createAuction(
        address _depositToken,
        address _rewardToken,
        uint256 _rewardTokenId,
        uint256 _endTime,
        uint256 _minBidAmount,
        uint256 _buyPrice,
        string calldata _title,
        string calldata _description
    ) external returns (address);

    function setCreator(address _account, bool _status) external;

    function setAllowedDepositToken(address _token, bool _status) external;

    function setAllowedRewardToken(address _token, bool _status) external;

    function charityToken() external view returns (address);

    function creators(address) external view returns (bool);

    function allowedDepositTokens(address) external view returns (bool);

    function allowedRewardTokens(address) external view returns (bool);

    function allowedDepositTokensList(uint256) external view returns (address);

    function allowedRewardTokensList(uint256) external view returns (address);

    function auctionById(uint256) external view returns (address);

    function auctionsCount() external view returns (uint256);

    function getAllowedDepositTokensList() external view returns (address[] memory);

    function getAllowedRewardTokensList() external view returns (address[] memory);
}
