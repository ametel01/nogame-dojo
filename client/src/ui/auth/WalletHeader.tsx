import React, { useState } from 'react';
import styled from 'styled-components';
import { BurnerModal } from './BurnerModal';

const HeaderWalletContainer = styled.div`
  color: #c5c6c7;
  font-weight: bold;
  opacity: 0.8;
  display: flex;
  padding: 12px;
  border-top: 2px solid #151a1e;
  cursor: pointer; // Makes the cursor a pointer when hovering over the element
  transition: background-color 0.3s, opacity 0.3s; // Smooth transition for background and opacity

  &:hover {
    background-color: #1f2a30; // Change background color on hover
    opacity: 1; // Increase opacity on hover for a more pronounced effect
  }
`;

interface WalletHeaderProps {
  account?: string;
}

const WalletHeader = ({ account }: WalletHeaderProps) => {
  const [isModalOpen, setIsModalOpen] = useState(false); // New state for modal visibility

  const toggleModal = () => {
    setIsModalOpen(!isModalOpen); // Function to toggle modal visibility
  };

  const shortenedAddress = account
    ? `${account.substring(0, 6)}...${account.slice(-4)}`
    : 'null';

  return (
    <>
      <HeaderWalletContainer onClick={toggleModal}>
        {shortenedAddress}
      </HeaderWalletContainer>
      <BurnerModal open={isModalOpen} onClose={toggleModal} />
    </>
  );
};

export default WalletHeader;
