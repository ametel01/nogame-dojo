import { useState, useEffect } from 'react';
import { useDojo } from '../dojo/useDojo';
import * as Names from '../constants/names/Names';
import { Resources } from './usePlanetResources';

export function useColonyResources(
  planetId: number,
  colonyId: number
): Resources {
  const [steel, setSteel] = useState<number | undefined>();
  const [quartz, setQuartz] = useState<number | undefined>();
  const [tritium, setTritium] = useState<number | undefined>();

  const {
    setup: { graphSdk },
  } = useDojo();

  useEffect(() => {
    async function fetchResourceAmount(
      resourceName: string,
      setter: React.Dispatch<React.SetStateAction<number | undefined>>
    ) {
      const response = await graphSdk.getColonyResource({
        planet_id: planetId,
        colony_id: colonyId,
        name: Names.Resource[resourceName as keyof typeof Names.Resource],
      });

      const edges = response.data.colonyResourceModels?.edges;
      const models = edges?.[0]?.node?.entity?.models;
      if (models) {
        const colonyResource = models.find(
          (model) => model?.__typename === 'ColonyResource'
        );
        if (colonyResource && 'amount' in colonyResource) {
          setter(colonyResource.amount as number);
        }
      }
    }

    fetchResourceAmount('Steel', setSteel);
    fetchResourceAmount('Quartz', setQuartz);
    fetchResourceAmount('Tritium', setTritium);
  }, [colonyId, graphSdk, planetId]);

  return { steel: steel ?? 0, quartz: quartz ?? 0, tritium: tritium ?? 0 };
}
