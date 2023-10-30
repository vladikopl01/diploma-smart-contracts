export type AuctionData = {
  charityToken: string;
  creator: string;
  depositToken: string;
  rewardToken: string;
  rewardTokenId: bigint;
  endTime: bigint;
  minBidAmount: bigint;
  buyPrice: bigint;
  title: string;
  description: string;
};

export type CharityPoolData = {
  creator: string;
  depositReceiver: string;
  inputToken: string;
  rewardToken: string;
  startTimestamp: bigint;
  endTimestamp: bigint;
  amountToRaise: bigint;
  minDepositAmount: bigint;
  rewardRatio: bigint;
  title: string;
  description: string;
  coverImageUrl: string;
};

export type StakingPoolData = {
  charityToken: string;
};

export type AuctionFactoryData = {
  charityToken: string;
};

export type PoolFactoryData = {
  charityToken: string;
};

export type TokenData = {
  name: string;
  symbol: string;
};
