import React from 'react';
import styled from 'styled-components';
import LogoAndRankContainer from './LogoutAndRankContainer';
import ResourcesContainer from './ResourcesContainer';
import ColonySelect from './ColonySelect';
import { SelectChangeEvent } from '@mui/material';
import { Position } from '../../hooks/usePlanetPosition';

const BodyContainer = styled.div`
  display: flex;
  flex-direction: column;
  flex: 1;
  height: fit-content;
  background-color: #1a2025;
`;

interface Props {
  planetId: number;
  selectedColonyId: number;
  handleChange: (event: SelectChangeEvent<unknown>) => void;
  planetPosition: Position;
}

const SideBar = ({
  planetId,
  selectedColonyId,
  handleChange,
  planetPosition,
}: Props) => {
  return (
    <BodyContainer>
      <LogoAndRankContainer planetId={planetId} />
      <ColonySelect
        planetId={planetId}
        selectedColonyId={selectedColonyId}
        handleChange={handleChange}
      />
      <ResourcesContainer
        planetId={planetId}
        selectedColonyId={selectedColonyId}
        planetPosition={planetPosition}
      />
    </BodyContainer>
  );
};

export default SideBar;
