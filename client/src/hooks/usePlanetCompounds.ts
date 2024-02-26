import { useDojo } from '../dojo/useDojo';
import { getEntityIdFromKeys } from '@dojoengine/utils';
import { Compound } from '../constants/names/Names';
import { Entity } from '@dojoengine/recs';
import { useComponentValue } from '@dojoengine/react';

export type Compounds = {
  steel: number;
  quartz: number;
  tritium: number;
  energy: number;
  lab: number;
  dockyard: number;
};

export function usePlanetCompounds(planetId: number): Compounds {
  const {
    setup: {
      clientComponents: { PlanetCompound },
    },
  } = useDojo();

  // Reusable function to get compound level
  const useGetCompoundLevel = (compoundType: number): number => {
    const entityId = getEntityIdFromKeys([
      BigInt(planetId),
      BigInt(compoundType),
    ]) as Entity;
    return useComponentValue(PlanetCompound, entityId)?.level ?? 0;
  };

  // Use the reusable function for each compound
  const compounds: Compounds = {
    steel: useGetCompoundLevel(Compound.Steel),
    quartz: useGetCompoundLevel(Compound.Quartz),
    tritium: useGetCompoundLevel(Compound.Tritium),
    energy: useGetCompoundLevel(Compound.Energy),
    lab: useGetCompoundLevel(Compound.Lab),
    dockyard: useGetCompoundLevel(Compound.Dockyard),
  };

  return compounds;
}
