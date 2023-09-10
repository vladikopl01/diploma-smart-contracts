// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.20;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {IERC721} from "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import {ERC721Holder} from "@openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol";

import {IAuction} from "../interfaces/IAuction.sol";
import {ICharityToken} from "../interfaces/ICharityToken.sol";

contract Auction is ERC721Holder, IAuction {
    address public immutable factory;
    ICharityToken public charityToken;
    address public creator;
    IERC20 public depositToken;
    IERC721 public rewardToken;
    uint256 public rewardTokenId;
    uint256 public startTime;
    uint256 public endTime;
    uint256 public minBidAmount;
    uint256 public buyPrice;

    string public title;
    string public description;

    mapping(address => uint256) public bids;
    mapping(uint256 => Bid) public bidHistory;
    uint256 public bidsCount;
    uint256 public highestBid;
    address public highestBidder;
    bool public cancelled;
    bool public bidsClaimed;
    bool public rewardClaimed;
    uint256 public charityMultiplier;

    modifier onlyCreator() {
        if (msg.sender != creator) revert OnlyCreatorAllowed();
        _;
    }

    modifier onlyNotCreator() {
        if (msg.sender == creator) revert CreatorNotAllowed();
        _;
    }

    modifier notEnded() {
        if (_isEnded()) revert AlreadyEnded();
        _;
    }

    modifier ended() {
        if (!_isEnded()) revert NotEnded();
        _;
    }

    modifier notCanceled() {
        if (cancelled) revert AuctionCancelled();
        _;
    }

    constructor() {
        factory = msg.sender;
    }

    function initialize(
        address _charityToken,
        address _creator,
        address _depositToken,
        address _rewardToken,
        uint256 _rewardTokenId,
        uint256 _endTime,
        uint256 _minBidAmount,
        uint256 _buyPrice,
        string calldata _title,
        string calldata _description
    ) external {
        if (msg.sender != factory) revert AlreadyInitialized();

        charityToken = ICharityToken(_charityToken);
        creator = _creator;
        depositToken = IERC20(_depositToken);
        rewardToken = IERC721(_rewardToken);
        rewardTokenId = _rewardTokenId;
        startTime = block.timestamp;
        endTime = _endTime;
        minBidAmount = _minBidAmount;
        buyPrice = _buyPrice;
        title = _title;
        description = _description;

        rewardToken.safeTransferFrom(msg.sender, address(this), _rewardTokenId);
    }

    function bid(uint256 _amount) external onlyNotCreator notEnded notCanceled {
        if (_amount < minBidAmount) revert BidTooLow();

        uint256 totalBid = bids[msg.sender] + _amount;
        if (totalBid <= highestBid) revert BidTooLow();
        if (totalBid > buyPrice) {
            _amount = buyPrice - bids[msg.sender];
            endTime = 0;
            return;
        }

        bids[msg.sender] += _amount;
        charityMultiplier = (bids[msg.sender] * 1000) / highestBid;
        bidsCount++;
        bidHistory[bidsCount] = Bid(msg.sender, _amount, block.timestamp);
        highestBid = bids[msg.sender];
        highestBidder = msg.sender;

        emit BidPlaced(msg.sender, _amount);
    }

    function withdraw() external onlyNotCreator ended {
        if (msg.sender == highestBidder) revert HighestBidderNotAllowed();
        if (bids[msg.sender] == 0) revert NothingToWithdraw();

        uint256 amount = bids[msg.sender];
        bids[msg.sender] = 0;
        depositToken.transferFrom(address(this), msg.sender, amount);

        emit BidWithdrawn(msg.sender, amount);
    }

    function claim() external ended notCanceled {
        if (msg.sender == creator) {
            if (bidsClaimed) revert BidsAlreadyClaimed();
            if (highestBid == 0) revert NothingToClaim();

            bidsClaimed = true;
            depositToken.transferFrom(address(this), msg.sender, highestBid);

            emit BidsClaimed(msg.sender, highestBid);
            return;
        }

        if (msg.sender == highestBidder) {
            if (rewardClaimed) revert RewardAlreadyClaimed();

            rewardClaimed = true;
            rewardToken.safeTransferFrom(address(this), highestBidder, rewardTokenId);
            charityToken.mint(msg.sender, (highestBid * charityMultiplier) / 1000);

            emit RewardClaimed(highestBidder, charityMultiplier);
            return;
        }

        revert NoClaimAvailable();
    }

    function cancel() external onlyCreator notEnded {
        cancelled = true;
        rewardToken.safeTransferFrom(address(this), creator, rewardTokenId);

        emit Cancelled();
    }

    function timeLeft() external view returns (uint256) {
        return block.timestamp >= endTime ? 0 : endTime - block.timestamp;
    }

    function isEnded() external view returns (bool) {
        return _isEnded();
    }

    function lastBids(uint256 _skip, uint256 _take) external view returns (Bid[] memory) {
        Bid[] memory _bids = new Bid[](_take);
        for (uint256 i = 0; i < _take; i++) {
            _bids[i] = bidHistory[bidsCount - _skip - i];
        }
        return _bids;
    }

    function _isEnded() internal view returns (bool) {
        return block.timestamp >= endTime;
    }
}
