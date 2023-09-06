// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.20;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {IERC721} from "@openzeppelin/contracts/token/ERC721/IERC721.sol";

interface IAuction {
    struct Bid {
        address bidder;
        uint256 amount;
        uint256 timestamp;
    }

    event BidPlaced(address indexed _bidder, uint256 _amount);
    event BidWithdrawn(address indexed _bidder, uint256 _amount);
    event RewardClaimed(address indexed _bidder, uint256 indexed _charityMultiplier);
    event BidsClaimed(address indexed _creator, uint256 _amount);
    event Cancelled();

    error AlreadyEnded();
    error NotEnded();
    error AuctionCancelled();
    error CreatorNotAllowed();
    error OnlyCreatorAllowed();
    error HighestBidderNotAllowed();
    error BidTooLow();
    error NoClaimAvailable();
    error NothingToWithdraw();
    error NothingToClaim();
    error BidsAlreadyClaimed();
    error RewardAlreadyClaimed();

    function bid(uint256 _amount) external;

    function withdraw() external;

    function claim() external;

    function cancel() external;

    function timeLeft() external view returns (uint256);

    function isEnded() external view returns (bool);

    function lastBids(uint256 _skip, uint256 _take) external view returns (Bid[] memory);

    function creator() external view returns (address);

    function depositToken() external view returns (IERC20);

    function rewardToken() external view returns (IERC721);

    function rewardTokenId() external view returns (uint256);

    function startTime() external view returns (uint256);

    function endTime() external view returns (uint256);

    function minBidAmount() external view returns (uint256);

    function title() external view returns (string memory);

    function description() external view returns (string memory);

    function bids(address _bidder) external view returns (uint256);

    function bidHistory(uint256 _index) external view returns (address, uint256, uint256);

    function bidsCount() external view returns (uint256);

    function highestBid() external view returns (uint256);

    function highestBidder() external view returns (address);

    function cancelled() external view returns (bool);

    function bidsClaimed() external view returns (bool);

    function rewardClaimed() external view returns (bool);
}
