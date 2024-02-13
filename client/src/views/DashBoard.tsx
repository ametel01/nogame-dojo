import React, { useState } from 'react';
import styled from 'styled-components';
import SideBar from '../sidebar/SideBar';
import { PlanetSection } from '../planetSection/PlanetSection';
// import { ResourcesSection } from '../panels/MainTabPanel';
import { SelectChangeEvent } from '@mui/material';
// import ColonyDashboard from '../colony/ColonyDashboard';
import { useDojo } from '../dojo/useDojo';
import { useComponentValue } from '@dojoengine/react';
import { getEntityIdFromKeys } from '@dojoengine/utils';
import { Entity } from '@dojoengine/recs';
import { Position } from '../shared/types';

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
  const {
    setup: {
      clientComponents: { PlanetPosition, ColonyPosition },
    },
  } = useDojo();
  const [selectedColonyId, setSelectedColonyId] = useState<number>(0);

  const handleChange = (event: SelectChangeEvent<unknown>) => {
    setSelectedColonyId(Number(event.target.value));
  };

  const planteIdEntity = getEntityIdFromKeys([BigInt(planetId)]) as Entity;
  const planetPosition = useComponentValue(PlanetPosition, planteIdEntity);

  const colonyIdEntity = getEntityIdFromKeys([
    BigInt(planetId * 1000 + selectedColonyId),
  ]);
  const colonyPosition = useComponentValue(ColonyPosition, colonyIdEntity);

  return (
    <DashboardMainContainer>
      <SideBar
        planetId={planetId}
        selectedColonyId={selectedColonyId}
        handleChange={handleChange}
        planetPosition={
          selectedColonyId === 0
            ? (planetPosition?.position as Position)
            : (colonyPosition?.position as Position)
        }
      />
      <GameContainer>
        <DashboardSubBodyContainer>
          <PlanetSection
            planetId={planetId}
            selctedColonyId={selectedColonyId}
          />
        </DashboardSubBodyContainer>
        {/* <DashboardSubBodyContainer>
          {selectedColonyId !== 0 && selectedColonyId !== null ? (
            <ColonyDashboard
              planetId={planetId}
              colonyId={Number(selectedColonyId)}
            />
          ) : (
            <ResourcesSection planetId={planetId} colonyId={selectedColonyId} />
          )} */}
        {/* </DashboardSubBodyContainer> */}
      </GameContainer>
    </DashboardMainContainer>
  );
}
