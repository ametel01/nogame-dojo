import { useDojo } from '../dojo/useDojo';
import { getEntityIdFromKeys } from '@dojoengine/utils';
import { Tech } from '../constants/names/Names';
import { Entity } from '@dojoengine/recs';
import { useComponentValue } from '@dojoengine/react';

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
  const {
    setup: {
      clientComponents: { PlanetTech },
    },
  } = useDojo();

  // Reusable function to get compound level
  const useGetTechLevel = (techType: number): number => {
    const entityId = getEntityIdFromKeys([
      BigInt(planetId),
      BigInt(techType),
    ]) as Entity;
    return useComponentValue(PlanetTech, entityId)?.level ?? 0;
  };

  // Use the reusable function for each compound
  const techs: Techs = {
    energy: useGetTechLevel(Tech.Energy),
    digital: useGetTechLevel(Tech.Digital),
    beam: useGetTechLevel(Tech.Beam),
    armour: useGetTechLevel(Tech.Armour),
    ion: useGetTechLevel(Tech.Ion),
    plasma: useGetTechLevel(Tech.Plasma),
    weapons: useGetTechLevel(Tech.Weapons),
    shield: useGetTechLevel(Tech.Shield),
    spacetime: useGetTechLevel(Tech.Spacetime),
    combustion: useGetTechLevel(Tech.Combustion),
    thrust: useGetTechLevel(Tech.Thrust),
    warp: useGetTechLevel(Tech.Warp),
    exocraft: useGetTechLevel(Tech.Exocraft),
  };

  return techs;
}
