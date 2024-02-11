import { useContract, useContractWrite } from '@starknet-react/core';
import { InvokeFunctionResponse } from 'starknet';
import { GAMEADDRESS } from '../../constants/addresses';
import game from '../../constants/nogame.json';
import { getUpgradeType, getColonyUpgradeType } from '../../shared/types';

// Define a type for the return value of useUpgrade
export interface UseUpgradeReturnType {
  writeAsync: () => Promise<InvokeFunctionResponse>;
  tx: InvokeFunctionResponse | undefined;
}

export function useCompoundUpgrade(
  unitName: number,
  amount: number,
  colonyId: number
): UseUpgradeReturnType {
  const { contract } = useContract({
    abi: game.abi,
    address: GAMEADDRESS,
  });

  const name =
    colonyId === 0 ? getUpgradeType(unitName) : getColonyUpgradeType(unitName);

  const { data: tx, writeAsync } = useContractWrite({
    calls: [
      colonyId === 0
        ? contract?.populateTransaction['process_compound_upgrade']!(
            name ?? 20,
            amount
          )
        : contract?.populateTransaction['process_colony_compound_upgrade']!(
            colonyId,
            name ?? 20,
            amount
          ),
    ],
  });

  return { writeAsync, tx };
}

export function useTechUpgrade(
  unitName: number,
  amount: number
): UseUpgradeReturnType {
  const { contract } = useContract({
    abi: game.abi,
    address: GAMEADDRESS,
  });

  const name = getUpgradeType(unitName);

  const { data: tx, writeAsync } = useContractWrite({
    calls: [
      contract?.populateTransaction['process_tech_upgrade']!(
        name ? name : 20,
        amount
      ),
    ],
  });

  return { writeAsync, tx };
}
