import { Button } from '@mui/material';
import { styled } from '@mui/system';

export const StyledButton = styled(Button)(() => ({
  borderRadius: 8,
  fontWeight: 600,
  fontSize: 14,
  textTransform: 'capitalize',
  size: 'large',
  color: '#F4F3EE',
  backgroundColor: '#4A63AA',
  // border: '1px solid #2E3A45',
  letterSpacing: '0.1em',
  boxShadow: '0 2px 4px rgba(0, 0, 0, 0.1)',
  '&:hover': {
    background: '#2E434C',
  },
  '&:disabled': {
    backgroundColor: '#3B3F53',
  },
}));

export const HeaderButton = styled(Button)({
  margin: '0 8px', // Even spacing on both sides
  color: '#c5c6c7',
  fontWeight: 'bold',
  letterSpacing: '0.05em', // Adjust for readability
  '&:hover': {
    backgroundColor: 'rgba(255, 255, 255, 0.08)', // Subtle hover effect
    color: '#FFF', // Brighter text on hover for contrast
  },
  '& .MuiButton-label': {
    // Target the label within the button
    textTransform: 'none', // Prevent uppercase text-transform
    fontSize: '1rem', // Standard font size
  },
});
