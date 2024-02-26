import { useDojo } from '../dojo/useDojo';
import { getEntityIdFromKeys } from '@dojoengine/utils';
import { Fleet as FleetNames } from '../constants/names/Names';
import { Entity } from '@dojoengine/recs';
import { useComponentValue } from '@dojoengine/react';
import { Fleet } from './usePlanetShips';

export function useColonyShips(planetId: number, colonyId: number): Fleet {
  const {
    setup: {
      clientComponents: { ColonyShips },
    },
  } = useDojo();

  // Reusable function to get ship level
  const useGetShipLevel = (shipType: number): number => {
    const entityId = getEntityIdFromKeys([
      BigInt(planetId),
      BigInt(colonyId),
      BigInt(shipType),
    ]) as Entity;
    return useComponentValue(ColonyShips, entityId)?.count ?? 0;
  };

  const ships: Fleet = {
    carrier: useGetShipLevel(FleetNames.Carrier),
    scraper: useGetShipLevel(FleetNames.Scraper),
    sparrow: useGetShipLevel(FleetNames.Sparrow),
    frigate: useGetShipLevel(FleetNames.Frigate),
    armade: useGetShipLevel(FleetNames.Armade),
  };
  return ships;
}
