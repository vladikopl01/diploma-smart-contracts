// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.20;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import {ICharityPool} from "../interfaces/ICharityPool.sol";
import {ICharityToken} from "../interfaces/ICharityToken.sol";

contract CharityPool is ICharityPool {
    address public factory;
    address public creator;
    address public depositReceiver;
    IERC20 public inputToken;
    ICharityToken public rewardToken;
    uint256 public startTimestamp;
    uint256 public endTimestamp;
    uint256 public amountToRaise;
    uint256 public minDepositAmount;
    uint256 public rewardRatio;

    string public title;
    string public description;
    string public coverImageUrl;

    mapping(address => uint256) public deposits;
    uint256 public totalDeposits;
    bool public isClaimed;

    modifier started() {
        if (block.timestamp < startTimestamp) revert PoolNotStarted();
        _;
    }

    modifier ended() {
        if (block.timestamp < endTimestamp) revert PoolNotEnded();
        _;
    }

    modifier notEnded() {
        if (block.timestamp >= endTimestamp) revert PoolAlreadyEnded();
        _;
    }

    constructor() {
        factory = msg.sender;
    }

    function initialize(
        address _creator,
        address _depositReceiver,
        address _inputToken,
        address _rewardToken,
        uint256 _startTimestamp,
        uint256 _endTimestamp,
        uint256 _amountToRaise,
        uint256 _minDepositAmount,
        uint256 _rewardRatio,
        string calldata _title,
        string calldata _description,
        string calldata _coverImageUrl
    ) external {
        if (msg.sender != factory) revert AlreadyInitialized();

        creator = _creator;
        depositReceiver = _depositReceiver;
        inputToken = IERC20(_inputToken);
        rewardToken = ICharityToken(_rewardToken);
        startTimestamp = _startTimestamp;
        endTimestamp = _endTimestamp;
        amountToRaise = _amountToRaise;
        minDepositAmount = _minDepositAmount;
        rewardRatio = _rewardRatio;

        title = _title;
        description = _description;
        coverImageUrl = _coverImageUrl;
    }

    function deposit(uint256 _amount) external started notEnded {
        if (_amount < minDepositAmount) revert AmountIsNotEnough();
        if (_amount == 0) revert AmountIsZero();

        inputToken.transferFrom(msg.sender, address(this), _amount);

        deposits[msg.sender] += _amount;
        totalDeposits += _amount;

        emit Deposit(msg.sender, _amount);
    }

    function withdraw(uint256 _amount) external notEnded {
        if (deposits[msg.sender] == 0) revert NothingToWithdraw();
        if (_amount == 0) revert AmountIsZero();
        if (_amount > deposits[msg.sender]) revert AmountExceedsDeposit();

        deposits[msg.sender] -= _amount;
        totalDeposits -= _amount;

        inputToken.transfer(msg.sender, _amount);

        emit Withdraw(msg.sender, _amount);
    }

    function claimDeposits() external ended {
        if (msg.sender != creator) revert OnlyCreator();
        if (totalDeposits == 0) revert NothingToClaim();
        if (isClaimed) revert DepositsAlreadyClaimed();

        isClaimed = true;
        inputToken.transfer(depositReceiver, totalDeposits);

        emit ClaimDeposits(totalDeposits);
    }

    function claimRewards() external ended {
        if (deposits[msg.sender] == 0) revert NothingToReward();

        uint256 _amount = (deposits[msg.sender] * rewardRatio) / 100;
        deposits[msg.sender] = 0;
        rewardToken.mint(msg.sender, _amount);

        emit ClaimRewards(msg.sender, _amount);
    }
}
