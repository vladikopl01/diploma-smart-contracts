import { SignerWithAddress } from "@nomicfoundation/hardhat-ethers/signers";
import { StakingPool, StakingPool__factory } from "../../typechain";
import { StakingPoolData } from "../types";

export async function deployStakingPool(
  deployer: SignerWithAddress,
  data: StakingPoolData,
): Promise<StakingPool> {
  const factory = new StakingPool__factory(deployer);
  const contract = await factory.deploy(data.charityToken);
  return contract;
}
