/* eslint-disable no-unused-vars */
import BigNumber from 'bignumber.js';
import { Position } from '../../hooks/usePlanetPosition';
import { Resources } from '../../hooks/usePlanetResources';
import { Techs } from '../../hooks/usePlanetTechs';
import { Fleet } from '../../hooks/usePlanetShips';
import { BigNumberish } from 'starknet';

export const dataToNumber = (value: unknown[] | string | number | undefined) =>
  new BigNumber(value as unknown as number).toNumber();

export const calculEnoughResources = (
  {
    steel: requiredSteel,
    quartz: requiredQuartz,
    tritium: requiredTritium,
  }: { steel: number; quartz: number; tritium: number },
  available?: Resources
): boolean => {
  if (!available) return false;
  return (
    (available.steel || 0) >= requiredSteel &&
    (available.quartz || 0) >= requiredQuartz &&
    (available.tritium || 0) >= requiredTritium
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
  techs: Techs | undefined
): boolean => {
  return labLevel !== undefined && techs !== undefined
    ? labLevel >= 3 && (techs.thrust || 0) >= 3
    : false;
};

export const beamTechRequirements = (
  labLevel: number | undefined,
  techs: Techs | undefined
): boolean => {
  return labLevel !== undefined && techs !== undefined
    ? labLevel >= 1 && (techs.energy || 0) >= 2
    : false;
};

export const shieldRequirements = (
  labLevel: number | undefined,
  techs: Techs | undefined
): boolean => {
  return labLevel !== undefined && techs !== undefined
    ? labLevel >= 6 && (techs.energy || 0) >= 3
    : false;
};

export const combustionRequirements = (
  labLevel: number | undefined,
  techs: Techs | undefined
): boolean => {
  return labLevel !== undefined && techs !== undefined
    ? labLevel >= 1 && (techs.energy || 0) >= 1
    : false;
};

export const thrustRequirements = (
  labLevel: number | undefined,
  techs: Techs | undefined
): boolean => {
  return labLevel !== undefined && techs !== undefined
    ? labLevel >= 2 && (techs.energy || 0) >= 1
    : false;
};

export const ionRequirements = (
  labLevel: number | undefined,
  techs: Techs | undefined
): boolean => {
  return labLevel !== undefined && techs !== undefined
    ? labLevel >= 4 && (techs.energy || 0) >= 4 && (techs.beam || 0) >= 5
    : false;
};

export const spacetimeRequirements = (
  labLevel: number | undefined,
  techs: Techs | undefined
): boolean => {
  return labLevel !== undefined && techs !== undefined
    ? labLevel >= 7 && (techs.energy || 0) >= 5 && (techs.shield || 0) >= 5
    : false;
};

export const warpRequirements = (
  labLevel: number | undefined,
  techs: Techs | undefined
): boolean => {
  return labLevel !== undefined && techs !== undefined
    ? labLevel >= 7 && (techs.energy || 0) >= 5 && (techs.spacetime || 0) >= 3
    : false;
};

export const plasmaTechRequirements = (
  labLevel: number | undefined,
  techs: Techs | undefined
): boolean => {
  return labLevel !== undefined && techs !== undefined
    ? labLevel >= 4 &&
        (techs.energy || 0) >= 8 &&
        (techs.beam || 0) >= 10 &&
        (techs.ion || 0) >= 5
    : false;
};

export const carrierRequirements = (
  dockyardLevel: number | undefined,
  techs: Techs | undefined
): boolean => {
  return dockyardLevel !== undefined && techs !== undefined
    ? dockyardLevel >= 2 && (techs.combustion || 0) >= 2
    : false;
};

export const celestiaRequirements = (
  dockyardLevel: number | undefined,
  techs: Techs | undefined
): boolean => {
  return dockyardLevel !== undefined && techs !== undefined
    ? dockyardLevel >= 1 && (techs.combustion || 0) >= 1
    : false;
};

export const scraperRequirements = (
  dockyardLevel: number | undefined,
  techs: Techs | undefined
): boolean => {
  return dockyardLevel !== undefined && techs !== undefined
    ? dockyardLevel >= 4 &&
        (techs.combustion || 0) >= 6 &&
        (techs.shield || 0) >= 2
    : false;
};

export const sparrowRequirements = (
  dockyardLevel: number | undefined,
  techs: Techs | undefined
): boolean => {
  return dockyardLevel !== undefined && techs !== undefined
    ? dockyardLevel >= 1 && (techs.combustion || 0) >= 1
    : false;
};

export const frigateRequirements = (
  dockyardLevel: number | undefined,
  techs: Techs | undefined
): boolean => {
  return dockyardLevel !== undefined && techs !== undefined
    ? dockyardLevel >= 5 && (techs.ion || 0) >= 2 && (techs.thrust || 0) >= 4
    : false;
};

export const armadeRequirements = (
  dockyardLevel: number | undefined,
  techs: Techs | undefined
): boolean => {
  return dockyardLevel !== undefined && techs !== undefined
    ? dockyardLevel >= 7 && (techs.warp || 0) >= 4
    : false;
};

export const blasterRequirements = (
  dockyardLevel: number | undefined
): boolean => {
  return dockyardLevel ? dockyardLevel >= 1 : false;
};

export const beamRequirements = (
  dockyardLevel: number | undefined,
  techs: Techs | undefined
): boolean => {
  return dockyardLevel !== undefined && techs !== undefined
    ? dockyardLevel >= 2 && (techs.energy || 0) >= 2 && (techs.beam || 0) >= 6
    : false;
};

export const astralRequirements = (
  dockyardLevel: number | undefined,
  techs: Techs | undefined
): boolean => {
  return dockyardLevel !== undefined && techs !== undefined
    ? dockyardLevel >= 6 &&
        (techs.energy || 0) >= 6 &&
        (techs.weapons || 0) >= 3 &&
        (techs.shield || 0) >= 1
    : false;
};

export const plasmaRequirements = (
  dockyardLevel: number | undefined,
  techs: Techs | undefined
): boolean => {
  return dockyardLevel !== undefined && techs !== undefined
    ? dockyardLevel >= 8 && (techs.plasma || 0) >= 7
    : false;
};

export const numberWithCommas = (num: number | undefined): string => {
  if (num === undefined) return '';

  return num > 999
    ? num.toString().replace(/\B(?=(\d{3})+(?!\d))/g, '.')
    : num.toString();
};

export function convertTechsToNumbers(Techs: Techs): {
  [K in keyof Techs]: number;
} {
  const converted = {} as { [K in keyof Techs]: number };
  for (const [key, value] of Object.entries(Techs)) {
    converted[key as keyof Techs] = Number(value);
  }
  return converted;
}

const DefaultPosition = { system: 0, orbit: 0 };

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

export const fleetToBigNumberishArray = (fleet: Fleet): BigNumberish[] => {
  return [
    fleet.carrier,
    fleet.scraper,
    fleet.sparrow,
    fleet.frigate,
    fleet.armade,
  ];
};
