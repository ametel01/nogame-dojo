import { Box, Button } from '@mui/material';
import { useDojo } from '../../dojo/useDojo';

export const GeneratePlanet = () => {
  const {
    setup: {
      systemCalls: { generatePlanet },
      // clientComponents: { GameOwnerPlanet },
    },
    account,
  } = useDojo();

  return (
    <Box position="relative" display="inline-flex">
      {/* {isPending && (
        <CircularProgress
          size={24}
          style={{
            position: 'absolute',
            top: '50%',
            left: '50%',
            marginTop: '-12px',
            marginLeft: '-12px',
          }}
        />
      )} */}
      <Button
        // variant="outlined"
        size="large"
        sx={{
          color: '#E7ECEE',
          width: '345px',
          height: '75px',
          backgroundColor: '#4A63AA',
          border: '1px solid #0F111A',
          borderRadius: '8px',
          marginTop: '32px',
          fontWeight: '700',
          '&:hover': {
            background: '#212530', // Slightly lighter than #1B1E2A for a subtle hover effect
          },
        }}
        onClick={() => {
          generatePlanet(account.account);
        }}
      >
        Mint Planet
      </Button>
    </Box>
  );
};
