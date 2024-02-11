import React, { useEffect, useState } from 'react';
import { useSimulation } from '../../hooks/useSimulation';
import { Fleet, DefenceLevels } from '../../shared/types';
import { CircularProgress, Typography, Box } from '@mui/material';
import styled from 'styled-components';
import { ColumnsContainer, SectionTitle } from '.';
import { TotalLosses } from './TotalLosses';

interface Props {
  attackerFleet: Fleet;
  defenderFleet: Fleet;
  defences: DefenceLevels;
}

const LabelText = styled(Typography)`
  color: white;
  width: 150px; // Fixed width of 150px
  display: inline-block; // Necessary to apply width to inline elements like Typography
  text-align: left; // Ensure the text is aligned to the left within the fixed width
`;

const SectionContainer = styled.div`
  display: flex;
  flex-direction: column;
  margin-right: 30px;
  background-color: #263238;
  padding: 15px;
  border-radius: 10px;
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.5);
`;

const LoadingContainer = styled(Box)`
  display: flex;
  justify-content: center;
  align-items: center;
  height: 100vh;
  background-color: #f5f5f5; // Light background for the loading container
`;

export const LossesRow = styled.div`
  display: flex;
  justify-content: space-between;
  margin-bottom: 10px; // Add space between rows
`;

export const LossValue = styled.span`
  display: inline-block;
  width: 100px; // Adjust width as needed
  margin-left: 10px; // Space between label and value
  padding: 8px;
  font-size: 0.8rem;
  border-radius: 5px;
  box-shadow: inset 0 2px 4px rgba(0, 0, 0, 0.3);
  background-color: #2c3e50;
  color: #23ce6b;
  text-align: center;
`;

function isFleetEmpty(before: Fleet, after: Fleet) {
  return Object.keys(after).every(
    (key) => after[key as keyof Fleet] === before[key as keyof Fleet]
  );
}

const FormattedSimulationResult = ({
  attackerFleet,
  defenderFleet,
  defences,
}: Props) => {
  const { result } = useSimulation(attackerFleet, defenderFleet, defences);
  // Define states for losses
  const [attackerLosses, setAttackerLosses] = useState({
    carrier: 0,
    scraper: 0,
    sparrow: 0,
    frigate: 0,
    armade: 0,
  });
  const [defenderLosses, setDefenderLosses] = useState({
    carrier: 0,
    scraper: 0,
    sparrow: 0,
    frigate: 0,
    armade: 0,
  });
  const [defencesLosses, setDefencesLosses] = useState({
    celestia: 0,
    blaster: 0,
    beam: 0,
    astral: 0,
    plasma: 0,
  });

  useEffect(() => {
    if (result !== undefined) {
      setAttackerLosses({
        carrier: Number(result.attacker_carrier),
        scraper: Number(result.attacker_scraper),
        sparrow: Number(result.attacker_sparrow),
        frigate: Number(result.attacker_frigate),
        armade: Number(result.attacker_armade),
      });
      setDefenderLosses({
        carrier: Number(result.defender_carrier),
        scraper: Number(result.defender_scraper),
        sparrow: Number(result.defender_sparrow),
        frigate: Number(result.defender_frigate),
        armade: Number(result.defender_armade),
      });
      setDefencesLosses({
        celestia: Number(result.celestia),
        blaster: Number(result.blaster),
        beam: Number(result.beam),
        astral: Number(result.astral),
        plasma: Number(result.plasma),
      });
    }
  }, [result]);

  if (result === undefined) {
    <LoadingContainer>
      <CircularProgress />
    </LoadingContainer>;
  }

  const isAttackerDefeated = isFleetEmpty(attackerFleet, attackerLosses);

  const LossesDisplay = ({
    title,
    losses,
  }: {
    title: string;
    losses: Record<string, number>;
  }) => (
    <>
      <SectionTitle>{title}</SectionTitle>
      {Object.entries(losses).map(([key, value]) => (
        <LossesRow key={key}>
          <LabelText style={{ letterSpacing: '0.1rem' }}>{`${
            key.charAt(0).toUpperCase() + key.slice(1)
          }`}</LabelText>
          <LossValue>{value}</LossValue>
        </LossesRow>
      ))}
    </>
  );

  return (
    <ColumnsContainer>
      <SectionContainer>
        <LossesDisplay title="Attacker Losses" losses={attackerLosses} />
      </SectionContainer>
      <SectionContainer>
        <LossesDisplay title="Defender Losses" losses={defenderLosses} />
      </SectionContainer>
      <SectionContainer>
        <LossesDisplay title="Defences Losses" losses={defencesLosses} />
      </SectionContainer>
      <TotalLosses
        attackerFleet={attackerLosses}
        defenderFleet={defenderLosses}
        defences={defencesLosses}
        attackerDefeated={isAttackerDefeated}
      />
    </ColumnsContainer>
  );
};

export default FormattedSimulationResult;
