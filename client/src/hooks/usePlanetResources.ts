import { useDojo } from '../dojo/useDojo';
import { getEntityIdFromKeys } from '@dojoengine/utils';
import { Resource } from '../constants/names/Names';
import { Entity } from '@dojoengine/recs';
import { useComponentValue } from '@dojoengine/react';
import { useEffect, useState } from 'react';
import { Resources } from '../dojo/generated/typescript/models.gen';

export function usePlanetResources(planetId: number): Resources {
  const {
    setup: {
      clientComponents: { PlanetResource },
      systemCalls: { getPlanetUncollectedResources },
    },
  } = useDojo();

  const [planetUncollectedResources, setPlanetUncollectedResources] =
    useState<Resources | null>(null);

  useEffect(() => {
    getPlanetUncollectedResources(planetId)
      .then((resources) => {
        setPlanetUncollectedResources(resources);
      })
      .catch((error) => {
        console.error('Error fetching planet resources:', error);
      });
  }, [planetId, getPlanetUncollectedResources]);

  // Reusable function to get resource level
  const useGetResourceLevel = (resourceType: number): bigint => {
    const entityId = getEntityIdFromKeys([
      BigInt(planetId),
      BigInt(resourceType),
    ]) as Entity;
    return useComponentValue(PlanetResource, entityId)?.amount ?? BigInt(0);
  };

  // Use the reusable function for each resource
  const resources: Resources = {
    steel:
      BigInt(planetUncollectedResources?.steel || 0) +
      useGetResourceLevel(Resource.Steel),
    quartz:
      BigInt(planetUncollectedResources?.quartz || 0) +
      useGetResourceLevel(Resource.Quartz),
    tritium:
      BigInt(planetUncollectedResources?.tritium || 0) +
      useGetResourceLevel(Resource.Tritium),
  };

  return resources;
}
