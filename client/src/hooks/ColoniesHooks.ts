import { useContractRead } from '@starknet-react/core';
import { GAMEADDRESS } from '../constants/addresses';
import game from '../constants/nogame.json';
import { BlockTag } from 'starknet';
import {
  CompoundsLevels,
  DefenceLevels,
  getColonyBuildType,
} from '../shared/types';
import { Resources } from '../shared/types';
import { UseUpgradeReturnType } from './writeHooks/useUpgrade';
import { useContractWrite } from '@starknet-react/core';
import { useContract } from '@starknet-react/core';
import { getColonyUpgradeType } from '../shared/types';
import { ShipsLevels } from '../shared/types/index';

const baseCompounds: CompoundsLevels = {
  steel: 0,
  quartz: 0,
  tritium: 0,
  energy: 0,
  lab: 0,
  dockyard: 0,
};

const baseResources: Resources = {
  steel: 0,
  quartz: 0,
  tritium: 0,
};

const baseDefences: DefenceLevels = {
  celestia: 0,
  blaster: 0,
  beam: 0,
  astral: 0,
  plasma: 0,
};

const baseShips: ShipsLevels = {
  carrier: 0,
  scraper: 0,
  celestia: 0,
  sparrow: 0,
  frigate: 0,
  armade: 0,
};

export type ColonyArrayElement = [bigint, { orbit: bigint; system: bigint }];
export type ColonyArray = ColonyArrayElement[];

export function useGetColonyMotherPlanet(planetId: number | undefined): number {
  const { data } = useContractRead({
    address: GAMEADDRESS,
    abi: game.abi,
    functionName: 'get_colony_mother_planet',
    args: [planetId!],
    blockIdentifier: BlockTag.pending,
  });

  if (!planetId) {
    0;
  }
  return data as unknown as number;
}

export function useGetPlanetColonies(
  planetId: number | undefined
): ColonyArray {
  const { data } = useContractRead({
    address: GAMEADDRESS,
    abi: game.abi,
    functionName: 'get_planet_colonies',
    args: [planetId!],
    blockIdentifier: BlockTag.pending,
  });

  if (!planetId) {
    return [];
  }

  return data as unknown as ColonyArray;
}

export function useGetColonyCompounds(
  planetId: number | undefined,
  colonyId: number | undefined
): CompoundsLevels {
  const { data } = useContractRead({
    address: GAMEADDRESS,
    abi: game.abi,
    functionName: 'get_colony_compounds',
    args: [planetId!, colonyId!],
    blockIdentifier: BlockTag.pending,
  });

  if (!planetId) {
    return baseCompounds;
  }

  return data as unknown as CompoundsLevels;
}

export function useGetColonyDefences(
  planetId: number | undefined,
  colonyId: number | undefined
): DefenceLevels {
  const { data } = useContractRead({
    address: GAMEADDRESS,
    abi: game.abi,
    functionName: 'get_colony_defences_levels',
    args: [planetId!, colonyId!],
    blockIdentifier: BlockTag.pending,
  });

  if (!planetId) {
    return baseDefences;
  }

  return data as unknown as DefenceLevels;
}

export function useGetColonyShips(
  planetId: number | undefined,
  colonyId: number | undefined
): ShipsLevels {
  const { data } = useContractRead({
    address: GAMEADDRESS,
    abi: game.abi,
    functionName: 'get_colony_ships_levels',
    args: [planetId!, colonyId!],
    blockIdentifier: BlockTag.pending,
  });

  if (!planetId) {
    return baseShips;
  }

  return data as unknown as ShipsLevels;
}

export function useGetColonyResources(
  planetId: number | undefined,
  colonyId: number | undefined
): Resources {
  const { data } = useContractRead({
    address: GAMEADDRESS,
    abi: game.abi,
    functionName: 'get_colony_collectible_resources',
    args: [planetId!, colonyId!],
    blockIdentifier: BlockTag.pending,
  });

  if (!planetId) {
    return baseResources;
  }

  return data as unknown as Resources;
}

export function useColonyCompoundUpgrade(
  colonyId: number,
  unitName: number | undefined,
  amount: number
): UseUpgradeReturnType {
  const { contract } = useContract({
    abi: game.abi,
    address: GAMEADDRESS,
  });

  unitName = unitName ?? 0;

  const name = getColonyUpgradeType(unitName);

  const { data: tx, writeAsync } = useContractWrite({
    calls: [
      contract?.populateTransaction['process_colony_compound_upgrade']!(
        colonyId,
        name ?? 0,
        amount
      ),
    ],
  });

  return { writeAsync, tx };
}

export function useColonyUnitBuild(
  colonyId: number,
  unitName: number | undefined,
  amount: number
): UseUpgradeReturnType {
  const { contract } = useContract({
    abi: game.abi,
    address: GAMEADDRESS,
  });

  unitName = unitName ?? 0;

  const name = getColonyBuildType(unitName);

  const { data: tx, writeAsync } = useContractWrite({
    calls: [
      contract?.populateTransaction['process_colony_unit_build']!(
        colonyId,
        name ?? 0,
        amount
      ),
    ],
  });

  return { writeAsync, tx };
}
