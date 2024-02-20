import React from 'react';
import { type FC } from 'react';
import NoGameLogo from '../../assets/logos/NoGameLogo.webp';
import ConnectWalletButton from './ConnectWallet';
import { GeneratePlanet } from '../buttons/GeneratePlanet';
import { BurnerAccount } from '@dojoengine/create-burner';
import * as styles from './styled';

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
    <styles.MainWrapper>
      <styles.ConnectWalletLogo src={NoGameLogo} alt="No Game Logo" />
      <styles.ConnectWalletText>
        Welcome to NoGame, an intergalactic, real-time multiplayer game set in
        the vastness of the cosmos, powered by Starknet technology. Connect your
        digital wallet to initiate the creation of your very own celestial body!
      </styles.ConnectWalletText>
    </styles.MainWrapper>
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
    <styles.MainWrapper>
      {account?.list().length !== 0 ? (
        <styles.StyledAddress>
          {formatAddress(account?.account.address)}
        </styles.StyledAddress>
      ) : null}
      <styles.RowCentered>
        <styles.StyledLogo src={NoGameLogo} alt="No Game Logo" />
      </styles.RowCentered>
      <styles.SubTextBefore>
        In NoGame each participant can mint a single planet NFT per wallet,
        granting access to the game. Prices for minting are set by a reverse
        Dutch auction: high demand increases prices, while lower demand reduces
        them. These prices, updated in real time by a smart contract, can
        fluctuate, so check back later if they are currently too high.
      </styles.SubTextBefore>
      <GeneratePlanet />
    </styles.MainWrapper>
  );
};

export default AuthScreen;
