import { SignerWithAddress } from "@nomicfoundation/hardhat-ethers/signers";
import { AuctionFactory, AuctionFactory__factory } from "../../typechain";
import { AuctionFactoryData } from "../types";

export async function deployAuctionFactory(
  deployer: SignerWithAddress,
  data: AuctionFactoryData,
): Promise<AuctionFactory> {
  const factory = new AuctionFactory__factory(deployer);
  const contract = await factory.deploy(data.charityToken);
  return contract;
}
