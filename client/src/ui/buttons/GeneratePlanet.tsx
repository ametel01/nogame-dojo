import styled from 'styled-components';
import Box from '@mui/material/Box';
import Button from '@mui/material/Button';
import { useDojo } from '../../dojo/useDojo';

const StyledButton = styled(Button)`
  && {
    color: #e7ecee;
    width: 345px;
    height: 75px;
    background-color: #4a63aa;
    border: 1px solid #0f111a;
    border-radius: 8px;
    margin-top: 32px;
    font-weight: 700;

    &:hover {
      background: #212530; /* Slightly lighter than #1B1E2A for a subtle hover effect */
    }

    &:focus {
      outline: none; /* Removes the focus outline */
    }
  }
`;

export const GeneratePlanet = () => {
  const {
    setup: {
      systemCalls: { generatePlanet },
    },
    account,
  } = useDojo();

  return (
    <Box position="relative" display="inline-flex">
      <StyledButton
        size="large"
        onClick={() => {
          generatePlanet(account.account);
        }}
      >
        Generate Planet
      </StyledButton>
    </Box>
  );
};
