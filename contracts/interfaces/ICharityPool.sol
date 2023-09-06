// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.20;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import {ICharityToken} from "../interfaces/ICharityToken.sol";

interface ICharityPool {
    event Deposit(address indexed _account, uint256 _amount);
    event Withdraw(address indexed _account, uint256 _amount);
    event ClaimDeposits(uint256 _amount);
    event ClaimRewards(address indexed _account, uint256 _amount);

    error AlreadyInitialized();
    error PoolNotStarted();
    error PoolAlreadyEnded();
    error PoolNotEnded();
    error AmountIsZero();
    error AmountIsNotEnough();
    error AmountExceedsDeposit();
    error NothingToClaim();
    error NothingToWithdraw();
    error NothingToReward();
    error DepositsAlreadyClaimed();
    error OnlyCreator();

    function initialize(
        address _creator,
        address _depositReceiver,
        address _inputToken,
        address _rewardToken,
        uint256 _startTimestamp,
        uint256 _endTimestamp,
        uint256 _minDepositAmount,
        uint256 _rewardRatio,
        string calldata _title,
        string calldata _description
    ) external;

    function deposit(uint256 _amount) external;

    function withdraw(uint256 _amount) external;

    function claimDeposits() external;

    function claimRewards() external;

    function factory() external view returns (address);

    function creator() external view returns (address);

    function depositReceiver() external view returns (address);

    function inputToken() external view returns (IERC20);

    function rewardToken() external view returns (ICharityToken);

    function startTimestamp() external view returns (uint256);

    function endTimestamp() external view returns (uint256);

    function minDepositAmount() external view returns (uint256);

    function rewardRatio() external view returns (uint256);

    function title() external view returns (string memory);

    function description() external view returns (string memory);

    function deposits(address _account) external view returns (uint256);

    function totalDeposits() external view returns (uint256);

    function isClaimed() external view returns (bool);
}
