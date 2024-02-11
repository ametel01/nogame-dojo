/* eslint-disable no-unused-vars */
import BigNumber from 'bignumber.js';
import { type Position, type TechLevels } from '../types';
import { DefaultPosition } from '../../hooks/usePlanetPosition';

export const dataToNumber = (value: unknown[] | string | number | undefined) =>
  new BigNumber(value as unknown as number).toNumber();

export const calculEnoughResources = (
  {
    steel: requiredSteel,
    quartz: requiredQuartz,
    tritium: requiredTritium,
  }: { steel: number; quartz: number; tritium: number },
  available?: { steel: number; quartz: number; tritium: number }
) => {
  if (!available) return false;
  return (
    available.steel >= requiredSteel &&
    available.quartz >= requiredQuartz &&
    available.tritium >= requiredTritium
  );
};

export const energyRequirements = (labLevel: number | undefined) => {
  return labLevel ? labLevel >= 1 : false;
};

export const digitalRequirements = (labLevel: number | undefined) => {
  return labLevel ? labLevel >= 1 : false;
};

export const armourRequirements = (labLevel: number | undefined) => {
  return labLevel ? labLevel >= 2 : false;
};

export const weaponsRequirements = (labLevel: number | undefined) => {
  return labLevel ? labLevel >= 4 : false;
};

export const exoRequirements = (
  labLevel: number | undefined,
  techs: TechLevels | undefined
) => {
  return labLevel
    ? labLevel >= 3 && techs
      ? techs.thrust >= 3
      : false
    : false;
};

export const beamTechRequirements = (
  labLevel: number | undefined,
  techs: TechLevels | undefined
) => {
  return labLevel
    ? labLevel >= 1 && techs
      ? techs.energy >= 2
      : false
    : false;
};

export const shieldRequirements = (
  labLevel: number | undefined,
  techs: TechLevels | undefined
) => {
  return labLevel
    ? labLevel >= 6 && techs
      ? techs.energy >= 3
      : false
    : false;
};

export const combustionRequirements = (
  labLevel: number | undefined,
  techs: TechLevels | undefined
) => {
  return labLevel
    ? labLevel >= 1 && techs
      ? techs.energy >= 1
      : false
    : false;
};

export const thrustRequirements = (
  labLevel: number | undefined,
  techs: TechLevels | undefined
) => {
  return labLevel
    ? labLevel >= 2 && techs
      ? techs.energy >= 1
      : false
    : false;
};

export const ionRequirements = (
  labLevel: number | undefined,
  techs: TechLevels | undefined
) => {
  return labLevel
    ? labLevel >= 4 && techs
      ? techs.energy >= 4 && techs
        ? techs.beam >= 5
        : false
      : false
    : false;
};

export const spacetimeRequirements = (
  labLevel: number | undefined,
  techs: TechLevels | undefined
) => {
  return labLevel
    ? labLevel >= 7 && techs
      ? techs.energy >= 5 && techs.shield >= 5
      : false
    : false;
};

export const warpRequirements = (
  labLevel: number | undefined,
  techs: TechLevels | undefined
) => {
  return labLevel
    ? labLevel >= 7 && techs
      ? techs.energy >= 5 && techs
        ? techs.spacetime >= 3
        : false
      : false
    : false;
};

export const plasmaTechRequirements = (
  labLevel: number | undefined,
  techs: TechLevels | undefined
) => {
  return labLevel
    ? labLevel >= 4 && techs
      ? techs.energy >= 8 && techs
        ? techs.beam >= 10 && techs
          ? techs.ion >= 5
          : false
        : false
      : false
    : false;
};

export const carrierRequirements = (
  dockyardLevel: number | undefined,
  techs: TechLevels | undefined
) => {
  return dockyardLevel
    ? dockyardLevel >= 2 && techs
      ? techs.combustion >= 2
      : false
    : false;
};

export const celestiaRequirements = (
  dockyardLevel: number | undefined,
  techs: TechLevels | undefined
) => {
  return dockyardLevel
    ? dockyardLevel >= 1 && techs
      ? techs.combustion >= 1
      : false
    : false;
};

