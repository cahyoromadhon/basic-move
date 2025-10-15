import { getFullnodeUrl } from "@mysten/sui/client";
import { TESTNET_COUNTER_PACKAGE_ID } from "./constants.ts";
import { createNetworkConfig } from "@mysten/dapp-kit";

const { networkConfig, useNetworkVariable, useNetworkVariables } =
  createNetworkConfig({
    testnet: {
      url: getFullnodeUrl("testnet"),
      variables: {
        counterPackageId: TESTNET_COUNTER_PACKAGE_ID,
      },
    }
  });

export { useNetworkVariable, useNetworkVariables, networkConfig };
