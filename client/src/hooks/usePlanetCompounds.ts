import { useState, useEffect } from 'react';
import { useDojo } from '../dojo/useDojo';
import * as Names from '../constants/names/Names';

export type Compounds = {
  steel: number | undefined;
  quartz: number | undefined;
  tritium: number | undefined;
  energy: number | undefined;
  lab: number | undefined;
  dockyard: number | undefined;
};

export function usePlanetCompounds(planetId: number): Compounds {
  const [steel, setSteel] = useState<number | undefined>();
  const [quartz, setQuartz] = useState<number | undefined>();
  const [tritium, setTritium] = useState<number | undefined>();
  const [energy, setEnergy] = useState<number | undefined>();
  const [lab, setLab] = useState<number | undefined>();
  const [dockyard, setDockyard] = useState<number | undefined>();

  const {
    setup: { graphSdk },
  } = useDojo();

  useEffect(() => {
    async function fetchCompoundLevels(
      compoundName: string,
      setter: React.Dispatch<React.SetStateAction<number | undefined>>
    ) {
      const response = await graphSdk.getPlanetCompound({
        planet_id: planetId,
        name: Names.Compound[compoundName as keyof typeof Names.Compound],
      });

      const edges = response.data.planetCompoundsModels?.edges;
      const models = edges?.[0]?.node?.entity?.models;
      if (models) {
        const planetCompound = models.find(
          (model) => model?.__typename === 'PlanetCompounds'
        );
        if (planetCompound && 'level' in planetCompound) {
          const amountHex = planetCompound.level;
          const amountNumber = parseInt(amountHex, 16);
          setter(amountNumber);
        }
      }
    }

    fetchCompoundLevels('Steel', setSteel);
    fetchCompoundLevels('Quartz', setQuartz);
    fetchCompoundLevels('Tritium', setTritium);
    fetchCompoundLevels('Energy', setEnergy);
    fetchCompoundLevels('Lab', setLab);
    fetchCompoundLevels('Dockyard', setDockyard);
  }, [graphSdk, planetId]);

  return { steel, quartz, tritium, energy, lab, dockyard };
}
