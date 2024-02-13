import {
  React,
  useMemo,
  Styled,
  usePlanetPosition,
  convertPositionToNumbers,
  PlanetModal,
  CircularProgress,
  numberWithCommas,
  DebrisFieldView,
  ButtonAttackPlanet,
  UniverseBoxProps as Props,
} from '.';
import { InfoContainer } from './styled';

const UniverseViewBox = ({
  planetId,
  img,
  position,
  owner,
  points,
  highlighted,
  ownPlanetId,
  ownFleet,
  ownTechs,
  isNoobProtected,
  lastActive,
  winLoss,
  colonyId,
}: Props) => {
  const boxStyle = highlighted ? { border: '1px solid #23CE6B' } : {};

  const formattedPosition = `${String(position.system).padStart(
    2,
    '0'
  )} / ${String(position.orbit).padStart(2, '0')}`;

  // Calculate the time difference in seconds
  const timeNow = new Date().getTime() / 1000;
  const timeDifference = timeNow - lastActive;
  const oneWeekInSeconds = 7 * 24 * 60 * 60;

  // Override isNoobProtected based on the lastActive time
  const updatedIsNoobProtected =
    isNoobProtected && timeDifference < oneWeekInSeconds;

  const planetIdForOwnPosition =
    colonyId === 0 ? ownPlanetId : ownPlanetId * 1000 + colonyId;

  const ownPlanetPosition = convertPositionToNumbers(
    usePlanetPosition(planetIdForOwnPosition)
  );

  const getLastActiveTime = useMemo(() => {
    if (!lastActive || timeDifference > oneWeekInSeconds) {
      return 'Inactive';
    }

    // Convert the Unix timestamp to a JavaScript Date object
    const lastActiveDate = new Date(lastActive * 1000);
    const now = new Date();

    // Calculate the difference in seconds
    const differenceInSeconds = Math.floor(
      (now.getTime() - lastActiveDate.getTime()) / 1000
    );
    // Format the time difference
    if (differenceInSeconds < 3600) {
      // Less than an hour
      return `${Math.floor(differenceInSeconds / 60)} min ago`;
    }
    if (differenceInSeconds < 86400) {
      // Less than a day
      return `${Math.floor(differenceInSeconds / 3600)} hours ago`;
    }
    return `${Math.floor(differenceInSeconds / 86400)} days ago`;
  }, [lastActive, oneWeekInSeconds, timeDifference]);

  const isDisable =
    Number(position.system) === ownPlanetPosition?.system &&
    Number(position.orbit) === ownPlanetPosition?.orbit;

  return (
    <Styled.Box style={boxStyle}>
      <Styled.ImageContainer>
        {img && planetId ? (
          <PlanetModal
            planetId={planetId}
            image={img}
            position={formattedPosition || ''}
          />
        ) : (
          <CircularProgress sx={{ color: '#ffffff', opacity: '0.5' }} />
        )}
      </Styled.ImageContainer>
      <Styled.SubBox>
        <Styled.Title>
          <Styled.ResourceTitle>PLAYER</Styled.ResourceTitle>
          <Styled.NumberContainer
            style={{ fontSize: '14px' }}
          >{`${owner}`}</Styled.NumberContainer>
        </Styled.Title>
        <InfoContainer>
          <Styled.ResourceContainer>
            <Styled.ResourceTitle style={{ width: '200%' }}>
              LAST ACTIVE
            </Styled.ResourceTitle>
            <Styled.NumberContainer style={{ fontSize: '14px' }}>
              {getLastActiveTime}
            </Styled.NumberContainer>
          </Styled.ResourceContainer>
          <Styled.ResourceContainer>
            <Styled.ResourceTitle>RANK</Styled.ResourceTitle>
            <Styled.NumberContainer style={{ fontSize: '14px' }}>
              {isNaN(Number(points)) ? '-' : numberWithCommas(Number(points))}
            </Styled.NumberContainer>
          </Styled.ResourceContainer>
          <Styled.ResourceContainer>
            <Styled.ResourceTitle style={{ width: '200%' }}>
              WIN/LOSS
            </Styled.ResourceTitle>
            <Styled.NumberContainer style={{ fontSize: '14px' }}>
              <span style={{ color: '#23CE6B' }}>{winLoss[0]}</span>
              <span style={{ color: 'inherit' }}> / </span>
              <span style={{ color: '#AB3836' }}>{winLoss[1]}</span>
            </Styled.NumberContainer>
          </Styled.ResourceContainer>

          <Styled.ResourceContainer>
            <Styled.ResourceTitle>POSITION</Styled.ResourceTitle>
            <Styled.NumberContainer style={{ fontSize: '14px' }}>
              {formattedPosition}
            </Styled.NumberContainer>
          </Styled.ResourceContainer>
        </InfoContainer>
        <DebrisFieldView
          planetId={planetId}
          position={formattedPosition}
          ownFleet={ownFleet}
          techs={ownTechs}
          ownPosition={ownPlanetPosition}
          colonyId={colonyId}
        />
        <Styled.ButtonContainer>
          <ButtonAttackPlanet
            disabled={isDisable}
            noRequirements={highlighted}
            isNoobProtected={updatedIsNoobProtected}
            destination={formattedPosition}
            destinationPosition={position}
            ownFleet={ownFleet!}
            techs={ownTechs}
            ownPosition={ownPlanetPosition}
            planetId={planetId}
            colonyId={colonyId}
          />
        </Styled.ButtonContainer>
      </Styled.SubBox>
    </Styled.Box>
  );
};

export default UniverseViewBox;
