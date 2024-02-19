import React from 'react';
import styled from 'styled-components';
import { type FC } from 'react';
import NoGameLogo from '../../assets/logos/NoGameLogo.webp';
import { ColumnCenter } from '../../shared/styled/Column';
import { RowCentered } from '../../components/ui/Row';
import ConnectWalletButton from '../wallet/ConnectWallet';
import { GeneratePlanet } from '../../components/buttons/GeneratePlanet';
import { BurnerAccount } from '@dojoengine/create-burner';

const MainWrapper = styled(ColumnCenter)`
  height: 100vh;
  justify-content: center; // Evenly distribute the child elements
  gap: 16px;
`;

const SubTextBefore = styled('div')`
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

const StyledLogo = styled('img')`
  margin-top: 100px;
`;

export const TopRightButtonContainer = styled('div')`
  position: absolute;
  top: 20px; /* Adjust the top position as needed */
  right: 20px; /* Adjust the right position as needed */
`;

const StyledAddress = styled('div')`
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

const ConnectWalletLogo = styled(StyledLogo)`
  margin-top: 20px;
`;

const ConnectWalletText = styled(SubTextBefore)`
  margin-top: 16px;
  font-size: 22px;
  max-width: 60%;
`;

interface AuthScreenProps {
  account?: BurnerAccount;
  hasGeneratedPlanets?: boolean;
}

type ConnectWalletViewProps = Omit<
  AuthScreenProps,
  'generatePlanet' | 'hasGeneratedPlanets'
>;

const AuthScreen = ({
  account,
  hasGeneratedPlanets = true,
}: AuthScreenProps) => {
  if (!hasGeneratedPlanets) {
    return (
      <>
        <ConnectWalletButton />
        <GeneratePlanetView account={account} />
      </>
    );
  }

  return <ConnectWalletView account={account} />;
};

const ConnectWalletView: FC<ConnectWalletViewProps> = () => {
  return (
    <MainWrapper>
      <ConnectWalletLogo src={NoGameLogo} alt="No Game Logo" />
      <ConnectWalletText>
        Welcome to NoGame, an intergalactic, real-time multiplayer game set in
        the vastness of the cosmos, powered by Starknet technology. Connect your
        digital wallet to initiate the creation of your very own celestial body!
      </ConnectWalletText>
    </MainWrapper>
  );
};

const formatAddress = (address: string | undefined) => {
  if (address && address.length > 10) {
    return `${address.substring(0, 6)}...${address.substring(
      address.length - 4
    )}`;
  }
  return address;
};

interface PlanetViewProp {
  account?: BurnerAccount;
}

const GeneratePlanetView = ({ account }: PlanetViewProp) => {
  console.log('account', account?.account);
  return (
    <MainWrapper>
      {account?.list().length !== 0 ? (
        <StyledAddress>{formatAddress(account?.account.address)}</StyledAddress>
      ) : null}
      <RowCentered>
        <StyledLogo src={NoGameLogo} alt="No Game Logo" />
      </RowCentered>
      <SubTextBefore>
        In NoGame each participant can mint a single planet NFT per wallet,
        granting access to the game. Prices for minting are set by a reverse
        Dutch auction: high demand increases prices, while lower demand reduces
        them. These prices, updated in real time by a smart contract, can
        fluctuate, so check back later if they are currently too high.
      </SubTextBefore>
      <GeneratePlanet />
    </MainWrapper>
  );
};

export default AuthScreen;
