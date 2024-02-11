import { useContract, useContractWrite } from '@starknet-react/core';
import { InvokeFunctionResponse } from 'starknet';
import { GAMEADDRESS } from '../../constants/addresses';
import game from '../../constants/nogame.json';
import { getBuildType, getColonyBuildType } from '../../shared/types';

// Define a type for the return value of useBuild
interface UseBuildReturnType {
  writeAsync: () => Promise<InvokeFunctionResponse>;
  tx: InvokeFunctionResponse | undefined;
}

export function useShipBuild(
  unitName: number,
  quantity: number,
  colonyId: number
): UseBuildReturnType {
  const { contract } = useContract({
    abi: game.abi,
    address: GAMEADDRESS,
  });

  const name =
    colonyId === 0 ? getBuildType(unitName) : getColonyBuildType(unitName);

  const calls = [
    colonyId === 0
      ? contract?.populateTransaction['process_ship_build']!(
          name ? name : 20,
          quantity
        )
      : contract?.populateTransaction['process_colony_unit_build']!(
          colonyId,
          name ? name : 20,
          quantity
        ),
  ];

  const { writeAsync, data: tx } = useContractWrite({
    calls,
  });

  return { writeAsync, tx };
}

export function useDefenceBuild(
  unitName: number,
  quantity: number,
  colonyId: number
): UseBuildReturnType {
  const { contract } = useContract({
    abi: game.abi,
    address: GAMEADDRESS,
  });

  const name =
    colonyId === 0 ? getBuildType(unitName) : getColonyBuildType(unitName);

  const calls = [
    colonyId === 0
      ? contract?.populateTransaction['process_defence_build']!(
          name ? name : 20,
          quantity
        )
      : contract?.populateTransaction['process_colony_unit_build']!(
          colonyId,
          name ? name : 20,
          quantity
        ),
  ];

  const { writeAsync, data: tx } = useContractWrite({
    calls,
  });

  return { writeAsync, tx };
}
