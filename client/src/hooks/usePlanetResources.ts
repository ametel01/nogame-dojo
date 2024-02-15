import { useState, useEffect } from 'react';
import { useDojo } from '../dojo/useDojo';
import * as Names from '../constants/names/Names';

export type Resources = {
  steel: number;
  quartz: number;
  tritium: number;
};

export function usePlanetResources(planetId: number): Resources {
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
      const response = await graphSdk.getPlanetResource({
        planet_id: planetId,
        name: Names.Resource[resourceName as keyof typeof Names.Resource],
      });

      const edges = response.data.planetResourceModels?.edges;
      const models = edges?.[0]?.node?.entity?.models;
      if (models) {
        const planetResource = models.find(
          (model) => model?.__typename === 'PlanetResource'
        );
        if (planetResource && 'amount' in planetResource) {
          const amountHex = planetResource.amount as string;
          const amountNumber = parseInt(amountHex, 16);
          setter(amountNumber);
        }
      }
    }

    fetchResourceAmount('Steel', setSteel);
    fetchResourceAmount('Quartz', setQuartz);
    fetchResourceAmount('Tritium', setTritium);
  }, [graphSdk, planetId]);

  return { steel: steel ?? 0, quartz: quartz ?? 0, tritium: tritium ?? 0 };
}
