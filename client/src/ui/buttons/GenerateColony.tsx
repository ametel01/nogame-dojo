import React, { useState } from 'react';
import { Box } from '@mui/material';
import { styled } from '@mui/system';
import { StyledButton } from '../../shared/styled/Button';
import { useDojo } from '../../dojo/useDojo';

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
  const {
    setup: {
      systemCalls: { generateColony },
    },
    account,
  } = useDojo();
  const [isClicked, setIsClicked] = useState(false);

  const handleOnClick = () => {
    void generateColony(account?.account);
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
    </>
  );
}
