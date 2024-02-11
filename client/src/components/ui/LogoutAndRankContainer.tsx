import React, { useMemo, useEffect, useState } from 'react';
import styled from 'styled-components';
import { Typography } from '@mui/material';
import nogameLogo from '../../assets/logos/NoGameLogo.webp';

import { numberWithCommas } from '../../shared/utils';

const LogoContainer = styled.div`
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  margin-top: 16px;
  padding: 16px 18px 18px;
  gap: 16px;
`;

const RankContainer = styled.div`
  display: flex;
  flex-direction: column;
  align-items: flex-start;
  padding: 4px 16px;
  gap: 10px;
  width: 192px;
`;

const RankLineContainer = styled.div`
  width: 100%;
  display: flex;
  justify-content: space-between;
  align-items: center; // Vertically align content in the middle
  font-weight: 500;
`;

const TitleContainer = styled(Typography)({
  fontWeight: 500,
  lineHeight: '18px',
  letterSpacing: '0.02em',
  color: 'grey',
  marginLeft: '4px',
});

const TrophyDiv = styled.div`
  display: flex;
  align-items: center; // Vertically align content in the middle
  gap: 8px; // Gap between icon and title for better spacing
`;

const StyledImage = styled.img`
  width: 200px;
  maxwidth: 100%;
  height: auto;
  objectfit: contain;
`;

interface LeaderboardEntry {
  planet_id: string; // Assuming planet_id is a string based on your initial data
  account: string;
  net_amount: string; // Assuming net_amount is a string that should be converted to a number
}

interface Props {
  planetId: number;
}

const LogoAndRankContainer = ({ planetId }: Props) => {
  const [leaderboard, setLeaderboard] = useState<LeaderboardEntry[]>([]);
  const [error, setError] = useState<string>('');
  const [isLoading, setIsLoading] = useState<boolean>(true);

  const nodeEnv = import.meta.env.VITE_NODE_ENV;
  const apiUrl =
    nodeEnv === 'production'
      ? 'https://www.api.testnet.no-game.xyz/leaderboard'
      : 'http://localhost:3001/leaderboard';

  useEffect(() => {
    const fetchLeaderboard = async () => {
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

    fetchLeaderboard();
  }, [apiUrl]);

  const score = useMemo(() => {
    const planetData = leaderboard.find(
      (planet) => planet.planet_id === planetId.toString()
    );
    return planetData ? Number(planetData.net_amount) : 0;
  }, [leaderboard, planetId]);

  if (isLoading) {
    return <div>Loading...</div>;
  }

  if (error) {
    return <div>Error: {error}</div>;
  }

  return (
    <LogoContainer>
      <StyledImage src={nogameLogo} alt="NoGame Logo" />
      <RankContainer>
        <RankLineContainer>
          <TrophyDiv>
            <TitleContainer>Score</TitleContainer>
          </TrophyDiv>
          {numberWithCommas(Math.ceil(score / 1000))}
        </RankLineContainer>
      </RankContainer>
    </LogoContainer>
  );
};

export default LogoAndRankContainer;
