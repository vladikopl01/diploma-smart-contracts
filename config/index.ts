import * as dotenv from "dotenv";
import * as env from "env-var";

dotenv.config({ path: ".env" });

export const config = {
  INFURA_API_KEY: env.get("INFURA_API_KEY").asString(),
  PRIVATE_KEY: env.get("PRIVATE_KEY").asString(),
  ETHERSCAN_API_KEY: env.get("ETHERSCAN_API_KEY").asString(),
  GAS_REPORTER: env.get("GAS_REPORTER").default("true").asBool(),
  COINMARKETCAP_API_KEY: env.get("COINMARKETCAP_API_KEY").asString(),
};
