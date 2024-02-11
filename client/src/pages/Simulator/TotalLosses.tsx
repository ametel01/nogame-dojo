import React, { useState, useEffect } from 'react';
import styled from 'styled-components';
import { Fleet, DefenceLevels } from '../../shared/types';
import { getBaseDefenceCost, getBaseShipsCost } from '../../constants/costs';
import { numberWithCommas } from '../../shared/utils/index';

const StyledContainer = styled.div`
  display: flex;
  flex-direction: column;
  align-items: flex-start;
  background-color: #263238;
  padding: 20px 20px;
  border-radius: 10px;
`;
const TableHeader = styled.div`
  font-size: 1.2rem;
  font-weight: bold;
  margin-bottom: 16px;
  color: #23ce6b;
  text-align: center;
`;

const TableGrid = styled.div`
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  text-align: center;
  border-radius: 8px;
`;

const TableRegularCell = styled.div`
  padding: 5px 5px;
  border-bottom: 1px solid #34495e;
  width: 100px;
`;

const TableCell = styled.div`
  width: 100px;
  padding: 5px 5px;
  text-align: left;
`;

const TableColoredCell = styled.div`
  width: 100px;
  color: #23ce6b;
  padding: 5px 5px;
`;

interface Props {
  attackerFleet: Fleet;
  defenderFleet: Fleet;
  defences: DefenceLevels;
  attackerDefeated: boolean;
}

type Cost = {
  steel: number;
  quartz: number;
  tritium: number;
};

export const TotalLosses = ({
  attackerFleet,
  defenderFleet,
  defences,
  attackerDefeated,
}: Props) => {
  const [attackerLosses, setAttackerLosses] = useState<Cost>({
    steel: 0,
    quartz: 0,
    tritium: 0,
  });
  const [defenderLosses, setDefenderLosses] = useState<Cost>({
    steel: 0,
    quartz: 0,
    tritium: 0,
  });
  const shipsCost = getBaseShipsCost();
  const defencesCost = getBaseDefenceCost();
  useEffect(() => {
    if (
      attackerFleet != undefined &&
      defenderFleet != undefined &&
      defences != undefined
    ) {
      // Calculate attacker losses
      const newAttackerLosses = Object.entries(attackerFleet).reduce(
        (acc, [shipType, quantity]) => {
          const cost: Cost = (shipsCost as Record<string, Cost>)[
            shipType as keyof typeof shipsCost
          ];
          acc.steel += cost.steel * quantity;
          acc.quartz += cost.quartz * quantity;
          acc.tritium += cost.tritium * quantity;
          return acc;
        },
        { steel: 0, quartz: 0, tritium: 0 }
      );
      setAttackerLosses(newAttackerLosses);

      // Calculate defender fleet losses
      const newDefenderFleetLosses = Object.entries(defenderFleet).reduce(
        (acc, [shipType, quantity]) => {
          const cost: Cost = (shipsCost as Record<string, Cost>)[
            shipType as keyof typeof shipsCost
          ];
          acc.steel += cost.steel * quantity;
          acc.quartz += cost.quartz * quantity;
          acc.tritium += cost.tritium * quantity;
          return acc;
        },
        { steel: 0, quartz: 0, tritium: 0 }
      );

      // Calculate defences losses
      const newDefencesLosses = Object.entries(defences).reduce(
        (acc, [defenceType, quantity]) => {
          const cost: Cost = (defencesCost as Record<string, Cost>)[
            defenceType as keyof typeof defencesCost
          ];
          if (cost) {
            acc.steel += cost.steel * quantity;
            acc.quartz += cost.quartz * quantity;
            acc.tritium += cost.tritium * quantity;
          }
          return acc;
        },
        { steel: 0, quartz: 0, tritium: 0 }
      );

      // Combine defender fleet and defences losses
      const totalDefenderLosses = {
        steel: newDefenderFleetLosses.steel + newDefencesLosses.steel,
        quartz: newDefenderFleetLosses.quartz + newDefencesLosses.quartz,
        tritium: newDefenderFleetLosses.tritium + newDefencesLosses.tritium,
      };
      setDefenderLosses(totalDefenderLosses);
    }
  }, [attackerFleet, defenderFleet, defences, shipsCost, defencesCost]);

  return (
    <StyledContainer>
      <TableHeader>Total Resources Loss</TableHeader>
      <TableGrid>
        <TableRegularCell></TableRegularCell>
        <TableRegularCell>Steel</TableRegularCell>
        <TableRegularCell>Quartz</TableRegularCell>
        <TableRegularCell>Tritium</TableRegularCell>

        <TableCell>Attacker</TableCell>
        <TableColoredCell>
          {numberWithCommas(attackerLosses.steel)}
        </TableColoredCell>
        <TableColoredCell>
          {numberWithCommas(attackerLosses.quartz)}
        </TableColoredCell>
        <TableColoredCell>
          {numberWithCommas(attackerLosses.tritium)}
        </TableColoredCell>
      </TableGrid>
      {/* Defender losses */}
      <TableGrid>
        <TableRegularCell></TableRegularCell>
        <TableRegularCell></TableRegularCell>
        <TableRegularCell></TableRegularCell>
        <TableRegularCell></TableRegularCell>

        <TableCell>Defender</TableCell>
        <TableColoredCell>
          {numberWithCommas(defenderLosses.steel)}
        </TableColoredCell>
        <TableColoredCell>
          {numberWithCommas(defenderLosses.quartz)}
        </TableColoredCell>
        <TableColoredCell>
          {numberWithCommas(defenderLosses.tritium)}
        </TableColoredCell>
      </TableGrid>
      <TableGrid>
        <TableRegularCell></TableRegularCell>
        <TableRegularCell></TableRegularCell>
        <TableRegularCell></TableRegularCell>
        <TableRegularCell></TableRegularCell>

        <TableCell>Debris</TableCell>
        <TableColoredCell>
          {numberWithCommas(
            Math.round((defenderLosses.steel + attackerLosses.steel) / 3)
          )}
        </TableColoredCell>
        <TableColoredCell>
          {numberWithCommas(
            Math.round((defenderLosses.quartz + attackerLosses.quartz) / 3)
          )}
        </TableColoredCell>
        <TableColoredCell>{0}</TableColoredCell>
      </TableGrid>
      {attackerDefeated ? (
        <TableHeader style={{ marginTop: '20px' }}>Defender Wins!</TableHeader>
      ) : (
        <TableHeader style={{ marginTop: '20px' }}>Attacker Wins!</TableHeader>
      )}
    </StyledContainer>
  );
};
