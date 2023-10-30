import { SignerWithAddress } from "@nomicfoundation/hardhat-ethers/signers";
import { ERC721Mock, ERC721Mock__factory } from "../../typechain";
import { TokenData } from "../types";

export async function deployERC721Mock(
  deployer: SignerWithAddress,
  data: TokenData,
): Promise<ERC721Mock> {
  const factory = new ERC721Mock__factory(deployer);
  const contract = await factory.deploy(data.name, data.symbol);
  return contract;
}
