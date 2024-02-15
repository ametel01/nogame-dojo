import { useState, useEffect } from 'react';
import { useDojo } from '../dojo/useDojo';
import * as Names from '../constants/names/Names';

export type Techs = {
  energy: number;
  digital: number;
  beam: number;
  armour: number;
  ion: number;
  plasma: number;
  weapons: number;
  shield: number;
  spacetime: number;
  combustion: number;
  thrust: number;
  warp: number;
  exocraft: number;
};

export function usePlanetTechs(planetId: number): Techs {
  const [energy, setEnergy] = useState<number | undefined>();
  const [digital, setDigital] = useState<number | undefined>();
  const [beam, setBeam] = useState<number | undefined>();
  const [armour, setArmour] = useState<number | undefined>();
  const [ion, setIon] = useState<number | undefined>();
  const [plasma, setPlasma] = useState<number | undefined>();
  const [weapons, setWeapons] = useState<number | undefined>();
  const [shield, setShield] = useState<number | undefined>();
  const [spacetime, setSpacetime] = useState<number | undefined>();
  const [combustion, setCombustion] = useState<number | undefined>();
  const [thrust, setThrust] = useState<number | undefined>();
  const [warp, setWarp] = useState<number | undefined>();
  const [exocraft, setExocraft] = useState<number | undefined>();

  const {
    setup: { graphSdk },
  } = useDojo();

  useEffect(() => {
    async function fetchTechLevel(
      techName: string,
      setter: React.Dispatch<React.SetStateAction<number | undefined>>
    ) {
      const response = await graphSdk.getPlanetTech({
        planet_id: planetId,
        name: Names.Tech[techName as keyof typeof Names.Tech],
      });

      const edges = response.data.planetTechsModels?.edges;
      const models = edges?.[0]?.node?.entity?.models;
      if (models) {
        const planetTech = models.find(
          (model) => model?.__typename === 'PlanetTechs'
        );
        if (planetTech && 'level' in planetTech) {
          setter(planetTech.level as number);
        }
      }
    }
    fetchTechLevel('Energy', setEnergy);
    fetchTechLevel('Digital', setDigital);
    fetchTechLevel('Beam', setBeam);
    fetchTechLevel('Armour', setArmour);
    fetchTechLevel('Ion', setIon);
    fetchTechLevel('Plasma', setPlasma);
    fetchTechLevel('Weapons', setWeapons);
    fetchTechLevel('Shield', setShield);
    fetchTechLevel('Spacetime', setSpacetime);
    fetchTechLevel('Combustion', setCombustion);
    fetchTechLevel('Thrust', setThrust);
    fetchTechLevel('Warp', setWarp);
    fetchTechLevel('Exocraft', setExocraft);
  }, [graphSdk, planetId]);

  return {
    energy: energy ?? 0,
    digital: digital ?? 0,
    beam: beam ?? 0,
    armour: armour ?? 0,
    ion: ion ?? 0,
    plasma: plasma ?? 0,
    weapons: weapons ?? 0,
    shield: shield ?? 0,
    spacetime: spacetime ?? 0,
    combustion: combustion ?? 0,
    thrust: thrust ?? 0,
    warp: warp ?? 0,
    exocraft: exocraft ?? 0,
  };
}
