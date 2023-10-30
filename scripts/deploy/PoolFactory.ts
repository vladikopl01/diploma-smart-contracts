import { SignerWithAddress } from "@nomicfoundation/hardhat-ethers/signers";
import { PoolFactory, PoolFactory__factory } from "../../typechain";
import { PoolFactoryData } from "../types";

export async function deployPoolFactory(
  deployer: SignerWithAddress,
  data: PoolFactoryData,
): Promise<PoolFactory> {
  const factory = new PoolFactory__factory(deployer);
  const contract = await factory.deploy(data.charityToken);
  return contract;
}
