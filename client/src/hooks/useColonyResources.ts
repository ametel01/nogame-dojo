import { useDojo } from '../dojo/useDojo';
import { getEntityIdFromKeys } from '@dojoengine/utils';
import { Resource } from '../constants/names/Names';
import { Entity } from '@dojoengine/recs';
import { useComponentValue } from '@dojoengine/react';
import { useEffect, useState } from 'react';
import { Resources } from './usePlanetResources';

export function useColonyResources(
  planetId: number,
  colonyId: number
): Resources {
  const {
    setup: {
      clientComponents: { ColonyResource },
      systemCalls: { getColonyUncollectedResources },
    },
  } = useDojo();

  const [colonyUncollectedResources, setColonyUncollectedResources] =
    useState<Resources | null>(null);

  useEffect(() => {
    getColonyUncollectedResources(planetId, colonyId)
      .then((resources) => {
        setColonyUncollectedResources(resources);
      })
      .catch((error) => {
        console.error('Error fetching planet resources:', error);
      });
  }, [planetId, getColonyUncollectedResources, colonyId]);

  // Reusable function to get resource level
  const useGetResourceLevel = (resourceType: number): number => {
    const entityId = getEntityIdFromKeys([
      BigInt(planetId),
      BigInt(colonyId),
      BigInt(resourceType),
    ]) as Entity;

    return Number(useComponentValue(ColonyResource, entityId)?.amount) ?? 0;
  };

  // Use the reusable function for each resource
  const resources: Resources = {
    steel:
      (colonyUncollectedResources?.steel || 0) +
      useGetResourceLevel(Resource.Steel),
    quartz:
      (colonyUncollectedResources?.quartz || 0) +
      useGetResourceLevel(Resource.Quartz),
    tritium:
      (colonyUncollectedResources?.tritium || 0) +
      useGetResourceLevel(Resource.Tritium),
  };

  return resources;
}
