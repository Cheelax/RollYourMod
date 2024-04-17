/* previously called generated.ts */

import { DojoProvider } from "@dojoengine/core";
import { Account, RevertedTransactionReceiptResponse } from "starknet";

const tryBetterErrorMsg = (msg: string): string => {
  const failureReasonIndex = msg.indexOf("Failure reason");
  if (failureReasonIndex > 0) {
    let betterMsg = msg.substring(failureReasonIndex);
    const cairoTracebackIndex = betterMsg.indexOf("Cairo traceback");
    betterMsg = betterMsg.substring(0, cairoTracebackIndex);

    const regex = /Failure reason:.*?\('([^']+)'\)/;
    const matches = betterMsg.match(regex);

    if (matches && matches.length > 1) {
      return matches[1];
    } else {
      return betterMsg;
    }
  }

  return msg;
};

export async function setupWorld(provider: DojoProvider) {
  // Transaction execution and checking wrapper
  const executeAndCheck = async (
    account: Account,
    contractName: string,
    methodName: string,
    args: any[]
  ) => {
    const ret = await provider.execute(account, contractName, methodName, args);
    const receipt = await account.waitForTransaction(ret.transaction_hash, {
      retryInterval: 100,
    });

    // Add any additional checks or logic here based on the receipt
    if (receipt.status === "REJECTED") {
      console.log("Transaction Rejected");
      throw new Error("[Tx REJECTED] ");
    }

    if ("execution_status" in receipt) {
      // The receipt is of a type that includes execution_status
      if (receipt.execution_status === "REVERTED") {
        const errorMessage = tryBetterErrorMsg(
          (receipt as RevertedTransactionReceiptResponse).revert_reason ||
            "Transaction Reverted"
        );
        console.log("ERROR KATANA", errorMessage);
        throw new Error("[Tx REVERTED] " + errorMessage);
      }
    }

    return receipt;
  };

  function game_actions() {
    const contractName = "ryo_pvp::contracts::game::game_actions";
    const create = async (account: Account, secondPlayer: string) => {
      try {
        return await executeAndCheck(account, contractName, "new", [
          provider.getWorldAddress(),
          account.address,
          secondPlayer,
        ]);
      } catch (error) {
        console.error("Error executing create:", error);
        throw error;
      }
    };

    const commitHustler = async (
      account: Account,
      game_id: number,
      hustler_id: number,
      hash: bigint
    ) => {
      try {
        return await executeAndCheck(account, contractName, "commit_hustler", [
          game_id,
          hustler_id,
          hash,
        ]);
      } catch (error) {
        console.error("Error executing commitHustler:", error);
        throw error;
      }
    };

    const revealHustler = async (
      account: Account,
      game_id: number,
      hustler: number,
      salt: bigint
    ) => {
      try {
        return await executeAndCheck(account, contractName, "reveal_hustler", [
          game_id,
          hustler,
          salt,
        ]);
      } catch (error) {
        console.error("Error executing revealHustler:", error);
        throw error;
      }
    };

    const commitMove = async (
      account: Account,
      game_id: number,
      hustler_id: number,
      hash: bigint
    ) => {
      try {
        return await executeAndCheck(account, contractName, "commit_move", [
          game_id,
          hustler_id,
          hash,
        ]);
      } catch (error) {
        console.error("Error executing commitMove:", error);
        throw error;
      }
    };

    const revealMove = async (
      account: Account,
      game_id: number,
      move: number,
      salt: bigint
    ) => {
      try {
        return await executeAndCheck(account, contractName, "reveal_move", [
          game_id,
          move,
          salt,
        ]);
      } catch (error) {
        console.error("Error executing revealMove:", error);
        throw error;
      }
    };

    const revealDrugs = async (
      account: Account,
      game_id: number,
      hustler_id: number,
      drugs: number,
      salt: bigint
    ) => {
      try {
        return await executeAndCheck(account, contractName, "reveal_drugs", [
          game_id,
          hustler_id,
          drugs,
          salt,
        ]);
      } catch (error) {
        console.error("Error executing revealDrugs:", error);
        throw error;
      }
    };

    return {
      create,
      commitHustler,
      revealHustler,
      commitMove,
      revealDrugs,
      revealMove,
    };
  }

  return {
    game_actions: game_actions(),
  };
}
