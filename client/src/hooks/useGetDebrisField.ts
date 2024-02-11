import { useContractRead } from '@starknet-react/core';
import { GAMEADDRESS } from '../constants/addresses';
import gameContract from '../constants/nogame.json';
import { type DebrisField } from '../shared/types';
import { BlockTag } from 'starknet';

export function useGetDebrisField(planetId: number | undefined): DebrisField {
  const zeroDebris: DebrisField = { steel: 0, quartz: 0 };

  const { data } = useContractRead({
    address: GAMEADDRESS,
    abi: gameContract.abi,
    functionName: 'get_debris_field',
    args: planetId !== undefined ? [planetId] : [],
    blockIdentifier: BlockTag.pending,
  });

  if (planetId === undefined) {
    return zeroDebris;
  }

  return data ? (data as unknown as DebrisField) : zeroDebris;
}
