import React, { useState } from 'react';
import { BigNumberish } from 'starknet';

import steelImg from '../assets/gameElements/compounds/steel4.webp';
import quartzImg from '../assets/gameElements/compounds/quartz4.webp';
import tritiumImg from '../assets/gameElements/compounds/tritium4.webp';
import energyImg from '../assets/gameElements/compounds/energy4.webp';
import labImg from '../assets/gameElements/compounds/lab4.webp';
import dockyardImg from '../assets/gameElements/compounds/dockyard4.webp';
import armourImg from '../assets/gameElements/techs/armour4.webp';
import beamImg from '../assets/gameElements/techs/beam4.webp';
import ionImg from '../assets/gameElements/techs/ion4.webp';
import plasmaImg from '../assets/gameElements/techs/plasma_not_available.webp';
import spacetimeImg from '../assets/gameElements/techs/spacetime_not_available.webp';
import warpEnginImg from '../assets/gameElements/techs/warp_not_available.webp';
import combustionImg from '../assets/gameElements/techs/combustion4.webp';
import thrustImg from '../assets/gameElements/techs/thrust4.webp';
import weaponsImg from '../assets/gameElements/techs/weapons4.webp';
import digitalImg from '../assets/gameElements/techs/digital4.webp';
import shieldImg from '../assets/gameElements/techs/shield4.webp';
import energyTechImg from '../assets/gameElements/techs/energy4.webp';
import exoImg from '../assets/gameElements/techs/exocraft.webp';
import armadeImg from '../assets/gameElements/ships/armade_not_available.webp';
import frigateImg from '../assets/gameElements/ships/frigate4.webp';
import carrierImg from '../assets/gameElements/ships/carrier4.webp';
import sparrowImg from '../assets/gameElements/ships/sparrow4.webp';
import scraperImg from '../assets/gameElements/ships/scraper4.webp';
import celestiaImg from '../assets/gameElements/ships/celestia4.webp';
import blasterImg from '../assets/gameElements/defences/blaster4.webp';
import beamCannonImg from '../assets/gameElements/defences/beam4.webp';
import astralLauncherImg from '../assets/gameElements/defences/astral_not_availa.webp';
import plasmaCannonImg from '../assets/gameElements/defences/plasma_not_available.webp';

// Re-exporting named exports directly
export { StyledTabPanel } from './styleds';

export {
  type TechEntities,
  type EnergyCost,
  UpgradeType,
  type ShipsCost,
  type DefenceCost,
  type PlanetDetails,
} from '../shared/types';

export { DefenceBuildType, ShipBuildType, TechUpgradeType } from '../types';

export {
  armourRequirements,
  beamTechRequirements,
  combustionRequirements,
  digitalRequirements,
  energyRequirements,
  ionRequirements,
  plasmaTechRequirements,
  shieldRequirements,
  spacetimeRequirements,
  thrustRequirements,
  warpRequirements,
  weaponsRequirements,
  calculEnoughResources,
  carrierRequirements,
  celestiaRequirements,
  scraperRequirements,
  sparrowRequirements,
  frigateRequirements,
  armadeRequirements,
  blasterRequirements,
  beamRequirements,
  astralRequirements,
  plasmaRequirements,
  exoRequirements,
} from '../shared/utils';

export {
  ArmourDescription,
  BeamDescription,
  CombustionDescription,
  ComputerDescription,
  EnergyDescription,
  IonDescription,
  PlasmaDescription,
  ShieldDescription,
  SpacetimeDescription,
  ThrustDescription,
  WarpDescription,
  WeaponsDescription,
  ExoDescription,
} from '../components/descriptions/LabPopover';

export {
  EnergyPlantDescription,
  QuartzMineDescription,
  SteelMineDescription,
  TritiumMineDescription,
  LabDescription,
  DockyardDescription,
} from '../components/descriptions/CompoundsPopover';

export {
  CarrierDescription,
  CelestiaDescription,
  ScraperDescription,
  SparrowDescription,
  FrigateDescription,
  ArmadeDescription,
} from '../components/descriptions/DockyardPopover';

export {
  BlasterDescription,
  BeamDescription as BeamCannonDescription,
  AstralDescription,
  PlasmaDescription as PlasmaCannotDescription,
} from '../components/descriptions/DefencesPopover';

