import { useState, useEffect } from 'react';
import { useDojo } from '../dojo/useDojo';
import * as Names from '../constants/names/Names';

export type Fleet = {
  carrier: number;
  scraper: number;
  sparrow: number;
  frigate: number;
  armade: number;
};

export function usePlanetShips(planetId: number): Fleet {
  const [carrier, setCarrier] = useState<number | undefined>();
  const [scraper, setScraper] = useState<number | undefined>();
  const [sparrow, setSparrow] = useState<number | undefined>();
  const [frigate, setFrigate] = useState<number | undefined>();
  const [armade, setArmade] = useState<number | undefined>();

  const {
    setup: { graphSdk },
  } = useDojo();

  useEffect(() => {
    async function fetchShipLevels(
      shipName: string,
      setter: React.Dispatch<React.SetStateAction<number | undefined>>
    ) {
      const response = await graphSdk.getPlanetShip({
        planet_id: planetId,
        name: Names.Fleet[shipName as keyof typeof Names.Fleet],
      });

      const edges = response.data.planetShipsModels?.edges;
      const models = edges?.[0]?.node?.entity?.models;
      if (models) {
        const planetShip = models.find(
          (model) => model?.__typename === 'PlanetShips'
        );
        if (planetShip && 'count' in planetShip) {
          setter(planetShip.count as number);
        }
      }
    }

    fetchShipLevels('Carrier', setCarrier);
    fetchShipLevels('Scraper', setScraper);
    fetchShipLevels('Sparrow', setSparrow);
    fetchShipLevels('Frigate', setFrigate);
    fetchShipLevels('Armade', setArmade);
  }, [graphSdk, planetId]);

  return {
    carrier: carrier ?? 0,
    scraper: scraper ?? 0,
    sparrow: sparrow ?? 0,
    frigate: frigate ?? 0,
    armade: armade ?? 0,
  };
}
