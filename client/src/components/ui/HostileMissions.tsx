import React, { useState, useEffect } from 'react';
import { keyframes, styled } from '@mui/system';
import Box from '@mui/material/Box';
import Typography from '@mui/material/Typography';
import { useGetHostileMissions } from '../../hooks/FleetHooks';
import WarningIcon from '@mui/icons-material/Warning';
import { usePlanetPosition } from '../../hooks/usePlanetPosition';
import { type HostileMission } from '../../shared/types';

// Styled components
const Container = styled(Box)(({ theme }) => ({
  backgroundColor: '#1a2025', // Assuming a dark theme from the image
  borderRadius: '8px',
  boxshadow: '0 4px 8px rgba(0, 0, 0, 0.1)',
  padding: theme.spacing(2),
  marginBottom: theme.spacing(2),
  width: 'fit-content',
  gap: '4px', // Reduced from 8px to 4px
}));

const TitleContainer = styled(Box)({
  display: 'flex',
  alignItems: 'center', // Aligns children vertically in the middle
  justifyContent: 'center', // Centers children horizontally
  flexWrap: 'nowrap', // Prevents wrapping
  marginBottom: '16px',
});

const Title = styled(Typography)({
  fontWeight: 'bold',
  textAlign: 'center',
  flexGrow: 1,
  opacity: 0.5,
});

const blinkAnimation = keyframes`
  50% {
    opacity: 0;
  }
`;

const StyledWarningIcon = styled(WarningIcon)({
  fontSize: '32px', // Adjust size as needed
  marginRight: '8px', // Assuming default theme spacing
  color: '#AB3836', // Icon color
  animation: `${blinkAnimation} 1s linear infinite`, // Apply the animation
});

const HeaderRow = styled(Box)({
  display: 'grid',
  gridTemplateColumns: 'repeat(4, 1fr)',
  gap: '0px', // Reduced from 8px to 4px
  paddingBottom: '8px',
  borderBottom: '1px solid #30363d',
});

const Row = styled(Box)({
  display: 'grid',
  gridTemplateColumns: 'repeat(4, 1fr)',
  gap: '0px', // Reduced from 8px to 4px
  padding: '4px 0',
});

const Cell = styled(Typography)(() => ({
  fontSize: '14px',
  opacity: 0.5,
  color: '#23CE6B',
}));

const RightAlignedCell = styled(Cell)({
  textAlign: 'right',
});

const shouldDisplayMission = (mission: HostileMission) => {
  const arrivalTimeInSeconds = Number(mission.time_arrival);
  const currentTimeInSeconds = Date.now() / 1000;
  const timeDifferenceInSeconds = arrivalTimeInSeconds - currentTimeInSeconds;

  // Check if the time difference is within 3 hours
  return timeDifferenceInSeconds > -3 * 3600;
};

const getTimeDifference = (arrivalTime: number) => {
  const currentTime = Date.now() / 1000; // Convert current time to seconds
  const differenceInSeconds = arrivalTime - currentTime;

  // Check if the mission has already arrived
  if (differenceInSeconds <= 0) {
    return 'Arrived';
  }

  // Otherwise, calculate the time remaining
  const hours = Math.floor(differenceInSeconds / 3600);
  const minutes = Math.floor((differenceInSeconds % 3600) / 60);
  const seconds = Math.floor(differenceInSeconds % 60);

  return `${hours}h ${minutes}m ${seconds}s`;
};

interface RowProps {
  mission: HostileMission;
}

const MissionRow = ({ mission }: RowProps) => {
  const [countdown, setCountdown] = useState(
    getTimeDifference(Number(mission.time_arrival))
  );
  const position = usePlanetPosition(Number(mission.origin));
  const originCoordinates = position
    ? `${position.system} / ${position.orbit}`
    : 'Unknown';

  useEffect(() => {
    const interval = setInterval(() => {
      setCountdown(getTimeDifference(Number(mission.time_arrival)));
    }, 1000);

    return () => {
      clearInterval(interval);
    };
  }, [mission.time_arrival]);

  // Check if the time difference is greater than 3 hours
  if (parseInt(countdown) > 3 * 3600) {
    return null; // Don't render anything
  }

  const destination =
    Number(mission.destination) > 500
      ? `Colony ${Number(mission.destination) % 1000}`
      : 'Mother Planet';

  return (
    <Row key={mission.id_at_origin}>
      <Cell>{originCoordinates}</Cell>
      <Cell>{countdown}</Cell>
      <Cell>{destination}</Cell>
      <RightAlignedCell>{Number(mission.number_of_ships)}</RightAlignedCell>
    </Row>
  );
};

interface HostileMissionsProps {
  planetId: number;
}

// Component
export const HostileMissions = ({ planetId }: HostileMissionsProps) => {
  const hostileMissions = useGetHostileMissions(Number(planetId));

  const displayedMissions = hostileMissions?.filter(shouldDisplayMission) || [];

  return (
    <>
      {displayedMissions.length != 0 ? (
        <Container>
          <TitleContainer>
            {displayedMissions.length > 0 && <StyledWarningIcon />}
            <Title variant="h6">Hostile Missions</Title>
          </TitleContainer>
          <HeaderRow>
            <Cell>Origin</Cell>
            <Cell>Arrival</Cell>
            <Cell>Destination</Cell>
            <RightAlignedCell>Ships</RightAlignedCell>
          </HeaderRow>
          {displayedMissions.map((mission) => (
            <MissionRow mission={mission} key={mission.id_at_origin} />
          ))}
        </Container>
      ) : null}
    </>
  );
};
