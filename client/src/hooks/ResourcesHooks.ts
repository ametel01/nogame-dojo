import { GAMEADDRESS } from '../constants/addresses';
import game from '../constants/nogame.json';
import { BlockTag } from 'starknet';
import { useContractRead } from '@starknet-react/core';
import { type Resources } from '../shared/types';

const DefaultResources: Resources = { steel: 0, quartz: 0, tritium: 0 };

export function useSpendableResources(planetId: number) {
  const isValidPlanetId = planetId !== undefined && !isNaN(planetId);

  const { data } = useContractRead({
    address: GAMEADDRESS,
    abi: game.abi,
    functionName: 'get_spendable_resources',
    args: isValidPlanetId ? [planetId] : undefined,
    blockIdentifier: BlockTag.pending,
  });

  if (!isValidPlanetId) {
    return DefaultResources;
  }

  return data as unknown as Resources;
}

export function useCollectibleResources(planetId: number) {
  const isValidPlanetId = planetId !== undefined && !isNaN(planetId);

  const { data } = useContractRead({
    address: GAMEADDRESS,
    abi: game.abi,
    functionName: 'get_collectible_resources',
    args: isValidPlanetId ? [planetId] : undefined,
    blockIdentifier: BlockTag.pending,
  });

  if (!isValidPlanetId) {
    return DefaultResources;
  }

  return data as unknown as Resources;
}

export function useEnergyAvailable(planetId: number) {
  const isValidPlanetId = planetId !== undefined && !isNaN(planetId);

  const { data } = useContractRead({
    address: GAMEADDRESS,
    abi: game.abi,
    functionName: 'get_energy_available',
    args: isValidPlanetId ? [planetId] : undefined,
    blockIdentifier: BlockTag.pending,
  });

  if (!isValidPlanetId) {
    return 0;
  }

  return data as unknown as number;
}
