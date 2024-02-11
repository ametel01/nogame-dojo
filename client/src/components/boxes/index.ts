import React, { ReactNode, useMemo, useState, useEffect } from 'react';
import styled from 'styled-components';
import { Input } from '@mui/joy';
import Tooltip from '@mui/material/Tooltip';
import * as Styled from '../../shared/styled/Box';
import { useAccount } from '@starknet-react/core';
import {
  numberWithCommas,
  calculEnoughResources,
  convertPositionToNumbers,
} from '../../shared/utils';
import DescriptionModal from '../modals/Description';
import AddTransactionIcon from '../../multicall/AddTransactionIcon';
import {
  DefenceLevels,
  Position,
  Resources,
  ShipsLevels,
  TechLevels,
} from '../../shared/types';
import { CircularProgress } from '@mui/material';
import PlanetModal from '../modals/PlanetOverview';
import DebrisFieldView from '../ui/DebrisFieldView';
import ButtonAttackPlanet from '../buttons/ButtonAttackPlanet';

export { useCompoundUpgrade } from '../../hooks/writeHooks/useUpgrade';
export { useTechUpgrade } from '../../hooks/writeHooks/useUpgrade';
export { useShipBuild } from '../../hooks/writeHooks/useBuild';
export { useDefenceBuild } from '../../hooks/writeHooks/useBuild';
export { usePlanetPosition } from '../../hooks/usePlanetPosition';

export { ButtonUpgrade } from '../ui/Button';
export { ButtonBuild } from '../ui/Button';
export { getCumulativeTechCost } from '../../shared/utils/Formulas';
export { baseTechCost } from '../../constants/costs';
export {
  type Resources,
  type TechLevels,
  type ShipsLevels,
  type DefenceLevels,
} from '../../shared/types';
export {
  getCompoundCost,
  getCumulativeEnergyChange,
} from '../../shared/utils/Formulas';

export {
  React,
  ReactNode,
  useMemo,
  useState,
  useEffect,
  useAccount,
  DescriptionModal,
  AddTransactionIcon,
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
  functionCallName: number;
  description: React.ReactNode;
  resourcesAvailable?: Resources;
  colonyId: number;
}

export interface LabBoxProps {
  img: string;
  title: string;
  functionCallName: number;
  level?: number;
  requirementsMet?: boolean;
  description: ReactNode;
  techs: TechLevels;
  resourcesAvailable: Resources;
}

export interface DockyardBoxProps {
  img: string;
  title: string;
  functionCallName: number;
  level?: number;
  costUpdate?: { steel: number; quartz: number; tritium: number };
  hasEnoughResources?: boolean;
  requirementsMet?: boolean;
  description: ReactNode;
  resourcesAvailable: Resources;
  colonyId: number;
}

export interface DefenceBoxProps {
  img: string;
  title: string;
  functionCallName: number;
  level?: number;
  costUpdate?: { steel: number; quartz: number; tritium: number };
  hasEnoughResources?: boolean;
  requirementsMet?: boolean;
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
  fleet?: ShipsLevels;
  defences?: DefenceLevels;
  ownPlanetId: number;
  ownFleet?: ShipsLevels;
  ownTechs?: TechLevels;
  isNoobProtected?: boolean;
  lastActive: number;
  winLoss: [number, number];
  colonyId: number;
}

export type ButtonState = 'valid' | 'noResource' | 'noRequirements';
