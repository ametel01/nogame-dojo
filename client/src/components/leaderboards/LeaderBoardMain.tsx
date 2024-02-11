import React, { useState, useEffect } from 'react';
import styled from 'styled-components';
import CircularProgress from '@mui/material/CircularProgress';
import { formatAccount, numberWithCommas } from '../../shared/utils';

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

interface FetchData {
  planet_id: number;
  account: string;
  net_amount: number;
}

interface Props {
  planetId: number;
}

const LeadearBoardMain = ({ planetId }: Props) => {
  const [leaderboard, setLeaderboard] = useState([]);
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const nodeEnv = import.meta.env.VITE_NODE_ENV;
  const apiUrl =
    nodeEnv === 'production'
      ? 'https://www.api.testnet.no-game.xyz/leaderboard'
      : 'http://localhost:3001/leaderboard';

  useEffect(() => {
    const fetchData = async () => {
      setIsLoading(true);
      setError(null);
      try {
        const response = await fetch(apiUrl);
        if (!response.ok) {
          throw new Error('Something went wrong!');
        }
        const data = await response.json();
        setLeaderboard(data);
      } catch (error) {
        if (error instanceof Error) {
          setError(error.message);
        } else {
          setError('An unexpected error occurred');
        }
      } finally {
        setIsLoading(false);
      }
    };

    fetchData();
  }, [apiUrl]);

  if (isLoading) {
    return (
      <CenteredProgress>
        <CircularProgress />
      </CenteredProgress>
    );
  }

  if (error) {
    return <div>Error: {error}</div>;
  }

  return (
    <Wrapper>
      <Table>
        <thead>
          <tr>
            <Header>Rank</Header>
            <Header>Player</Header>
            <Header>Planet</Header>
            <Header>Points</Header>
          </tr>
        </thead>
        <tbody>
          {leaderboard.map((entry: FetchData, index: number) => (
            <Row
              key={entry.planet_id}
              isHighlighted={Number(entry.planet_id) === Number(planetId)}
            >
              <Data>{index + 1}</Data>
              <Data>
                {entry.account
                  ? `${formatAccount(entry.account).substring(
                      0,
                      6
                    )}...${entry.account.substring(entry.account.length - 4)}`
                  : 'Unknown Account'}
              </Data>
              <Data>{entry.planet_id}</Data>
              <Data>
                {numberWithCommas(Math.ceil(Number(entry.net_amount) / 1000))}
              </Data>
            </Row>
          ))}
        </tbody>
      </Table>
    </Wrapper>
  );
};

export default LeadearBoardMain;
