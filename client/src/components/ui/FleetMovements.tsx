import React, {
  useState,
  useEffect,
  useCallback,
  useReducer,
  useMemo,
} from 'react';

import { useGetActiveMissions } from '../../hooks/FleetHooks';
import { Box } from '@mui/system';
import Modal from '@mui/material/Modal';
import styled from 'styled-components';
import { calculateFleetLoss } from '../../shared/utils/Formulas';
import { HeaderButton } from '../../shared/styled/Button';
import { MissionRow } from './MissionRow';

export const StyledBox = styled(Box)({
  fontWeight: 400,
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
  width: '60%',
});

const GridContainer = styled.div`
  display: grid;
  grid-template-columns: repeat(7, 1fr);
  gap: 4px;
  background-size: cover;
  padding: 8px;
  border-radius: 8px;
`;

export const FixedLengthText = styled('div')({
  flex: 1,
  padding: '0 4px',
});

export const MissionText = styled('div')({
  color: '#23CE6B',
  padding: '10px',
  textShadow: '0 0 5px rgba(152, 251, 152, 0.7)', // Glow effect
});

interface FleetState {
  countdowns: string[];
  decayPercentages: number[];
}

interface UpdateCountdownAction {
  type: 'UPDATE_COUNTDOWN';
  payload: { index: number; countdown: string };
}

interface UpdateDecayAction {
  type: 'UPDATE_DECAY';
  payload: { index: number; decay: number };
}

interface UpdateMissionAction {
  type: 'UPDATE_MISSION';
  payload: { index: number; countdown: string; decay: number };
}

type FleetAction =
  | UpdateCountdownAction
  | UpdateDecayAction
  | UpdateMissionAction;

// Reducer for managing countdowns and decay percentages
const fleetReducer = (state: FleetState, action: FleetAction): FleetState => {
  switch (action.type) {
    case 'UPDATE_COUNTDOWN': {
      const newCountdowns = [...state.countdowns];
      newCountdowns[action.payload.index] = action.payload.countdown;
      return { ...state, countdowns: newCountdowns };
    }
    case 'UPDATE_DECAY': {
      const newDecays = [...state.decayPercentages];
      newDecays[action.payload.index] = action.payload.decay;
      return { ...state, decayPercentages: newDecays };
    }
    case 'UPDATE_MISSION': {
      const newCountdowns = [...state.countdowns];
      const newDecays = [...state.decayPercentages];

      newCountdowns[action.payload.index] = action.payload.countdown;
      newDecays[action.payload.index] = action.payload.decay;

      return {
        ...state,
        countdowns: newCountdowns,
        decayPercentages: newDecays,
      };
    }
    default:
      return state;
  }
};

interface Props {
  planetId: number;
}

export const FleetMovements = ({ planetId }: Props) => {
  const rawMissions = useGetActiveMissions(planetId);
  const missions = useMemo(() => {
    if (!rawMissions) return [];

    return [...rawMissions].sort((a, b) => {
      return Number(a.time_arrival) - Number(b.time_arrival);
    });
  }, [rawMissions]);

  const [isOpen, setIsOpen] = useState(false);
  const [state, dispatch] = useReducer(fleetReducer, {
    countdowns: [],
    decayPercentages: [],
  });

  const getTimeDifference = useCallback((arrivalTime: number) => {
    const currentTime = Date.now();
    const differenceInSeconds = (arrivalTime - currentTime) / 1000 + 320;

    if (differenceInSeconds <= 0) {
      return 'Arrived';
    }

    const hours = Math.floor(differenceInSeconds / 3600);
    const minutes = Math.floor((differenceInSeconds % 3600) / 60);
    const seconds = Math.floor(differenceInSeconds % 60);

    return `${hours}h ${minutes}m ${seconds}s`;
  }, []);

  useEffect(() => {
    // Array to keep track of interval IDs
    const intervalIDs: ReturnType<typeof setInterval>[] = [];

    missions.forEach((mission, index) => {
      if (missions.length === 0) {
        return;
      }
      const intervalID = setInterval(() => {
        // Update countdown
        const countdown = getTimeDifference(
          Number(mission.time_arrival) * 1000
        );

        // Calculate decay if needed
        const timeSinceArrival =
          Date.now() / 1000 - Number(mission.time_arrival);
        let decay = 0;
        if (timeSinceArrival > 7200) {
          decay = calculateFleetLoss(timeSinceArrival - 7200);
        }

        // Dispatch a single action to update both countdown and decay
        dispatch({
          type: 'UPDATE_MISSION',
          payload: { index, countdown, decay },
        });
      }, 1000);

      // Keep track of the interval ID so it can be cleared later
      intervalIDs.push(intervalID);
    });

    // Clear intervals when the component unmounts or when missions change
    return () => {
      intervalIDs.forEach(clearInterval);
    };
  }, [getTimeDifference, missions]);

  const toggleModal = useCallback((open: boolean) => {
    setIsOpen(open);
  }, []);

  return (
    <div>
      <HeaderButton
        onClick={() => {
          toggleModal(true);
        }}
      >
        FLEET MOVEMENTS
      </HeaderButton>

      <Modal
        open={isOpen}
        onClose={() => {
          toggleModal(false);
        }}
        disableAutoFocus={true}
      >
        <StyledBox>
          <GridContainer>
            <FixedLengthText>
              <strong>Mission</strong>
            </FixedLengthText>
            <FixedLengthText>
              <strong>Origin</strong>
            </FixedLengthText>
            <FixedLengthText>
              <strong>Destination</strong>
            </FixedLengthText>
            <FixedLengthText>
              <strong>Type</strong>
            </FixedLengthText>
            <FixedLengthText>
              <strong>Arrival</strong>
            </FixedLengthText>
            <FixedLengthText>
              <strong>Decay</strong>
            </FixedLengthText>
            <div />
            {missions.map((mission, index) => (
              <MissionRow
                key={mission.id}
                mission={mission}
                index={index}
                countdown={state.countdowns[index]}
                decayPercentage={state.decayPercentages[index]}
              />
            ))}
          </GridContainer>
        </StyledBox>
      </Modal>
    </div>
  );
};
