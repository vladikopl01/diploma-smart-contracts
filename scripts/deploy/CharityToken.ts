import { SignerWithAddress } from "@nomicfoundation/hardhat-ethers/signers";
import { CharityToken, CharityToken__factory } from "../../typechain";

export async function deployCharityToken(
  deployer: SignerWithAddress,
): Promise<CharityToken> {
  const factory = new CharityToken__factory(deployer);
  const contract = await factory.deploy();
  return contract;
}
