import React, { useState } from 'react';
import Button from '@mui/material/Button';
import AccountBalanceWalletIcon from '@mui/icons-material/AccountBalanceWallet';
import { styled } from '@mui/system';
import { BurnerModal } from './BurnerModal';

const ToolbarWalletButton = styled(Button)({
  width: 'auto',
  borderRadius: 8,
  padding: '8px 32px',
  fontWeight: 'bold',
  textTransform: 'capitalize',
  letterSpacing: '0.1em',
  backgroundColor: '#4A63AA', // Slightly lighter background for the WalletButton
  border: '1px solid #28408F', // Darker border for definition
  display: 'flex',
  color: '#F4F3EE',
  justifyContent: 'center',
  '&:hover': {
    background: '#445C9C', // Slightly lighter than #1B1E2A for a subtle hover effect
  },
});

export default function ConnectWallet() {
  const [isModalOpen, setIsModalOpen] = useState(false); // New state for modal visibility

  const toggleModal = () => {
    setIsModalOpen(!isModalOpen); // Function to toggle modal visibility
  };

  return (
    <>
      <ToolbarWalletButton
        startIcon={<AccountBalanceWalletIcon />}
        onClick={toggleModal} // Assigning the toggle function to the onClick event
      >
        Create Burner
      </ToolbarWalletButton>
      <BurnerModal open={isModalOpen} onClose={toggleModal} />{' '}
      {/* Pass the open state and onClose handler */}
    </>
  );
}
