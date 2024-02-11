import { type Fleet, type Position, type TechLevels } from '../types';
import { ShipsStats, DefencesStats } from '../../constants/Stats';

export function getDistance(start: Position, end: Position): number {
  const orbitDistance = Math.abs(start.orbit - end.orbit);
  const systemDistance = Math.abs(start.system - end.system);

  if (start.system === end.system) {
    // Same system
    if (start.orbit === end.orbit) {
      // Same orbit
      return 5;
    } else {
      // Different orbit
      return 1000 + 5 * orbitDistance;
    }
  } else {
    // Different system
    // Assuming the distance calculation for different systems needs to factor in other parameters
    // For now, using orbitDistance as a placeholder
    return 2700 + 95 * systemDistance;
  }
}

function getUnitConsumption(
  ship: Unit,
  distance: number,
  speed: number
): number {
  const consumption =
    1 +
    Math.ceil(
      ((ship.consumption * distance) / 35000) * Math.pow(speed / 100 + 1, 2)
    );
  return consumption;
}

export function getFuelConsumption(
  fleet: Fleet,
  distance: number,
  speedFactor: number
): number {
  return Math.ceil(
    fleet.carrier * getUnitConsumption(CARRIER, distance, speedFactor) +
      fleet.scraper * getUnitConsumption(SCRAPER, distance, speedFactor) +
      fleet.sparrow * getUnitConsumption(SPARROW, distance, speedFactor) +
      fleet.frigate * getUnitConsumption(FRIGATE, distance, speedFactor) +
      fleet.armade * getUnitConsumption(ARMADE, distance, speedFactor)
  );
}

export function getFlightTime(
  speed: number,
  distance: number,
  speedFactor: number
): number {
  const result = 10 + 3500 * Math.sqrt((10 * distance) / speed);
  return Math.floor(result / speedFactor); // Assuming we need an integer result
}

export function getFleetSpeed(fleet: Fleet, techs: TechLevels) {
  let minSpeed = Number.MAX_SAFE_INTEGER;

  const calculateSpeed = (
    baseSpeed: number,
    techLevel: number,
    multiplier: number
  ) => {
    return baseSpeed + (baseSpeed * techLevel * multiplier) / 10;
  };

  if (fleet.carrier > 0) {
    const baseSpeed = CARRIER.speed;
    const speed =
      techs.thrust >= 4
        ? calculateSpeed(baseSpeed * 2, Number(techs.thrust) - 4, 2)
        : calculateSpeed(baseSpeed, Number(techs.combustion), 1);
    minSpeed = Math.min(minSpeed, speed);
  }

  if (fleet.scraper > 0) {
    const speed = calculateSpeed(SCRAPER.speed, Number(techs.combustion), 1);
    minSpeed = Math.min(minSpeed, speed);
  }

  if (fleet.sparrow > 0) {
    const speed = calculateSpeed(SPARROW.speed, Number(techs.combustion), 1);
    minSpeed = Math.min(minSpeed, speed);
  }

  if (fleet.frigate > 0) {
    const baseSpeed = FRIGATE.speed;
    const speed =
      techs.thrust >= 4
        ? calculateSpeed(baseSpeed, Number(techs.thrust) - 4, 2)
        : calculateSpeed(baseSpeed, Number(techs.combustion), 1);
    minSpeed = Math.min(minSpeed, speed);
  }

  if (fleet.armade > 0) {
    const baseSpeed = ARMADE.speed;
    const speed = calculateSpeed(baseSpeed, Number(techs.warp) - 3, 3);
    minSpeed = Math.min(minSpeed, speed);
  }

  // Additional ship types can be added here following the same pattern

  return minSpeed;
}

