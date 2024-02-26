import { useDojo } from '../dojo/useDojo';
import { getEntityIdFromKeys } from '@dojoengine/utils';
import { Defence } from '../constants/names/Names';
import { Entity } from '@dojoengine/recs';
import { useComponentValue } from '@dojoengine/react';
import { Defences } from './usePlanetDefences';

export function useColonyDefences(
  planetId: number,
  colonyId: number
): Defences {
  const {
    setup: {
      clientComponents: { ColonyDefences },
    },
  } = useDojo();

  // Reusable function to get ship level
  const useGetDefenceLevel = (shipType: number): number => {
    const entityId = getEntityIdFromKeys([
      BigInt(planetId),
      BigInt(colonyId),
      BigInt(shipType),
    ]) as Entity;
    return useComponentValue(ColonyDefences, entityId)?.count ?? 0;
  };

  const defences: Defences = {
    celestia: useGetDefenceLevel(Defence.Celestia),
    blaster: useGetDefenceLevel(Defence.Blaster),
    beam: useGetDefenceLevel(Defence.Beam),
    astral: useGetDefenceLevel(Defence.Astral),
    plasma: useGetDefenceLevel(Defence.Plasma),
  };
  return defences;
}
