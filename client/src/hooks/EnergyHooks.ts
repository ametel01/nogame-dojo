import { useContractRead } from '@starknet-react/core';
import { GAMEADDRESS } from '../constants/addresses';
import game from '../constants/nogame.json';
import { BlockTag } from 'starknet';

export function useGetCelestiaAvailable(planetId: number): number {
  const { data } = useContractRead({
    address: GAMEADDRESS,
    abi: game.abi,
    functionName: 'get_celestia_available',
    args: [planetId],
    blockIdentifier: BlockTag.pending,
  });
  return data as unknown as number;
}

export function useGetEnergyGainAfterUpgrade(planetId: number): number {
  const { data } = useContractRead({
    address: GAMEADDRESS,
    abi: game.abi,
    functionName: 'get_energy_gain_after_upgrade',
    args: [planetId],
    blockIdentifier: BlockTag.pending,
  });
  return data as unknown as number;
}
