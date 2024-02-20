import React, { useState, useEffect, useMemo } from 'react';
import { styled } from '@mui/system';
import Modal from '@mui/material/Modal';
import Box from '@mui/material/Box';
import CloseIcon from '@mui/icons-material/Close';
import { StyledButton } from '../../../shared/styled/Button';
import { MissionCategory } from '../../../shared/types';
import { Position } from '../../../hooks/usePlanetPosition';
import { Fleet } from '../../../hooks/usePlanetShips';
import { Techs } from '../../../hooks/usePlanetTechs';
import {
  calculateTotalCargoCapacity,
  getDistance,
  getFleetSpeed,
  getFlightTime,
  getFuelConsumption,
} from '../../../shared/utils/FleetUtils';
import Slider from '@mui/material/Slider';
import { useDojo } from '../../../dojo/useDojo';
import { useActiveMissions } from '../../../hooks/useActiveMissions';
import { TravelInfo } from './TravelInfo';
import { InputButtonContainer, InputImage, ShipsSelect } from './ShipsSelect';
import { Resources } from '../../../hooks/usePlanetResources';
import { StyledInput } from '../../../shared/styled/input';
import steelImg from '../../../assets/gameElements/resources/steel-1.webp';
import quartzImg from '../../../assets/gameElements/resources/quartz-2.webp';
import tritiumImg from '../../../assets/gameElements/resources/tritium-1.webp';
import KeyboardDoubleArrowUpIcon from '@mui/icons-material/KeyboardDoubleArrowUp';

export const StyledBox = styled(Box)({
  fontWeight: 400,
  fontSize: 16,
  color: '#E7ECEE',
  position: 'absolute',
  top: '50%',
  left: '50%',
  transform: 'translate(-50%, -50%)',
  backgroundColor: '#1a2025',
  borderRadius: 16,
  boxShadow: '0px 3px 5px rgba(0, 0, 0, 0.2)',
  padding: '16px 32px',
  display: 'flex',
  flexDirection: 'column',
  width: 'fit-content',
});

export const CloseStyledIcon = styled(CloseIcon)({
  cursor: 'pointer',
  padding: '0 8px',
  fontSize: '2em',
  position: 'absolute',
  top: 8, // You can adjust this value as needed
  right: 8, // You can adjust this value as needed
  transition: 'boxShadow 0.3s ease', // Smooth transition for the shadow on hover

  '&:hover': {
    boxShadow: '0px 0px 10px 3px rgba(0, 0, 0, 0.2)', // Circle shadow effect
    borderRadius: '50%', // Ensures the shadow takes a circular form
  },
});

export const HeaderDiv = styled('div')({
  // display: 'flex',
  justifyContent: 'space-between',
  alignItems: 'center',
  textAlign: 'center',
  fontSize: '20px',
});

export const StyledUl = styled('ul')({
  padding: '8px',
  flexGrow: 1,
});

export const Text = styled('span')({
  flexGrow: 1,
  textAlign: 'center',
});

export const FlexContainer = styled('div')({
  display: 'flex',
  alignItems: 'left',
  justifyContent: 'flex-start',
  borderRadius: '8px',
  gap: '4px',
  margin: '8px',
  flexDirection: 'row',
});

export const SliderContainer = styled('div')({
  display: 'flex',
  alignItems: 'center', // Vertically centers the child elements
  justifyContent: 'center', // Horizontally centers the child elements
});

export type ShipName = 'carrier' | 'scraper' | 'sparrow' | 'frigate' | 'armade';

export type ResourceName = 'steel' | 'quartz' | 'tritium';

export const resourceImageMapping: Record<ResourceName, string> = {
  steel: steelImg,
  quartz: quartzImg,
  tritium: tritiumImg,
};

interface Props {
  callback?: () => void;
  disabled?: boolean;
  noRequirements?: boolean;
  isNoobProtected?: boolean;
  destination: string;
  destinationPosition: Position;
  resourcesAvailable: Resources;
  ownFleet: Fleet;
  techs?: Techs;
  ownPosition?: Position;
  planetId: number;
  colonyId: number;
}

