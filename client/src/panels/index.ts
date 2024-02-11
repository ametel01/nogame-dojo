import React, { useState } from 'react';

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
  type Resources,
  type TechLevels,
  type TechEntities,
  type CompoundsLevels,
  type EnergyCost,
  UpgradeType,
  type ShipsCost,
  type ShipsLevels,
  BuildType,
  type DefenceCost,
  type DefenceLevels,
  type PlanetDetails,
} from '../shared/types';

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
  Resources,
  TechLevels,
  CompoundsLevels,
  EnergyCost,
  ShipsLevels,
  ShipsCost,
  DefenceLevels,
  DefenceCost,
  PlanetDetails,
} from '../shared/types';

export interface CompoundConfigType {
  description: React.ReactNode;
  img: string;
  title: string;
  functionCallName: number;
  compoundName: keyof CompoundsLevels;
  energyKey: keyof EnergyCost;
}

export interface CompoundProps {
  colonyId: number;
  spendableResources?: Resources;
  compoundsLevels: CompoundsLevels;
}

export interface ResearchConfigType {
  description: React.ReactNode;
  img: string;
  title: string;
  functionCallName: number;
  techName: TechEntities; // <-- make sure of this type
  requirements: boolean;
}

export interface LabProps {
  spendableResources: Resources;
  techLevels?: TechLevels;
  labLevel?: number;
}

export interface ShipConfigType {
  description: React.ReactNode;
  img: string;
  title: string;
  functionCallName: number;
  shipName: keyof ShipsLevels;
  requirements: boolean;
}

export interface DockyardProps {
  spendableResources?: Resources;
  shipsLevels?: ShipsLevels;
  shipsCost?: ShipsCost;
  dockyardLevel?: number;
  techLevels?: TechLevels;
  celestia?: number;
  colonyId: number;
}

export interface DefenceProps {
  spendableResources?: Resources;
  defenceLevels?: DefenceLevels;
  defenceCost?: DefenceCost;
  dockyardLevel?: number;
  techLevels?: TechLevels;
  colonyId: number;
}

export interface UniverseProps {
  ownPlanetId: number;
  planet: PlanetDetails;
  ownTechs?: TechLevels;
  colonyId: number;
}

import Pagination from '@mui/material/Pagination';
import Stack from '@mui/material/Stack';
import UniverseViewBox from '../components/boxes/UniverseViewBox';
import fetchPlanetsData from '../api/fetchPlanetsData';

export { useAccount } from '@starknet-react/core';
export { useShipsLevels } from '../hooks/LevelsHooks';
export { useGetIsNoobProtected, useLastActive } from '../hooks/FleetHooks';
export { getPlanetImage, type ImageId } from '../shared/utils/getPlanetImage';
export { useGetPlanetRanking } from '../components/leaderboards/utils';
export { useCalculateWinsAndLosses } from '../reports/utils';
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
export {
  useCollectibleResources,
  useSpendableResources,
} from '../hooks/ResourcesHooks';
export {
  useCompoundsLevels,
  useDefencesLevels,
  useTechLevels,
} from '../hooks/LevelsHooks';
export { UniverseViewTabPanel } from './UniverseViewTab';
export { useGetCelestiaAvailable } from '../hooks/EnergyHooks';

import CircularProgress from '@mui/material/CircularProgress';
import {
  PrecisionManufacturing,
  Biotech,
  Rocket,
  Security,
  Explore,
} from '@mui/icons-material';

import { Typography } from '@mui/material';
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
};

export interface ResourcesSectionArgs {
  planetId: number;
  colonyId: number;
}
