import { useState, useEffect } from 'react';
import { useDojo } from '../dojo/useDojo';

export type Debris = {
  steel: number;
  quartz: number;
};

export function usePlanetDebris(planetId: number): Debris {
  const [steel, setSteel] = useState<number | undefined>();
  const [quartz, setQuartz] = useState<number | undefined>();

  const {
    setup: { graphSdk },
  } = useDojo();

  useEffect(() => {
    async function fetchDebrisAmount(
      setter: React.Dispatch<React.SetStateAction<number | undefined>>
    ) {
      const response = await graphSdk.getPlanetDebris({
        planet_id: planetId,
      });

      const edges = response.data.planetDebrisFieldModels?.edges;
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

    fetchDebrisAmount(setSteel);
    fetchDebrisAmount(setQuartz);
  }, [graphSdk, planetId]);

  return { steel: steel ?? 0, quartz: quartz ?? 0 };
}
