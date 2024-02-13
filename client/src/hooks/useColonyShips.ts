import { useState, useEffect } from 'react';
import { useDojo } from '../dojo/useDojo';
import * as Names from '../constants/names/Names';
import { Fleet } from './usePlanetShips';

export function useColonyShips(planetId: number, colonyId: number): Fleet {
  const [carrier, setCarrier] = useState<number | undefined>();
  const [scraper, setScraper] = useState<number | undefined>();
  const [sparrow, setSparrow] = useState<number | undefined>();
  const [frigate, setFrigate] = useState<number | undefined>();
  const [armade, setArmade] = useState<number | undefined>();

  const {
    setup: { graphSdk },
  } = useDojo();

  useEffect(() => {
    async function fetchShipLevel(
      shipName: string,
      setter: React.Dispatch<React.SetStateAction<number | undefined>>
    ) {
      const response = await graphSdk.getColonyShip({
        planet_id: planetId,
        colony_id: colonyId,
        name: Names.Fleet[shipName as keyof typeof Names.Fleet],
      });

      const edges = response.data.colonyShipsModels?.edges;
      const models = edges?.[0]?.node?.entity?.models;
      if (models) {
        const planetShip = models.find(
          (model) => model?.__typename === 'PlanetShips'
        );
        if (planetShip && 'count' in planetShip) {
          const amountHex = planetShip.count;
          const amountNumber = parseInt(amountHex, 16);
          setter(amountNumber);
        }
      }
    }

    fetchShipLevel('Carrier', setCarrier);
    fetchShipLevel('Scraper', setScraper);
    fetchShipLevel('Sparrow', setSparrow);
    fetchShipLevel('Frigate', setFrigate);
    fetchShipLevel('Armade', setArmade);
  }, [graphSdk, planetId]);

  return { carrier, scraper, sparrow, frigate, armade };
}
