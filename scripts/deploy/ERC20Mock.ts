import { SignerWithAddress } from "@nomicfoundation/hardhat-ethers/signers";
import { ERC20Mock, ERC20Mock__factory } from "../../typechain";
import { TokenData } from "../types";

export async function deployERC20Mock(
  deployer: SignerWithAddress,
  data: TokenData,
): Promise<ERC20Mock> {
  const factory = new ERC20Mock__factory(deployer);
  const contract = await factory.deploy(data.name, data.symbol);
  return contract;
}
