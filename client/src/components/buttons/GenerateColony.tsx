import React, { useState } from 'react';
import { Box } from '@mui/material';
import { styled } from '@mui/system';
import { TransactionStatus } from '../ui/TransactionStatus';
import { GAMEADDRESS } from '../../constants/addresses';
import game from '../../constants/nogame.json';
import { useContractWrite, useContract } from '@starknet-react/core';
import { StyledButton } from '../../shared/styled/Button';

const StyledBox = styled(Box)(() => ({
  position: 'relative',
  display: 'flex',
  justifyContent: 'center', // center horizontally
  alignItems: 'center', // center vertically
  padding: '8px 0',
}));

interface Props {
  isActivated: boolean;
}

export function GenerateColony({ isActivated }: Props) {
  const [isClicked, setIsClicked] = useState(false);

  const { contract } = useContract({
    abi: game.abi,
    address: GAMEADDRESS,
  });
  const { writeAsync, data } = useContractWrite({
    calls: [contract?.populateTransaction.generate_colony?.()],
  });

  const handleOnClick = () => {
    void writeAsync();
    setIsClicked(true);
  };

  return (
    <>
      <StyledBox>
        {isActivated ? (
          <StyledButton
            fullWidth
            style={{ margin: '4px', background: '#4A63AA' }}
            onClick={handleOnClick}
            variant="contained"
            disabled={!isActivated}
          >
            Generate Colony
          </StyledButton>
        ) : (
          <StyledButton
            fullWidth
            style={{ margin: '4px', background: '#3B3F53' }}
            variant="contained"
            disabled={!isActivated}
          >
            No Requirements
          </StyledButton>
        )}
      </StyledBox>
      {isClicked ? (
        <TransactionStatus
          name="Collect Resources"
          tx={data?.transaction_hash}
        />
      ) : (
        <></>
      )}
    </>
  );
}
