import { useContractRead } from '@starknet-react/core';
import { GAMEADDRESS } from '../constants/addresses';
import gameContract from '../constants/nogame.json';
import { BlockTag } from 'starknet';

export function useGetPlanetPrice() {
  const { data } = useContractRead({
    address: GAMEADDRESS,
    abi: gameContract.abi,
    functionName: 'get_current_planet_price',
    args: [],
    blockIdentifier: BlockTag.pending,
  });
  return data as unknown as number;
}
