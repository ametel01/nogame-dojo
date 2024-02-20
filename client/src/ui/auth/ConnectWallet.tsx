import React, { useState } from 'react';
import { BurnerModalWalletButton } from './styled';
import AccountBalanceWalletIcon from '@mui/icons-material/AccountBalanceWallet';
import { BurnerModal } from './BurnerModal';

export default function ConnectWallet() {
  const [isModalOpen, setIsModalOpen] = useState(false); // New state for modal visibility

  const toggleModal = () => {
    setIsModalOpen(!isModalOpen); // Function to toggle modal visibility
  };

  return (
    <div style={{ padding: '12px', width: '20%' }}>
      <BurnerModalWalletButton
        startIcon={<AccountBalanceWalletIcon />}
        onClick={toggleModal} // Assigning the toggle function to the onClick event
      >
        Create Burner
      </BurnerModalWalletButton>
      <BurnerModal open={isModalOpen} onClose={toggleModal} />{' '}
      {/* Pass the open state and onClose handler */}
    </div>
  );
}
