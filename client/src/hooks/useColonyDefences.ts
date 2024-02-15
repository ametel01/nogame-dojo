import { useState, useEffect } from 'react';
import { useDojo } from '../dojo/useDojo';
import * as Names from '../constants/names/Names';
import { Defences } from './usePlanetDefences';

export function useColonyDefences(
  planetId: number,
  colonyId: number
): Defences {
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
      const response = await graphSdk.getColonyDefence({
        planet_id: planetId,
        colony_id: colonyId,
        name: Names.Defence[defenceName as keyof typeof Names.Defence],
      });

      const edges = response.data.colonyDefencesModels?.edges;
      const models = edges?.[0]?.node?.entity?.models;
      if (models) {
        const planetDefence = models.find(
          (model) => model?.__typename === 'ColonyDefences'
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
  }, [colonyId, graphSdk, planetId]);

  return {
    celestia: celestia ?? 0,
    blaster: blaster ?? 0,
    beam: beam ?? 0,
    astral: astral ?? 0,
    plasma: plasma ?? 0,
  };
}
