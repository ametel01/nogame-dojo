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
}));

interface Props {
  selectedColonyId: number;
}

export function UseCollectResources({ selectedColonyId }: Props) {
  const [isClicked, setIsClicked] = useState(false);

  const { contract } = useContract({
    abi: game.abi,
    address: GAMEADDRESS,
  });
  const { writeAsync: motherCollect, data: motherData } = useContractWrite({
    calls: [contract?.populateTransaction.collect_resources?.()],
  });

  const { writeAsync: colonyCollect, data: colonyData } = useContractWrite({
    calls: [
      contract?.populateTransaction.collect_colony_resources?.(
        selectedColonyId
      ),
    ],
  });

  const handleMotherOnClick = () => {
    void motherCollect();
    setIsClicked(true);
  };

  const handleColonyOnClick = () => {
    void colonyCollect();
    setIsClicked(true);
  };

  return (
    <>
      <StyledBox>
        <StyledButton
          fullWidth
          style={{ margin: '4px', background: '#4A63AA' }}
          onClick={
            selectedColonyId === 0 ? handleMotherOnClick : handleColonyOnClick
          }
          variant="contained"
        >
          Collect Resources
        </StyledButton>
      </StyledBox>
      {isClicked ? (
        <TransactionStatus
          name="Collect Resources"
          tx={
            selectedColonyId === 0
              ? motherData?.transaction_hash
              : colonyData?.transaction_hash
          }
        />
      ) : (
        <></>
      )}
    </>
  );
}
