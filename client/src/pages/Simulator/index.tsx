import React, { useState } from 'react';
import styled from 'styled-components';
import { Fleet, DefenceLevels } from '../../shared/types';
import FormattedSimulationResult from './FormatSimulationResult';
import Header from '../../components/ui/Header';
import { useTokenOf } from '../../hooks/useTokenOf';

export const Container = styled.div`
  color: #fff; // White text for contrast
  padding: 20px;
  display: flex;
  flex-direction: column;
  align-items: flex-start;
`;

const SectionContainer = styled.div`
  display: flex;
  flex-direction: column;
  background-color: #263238;
  padding: 15px;
  border-radius: 10px;
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.5);
  margin-right: 30px;
  // margin-bottom: 30px;
  align-items: flex-start; // Align items to the start of the flex container
`;

export const ColumnsContainer = styled.div`
  display: flex;
  flex-direction: row;
  justify-content: flex-start;
  align-items: flex-start;
  margin-bottom: 30px;
`;

const Label = styled.label`
  color: white;
  width: 170px; // Fixed width of 150px
  display: inline-block; // Necessary to apply width to inline elements like Typography
  text-align: left; // Ensure the text is aligned to the left within the fixed width
  letter-spacing: 0.1rem;
`;

const FleetInput = styled.input`
  max-width: 80px; // Set a maximum width or choose a specific width
  margin: 5px 5px;
  padding: 8px;
  border: none;
  border-radius: 5px;
  box-shadow: inset 0 2px 4px rgba(0, 0, 0, 0.3);
  background-color: #2c3e50;
  color: #23ce6b;
  &:focus {
    outline: none;
    box-shadow: 0 0 5px #4fd1c5; // Focus effect
  }
`;

export const SectionTitle = styled.div`
  font-size: 1.2rem;
  font-weight: bold;
  margin-bottom: 10px;
  color: #23ce6b;
`;

const baseFleet: Fleet = {
  carrier: 0,
  scraper: 0,
  sparrow: 0,
  frigate: 0,
  armade: 0,
};

export const baseDefences: DefenceLevels = {
  celestia: 0,
  blaster: 0,
  beam: 0,
  astral: 0,
  plasma: 0,
};

export type SimulationResult = {
  attackerLosses: Fleet;
  defenderLosses: Fleet;
  defencesLosses: DefenceLevels;
};

export const BattleSimulator = () => {
  const { address } = useAccount();
  const { planetId } = useTokenOf(address);
  const [attackerFleet, setAttackerFleet] = useState<Fleet>(baseFleet);
  const [defenderFleet, setDefenderFleet] = useState<Fleet>(baseFleet);
  const [defences, setDefences] = useState<DefenceLevels>(baseDefences);

  const handleInputChange = (
    fleetType: 'attacker' | 'defender',
    shipType: keyof Fleet,
    value: string
  ) => {
    // Ensure the correct fleet object is updated based on fleetType
    if (fleetType === 'attacker') {
      const updatedFleet = { ...attackerFleet, [shipType]: Number(value) };
      setAttackerFleet(updatedFleet);
    } else {
      const updatedFleet = { ...defenderFleet, [shipType]: Number(value) };
      setDefenderFleet(updatedFleet);
    }
  };

  const handleDefenceChange = (
    defenceType: keyof DefenceLevels,
    value: string
  ) => {
    // Ensure the keys used here are appropriate for DefenceLevels
    const updatedDefences = { ...defences, [defenceType]: Number(value) };
    setDefences(updatedDefences);
  };

  return (
    <>
      <Header planetId={planetId} />
      <Container>
        <ColumnsContainer>
          <SectionContainer>
            <SectionTitle>Attacker Fleet</SectionTitle>
            {Object.keys(attackerFleet).map((shipType) => (
              <div style={{ textTransform: 'capitalize' }} key={shipType}>
                <Label htmlFor={`attacker-${shipType}`}>{shipType}</Label>
                <FleetInput
                  id={`attacker-${shipType}`}
                  type="number"
                  value={attackerFleet[shipType as keyof Fleet]}
                  onChange={(e) =>
                    handleInputChange(
                      'attacker',
                      shipType as keyof Fleet,
                      e.target.value
                    )
                  }
                />
              </div>
            ))}
          </SectionContainer>

          {/* Defender Fleet Section */}
          <SectionContainer>
            <SectionTitle>Defender Fleet</SectionTitle>
            {Object.keys(defenderFleet).map((shipType) => (
              <div style={{ textTransform: 'capitalize' }} key={shipType}>
                <Label htmlFor={`defender-${shipType}`}>{shipType}</Label>
                <FleetInput
                  id={`defender-${shipType}`}
                  type="number"
                  value={defenderFleet[shipType as keyof Fleet]}
                  onChange={(e) =>
                    handleInputChange(
                      'defender',
                      shipType as keyof Fleet,
                      e.target.value
                    )
                  }
                />
              </div>
            ))}
          </SectionContainer>

          {/* Defences Section */}
          <SectionContainer>
            <SectionTitle>Defences</SectionTitle>
            {Object.keys(defences).map((defenceType) => (
              <div style={{ textTransform: 'capitalize' }} key={defenceType}>
                <Label htmlFor={`defence-${defenceType}`}>{defenceType}</Label>
                <FleetInput
                  id={`defence-${defenceType}`}
                  type="number"
                  value={defences[defenceType as keyof DefenceLevels]}
                  onChange={(e) =>
                    handleDefenceChange(
                      defenceType as keyof DefenceLevels,
                      e.target.value
                    )
                  }
                />
              </div>
            ))}
          </SectionContainer>
        </ColumnsContainer>

        <FormattedSimulationResult
          attackerFleet={attackerFleet}
          defenderFleet={defenderFleet}
          defences={defences}
        />
      </Container>
    </>
  );
};
