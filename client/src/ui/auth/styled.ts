import styled from 'styled-components';
import { ColumnCenter } from '../../shared/styled/Column';
export { RowCentered } from '../../components/ui/Row';
import Button from '@mui/material/Button';
import { Box } from '@mui/system';

export const MainWrapper = styled(ColumnCenter)`
  justify-content: center; // Evenly distribute the child elements
  gap: 16px;
`;

export const SubTextBefore = styled('div')`
  margin-top: 24px;
  // margin-bottom: 24px;
  font-weight: 400;
  font-size: 20px;
  line-height: 42px;
  text-align: center;
  letter-spacing: 0.02em;
  padding: 0 15px 16px;
  width: 70%;
  opacity: 0.8;
  margin-y: 80px;
`;

export const StyledLogo = styled('img')`
  align-self: center;
  margin-top: 96px;
`;

export const TopRightButtonContainer = styled('div')`
  position: absolute;
  top: 20px; /* Adjust the top position as needed */
  right: 20px; /* Adjust the right position as needed */
`;

export const StyledAddress = styled('div')`
  display: flex;
  align-items: center;
  position: absolute;
  top: 20px;
  right: 20px;
  font-size: 16px;
  opacity: 0.8;
  background-color: rgba(34, 36, 45, 0.8); // Optional: Add background color
  padding: 8px; // Optional: Add padding
  border-radius: 8px; // Optional: Round corners
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.3); // Optional: Add shadow for depth
`;

export const ConnectWalletLogo = styled(StyledLogo)`
  //   margin-top: 20px;
`;

export const ConnectWalletText = styled(SubTextBefore)`
  margin-top: 16px;
  font-size: 22px;
  max-width: 60%;
`;

export const BurnerModalBox = styled(Box)({
  fontWeight: 600,
  fontSize: 20,
  position: 'absolute',
  top: '50%',
  left: '50%',
  transform: 'translate(-50%, -50%)',
  backgroundColor: '#1B1E2A',
  border: '1px solid #282C3E',
  borderRadius: 16,
  boxShadow: '0px 3px 5px rgba(0, 0, 0, 0.2)',
  padding: '24px 12px',
  display: 'flex',
  flexDirection: 'column',
  width: '30%',
});

export const BurnerModalWalletButton = styled(Button)`
  && {
    width: 100%;
    border-radius: 8px;
    padding: 8px 32px;
    text-transform: capitalize;
    letter-spacing: 0.1em;
    background-color: #282c3e; /* Slightly lighter background for the WalletButton */
    display: flex;
    color: #f4f3ee;
    justify-content: center;

    &:hover {
      background: #202332; /* Slightly lighter than #1B1E2A for a subtle hover effect */
    }

    &:focus {
      outline: none; /* Removes the focus outline */
    }
  }
`;

export const BurnerModalUl = styled('ul')({
  padding: '8px',
  flexGrow: 1,
});

export const BurnerModalLi = styled('li')({
  listStyleType: 'none',
  margin: '8px',
});
