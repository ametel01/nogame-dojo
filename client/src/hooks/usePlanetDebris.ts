import { useDojo } from '../dojo/useDojo';
import { getEntityIdFromKeys } from '@dojoengine/utils';
import { Entity } from '@dojoengine/recs';
import { useComponentValue } from '@dojoengine/react';

export type Debris = {
  steel: number;
  quartz: number;
};

export function usePlanetDebris(planetId: number): Debris {
  const {
    setup: {
      clientComponents: { PlanetDebrisField },
    },
  } = useDojo();

  // Reusable function to get debris level
  const entityId = getEntityIdFromKeys([BigInt(planetId)]) as Entity;

  const debrisField = useComponentValue(PlanetDebrisField, entityId)?.debris;

  return {
    steel: Number(debrisField?.steel) ?? 0,
    quartz: Number(debrisField?.quartz) ?? 0,
  };
}