import {
  TechEntities,
  EnergyCost,
  ShipsCost,
  DefenceCost,
  PlanetDetails,
} from '../shared/types';

import { Compounds } from '../hooks/usePlanetCompounds';
export type { Compounds } from '../hooks/usePlanetCompounds';

import { Resources } from '../hooks/useColonyResources';
export type { Resources } from '../hooks/useColonyResources';

import { Techs } from '../hooks/usePlanetTechs';
export type { Techs } from '../hooks/usePlanetTechs';

import { Defences } from '../hooks/usePlanetDefences';
export type { Defences } from '../hooks/usePlanetDefences';

import { Fleet } from '../hooks/usePlanetShips';
export type { Fleet } from '../hooks/usePlanetShips';

export interface CompoundConfigType {
  description: React.ReactNode;
  img: string;
  title: string;
  functionCallName: BigNumberish;
  compoundName: keyof Compounds;
  energyKey: keyof EnergyCost;
}

export interface CompoundProps {
  colonyId: number;
  resources: Resources;
  compounds: Compounds;
}

export interface ResearchConfigType {
  description: React.ReactNode;
  img: string;
  title: string;
  functionCallName: BigNumberish;
  techName: TechEntities; // <-- make sure of this type
  requirements: boolean;
}

export interface LabProps {
  resources: Resources;
  techLevels: Techs;
  labLevel: number;
}

export interface ShipConfigType {
  description: React.ReactNode;
  img: string;
  title: string;
  functionCallName: BigNumberish;
  shipName: keyof Fleet | 'celestia';
  requirements: boolean;
}

export interface DockyardProps {
  resources: Resources;
  ships: Fleet;
  shipsCost: ShipsCost;
  dockyard: number;
  techs: Techs;
  celestia: number;
  colonyId: number;
}

export interface DefenceProps {
  resources: Resources;
  defences: Defences;
  defenceCost: DefenceCost;
  dockyard: number;
  techs: Techs;
  colonyId: number;
}

export interface UniverseProps {
  ownPlanetId: number;
  planet: PlanetDetails;
  ownTechs?: Techs;
  colonyId: number;
}

import Pagination from '@mui/material/Pagination';
import Stack from '@mui/material/Stack';
import UniverseViewBox from '../boxes/UniverseViewBox';
import fetchPlanetsData from '../api/fetchPlanetsData';

export { getPlanetImage, type ImageId } from '../shared/utils/getPlanetImage';
export { useGetPlanetRanking } from '../components/leaderboards/utils';
// export { useCalculateWinsAndLosses } from '../reports/utils';
export { RowCentered } from '../components/ui/Row';
export {
  ResourceTab,
  ResourcesTabs,
  ResourcesTabList,
} from '../shared/styled/Tabs';
export { ResearchTabPanel } from './ResearchTab';
export { DockyardTabPanel } from './DockyardTab';
export { DefenceTabPanel } from './DefencesTab';
export { CompoundsTabPanel } from './CompoundsTab';
export { UniverseViewTabPanel } from './UniverseViewTab';

import CircularProgress from '@mui/material/CircularProgress';
import {
  PrecisionManufacturing,
  Biotech,
  Rocket,
  Security,
  Explore,
} from '@mui/icons-material';

import { Typography } from '@mui/material';
import DefencesBox from '../boxes/DefencesBox';
export { getBaseShipsCost, getBaseDefenceCost } from '../constants/costs';

export {
  React,
  useState,
  PrecisionManufacturing,
  Biotech,
  Rocket,
  Security,
  Explore,
  Typography,
  CircularProgress,
  Pagination,
  Stack,
  UniverseViewBox,
  fetchPlanetsData,
  steelImg,
  quartzImg,
  tritiumImg,
  energyImg,
  labImg,
  dockyardImg,
  armourImg,
  beamImg,
  ionImg,
  plasmaImg,
  spacetimeImg,
  warpEnginImg,
  combustionImg,
  thrustImg,
  weaponsImg,
  digitalImg,
  shieldImg,
  energyTechImg,
  exoImg,
  armadeImg,
  frigateImg,
  carrierImg,
  sparrowImg,
  scraperImg,
  celestiaImg,
  blasterImg,
  beamCannonImg,
  astralLauncherImg,
  plasmaCannonImg,
  DefencesBox,
};

export interface ResourcesSectionArgs {
  planetId: number;
  colonyId: number;
}
