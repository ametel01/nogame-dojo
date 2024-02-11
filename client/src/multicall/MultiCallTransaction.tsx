import React, { useState, useCallback } from 'react';
import styled from 'styled-components';
import Modal from '@mui/material/Modal';
import ShoppingCartIcon from '@mui/icons-material/ShoppingCart';
import DeleteIcon from '@mui/icons-material/Delete';
import Badge from '@mui/material/Badge';
import { StyledButton, HeaderButton } from '../shared/styled/Button';
import { useContractWrite } from '@starknet-react/core';
import { useBlockchainCall } from '../context/BlockchainCallContext';
// Styled Components
const StyledModal = styled(Modal)`
  display: flex;
  align-items: center;
  justify-content: center;
`;

const StyledModalContent = styled.div`
  background-color: #1a2025;
  color: #cfd8dc;
  border-radius: 8px;
  padding: 20px;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.7);
  max-width: 500px;
  width: 100%;
  overflow-y: auto; // Add this for vertical scroll
  max-height: 40vh; // Adjust as needed
  padding-bottom: 20px; // Optional, for extra space at the bottom
`;

const CartTitle = styled.h3`
  margin-bottom: 20px;
  text-align: center;
`;

const StyledActionList = styled.ul`
  list-style: none;
  padding: 0;
  margin: 0;
`;

const StyledActionItem = styled.li`
  background-color: #2c3e50;
  color: #ecf0f1;
  border: 1px solid #34495e;
  font-size: 16px;
  border-radius: 4px;
  padding: 10px;
  margin: 10px 0;
  display: flex;
  justify-content: space-between;
  align-items: center;
`;

const StyledBinIcon = styled(DeleteIcon)`
  cursor: pointer;
  color: #e74c3c;
`;

const StyledCartIcon = styled(ShoppingCartIcon)`
  cursor: pointer;
`;

const StyledBadge = styled(Badge)`
  .MuiBadge-badge {
    background-color: #ff1744; // Red badge
    color: white;
  }
`;

export type CallType = 'compound' | 'tech' | 'ship' | 'defence';

export type SingleCall = {
  type: string;
  name: string | undefined;
  quantity: number;
  colonyId: number;
};

export function MultiCallTransaction() {
  const [isOpen, setIsOpen] = useState(false);
  const {
    selectedCalls,
    setSelectedCalls,
    singleCalls,
    setSingleCalls,
    removeCall,
  } = useBlockchainCall();
  const { writeAsync } = useContractWrite({ calls: selectedCalls });

  const handleModalClose = () => {
    setIsOpen(false);
  };

  const toggleModal = useCallback((open: boolean) => {
    setIsOpen(open);
  }, []);

  const handleClick = () => {
    writeAsync();
    setSelectedCalls([]);
    setSingleCalls([]);
  };

  return (
    <>
      <HeaderButton onClick={() => toggleModal(true)}>
        <StyledBadge badgeContent={selectedCalls.length} color="secondary">
          <StyledCartIcon />
        </StyledBadge>
      </HeaderButton>
      <StyledModal open={isOpen} onClose={handleModalClose}>
        <StyledModalContent>
          <CartTitle>Your Transactions Cart</CartTitle>
          <StyledActionList>
            {singleCalls.map((call, index) => {
              const actionText =
                call.colonyId == 0
                  ? call.type === 'compound' || call.type === 'tech'
                    ? `Upgrade ${call.name} x${call.quantity}`
                    : `Build ${call.name} x${call.quantity}`
                  : call.type === 'compound' || call.type === 'tech'
                  ? `Upgrade ${call.name} x${call.quantity} in colony ${call.colonyId}`
                  : `Build ${call.name} x${call.quantity} in colony ${call.colonyId}`;

              return (
                <StyledActionItem key={index}>
                  <span>{actionText}</span>
                  <StyledBinIcon
                    onClick={(e) => {
                      e.stopPropagation();
                      removeCall(index);
                    }}
                  />
                </StyledActionItem>
              );
            })}
          </StyledActionList>
          <StyledButton
            variant="contained"
            size="large"
            onClick={handleClick}
            color="primary"
            fullWidth
          >
            Send Transaction
          </StyledButton>
        </StyledModalContent>
      </StyledModal>
    </>
  );
}
