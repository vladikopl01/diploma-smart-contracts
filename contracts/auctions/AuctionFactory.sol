// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.20;

import {Create2} from "@openzeppelin/contracts/utils/Create2.sol";

import {IAuctionFactory} from "../interfaces/IAuctionFactory.sol";
import {Auction} from "./Auction.sol";
import {Operatable} from "../utilities/Operatable.sol";

contract AuctionFactory is IAuctionFactory, Operatable {
    address public immutable charityToken;

    mapping(address => bool) public creators;
    mapping(address => bool) public allowedDepositTokens;
    mapping(address => bool) public allowedRewardTokens;

    mapping(uint256 => address) public auctionById;
    uint256 public auctionsCount;

    modifier onlyCreator() {
        if (!creators[msg.sender]) revert NotCreator();
        _;
    }

    constructor(address _charityToken) {
        charityToken = _charityToken;
    }

    function createAuction(
        address _depositToken,
        address _rewardToken,
        uint256 _rewardTokenId,
        uint256 _endTime,
        uint256 _minBidAmount,
        string calldata _title,
        string calldata _description
    ) external onlyCreator returns (address) {
        if (_depositToken == address(0)) revert AddressIsZero();
        if (_rewardToken == address(0)) revert AddressIsZero();
        if (_endTime <= block.timestamp) revert InvalidTimestamp();
        if (_minBidAmount == 0) revert InvalidMinBidAmount();

        if (bytes(_title).length == 0) revert EmptyTitle();
        if (bytes(_description).length == 0) revert EmptyDescription();

        ++auctionsCount;
        bytes memory bytecode = type(Auction).creationCode;
        bytes32 salt = keccak256(abi.encodePacked(auctionsCount, msg.sender));
        address auction = Create2.deploy(0, salt, bytecode);

        Auction(auction).initialize(
            charityToken,
            msg.sender,
            _depositToken,
            _rewardToken,
            _rewardTokenId,
            _endTime,
            _minBidAmount,
            _title,
            _description
        );

        auctionById[auctionsCount] = auction;
        emit AuctionCreated(msg.sender, auction);

        return auction;
    }

    function setCreator(address _account, bool _status) external onlyOperator {
        creators[_account] = _status;
        emit CreatorStatusChanged(_account, _status);
    }

    function setAllowedDepositToken(address _token, bool _status) external onlyOperator {
        allowedDepositTokens[_token] = _status;
        emit DepositTokenStatusChanged(_token, _status);
    }

    function setAllowedRewardToken(address _token, bool _status) external onlyOperator {
        allowedRewardTokens[_token] = _status;
        emit RewardTokenStatusChanged(_token, _status);
    }
}
