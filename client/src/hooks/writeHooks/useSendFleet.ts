import {
  useContract,
  useContractWrite,
  ContractWriteVariables,
} from '@starknet-react/core';
import { InvokeFunctionResponse } from 'starknet';
import { GAMEADDRESS } from '../../constants/addresses';
import game from '../../constants/nogame.json';
import { type Fleet, type Position } from '../../shared/types';

export default function useSendFleet(
  fleet: Fleet,
  position: Position,
  missioCategory: number,
  speedModifier: number,
  colonyId: number
): {
  writeAsync: (
    args?: ContractWriteVariables | undefined
  ) => Promise<InvokeFunctionResponse>;
  data: InvokeFunctionResponse | undefined;
} {
  const { contract } = useContract({
    abi: game.abi,
    address: GAMEADDRESS,
  });
  const { writeAsync, data } = useContractWrite({
    calls: [
      contract?.populateTransaction.send_fleet!(
        fleet,
        position,
        missioCategory,
        speedModifier,
        colonyId
      ),
    ],
  });

  return { writeAsync, data };
}
