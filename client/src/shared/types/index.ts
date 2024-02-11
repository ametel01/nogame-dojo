import { CairoCustomEnum } from 'starknet';

export interface Resources {
  steel: number;
  quartz: number;
  tritium: number;
}

export type CompoundsEntities =
  | 'steel'
  | 'quartz'
  | 'tritium'
  | 'energy'
  | 'dockyard'
  | 'lab';
export type ShipsEntities =
  | 'carrier'
  | 'scraper'
  | 'celestia'
  | 'sparrow'
  | 'frigate'
  | 'armade';
type DefencesEntities = 'celestia' | 'blaster' | 'beam' | 'astral' | 'plasma';
type DefencesCostEntities = 'blaster' | 'beam' | 'astral' | 'plasma';
export type TechEntities =
  | 'armour'
  | 'combustion'
  | 'digital'
  | 'energy'
  | 'warp'
  | 'spacetime'
  | 'thrust'
  | 'ion'
  | 'beam'
  | 'plasma'
  | 'shield'
  | 'weapons'
  | 'exocraft';

export type EnergyEntities =
  | 'steel'
  | 'quartz'
  | 'tritium'
  | 'energy'
  | 'celestia'
  | 'null';

export type EnergyCost = { [key in EnergyEntities]: number };
export type CompoundsCostUpgrade = { [key in CompoundsEntities]: Resources };
export type CompoundsLevels = { [key in CompoundsEntities]: number };

export type ShipsCost = { [key in ShipsEntities]: Resources };
export type ShipsLevels = { [key in ShipsEntities]: number };

export type DefenceCost = { [key in DefencesCostEntities]: Resources };
export type DefenceLevels = { [key in DefencesEntities]: number };

export type TechCost = { [key in TechEntities]: Resources };
export type TechLevels = { [key in TechEntities]: number };

export interface DebrisField {
  steel: number;
  quartz: number;
}

export interface Fleet {
  carrier: number;
  scraper: number;
  sparrow: number;
  frigate: number;
  armade: number;
}

export interface Position {
  system: number;
  orbit: number;
}

export interface PlanetDetails {
  planetId: number;
  account: string;
  position: Position;
  points: number;
  lastActive: string;
}

export interface Mission {
  id: number;
  time_start: number;
  origin: number;
  destination: number;
  time_arrival: number;
  fleet: Fleet;
  category: number;
}

export interface HostileMission {
  origin: number;
  id_at_origin: number;
  time_arrival: number;
  number_of_ships: number;
  destination: number;
}

export const ColonyUpgradeType = {
  SteelMine: 0,
  QuartzMine: 1,
  TritiumMine: 2,
  EnergyPlant: 3,
  Dockyard: 4,
};

export function getColonyUpgradeType(
  name: number
): CairoCustomEnum | undefined {
  switch (name) {
    case 0:
      return new CairoCustomEnum({ SteelMine: {} });
    case 1:
      return new CairoCustomEnum({ QuartzMine: {} });
    case 2:
      return new CairoCustomEnum({ TritiumMine: {} });
    case 3:
      return new CairoCustomEnum({ EnergyPlant: {} });
    case 4:
      return new CairoCustomEnum({ Dockyard: {} });
  }
}

export const UpgradeType = {
  SteelMine: 0,
  QuartzMine: 1,
  TritiumMine: 2,
  EnergyPlant: 3,
  Lab: 4,
  Dockyard: 5,
  EnergyTech: 6,
  Digital: 7,
  BeamTech: 8,
  Armour: 9,
  Ion: 10,
  PlasmaTech: 11,
  Weapons: 12,
  Shield: 13,
  Spacetime: 14,
  Combustion: 15,
  Thrust: 16,
  Warp: 17,
  Exocraft: 18,
};

export function getUpgradeType(name: number): CairoCustomEnum | undefined {
  switch (name) {
    case 0:
      return new CairoCustomEnum({ SteelMine: {} });
    case 1:
      return new CairoCustomEnum({ QuartzMine: {} });
    case 2:
      return new CairoCustomEnum({ TritiumMine: {} });
    case 3:
      return new CairoCustomEnum({ EnergyPlant: {} });
    case 4:
      return new CairoCustomEnum({ Lab: {} });
    case 5:
      return new CairoCustomEnum({ Dockyard: {} });
    case 6:
      return new CairoCustomEnum({ EnergyTech: {} });
    case 7:
      return new CairoCustomEnum({ Digital: {} });
    case 8:
      return new CairoCustomEnum({ BeamTech: {} });
    case 9:
      return new CairoCustomEnum({ Armour: {} });
    case 10:
      return new CairoCustomEnum({ Ion: {} });
    case 11:
      return new CairoCustomEnum({ PlasmaTech: {} });
    case 12:
      return new CairoCustomEnum({ Weapons: {} });
    case 13:
      return new CairoCustomEnum({ Shield: {} });
    case 14:
      return new CairoCustomEnum({ Spacetime: {} });
    case 15:
      return new CairoCustomEnum({ Combustion: {} });
    case 16:
      return new CairoCustomEnum({ Thrust: {} });
    case 17:
      return new CairoCustomEnum({ Warp: {} });
    case 18:
      return new CairoCustomEnum({ Exocraft: {} });
  }
}

