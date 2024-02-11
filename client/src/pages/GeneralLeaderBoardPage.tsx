import React from 'react';
import LeadearBoardFleet from '../components/leaderboards/LeaderBoardFleet';
import LeadearBoardMain from '../components/leaderboards/LeaderBoardMain';
import LeadearBoardTech from '../components/leaderboards/LeaderBoardTech';
import Header from '../components/ui/Header';
import styled from 'styled-components';
import { useAccount } from '@starknet-react/core';
import { useTokenOf } from '../hooks/useTokenOf';

const Wrapper = styled.div`
  display: flex;
  height: 100vh; // Adjust the height as needed
`;

const Column = styled.div`
  flex: 1;
  overflow-y: auto; // If you want each column to independently scroll
  padding: 20px;
`;

const Section = styled.section`
  background: #1a2025; // Single color background to match your color requirement
  color: #c5c6c7; // A slightly brighter text color for better contrast against the dark background
  margin-bottom: 20px;
  padding: 20px;
  border-radius: 10px; // Sleek, modern border radius
  box-shadow: 0 6px 12px rgba(0, 0, 0, 0.5); // Soft box shadow for depth without a blue hue
  border: 1px solid #2a3038; // Slick border that is just slightly lighter than the background
  overflow: hidden; // Ensures content does not spill out, maintaining a clean look
  transition: all 0.2s ease-in-out; // Smooth transition for potential hover effects

  // Typography
  font-family: 'Orbitron', sans-serif; // Retaining the sci-fi theme

  // Since this is a passive element, we keep the hover effect subtle or you can remove it if not needed
  &:hover {
    box-shadow: 0 8px 16px rgba(0, 0, 0, 0.6);
    transform: translateY(-2px); // Slight raise to give a hovering effect
  }
`;

const Title = styled.h2`
  text-align: center;
  margin-bottom: 20px;
  opacity: 0.5;
`;

const GeneralLeaderboardPage = () => {
  const { address } = useAccount();
  const { planetId } = useTokenOf(address);

  const MainLeaderboard = () => <LeadearBoardMain planetId={planetId} />;
  const TechLeaderboard = () => <LeadearBoardTech planetId={planetId} />;
  const FleetLeaderboard = () => <LeadearBoardFleet planetId={planetId} />;

  return (
    <>
      <Header planetId={planetId} />
      <Wrapper>
        <Column>
          <Section>
            <Title>Main Leaderboard</Title>
            <MainLeaderboard />
          </Section>
        </Column>
        <Column>
          <Section>
            <Title>Tech Leaderboard</Title>
            <TechLeaderboard />
          </Section>
        </Column>
        <Column>
          <Section>
            <Title>Fleet Leaderboard</Title>
            <FleetLeaderboard />
          </Section>
        </Column>
      </Wrapper>
    </>
  );
};

export default GeneralLeaderboardPage;
