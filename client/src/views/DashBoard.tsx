import React, { useState } from 'react';
import styled from 'styled-components';
import SideBar from '../components/ui/SideBar';
import { PlanetSection } from '../components/ui/PlanetSection';
import { ResourcesSection } from '../panels/MainTabPanel';
import { SelectChangeEvent } from '@mui/material';
import ColonyDashboard from '../colony/ColonyDashboard';
import { usePlanetPosition } from '../hooks/usePlanetPosition';

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
}

export default function Dashboard({ planetId }: Props) {
  const [selectedColonyId, setSelectedColonyId] = useState<number>(0);

  const handleChange = (event: SelectChangeEvent<unknown>) => {
    setSelectedColonyId(Number(event.target.value));
  };

  const position = usePlanetPosition(planetId);

  const colonyPosition = usePlanetPosition(planetId * 1000 + selectedColonyId);

  return (
    <DashboardMainContainer>
      <SideBar
        planetId={planetId}
        selectedColonyId={selectedColonyId}
        handleChange={handleChange}
        planetPosition={selectedColonyId === 0 ? position : colonyPosition}
      />
      <GameContainer>
        <DashboardSubBodyContainer>
          <PlanetSection
            planetId={planetId}
            selctedColonyId={selectedColonyId}
          />
        </DashboardSubBodyContainer>
        <DashboardSubBodyContainer>
          {selectedColonyId !== 0 && selectedColonyId !== null ? (
            <ColonyDashboard
              planetId={planetId}
              colonyId={Number(selectedColonyId)}
            />
          ) : (
            <ResourcesSection planetId={planetId} colonyId={selectedColonyId} />
          )}
        </DashboardSubBodyContainer>
      </GameContainer>
    </DashboardMainContainer>
  );
}
