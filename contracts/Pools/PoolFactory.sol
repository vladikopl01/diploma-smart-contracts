// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.20;

import {Create2} from "@openzeppelin/contracts/utils/Create2.sol";

import {IPoolFactory} from "../interfaces/IPoolFactory.sol";
import {CharityPool} from "./CharityPool.sol";
import {Operatable} from "../utilities/Operatable.sol";

contract PoolFactory is IPoolFactory, Operatable {
    address public immutable charityToken;

    mapping(address => bool) public creators;
    mapping(uint256 => address) public poolById;
    uint256 public poolsCount;

    constructor(address _charityToken) {
        charityToken = _charityToken;
    }

    function createPool(
        address _depositReceiver,
        address _inputToken,
        uint256 _startTimestamp,
        uint256 _endTimestamp,
        uint256 _minDepositAmount,
        uint256 _rewardRatio
    ) external returns (address) {
        if (_depositReceiver == address(0)) revert AddressIsZero();
        if (_inputToken == address(0)) revert AddressIsZero();
        if (_startTimestamp < block.timestamp) revert InvalidTimestamp();
        if (_endTimestamp <= _startTimestamp) revert InvalidTimestamp();
        if (_rewardRatio == 0) revert InvalidRewardRatio();

        ++poolsCount;
        bytes memory bytecode = type(CharityPool).creationCode;
        bytes32 salt = keccak256(abi.encodePacked(poolsCount, msg.sender));
        address pool = Create2.deploy(0, salt, bytecode);

        CharityPool(pool).initialize(
            msg.sender,
            _depositReceiver,
            _inputToken,
            charityToken,
            _startTimestamp,
            _endTimestamp,
            _minDepositAmount,
            _rewardRatio
        );

        poolById[poolsCount] = pool;
        emit PoolCreated(pool, msg.sender);

        return pool;
    }

    function setCreator(address _account, bool _status) external onlyOperator {
        creators[_account] = _status;
        emit CreatorStatusChanged(_account, _status);
    }
}