export const scraperRequirements = (
  dockyardLevel: number | undefined,
  techs: TechLevels | undefined
) => {
  return dockyardLevel
    ? dockyardLevel >= 4 && techs
      ? techs.combustion >= 6 && techs
        ? techs.shield >= 2
        : false
      : false
    : false;
};

export const sparrowRequirements = (
  dockyardLevel: number | undefined,
  techs: TechLevels | undefined
) => {
  return dockyardLevel
    ? dockyardLevel >= 1 && techs
      ? techs?.combustion >= 1
      : false
    : false;
};

export const frigateRequirements = (
  dockyardLevel: number | undefined,
  techs: TechLevels | undefined
) => {
  return dockyardLevel
    ? dockyardLevel >= 5 && techs
      ? techs.ion >= 2 && techs
        ? techs.thrust >= 4
        : false
      : false
    : false;
};

export const armadeRequirements = (
  dockyardLevel: number | undefined,
  techs: TechLevels | undefined
) => {
  return dockyardLevel
    ? dockyardLevel >= 7 && techs
      ? techs.warp >= 4
      : false
    : false;
};

export const blasterRequirements = (dockyardLevel: number | undefined) => {
  return dockyardLevel ? dockyardLevel >= 1 : false;
};

export const beamRequirements = (
  dockyardLevel: number | undefined,
  techs: TechLevels | undefined
) => {
  return dockyardLevel
    ? dockyardLevel >= 2 && techs
      ? techs.energy >= 2 && techs
        ? techs.beam >= 6
        : false
      : false
    : false;
};

export const astralRequirements = (
  dockyardLevel: number | undefined,
  techs: TechLevels | undefined
) => {
  return dockyardLevel
    ? dockyardLevel >= 6 && techs
      ? techs.energy >= 6 && techs
        ? techs.weapons >= 3 && techs
          ? techs.shield >= 1
          : false
        : false
      : false
    : false;
};

export const plasmaRequirements = (
  dockyardLevel: number | undefined,
  techs: TechLevels | undefined
) => {
  return dockyardLevel
    ? dockyardLevel >= 8 && techs
      ? techs.plasma >= 7
      : false
    : false;
};

export const numberWithCommas = (num: number) =>
  num > 999
    ? num.toString().replace(/\B(?=(\d{3})+(?!\d))/g, '.')
    : num.toString();

export function convertTechLevelsToNumbers(techLevels: TechLevels): {
  [K in keyof TechLevels]: number;
} {
  const converted = {} as { [K in keyof TechLevels]: number };
  for (const [key, value] of Object.entries(techLevels)) {
    converted[key as keyof TechLevels] = Number(value);
  }
  return converted;
}

export function convertPositionToNumbers(
  position?: Position
): Position | undefined {
  if (!position) {
    return DefaultPosition;
  }
  return {
    system: Number(position.system),
    orbit: Number(position.orbit),
  };
}

export function convertSecondsToTime(seconds: number): string {
  const hours = Math.floor(seconds / 3600);
  const minutes = Math.floor((seconds % 3600) / 60);
  const remainingSeconds = seconds % 60;

  // Format the time parts to have two digits
  const formattedHours = String(hours).padStart(2, '0');
  const formattedMinutes = String(minutes).padStart(2, '0');
  const formattedSeconds = String(remainingSeconds).padStart(2, '0');

  return `${formattedHours}:${formattedMinutes}:${formattedSeconds}`;
}

export const formatAccount = (account: string) => {
  if (account.startsWith('0x')) {
    // Remove zeros immediately following '0x'
    return account.replace(/^0x0*/, '0x');
  }
  return account;
};

export function getPlanetAndColonyIds(planetId: number): [number, number] {
  if (planetId > 500) {
    const planet = Math.floor(planetId / 1000);
    const colony = planetId % 1000;
    return [planet, colony];
  }
  return [planetId, 0];
}
