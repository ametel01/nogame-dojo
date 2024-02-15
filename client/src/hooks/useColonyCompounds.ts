import { useState, useEffect } from 'react';
import { useDojo } from '../dojo/useDojo';
import * as Names from '../constants/names/Names';

export type ColonyCompounds = {
  steel: number;
  quartz: number;
  tritium: number;
  energy: number;
  dockyard: number;
};

export function useColonyCompounds(
  planetId: number,
  colonyId: number
): ColonyCompounds {
  const [steel, setSteel] = useState<number | undefined>();
  const [quartz, setQuartz] = useState<number | undefined>();
  const [tritium, setTritium] = useState<number | undefined>();
  const [energy, setEnergy] = useState<number | undefined>();
  const [dockyard, setDockyard] = useState<number | undefined>();

  const {
    setup: { graphSdk },
  } = useDojo();

  useEffect(() => {
    async function fetchColonyCompoundLevels(
      compoundName: string,
      setter: React.Dispatch<React.SetStateAction<number | undefined>>
    ) {
      const response = await graphSdk.getColonyCompound({
        planet_id: planetId,
        colony_id: colonyId,
        name: Names.Compound[compoundName as keyof typeof Names.Compound],
      });

      const edges = response.data.colonyCompoundsModels?.edges;
      const models = edges?.[0]?.node?.entity?.models;
      if (models) {
        const colonyCompound = models.find(
          (model) => model?.__typename === 'ColonyCompounds'
        );
        if (colonyCompound && 'level' in colonyCompound) {
          setter(colonyCompound.level);
        }
      }
    }

    fetchColonyCompoundLevels('Steel', setSteel);
    fetchColonyCompoundLevels('Quartz', setQuartz);
    fetchColonyCompoundLevels('Tritium', setTritium);
    fetchColonyCompoundLevels('Energy', setEnergy);
    fetchColonyCompoundLevels('Dockyard', setDockyard);
  }, [colonyId, graphSdk, planetId]);

  return {
    steel: steel ?? 0,
    quartz: quartz ?? 0,
    tritium: tritium ?? 0,
    energy: energy ?? 0,
    dockyard: dockyard ?? 0,
  };
}