export const ColonyBuildType = {
  Carrier: 0,
  Scraper: 1,
  Sparrow: 2,
  Frigate: 3,
  Armade: 4,
  Celestia: 5,
  Blaster: 6,
  Beam: 7,
  Astral: 8,
  Plasma: 9,
};

export function getColonyBuildType(name: number): CairoCustomEnum | undefined {
  switch (name) {
    case 0:
      return new CairoCustomEnum({ Carrier: {} });
    case 1:
      return new CairoCustomEnum({ Scraper: {} });
    case 2:
      return new CairoCustomEnum({ Sparrow: {} });
    case 3:
      return new CairoCustomEnum({ Frigate: {} });
    case 4:
      return new CairoCustomEnum({ Armade: {} });
    case 5:
      return new CairoCustomEnum({ Celestia: {} });
    case 6:
      return new CairoCustomEnum({ Blaster: {} });
    case 7:
      return new CairoCustomEnum({ Beam: {} });
    case 8:
      return new CairoCustomEnum({ Astral: {} });
    case 9:
      return new CairoCustomEnum({ Plasma: {} });
  }
}

export const BuildType = {
  Carrier: 0,
  Scraper: 1,
  Celestia: 2,
  Sparrow: 3,
  Frigate: 4,
  Armade: 5,
  Blaster: 6,
  Beam: 7,
  Astral: 8,
  Plasma: 9,
};

export function getBuildType(name: number): CairoCustomEnum | undefined {
  switch (name) {
    case 0:
      return new CairoCustomEnum({ Carrier: {} });
    case 1:
      return new CairoCustomEnum({ Scraper: {} });
    case 2:
      return new CairoCustomEnum({ Celestia: {} });
    case 3:
      return new CairoCustomEnum({ Sparrow: {} });
    case 4:
      return new CairoCustomEnum({ Frigate: {} });
    case 5:
      return new CairoCustomEnum({ Armade: {} });
    case 6:
      return new CairoCustomEnum({ Blaster: {} });
    case 7:
      return new CairoCustomEnum({ Beam: {} });
    case 8:
      return new CairoCustomEnum({ Astral: {} });
    case 9:
      return new CairoCustomEnum({ Plasma: {} });
  }
}

export const callTypeOptions = {
  compound: [
    { value: 0, label: 'Steel Mine' },
    { value: 1, label: 'Quartz Mine' },
    { value: 2, label: 'Tritium Mine' },
    { value: 3, label: 'Energy Plant' },
    { value: 4, label: 'Research Lab' },
    { value: 5, label: 'Dockyard' },
  ],
  tech: [
    { value: 6, label: 'Energy Tech' },
    { value: 7, label: 'Digital Systems' },
    { value: 8, label: 'Beam Tech' },
    { value: 9, label: 'Armor Tech' },
    { value: 10, label: 'Ion Tech' },
    { value: 11, label: 'Plasma Tech' },
    { value: 12, label: 'Weapons Tech' },
    { value: 13, label: 'Shield Tech' },
    { value: 14, label: 'Spacetime Tech' },
    { value: 15, label: 'Combustion Engine' },
    { value: 16, label: 'Thrust Propulsion' },
    { value: 17, label: 'Warp Drive' },
  ],
  ship: [
    { value: 0, label: 'Carrier' },
    { value: 1, label: 'Scraper' },
    { value: 2, label: 'Celestia' },
    { value: 3, label: 'Sparrow' },
    { value: 4, label: 'Frigate' },
    { value: 5, label: 'Armade' },
  ],
  defence: [
    { value: 6, label: 'Blaster' },
    { value: 7, label: 'Beam' },
    { value: 8, label: 'Astral Launcher' },
    { value: 9, label: 'Plasma Projector' },
  ],
};

type UpgradeTypeKeys = keyof typeof UpgradeType;
type BuildTypeKeys = keyof typeof BuildType;

export function getUpgradeNameById(id: number, isBuild: boolean) {
  if (isBuild == false) {
    const reversedMapping = (
      Object.keys(UpgradeType) as UpgradeTypeKeys[]
    ).find((key) => UpgradeType[key] === id);
    return reversedMapping;
  }
  const reversedMapping = (Object.keys(BuildType) as BuildTypeKeys[]).find(
    (key) => BuildType[key] === id
  );
  return reversedMapping;
}

export type SimulationResult = {
  attacker_carrier: number;
  attacker_scraper: number;
  attacker_sparrow: number;
  attacker_frigate: number;
  attacker_armade: number;
  defender_carrier: number;
  defender_scraper: number;
  defender_sparrow: number;
  defender_frigate: number;
  defender_armade: number;
  celestia: number;
  blaster: number;
  beam: number;
  astral: number;
  plasma: number;
};

export const MissionCategory = {
  Attack: 1,
  Transport: 2,
  Debris: 3,
};
