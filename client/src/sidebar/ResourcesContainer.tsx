import React from 'react';
import styled from 'styled-components';
import { Typography } from '@mui/material';
import { numberWithCommas } from '../shared/utils';
// Asset imports
import ironImg from '../assets/gameElements/resources/steel-1.webp';
import quartzImg from '../assets/gameElements/resources/quartz-2.webp';
import tritiumImg from '../assets/gameElements/resources/tritium-1.webp';
import energyImg from '../assets/gameElements/resources/energy-2.webp';
import CompoundsFormulas, {
  getCelestiaProduction,
} from '../shared/utils/Formulas';
import { Position } from '../shared/types';
import { usePlanetResources } from '../hooks/usePlanetResources';
import { usePlanetCompounds } from '../hooks/usePlanetCompounds';
import { useColonyCompounds } from '../hooks/useColonyCompounds';
import { useColonyResources } from '../hooks/useColonyResources';
import { usePlanetDefences } from '../hooks/usePlanetDefences';
import { useColonyDefences } from '../hooks/useColonyDefences';

const Container = styled.div`
  display: flex;
  align-items: center;
  padding: 4px 16px;
  border-top: 2px solid #151a1e;
`;

const ImageAddressContainer = styled.div`
  display: flex;
  flex-direction: column;
  align-items: center;
  width: 50px;
  cursor: pointer;

  &:hover {
    opacity: 0.8;
  }
`;

const ImageStyle = styled.img`
  width: 50px;
  height: auto;
  object-fit: contain;
`;

const ResourceName = styled(Typography)({
  textTransform: 'uppercase',
  opacity: 0.5,
  fontWeight: 700,
  lineHeight: '16px',
  letterSpacing: '0.02em',
  margin: 0, // Make sure no external spacing
  padding: 0, // Make sure no internal spacing

  width: '64px',
});

const TotalResourceText = styled.div`
  color: #23ce6b;
  font-weight: 500;
  margin-left: 10px;
  padding-bottom: 6px;
`;

const TotalResourceContainer = styled.div`
  display: flex;
  align-items: center;
  padding: 16px;
`;

const TotalResourceWrapper = styled.div`
  margin-left: 30px;
  display: flex;
  flex-direction: column;
`;

interface Props {
  img: string;
  title: string;
  available?: number;
  solar?: number;
  celestia?: number;
}

const Energy = ({ solar, celestia, img, title }: Props) => {
  const available = solar && celestia ? solar + celestia : 0;
  const availableStyle = {
    color: available < 0 ? '#AB3836' : '#23CE6B', // Apply red color if available is negative
  };
  return (
    <Container>
      <div>
        <ResourceName style={{ fontSize: '16px' }}>{title}</ResourceName>
        <ImageAddressContainer>
          <div style={{ width: '30px' }}>
            <ImageStyle src={img} alt="resource" />
          </div>
        </ImageAddressContainer>
      </div>
      <TotalResourceWrapper>
        <TotalResourceContainer>
          <div>
            <ResourceName style={{ fontSize: '10px' }}>Available</ResourceName>
            <TotalResourceText style={availableStyle}>
              {numberWithCommas(available)}
            </TotalResourceText>
            <ResourceName style={{ fontSize: '10px' }}>Celestia</ResourceName>
            <TotalResourceText>
              {numberWithCommas(celestia ? celestia : 0)}
            </TotalResourceText>
          </div>
        </TotalResourceContainer>
      </TotalResourceWrapper>
    </Container>
  );
};

const Resource = ({ available, img, title }: Props) => {
  return (
    <Container>
      <div>
        <ResourceName style={{ fontSize: '16px' }}>{title}</ResourceName>
        <ImageAddressContainer>
          <div style={{ width: '30px' }}>
            <ImageStyle src={img} alt="resource" />
          </div>
        </ImageAddressContainer>
      </div>
      <TotalResourceWrapper>
        <TotalResourceContainer>
          <div>
            <ResourceName style={{ fontSize: '10px' }}>Available</ResourceName>
            <TotalResourceText>{available}</TotalResourceText>
            {/* Additional details can be added here if needed */}
          </div>
        </TotalResourceContainer>
      </TotalResourceWrapper>
    </Container>
  );
};

interface ResourceContainerArgs {
  planetId: number;
  selectedColonyId: number;
  planetPosition: Position;
}

const ResourcesContainer = ({
  planetId,
  selectedColonyId,
  planetPosition,
}: ResourceContainerArgs) => {
  const planetResources = usePlanetResources(planetId);

  const compoundsLevels = usePlanetCompounds(planetId);

  const colonyResources = useColonyResources(planetId, selectedColonyId);

  const colonyCompounds = useColonyCompounds(planetId, selectedColonyId);

  const solarEnergy = CompoundsFormulas.energyProduction(
    selectedColonyId === 0 ? compoundsLevels?.energy : colonyCompounds?.energy
  );

  const planetCelestia = usePlanetDefences(planetId).celestia;

  const colonyCelestia = useColonyDefences(planetId, selectedColonyId).celestia;

  const celestiaProduction = getCelestiaProduction(
    Number(planetPosition?.orbit)
  );

  const energyFromCelestia =
    planetCelestia && colonyCelestia
      ? selectedColonyId === 0
        ? planetCelestia * celestiaProduction
        : colonyCelestia * celestiaProduction
      : 0;

  const steelConsumption = CompoundsFormulas.steelConsumption(
    selectedColonyId === 0 ? compoundsLevels?.steel : colonyCompounds?.steel
  );

  const quartzConsumption = CompoundsFormulas.quartzConsumption(
    selectedColonyId === 0 ? compoundsLevels?.quartz : colonyCompounds?.quartz
  );

  const tritiumConsumption = CompoundsFormulas.tritiumConsumption(
    selectedColonyId === 0 ? compoundsLevels?.tritium : colonyCompounds?.tritium
  );

  const netEnergy =
    solarEnergy + (steelConsumption + quartzConsumption + tritiumConsumption);

  return (
    <div>
      <Resource
        title="Steel"
        img={ironImg}
        available={
          selectedColonyId === 0
            ? planetResources?.steel
            : colonyResources?.steel
        }
      />
      <Resource
        title="Quartz"
        img={quartzImg}
        available={
          selectedColonyId === 0
            ? planetResources?.quartz
            : colonyResources?.quartz
        }
      />
      <Resource
        title="Tritium"
        img={tritiumImg}
        available={
          selectedColonyId === 0
            ? planetResources?.tritium
            : colonyResources?.tritium
        }
      />
      <Energy
        title="Energy"
        img={energyImg}
        solar={netEnergy}
        celestia={energyFromCelestia}
      />
    </div>
  );
};

export default ResourcesContainer;