export function calculateTotalCargoCapacity(fleet: Fleet) {
  let totalCargoCapacity = 0;

  if (fleet.carrier) {
    totalCargoCapacity += fleet.carrier * ShipsStats.carrier.cargo;
  }
  if (fleet.scraper) {
    totalCargoCapacity += fleet.scraper * ShipsStats.scraper.cargo;
  }
  if (fleet.sparrow) {
    totalCargoCapacity += fleet.sparrow * ShipsStats.sparrow.cargo;
  }
  if (fleet.frigate) {
    totalCargoCapacity += fleet.frigate * ShipsStats.frigate.cargo;
  }
  if (fleet.armade) {
    totalCargoCapacity += fleet.armade * ShipsStats.armade.cargo;
  }

  return totalCargoCapacity;
}

interface Unit {
  id: number;
  weapon: number;
  shield: number;
  hull: number;
  speed: number;
  cargo: number;
  consumption: number;
}

export const CARRIER: Unit = {
  id: 0,
  weapon: ShipsStats.carrier.weapon,
  shield: ShipsStats.carrier.shield,
  hull: ShipsStats.carrier.hull,
  speed: ShipsStats.carrier.speed,
  cargo: ShipsStats.carrier.cargo,
  consumption: ShipsStats.carrier.consumption,
};
export const SCRAPER: Unit = {
  id: 1,
  weapon: ShipsStats.scraper.weapon,
  shield: ShipsStats.scraper.shield,
  hull: ShipsStats.scraper.hull,
  speed: ShipsStats.scraper.speed,
  cargo: ShipsStats.scraper.cargo,
  consumption: ShipsStats.scraper.consumption,
};
export const SPARROW: Unit = {
  id: 2,
  weapon: ShipsStats.sparrow.weapon,
  shield: ShipsStats.sparrow.shield,
  hull: ShipsStats.sparrow.hull,
  speed: ShipsStats.sparrow.speed,
  cargo: ShipsStats.sparrow.cargo,
  consumption: ShipsStats.sparrow.consumption,
};
export const FRIGATE: Unit = {
  id: 3,
  weapon: ShipsStats.frigate.weapon,
  shield: ShipsStats.frigate.shield,
  hull: ShipsStats.frigate.hull,
  speed: ShipsStats.frigate.speed,
  cargo: ShipsStats.frigate.cargo,
  consumption: ShipsStats.frigate.consumption,
};
export const ARMADE: Unit = {
  id: 4,
  weapon: ShipsStats.armade.weapon,
  shield: ShipsStats.armade.shield,
  hull: ShipsStats.armade.hull,
  speed: ShipsStats.armade.speed,
  cargo: ShipsStats.armade.cargo,
  consumption: ShipsStats.armade.consumption,
};
export const CELESTIA: Unit = {
  id: 5,
  weapon: DefencesStats.celestia.weapon,
  shield: DefencesStats.celestia.shield,
  hull: DefencesStats.celestia.hull,
  speed: 0,
  cargo: 0,
  consumption: 0,
};
export const BLASTER: Unit = {
  id: 6,
  weapon: DefencesStats.blaster.weapon,
  shield: DefencesStats.blaster.shield,
  hull: DefencesStats.blaster.hull,
  speed: 0,
  cargo: 0,
  consumption: 0,
};
export const BEAM: Unit = {
  id: 7,
  weapon: DefencesStats.beam.weapon,
  shield: DefencesStats.beam.shield,
  hull: DefencesStats.beam.hull,
  speed: 0,
  cargo: 0,
  consumption: 0,
};
export const ASTRAL: Unit = {
  id: 8,
  weapon: DefencesStats.astral.weapon,
  shield: DefencesStats.astral.shield,
  hull: DefencesStats.astral.hull,
  speed: 0,
  cargo: 0,
  consumption: 0,
};
export const PLASMA: Unit = {
  id: 9,
  weapon: DefencesStats.plasma.weapon,
  shield: DefencesStats.plasma.shield,
  hull: DefencesStats.plasma.hull,
  speed: 0,
  cargo: 0,
  consumption: 0,
};
