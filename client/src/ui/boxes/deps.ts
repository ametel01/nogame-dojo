import React, { ReactNode, useMemo, useState, useEffect } from 'react';
import styled from 'styled-components';
import { Input } from '@mui/joy';
import Tooltip from '@mui/material/Tooltip';
import * as Styled from '../../shared/styled/Box';
import {
  numberWithCommas,
  calculEnoughResources,
  convertPositionToNumbers,
} from '../../shared/utils';
import DescriptionModal from '../../components/modals/Description';

import { Resources } from '../../hooks/usePlanetResources';
export type { Resources } from '../../hooks/usePlanetResources';

export type { Compounds } from '../../hooks/usePlanetCompounds';

import { Techs } from '../../hooks/usePlanetTechs';
export type { Techs } from '../../hooks/usePlanetTechs';

import { Defences } from '../../hooks/usePlanetDefences';
export type { Defences } from '../../hooks/usePlanetDefences';

import { Fleet } from '../../hooks/usePlanetShips';
export type { Fleet } from '../../hooks/usePlanetShips';

import { Position } from '../../hooks/usePlanetPosition';
export type { Position } from '../../hooks/usePlanetPosition';

import { CircularProgress } from '@mui/material';
import PlanetModal from '../../components/modals/PlanetOverview';
import DebrisFieldView from '../../components/ui/DebrisFieldView';
import ButtonAttackPlanet from '../../components/buttons/ButtonAttackPlanet';
import { BigNumberish } from 'starknet';
export { usePlanetPosition } from '../../hooks/usePlanetPosition';

export { ButtonUpgrade } from '../../components/ui/Button';
export { ButtonBuild } from '../../components/ui/Button';
export { getCumulativeTechCost } from '../../shared/utils/Formulas';
export { baseTechCost } from '../../constants/costs';
export { type ShipsLevels, type DefenceLevels } from '../../shared/types';
export {
  getCompoundCost,
  getCumulativeEnergyChange,
} from '../../shared/utils/Formulas';

export {
  React,
  type ReactNode,
  useMemo,
  useState,
  useEffect,
  DescriptionModal,
  Tooltip,
  Input,
  Styled,
  styled,
  numberWithCommas,
  calculEnoughResources,
  ButtonAttackPlanet,
  CircularProgress,
  PlanetModal,
  DebrisFieldView,
  convertPositionToNumbers,
};

export interface CompoundsBoxProps {
  img: string;
  title: string;
  level: number;
  functionCallName: BigNumberish;
  description: React.ReactNode;
  resourcesAvailable: Resources;
  colonyId: number;
}

export interface LabBoxProps {
  img: string;
  title: string;
  functionCallName: BigNumberish;
  level: number;
  requirementsMet?: boolean;
  description: ReactNode;
  techs: Techs;
  resources: Resources;
}

export interface DockyardBoxProps {
  img: string;
  title: string;
  functionCallName: BigNumberish;
  level: number;
  costUpdate: { steel: number; quartz: number; tritium: number };
  hasEnoughResources?: boolean;
  requirementsMet?: boolean;
  description: ReactNode;
  resourcesAvailable: Resources;
  colonyId: number;
  isCelestia?: boolean;
}

export interface DefenceBoxProps {
  img: string;
  title: string;
  functionCallName: BigNumberish;
  level?: number;
  costUpdate?: { steel: number; quartz: number; tritium: number };
  hasEnoughResources: boolean | number;
  requirementsMet?: boolean | number;
  description: React.ReactNode;
  resourcesAvailable: Resources;
  colonyId: number;
}

export interface UniverseBoxProps {
  planetId: number;
  img: string | undefined;
  owner?: string;
  position: Position;
  debris?: { steel: number; quartz: number };
  points: string | number;
  highlighted: boolean;
  spendable?: Resources;
  collectible?: Resources;
  fleet?: Fleet;
  defences?: Defences;
  ownPlanetId: number;
  ownFleet?: Fleet;
  ownTechs?: Techs;
  isNoobProtected?: boolean;
  lastActive: number;
  winLoss: [number, number];
  colonyId: number;
}

export type ButtonState = 'valid' | 'noResource' | 'noRequirements';