function ButtonAttackPlanet({
  disabled,
  noRequirements,
  isNoobProtected,
  destination,
  destinationPosition,
  resourcesAvailable,
  ownFleet,
  techs,
  ownPosition,
  planetId,
  colonyId,
}: Props) {
  const {
    setup: {
      systemCalls: { sendFleet },
    },
    account,
  } = useDojo();

  const [quantities, setQuantities] = useState<Record<string, number>>({});
  const [travelTime, setTravelTime] = useState(0);
  const [fuelConsumption, setFuelConsumption] = useState(0);
  const [cargoCapacity, setCargoCapacity] = useState(0);
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [, setisButtotClicked] = useState(false);
  const [speed, setSpeed] = useState(100);
  const [cargo, setCargo] = useState<Resources>({
    steel: 0,
    quartz: 0,
    tritium: 0,
  });

  function handleShipChange(
    ship: string,
    event: { target: { value: string } }
  ) {
    let value = parseInt(event.target.value, 10);
    if (isNaN(value) || value < 0) {
      value = 0;
    }
    setQuantities({ ...quantities, [ship]: value });
  }

  const handleMaxQuantity = (ship: ShipName) => {
    setQuantities({
      ...quantities,
      [ship]: ownFleet[ship], // Convert BigInt to Number
    });
  };

  const handleMaxResourcesQuantity = (resource: ResourceName) => {
    setCargo({
      ...cargo,
      [resource]: resourcesAvailable[resource] || 0,
    });
  };

  const missions = useActiveMissions(planetId);
  const isMissionLimitReached =
    missions && techs && missions.length === techs.digital + 1;

  const handleButtonClick = () => {
    setIsModalOpen(true);
  };

  const handleClose = () => {
    setIsModalOpen(false);
  };

  const destinationArray = destination.split('/');

  const position: Position = {
    system: Number(destinationArray[0]),
    orbit: Number(destinationArray[1]),
  };

  const fleet = useMemo(
    () => ({
      carrier: quantities.carrier || 0,
      scraper: quantities.scraper || 0,
      sparrow: quantities.sparrow || 0,
      frigate: quantities.frigate || 0,
      armade: quantities.armade || 0,
    }),
    [quantities]
  );

  const distance = ownPosition ? getDistance(ownPosition, position) : 0;

  useEffect(() => {
    setFuelConsumption(getFuelConsumption(fleet, distance, speed));
    setCargoCapacity(calculateTotalCargoCapacity(fleet));
  }, [distance, fleet, ownPosition, speed, techs]);

  const sendAttackCallBack = () =>
    sendFleet(
      account.account,
      fleet,
      destinationPosition,
      cargo,
      MissionCategory['Attack'],
      speed,
      colonyId
    );

  const sendTransportCallBack = () =>
    sendFleet(
      account.account,
      fleet,
      destinationPosition,
      cargo,
      MissionCategory['Transport'],
      speed,
      colonyId
    );

  const ships = ['carrier', 'scraper', 'sparrow', 'frigate', 'armade'];

  const isAnyShipOverLimit = ships.some(
    (ship) => quantities[ship] > ownFleet[ship as keyof typeof ownFleet]
  );

  const [timeOfArrival, setTimeOfArrival] = useState<Date | null>(null);

  useEffect(() => {
    if (travelTime !== undefined) {
      const arrival = new Date();
      arrival.setSeconds(arrival.getSeconds() + Number(travelTime));
      setTimeOfArrival(arrival);
    }
  }, [travelTime]);

  useEffect(() => {
    const speedFactor = speed / 100; // Convert percentage to a factor
    const fleetSpeed = techs ? getFleetSpeed(fleet, techs) : 0;
    setTravelTime(getFlightTime(fleetSpeed, distance, speedFactor));
    setFuelConsumption(getFuelConsumption(fleet, distance, speed));
  }, [distance, fleet, ownPosition, techs, speed]);

  const handleSendAttackClick = () => {
    sendAttackCallBack(), setIsModalOpen(false), setisButtotClicked(true);
  };

  const handleSendTransportClick = () => {
    sendTransportCallBack(), setIsModalOpen(false), setisButtotClicked(true);
  };

  const handleSpeedChange = (newValue: number | number[]) => {
    if (typeof newValue === 'number') {
      setSpeed(newValue);
    }
  };

  const handleCargoChange = (resource: keyof Resources, value: number) => {
    setCargo((prev) => ({ ...prev, [resource]: value || 0 }));
  };

  const resources: ResourceName[] = ['steel', 'quartz', 'tritium'];

  return (
    <div>
      {!isNoobProtected && !disabled ? (
        <>
          <StyledButton
            onClick={handleButtonClick}
            fullWidth={true}
            sx={{
              background: '#4A63AA',
            }}
          >
            {!noRequirements ? 'Initiate Attack' : 'Initiate Transport'}
          </StyledButton>
          <Modal open={isModalOpen} onClose={handleClose}>
            <StyledBox>
              <HeaderDiv>
                SELECT SHIPS
                <CloseStyledIcon onClick={handleClose} />
              </HeaderDiv>
              <FlexContainer
                style={{
                  flexDirection: 'row',
                  justifyContent: 'flex-start',
                }}
              >
                <ShipsSelect
                  ownFleet={ownFleet}
                  quantities={quantities}
                  handleChange={handleShipChange}
                  handleMaxQuantity={handleMaxQuantity}
                />
                <StyledUl>
                  {resources.map((resource) => (
                    <FlexContainer key={resource}>
                      <InputImage
                        src={resourceImageMapping[resource]}
                        alt={resource}
                      />
                      <InputButtonContainer>
                        <StyledInput
                          type="number"
                          value={cargo[resource] || 0}
                          onChange={(e) =>
                            handleCargoChange(resource, Number(e.target.value))
                          }
                          color="neutral"
                          style={{ width: '80px' }}
                        />
                        <KeyboardDoubleArrowUpIcon
                          onClick={() =>
                            handleMaxResourcesQuantity(resource as ResourceName)
                          }
                          style={{ cursor: 'pointer' }}
                        />
                      </InputButtonContainer>
                    </FlexContainer>
                  ))}
                </StyledUl>
                <div>
                  <TravelInfo
                    destination={destination}
                    travelTime={travelTime}
                    timeOfArrival={timeOfArrival}
                    fuelConsumption={fuelConsumption}
                    cargoCapacity={cargoCapacity}
                  />
                  <Text>Fleet Speed: {speed}%</Text>
                  <SliderContainer>
                    <Slider
                      value={speed}
                      onChange={(event, newValue) =>
                        handleSpeedChange(newValue)
                      }
                      aria-labelledby="fleet-speed-slider"
                      valueLabelDisplay="auto"
                      min={1}
                      max={100}
                      sx={{ width: '150px' }} // Adjust styling as needed
                    />
                  </SliderContainer>
                </div>
              </FlexContainer>
              <StyledButton
                onClick={
                  noRequirements
                    ? handleSendTransportClick
                    : handleSendAttackClick
                }
                fullWidth
                style={{
                  background: isAnyShipOverLimit ? '#3B3F53' : '#4A63AA',
                }}
                disabled={isAnyShipOverLimit || isMissionLimitReached}
              >
                Send Fleet
              </StyledButton>
            </StyledBox>
          </Modal>
        </>
      ) : noRequirements ? (
        <StyledButton
          disabled
          fullWidth={true}
          sx={{
            background: '#3B3F53',
          }}
        >
          Own Planet
        </StyledButton>
      ) : (
        <StyledButton
          fullWidth={true}
          disabled
          sx={{
            background: '#E67E51',
          }}
        >
          Noob Protected
        </StyledButton>
      )}
    </div>
  );
}

export default ButtonAttackPlanet;
