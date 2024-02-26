import { useDojo } from '../dojo/useDojo';
import { getEntityIdFromKeys } from '@dojoengine/utils';
import { Defence } from '../constants/names/Names';
import { Entity } from '@dojoengine/recs';
import { useComponentValue } from '@dojoengine/react';

export type Defences = {
  celestia: number;
  blaster: number;
  beam: number;
  astral: number;
  plasma: number;
};

export function usePlanetDefences(planetId: number): Defences {
  const {
    setup: {
      clientComponents: { PlanetDefence },
    },
  } = useDojo();

  // Reusable function to get ship level
  const useGetDefenceLevel = (shipType: number): number => {
    const entityId = getEntityIdFromKeys([
      BigInt(planetId),
      BigInt(shipType),
    ]) as Entity;
    return useComponentValue(PlanetDefence, entityId)?.count ?? 0;
  };

  // Use the reusable function for each ship
  const defences: Defences = {
    celestia: useGetDefenceLevel(Defence.Celestia),
    blaster: useGetDefenceLevel(Defence.Blaster),
    beam: useGetDefenceLevel(Defence.Beam),
    astral: useGetDefenceLevel(Defence.Astral),
    plasma: useGetDefenceLevel(Defence.Plasma),
  };

  return defences;
}
