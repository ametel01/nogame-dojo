import React, { useState, useEffect, useMemo } from 'react';
import { styled } from '@mui/system';
import Modal from '@mui/material/Modal';
import Box from '@mui/material/Box';
import CloseIcon from '@mui/icons-material/Close';
import { Input } from '@mui/joy';
import scraperImg from '../../assets/gameElements/ships/scraper4.webp';
import { StyledButton } from '../../shared/styled/Button';
import useSendFleet from '../../hooks/writeHooks/useSendFleet';
import {
  MissionCategory,
  type DebrisField,
  type Position,
  type ShipsLevels,
  type TechLevels,
} from '../../shared/types';
import {
  SCRAPER,
  getDistance,
  getFleetSpeed,
  getFlightTime,
  getFuelConsumption,
} from '../../shared/utils/FleetUtils';
import { convertSecondsToTime, numberWithCommas } from '../../shared/utils';
import { TransactionStatus } from '../ui/TransactionStatus';
import { SliderContainer, Text as SliderText } from './ButtonAttackPlanet';
import Slider from '@mui/material/Slider';
import KeyboardDoubleArrowUpIcon from '@mui/icons-material/KeyboardDoubleArrowUp';

export const StyledBox = styled(Box)({
  fontWeight: 400,
  fontSize: 20,
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
  width: '40%',
});

const Container = styled('div')({
  display: 'flex',
  flexDirection: 'column',
  alignItems: 'center', // Centers children horizontally in the flex container
  justifyContent: 'flex-start', // Aligns children at the start of the flex container vertically
  gap: '16px', // Adjust the space between the children as needed
  width: '100%',
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
  display: 'flex',
  justifyContent: 'space-between',
  alignSelf: 'center',
  alignItems: 'center',
  marginBottom: '16px',
});

const StyledUl = styled('ul')({
  flexGrow: 0,
  width: '100%', // Ensuring ul takes full width for consistency
});

interface TextProps {
  totalShips: number;
  ownFleet: { scraper: number; [key: string]: number };
}

const Text = styled('span')<TextProps>(({ totalShips, ownFleet }) => ({
  margin: '0px 16px', // Adjust margin as needed
  textAlign: 'center',
  fontSize: '16px',
  textTransform: 'capitalize',
  color: totalShips > ownFleet.scraper ? '#AB3836' : '#F8F8FF',
}));

const FlexContainer = styled('div')({
  marginBottom: '16px',
  display: 'flex',
  alignItems: 'center',
  justifyContent: 'flex-start',
  width: '100%',
});

const TotalDebrisText = styled('div')({
  color: '#F8F8FF',
  fontSize: '16px',
  marginRight: '8px', // Adjust margin as needed
});

const TotalDebrisValue = styled('span')({
  color: '#23CE6B',
});

const InputButtonContainer = styled('div')({
  display: 'flex',
  alignItems: 'center',
  gap: '4px',
  marginRight: '16px', // Add right margin to create space
});

const TravelInfoContainer = styled('div')({
  display: 'flex',
  flexDirection: 'row',
  gap: '8px',
  alignItems: 'flex-start',
  width: '100%',
});

const TravelDetailColumn = styled('div')({
  display: 'flex',
  flexDirection: 'column',
  justifyContent: 'flex-start',
  alignItems: 'flex-start',
  gap: '16px',
  fontSize: '16px',
  marginBottom: '48px',
  flex: '1 1 auto',
});

const TravelInfoName = styled('div')({
  color: '#F8F8FF',
});

const TravelInfoValue = styled('span')({
  color: '#23CE6B',
});

const ShipImage = styled('img')({
  width: '40px',
  height: '40px',
  backgroundSize: 'cover',
  backgroundPosition: 'center',
  borderRadius: '8px',
});

interface Props {
  onClose: () => void;
  position: string;
  ownFleet: ShipsLevels;
  techs: TechLevels;
  ownPosition: Position;
  debrisField: DebrisField;
  colonyId: number;
}

