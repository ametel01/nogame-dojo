import React from 'react';
import AppBar from '@mui/material/AppBar';
import Toolbar from '@mui/material/Toolbar';
import { HeaderButton } from '../../shared/styled/Button';
import { styled } from '@mui/material/styles';
import { FleetMovements } from './FleetMovements';
import { Link } from 'react-router-dom';
import WalletHeader from '../../ui/auth/WalletHeader';
import { useDojo } from '../../dojo/useDojo';

const HeaderWrapper = styled(AppBar)({
  backgroundColor: '#1a2025',
  margin: 0,
  padding: 0,
  boxShadow: 'none',
});

const StyledToolbar = styled(Toolbar)({
  display: 'flex',
  alignItems: 'center',
  justifyContent: 'space-between',
  padding: '0 16px', // Consistent padding
  minHeight: '48px', // Standard height for toolbar
  background: 'rgba(0, 0, 0, 0.2)',
});

const Spacer = styled('div')({
  flex: '1',
});

interface Props {
  planetId: number;
}

const Header = ({ planetId }: Props) => {
  const { account } = useDojo();

  return (
    <HeaderWrapper position="static">
      <StyledToolbar style={{ minHeight: '48px', padding: '0px 16px' }}>
        <WalletHeader account={account?.account.address} />
        <Spacer />
        <HeaderButton variant="text">
          <Link to="/" style={{ textDecoration: 'none', color: 'inherit' }}>
            DashBoard
          </Link>
        </HeaderButton>
        {/* <ConnectWallet /> */}
        <FleetMovements planetId={planetId || 0} />

        {/* <HeaderButton>
          <Link
            to="/pioneer"
            style={{ textDecoration: 'none', color: 'inherit' }}
          >
            Pioneer NFT
          </Link>
        </HeaderButton>
        <HeaderButton variant="text">
          <Link
            to="/battlereports"
            style={{ textDecoration: 'none', color: 'inherit' }}
          >
            Reports
          </Link>
  </HeaderButton> */}
        <HeaderButton
          variant="text"
          sx={{ display: 'flex', alignItems: 'center' }}
        >
          <Link
            to="/leaderboard"
            style={{ textDecoration: 'none', color: 'inherit' }}
          >
            LeaderBoard
          </Link>
        </HeaderButton>
        {/* <HeaderButton
          variant="text"
          sx={{ display: 'flex', alignItems: 'center' }}
        >
          <Link
            to="/simulator"
            style={{ textDecoration: 'none', color: 'inherit' }}
          >
            Simulator
          </Link>
        </HeaderButton> */}
        {/* <MultiCallTransaction /> */}
      </StyledToolbar>
    </HeaderWrapper>
  );
};

export default Header;
