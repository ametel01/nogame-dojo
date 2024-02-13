import { useState, useEffect } from 'react';
import { useDojo } from '../dojo/useDojo';
import * as Names from '../constants/names/Names';

export type Defences = {
  celestia: number | undefined;
  blaster: number | undefined;
  beam: number | undefined;
  astral: number | undefined;
  plasma: number | undefined;
};

export function usePlanetDefences(planetId: number): Defences {
  const [celestia, setCelestia] = useState<number | undefined>();
  const [blaster, setBlaster] = useState<number | undefined>();
  const [beam, setBeam] = useState<number | undefined>();
  const [astral, setAstral] = useState<number | undefined>();
  const [plasma, setPlasma] = useState<number | undefined>();

  const {
    setup: { graphSdk },
  } = useDojo();

  useEffect(() => {
    async function fetchDefenceLevels(
      defenceName: string,
      setter: React.Dispatch<React.SetStateAction<number | undefined>>
    ) {
      const response = await graphSdk.getPlanetDefence({
        planet_id: planetId,
        name: Names.Defence[defenceName as keyof typeof Names.Defence],
      });

      const edges = response.data.planetDefencesModels?.edges;
      const models = edges?.[0]?.node?.entity?.models;
      if (models) {
        const planetDefence = models.find(
          (model) => model?.__typename === 'PlanetDefences'
        );
        if (planetDefence && 'count' in planetDefence) {
          const amountHex = planetDefence.count;
          const amountNumber = parseInt(amountHex, 16);
          setter(amountNumber);
        }
      }
    }

    fetchDefenceLevels('Celestia', setCelestia);
    fetchDefenceLevels('Blaster', setBlaster);
    fetchDefenceLevels('Beam', setBeam);
    fetchDefenceLevels('Astral', setAstral);
    fetchDefenceLevels('Plasma', setPlasma);
  }, [graphSdk, planetId]);

  return { celestia, blaster, beam, astral, plasma };
}
