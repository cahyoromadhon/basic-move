import {
  useCurrentAccount,
  useSignAndExecuteTransaction,
  useSuiClient,
  useSuiClientQuery,
} from "@mysten/dapp-kit";
import type { SuiObjectData } from "@mysten/sui/client";
import { Transaction } from "@mysten/sui/transactions";
import { useNetworkVariable } from "./networkConfig";
import { useState } from "react";
import ClipLoader from "react-spinners/ClipLoader";
import { Button, Flex, Heading, Text } from "@radix-ui/themes";

export function Counter({ id }: { id: string }) {
  const counterPackageId = useNetworkVariable("counterPackageId");
  const suiClient = useSuiClient();
  const currentAccount = useCurrentAccount();
  const { mutate: signAndExecute } = useSignAndExecuteTransaction();
  const { data, isPending, error, refetch } = useSuiClientQuery("getObject", {
    id,
    options: {
      showContent: true,
      showOwner: true,
    },
  });

  const [waitingForTxn, setWaitingForTxn] = useState("");

  const executeMoveCall = (method: "increment" | "decrement" | "reset") => {
    setWaitingForTxn(method);

    const tx = new Transaction();

    if (method === "reset") {
      tx.moveCall({
        arguments: [tx.object(id), tx.pure.u64(0)],
        target: `${counterPackageId}::distributed_counter::set_value`,
      });
    } else if (method === "increment"){
      tx.moveCall({
        arguments: [tx.object(id)],
        target: `${counterPackageId}::distributed_counter::increment`,
      });
    } else if (method === "decrement") {
      tx.moveCall({
        arguments: [tx.object(id)],
        target: `${counterPackageId}::distributed_counter::decrement`,
      });
    } else throw new Error("Unknown method");

    signAndExecute(
      {
        transaction: tx,
      },
      {
        onSuccess: (tx) => {
          suiClient.waitForTransaction({ digest: tx.digest }).then(async () => {
            await refetch();
            setWaitingForTxn("");
          });
        },
      },
    );
  };

  if (isPending) return <Text>Loading...</Text>;

  if (error) return <Text>Error: {error.message}</Text>;

  if (!data.data) return <Text>Not found</Text>;

  const ownedByCurrentAccount =
    getCounterFields(data.data)?.owner === currentAccount?.address;

  return (
    <>
      <Heading size="5" align="center" mt="20vh">ID: {id}</Heading>

      <Flex direction="column" gap="2" justify="center" align="center" height="20vh">
        <Text>Count: {getCounterFields(data.data)?.value}</Text>
        <Flex direction="row" gap="2">
          <Button
            onClick={() => executeMoveCall("increment")}
            disabled={waitingForTxn !== ""}
          >
            {waitingForTxn === "increment" ? (
              <ClipLoader size={20} />
            ) : (
              "Increment"
            )}
          </Button>
          <Button
            onClick={() => executeMoveCall("decrement")}
            disabled={waitingForTxn !== ""}
            className=""
          >
            {waitingForTxn === "decrement" ? (
              <ClipLoader size={20} />
            ) : (
              "Decrement"
            )}
          </Button>
          {ownedByCurrentAccount ? (
            <Button
              onClick={() => executeMoveCall("reset")}
              disabled={waitingForTxn !== ""}
            >
              {waitingForTxn === "reset" ? <ClipLoader size={20} /> : "Reset"}
            </Button>
          ) : null}
        </Flex>
      </Flex>
    </>
  );
}
function getCounterFields(data: SuiObjectData) {
  if (data.content?.dataType !== "moveObject") {
    return null;
  }

  return data.content.fields as { value: number; owner: string };
}
