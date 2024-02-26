import { useDojo } from '../dojo/useDojo';
import { getEntityIdFromKeys } from '@dojoengine/utils';
import { Resource } from '../constants/names/Names';
import { Entity } from '@dojoengine/recs';
import { useComponentValue } from '@dojoengine/react';
import { useEffect, useState } from 'react';

export type Resources = {
  steel: number;
  quartz: number;
  tritium: number;
};

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
  const useGetResourceLevel = (resourceType: number): number => {
    const entityId = getEntityIdFromKeys([
      BigInt(planetId),
      BigInt(resourceType),
    ]) as Entity;
    return Number(useComponentValue(PlanetResource, entityId)?.amount) ?? 0;
  };

  // Use the reusable function for each resource
  const resources: Resources = {
    steel:
      (planetUncollectedResources?.steel || 0) +
      useGetResourceLevel(Resource.Steel),
    quartz:
      (planetUncollectedResources?.quartz || 0) +
      useGetResourceLevel(Resource.Quartz),
    tritium:
      (planetUncollectedResources?.tritium || 0) +
      useGetResourceLevel(Resource.Tritium),
  };

  return resources;
}
