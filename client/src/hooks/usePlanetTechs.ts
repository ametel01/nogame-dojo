import { useState, useEffect } from 'react';
import { useDojo } from '../dojo/useDojo';
import * as Names from '../constants/names/Names';

type Techs = {
  energy: number | undefined;
  digital: number | undefined;
  beam: number | undefined;
  armour: number | undefined;
  ion: number | undefined;
  plasma: number | undefined;
  weapons: number | undefined;
  shield: number | undefined;
  spacetime: number | undefined;
  combustion: number | undefined;
  thrust: number | undefined;
  warp: number | undefined;
  exocraft: number | undefined;
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
          const amountHex = planetTech.level;
          const amountNumber = parseInt(amountHex, 16);
          setter(amountNumber);
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
    energy,
    digital,
    beam,
    armour,
    ion,
    plasma,
    weapons,
    shield,
    spacetime,
    combustion,
    thrust,
    warp,
    exocraft,
  };
}
