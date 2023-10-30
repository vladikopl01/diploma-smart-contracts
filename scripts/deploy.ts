import hre from "hardhat";
import { erc20Tokens, erc721Tokens } from "./data/tokens";
import { deployCharityToken } from "./deploy/CharityToken";
import { deployERC20Mock } from "./deploy/ERC20Mock";
import { deployERC721Mock } from "./deploy/ERC721Mock";
import { deployPoolFactory } from "./deploy/PoolFactory";
import { deployStakingPool } from "./deploy/StakingPool";
import { CharityPoolData } from "./types";

async function deployProject(): Promise<void> {
  try {
    // Get deployer
    const [owner, alice, bob, john, depositReceiver] =
      await hre.ethers.getSigners();

    // deploy ERC20 Tokens
    const erc20mocks = await Promise.all(
      erc20Tokens.map((token) => {
        return deployERC20Mock(owner, token);
      }),
    );

    // deploy ERC721 Tokens
    const erc721mocks = await Promise.all(
      erc721Tokens.map((token) => {
        return deployERC721Mock(owner, token);
      }),
    );

    // deploy CharityToken
    const charityToken = await deployCharityToken(owner);

    // deploy StakingPool
    const stakingPool = await deployStakingPool(owner, {
      charityToken: await charityToken.getAddress(),
    });

    // deploy PoolFactory
    const poolFactory = await deployPoolFactory(owner, {
      charityToken: await charityToken.getAddress(),
    });

    // deploy AuctionFactory
    const auctionFactory = await deployPoolFactory(owner, {
      charityToken: await charityToken.getAddress(),
    });

    // deploy Pools
    const pools: CharityPoolData[] = [
      {
        creator: await alice.getAddress(),
        depositReceiver: await depositReceiver.getAddress(),
        inputToken: await erc20mocks[0].getAddress(),
        rewardToken: await charityToken.getAddress(),
        startTimestamp: BigInt(0),
        endTimestamp: BigInt(0),
        amountToRaise: BigInt(0),
        minDepositAmount: BigInt(0),
        rewardRatio: BigInt(0),
        title: "Rebuild Ukraine",
        description: "Pool 1",
        coverImageUrl: "",
      },
      {
        creator: await bob.getAddress(),
        depositReceiver: await depositReceiver.getAddress(),
        inputToken: await erc20mocks[1].getAddress(),
        rewardToken: await charityToken.getAddress(),
        startTimestamp: BigInt(0),
        endTimestamp: BigInt(0),
        amountToRaise: BigInt(0),
        minDepositAmount: BigInt(0),
        rewardRatio: BigInt(0),
        title: "Keep Ukraine moving",
        description:
          "Support to save lives by providing Ukraine with urgently needed ambulances. Donate now to support the Ministry of Health of Ukraine in obtaining Type-C ambulances.",
        coverImageUrl:
          "https://files.u24.gov.ua/pages/uber/_processed/hero-bg-2_1600x.jpg",
      },
      {
        creator: await john.getAddress(),
        depositReceiver: await depositReceiver.getAddress(),
        inputToken: await erc20mocks[2].getAddress(),
        rewardToken: await charityToken.getAddress(),
        startTimestamp: BigInt(0),
        endTimestamp: BigInt(0),
        amountToRaise: BigInt(0),
        minDepositAmount: BigInt(0),
        rewardRatio: BigInt(0),
        title: "The World's First Naval Fleet of Drones",
        description:
          "Join us in creating the world's first Fleet of Naval Drones. It will protect Ukrainian seas, prevent cities from being struck by missiles, and help unlock corridors for civilian ships that transport grain.",
        coverImageUrl: "https://u24.gov.ua/assets/img/navaldrones/bg_hero.jpg",
      },
    ];
    // deploy Auctions
  } catch (error) {
    console.error(error);
  }
}

async function main() {
  await deployProject();
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
