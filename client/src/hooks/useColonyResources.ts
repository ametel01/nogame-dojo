import { useDojo } from '../dojo/useDojo';
import { getEntityIdFromKeys } from '@dojoengine/utils';
import { Resource } from '../constants/names/Names';
import { Entity } from '@dojoengine/recs';
import { useComponentValue } from '@dojoengine/react';
import { useEffect, useState } from 'react';
import { Resources } from '../dojo/generated/typescript/models.gen';

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
  const useGetResourceLevel = (resourceType: number): bigint => {
    // Ensure these IDs are needed as BigInt, if not, avoid conversion
    const entityId = getEntityIdFromKeys([
      BigInt(planetId), // Converted to BigInt, assuming getEntityIdFromKeys needs BigInt
      BigInt(colonyId),
      BigInt(resourceType),
    ]) as Entity;

    // Assuming useComponentValue can handle entityId as BigInt
    const resourceComponent = useComponentValue(ColonyResource, entityId);

    // Convert the BigInt amount to number before returning if needed
    return resourceComponent ? resourceComponent.amount : BigInt(0);
  };

  // Use the reusable function for each resource
  const resources: Resources = {
    steel:
      BigInt(colonyUncollectedResources?.steel || 0) +
      useGetResourceLevel(Resource.Steel),
    quartz:
      BigInt(colonyUncollectedResources?.quartz || 0) +
      useGetResourceLevel(Resource.Quartz),
    tritium:
      BigInt(colonyUncollectedResources?.tritium || 0) +
      useGetResourceLevel(Resource.Tritium),
  };

  return resources;
}
