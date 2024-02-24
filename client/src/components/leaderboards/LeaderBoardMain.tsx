import React from 'react';
import styled from 'styled-components';
import CircularProgress from '@mui/material/CircularProgress';
import { formatAccount, numberWithCommas } from '../../shared/utils';
import { useLeaderboardData } from '../../hooks/useLeaderboardData';

const Table = styled.table`
  width: 100%;
  border-collapse: collapse;
  margin-top: 20px;
  text-align: left;
`;

const Header = styled.th`
  background-color: #1a2025;
  padding: 10px;
  opacity: 0.5;
`;

interface RowProps {
  isHighlighted: boolean;
}

export const CenteredProgress = styled.div`
  display: flex;
  justify-content: center;
  align-items: center;
  height: 200px; // Adjust as needed
`;
// Use the type in your styled component with the correct syntax
const Row = styled.tr<RowProps>`
  background-color: ${(props) =>
    props.isHighlighted ? '#32414B' : 'transparent'};
  color: #23ce6b;
`;

const Data = styled.td`
  padding: 10px;
  // border-bottom: 1px solid #ddd;
  color: '#23CE6B';
`;

const Wrapper = styled.div`
  padding: 20px;
`;

interface Props {
  planetId: number;
}

const LeadearBoardMain = ({ planetId }: Props) => {
  const leaderboardData = useLeaderboardData(); // Using the hook

  if (!leaderboardData.length) {
    return (
      <CenteredProgress>
        <CircularProgress />
      </CenteredProgress>
    );
  }

  // Assuming the hook handles errors internally and returns an empty array on error
  return (
    <Wrapper>
      <Table>
        <thead>
          <tr>
            <Header>Rank</Header>
            <Header>Player</Header>
            <Header>Position</Header>
            <Header>Points</Header>
          </tr>
        </thead>
        <tbody>
          {leaderboardData.map((entry, index) => (
            <Row
              key={entry.planetId}
              isHighlighted={entry.planetId === planetId}
            >
              <Data>{index + 1}</Data>
              <Data>
                {entry.owner
                  ? `${formatAccount(entry.owner).substring(
                      0,
                      6
                    )}...${entry.owner.substring(entry.owner.length - 4)}`
                  : 'Unknown Account'}
              </Data>
              <Data>
                {parseInt(entry.position.system, 16)}/
                {parseInt(entry.position.orbit, 16)}
              </Data>
              <Data>{numberWithCommas(entry.points)}</Data>
            </Row>
          ))}
        </tbody>
      </Table>
    </Wrapper>
  );
};

export default LeadearBoardMain;
