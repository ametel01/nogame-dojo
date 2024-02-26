import { useDojo } from '../dojo/useDojo';
import { getEntityIdFromKeys } from '@dojoengine/utils';
import { Fleet } from '../constants/names/Names';
import { Entity } from '@dojoengine/recs';
import { useComponentValue } from '@dojoengine/react';

export type Fleet = {
  carrier: number;
  scraper: number;
  sparrow: number;
  frigate: number;
  armade: number;
};

export function usePlanetShips(planetId: number): Fleet {
  const {
    setup: {
      clientComponents: { PlanetShip },
    },
  } = useDojo();

  // Reusable function to get ship level
  const useGetShipLevel = (shipType: number): number => {
    const entityId = getEntityIdFromKeys([
      BigInt(planetId),
      BigInt(shipType),
    ]) as Entity;
    return useComponentValue(PlanetShip, entityId)?.count ?? 0;
  };

  // Use the reusable function for each ship
  const ships: Fleet = {
    carrier: useGetShipLevel(Fleet.Carrier),
    scraper: useGetShipLevel(Fleet.Scraper),
    sparrow: useGetShipLevel(Fleet.Sparrow),
    frigate: useGetShipLevel(Fleet.Frigate),
    armade: useGetShipLevel(Fleet.Armade),
  };

  return ships;
}
