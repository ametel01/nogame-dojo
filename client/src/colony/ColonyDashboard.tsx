import React from 'react';
import styled from 'styled-components';
// import { PlanetSection } from '../components/ui/PlanetSection';
import {
  useGetColonyCompounds,
  useGetColonyDefences,
  useGetColonyResources,
} from '../hooks/ColoniesHooks';
import { useSpendableResources } from '../hooks/ResourcesHooks';
import { ColonyResourcesSection } from './ColonyResourcesSection';
import { getBaseShipsCost } from '../constants/costs';
import { useGetColonyShips } from '../hooks/ColoniesHooks';

export const GameContainer = styled.div`
  display: grid;
  grid-template-rows: 34% auto;
  justify-items: center;
  align-items: center;
  height: 100%;
  max-height: 100vh;
  flex: 5;
`;

export const DashboardMainContainer = styled.div`
  height: 100vh;
  overflow: auto;
  width: 100vw;
  display: flex;
  flex-direction: row;
  justify-items: center;
  border: 2px solid #151a1e;
  align-items: stretch;
`;

export const DashboardSubBodyContainer = styled.section<{ border?: boolean }>`
  display: flex;
  flex-direction: row;
  justify-content: flex-start;
  justify-items: center;
  height: 100%;
  width: 100%;
  background-color: #151a1e;
`;

interface Props {
  planetId: number;
  colonyId: number;
}

export default function ColonyDashboard({ planetId, colonyId }: Props) {
  const compoundLevels = useGetColonyCompounds(planetId, colonyId);
  const spendableResources = useSpendableResources(planetId);
  const collectibleResource = useGetColonyResources(planetId, colonyId);
  const defencesLevels = useGetColonyDefences(planetId, colonyId);
  const shipsLevels = useGetColonyShips(planetId, colonyId);
  const shipsCost = getBaseShipsCost();
  const celestia = defencesLevels ? Number(defencesLevels.celestia) : 0;

  return (
    <ColonyResourcesSection
      planetId={planetId}
      colonyId={colonyId}
      spendableResources={spendableResources}
      collectibleResource={collectibleResource}
      defencesLevels={defencesLevels}
      compoundsLevels={compoundLevels}
      shipsLevels={shipsLevels}
      shipsCost={shipsCost}
      celestiaAvailable={celestia}
    />
  );
}
