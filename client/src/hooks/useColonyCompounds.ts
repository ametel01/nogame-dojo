import { useDojo } from '../dojo/useDojo';
import { getEntityIdFromKeys } from '@dojoengine/utils';
import { Compound } from '../constants/names/Names';
import { Entity } from '@dojoengine/recs';
import { useComponentValue } from '@dojoengine/react';

export type ColonyCompounds = {
  steel: number;
  quartz: number;
  tritium: number;
  energy: number;
  dockyard: number;
};

export function useColonyCompounds(
  planetId: number,
  colonyId: number
): ColonyCompounds {
  const {
    setup: {
      clientComponents: { ColonyCompounds },
    },
  } = useDojo();

  // Reusable function to get compound level
  const useGetCompoundLevel = (compoundType: number): number => {
    const entityId = getEntityIdFromKeys([
      BigInt(planetId),
      BigInt(colonyId),
      BigInt(compoundType),
    ]) as Entity;
    return useComponentValue(ColonyCompounds, entityId)?.level ?? 0;
  };

  // Use the reusable function for each compound
  const compounds: ColonyCompounds = {
    steel: useGetCompoundLevel(Compound.Steel),
    quartz: useGetCompoundLevel(Compound.Quartz),
    tritium: useGetCompoundLevel(Compound.Tritium),
    energy: useGetCompoundLevel(Compound.Energy),
    dockyard: useGetCompoundLevel(Compound.Dockyard),
  };

  return compounds;
}