export function ButtonCollectDebris({
  onClose,
  position: positionString,
  ownFleet,
  techs,
  ownPosition,
  debrisField,
  colonyId,
}: Props) {
  const [quantities, setQuantities] = useState<Record<string, number>>({});
  const [travelTime, setTravelTime] = useState(0);
  const [fuelConsumption, setFuelConsumption] = useState(0);
  const [isModalOpen, setIsModalOpen] = useState(true);
  const [isButtotClicked, setIsButtonClicked] = useState(false);
  const [speed, setSpeed] = useState(100);
  const totalShips = quantities.scraper || 0;

  const handleInputChange = (e: { target: { value: string } }) => {
    const inputValue =
      e.target.value === '' ? 0 : Math.max(0, parseInt(e.target.value, 10));
    setQuantities({ scraper: inputValue });
  };

  const handleMaxQuantity = () => {
    // Update the quantities state to use the maximum available scrapers
    setQuantities({
      ...quantities,
      scraper: Number(ownFleet.scraper), // Setting to the total number of available scrapers
    });
  };

  // Calculate the available scrapers after considering the input value
  const availableScrapers =
    Number(ownFleet.scraper) - (quantities.scraper || 0);

  const destinationArray = positionString.split('/');
  const position: Position = {
    system: Number(destinationArray[0]),
    orbit: Number(destinationArray[1]),
  };

  const fleet = useMemo(() => {
    return {
      scraper: totalShips,
      carrier: 0,
      sparrow: 0,
      frigate: 0,
      armade: 0,
    };
  }, [totalShips]);

  const distance = ownPosition ? getDistance(ownPosition, position) : 0;

  useEffect(() => {
    const speedFactor = speed / 100; // Convert percentage to a factor
    const fleetSpeed = techs ? getFleetSpeed(fleet, techs) : 0;
    setTravelTime(getFlightTime(fleetSpeed, distance, speedFactor));
    setFuelConsumption(getFuelConsumption(fleet, distance, speedFactor));
  }, [distance, fleet, speed, techs]);

  const { writeAsync, data } = useSendFleet(
    fleet,
    position,
    MissionCategory['Debris'],
    speed,
    colonyId
  );

  const isShipOverLimit = totalShips > ownFleet.scraper;

  const [timeOfArrival, setTimeOfArrival] = useState<Date | null>(null);

  useEffect(() => {
    if (travelTime !== undefined) {
      const arrival = new Date();
      arrival.setSeconds(arrival.getSeconds() + Number(travelTime) + 240);
      setTimeOfArrival(arrival);
    }
  }, [travelTime]);

  const handleButtonClick = () => {
    writeAsync(), setIsModalOpen(false), setIsButtonClicked(true);
  };

  const handleSpeedChange = (newValue: number | number[]) => {
    if (typeof newValue === 'number') {
      setSpeed(newValue);
    }
  };

  return (
    <>
      <Modal open={isModalOpen} onClose={onClose}>
        <StyledBox>
          <HeaderDiv>
            SELECT SHIPS
            <CloseStyledIcon onClick={onClose} />
          </HeaderDiv>
          <Container>
            <StyledUl>
              <FlexContainer>
                <ShipImage src={scraperImg} alt="scraper" />
                <Text totalShips={totalShips} ownFleet={ownFleet}>
                  scraper (
                  <span
                    style={{
                      color:
                        totalShips > ownFleet.scraper ? '#AB3836' : '#F8F8FF',
                    }}
                  >
                    {String(availableScrapers)}
                  </span>
                  )
                </Text>
                <InputButtonContainer>
                  <Input
                    type="number"
                    value={quantities.scraper || 0}
                    onChange={handleInputChange}
                    size="sm"
                    color="neutral"
                    variant="soft"
                    style={{ width: '80px' }}
                  />
                  <KeyboardDoubleArrowUpIcon
                    onClick={() => handleMaxQuantity()}
                    style={{ cursor: 'pointer' }}
                  />
                </InputButtonContainer>
                <TotalDebrisText>
                  Total Debris{' '}
                  <TotalDebrisValue>
                    {numberWithCommas(
                      Number(debrisField.steel) + Number(debrisField.quartz)
                    )}
                  </TotalDebrisValue>
                </TotalDebrisText>
              </FlexContainer>
            </StyledUl>
            <TravelInfoContainer>
              <TravelDetailColumn>
                <TravelInfoName>
                  Destination:{' '}
                  <TravelInfoValue>{positionString}</TravelInfoValue>
                </TravelInfoName>
                <TravelInfoName>
                  Travel time:{' '}
                  <TravelInfoValue>
                    {convertSecondsToTime(travelTime)}
                  </TravelInfoValue>
                </TravelInfoName>
                <TravelInfoName>
                  Time arrival:{' '}
                  <TravelInfoValue>
                    {timeOfArrival ? timeOfArrival.toLocaleTimeString() : null}
                  </TravelInfoValue>
                </TravelInfoName>
              </TravelDetailColumn>
              <TravelDetailColumn>
                <TravelInfoName>
                  Tritium consumption:{' '}
                  <TravelInfoValue>
                    {numberWithCommas(fuelConsumption)}
                  </TravelInfoValue>
                </TravelInfoName>
                <TravelInfoName>
                  Total number of ships:{' '}
                  <TravelInfoValue>
                    {numberWithCommas(totalShips)}
                  </TravelInfoValue>
                </TravelInfoName>
                <TravelInfoName>
                  Cargo Capacity:{' '}
                  <TravelInfoValue>
                    {numberWithCommas(totalShips * SCRAPER.cargo)}
                  </TravelInfoValue>
                </TravelInfoName>
              </TravelDetailColumn>
            </TravelInfoContainer>
          </Container>
          <SliderText>Fleet Speed: {speed}%</SliderText>
          <SliderContainer>
            <Slider
              value={speed}
              onChange={(event, newValue) => handleSpeedChange(newValue)}
              aria-labelledby="fleet-speed-slider"
              valueLabelDisplay="auto"
              min={1}
              max={100}
              sx={{ width: '200px', marginBottom: '24px' }} // Adjust styling as needed
            />
          </SliderContainer>
          <StyledButton
            onClick={handleButtonClick}
            fullWidth
            style={{
              background: isShipOverLimit ? '#3B3F53' : '#4A63AA',
            }}
            disabled={isShipOverLimit}
          >
            Send Debris Collection
          </StyledButton>
        </StyledBox>
      </Modal>
      {isButtotClicked && (
        <TransactionStatus name="Collect Debris" tx={data?.transaction_hash} />
      )}
    </>
  );
}
