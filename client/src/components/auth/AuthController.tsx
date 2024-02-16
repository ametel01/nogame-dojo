import { useComponentValue } from '@dojoengine/react';
import { Entity } from '@dojoengine/recs';
import { getEntityIdFromKeys } from '@dojoengine/utils';
import AuthScreen from '../../views/LoginOrGenerate';
import Dashboard from '../../views/DashBoard';
import Header from '../ui/Header';
import { useDojo } from '../../dojo/useDojo';
import { DestinationProvider } from '../../context/DestinationContext';

const AuthController = () => {
  const {
    setup: {
      clientComponents: { GameOwnerPlanet },
    },
    account,
  } = useDojo();

  const entityId = getEntityIdFromKeys([
    BigInt(account?.account.address),
  ]) as Entity;

  const planetId = useComponentValue(GameOwnerPlanet, entityId);

  const hasGeneratedPlanets = (planetId?.planet_id || 0) > 0;
  // const isOverallLoading = isTokenOfLoading || walletConnectLoading;

  const shouldRenderAuthScreen =
    !account.account.address || !hasGeneratedPlanets;

  return shouldRenderAuthScreen ? (
    <AuthScreen
      address={account?.account.address}
      hasGeneratedPlanets={hasGeneratedPlanets}
    />
  ) : (
    <>
      <DestinationProvider>
        <Header planetId={planetId?.planet_id || 0} />
        <Dashboard planetId={planetId?.planet_id || 0} />
      </DestinationProvider>
    </>
  );
};

export default AuthController;
