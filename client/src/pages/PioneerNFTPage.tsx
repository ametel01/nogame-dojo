import React from 'react';
import { useAccount } from '@starknet-react/core';
import { useTokenOf } from '../hooks/useTokenOf';
import PioneerKey from '../components/ui/PioneerKey';
import Header from '../components/ui/Header';

const PioneerNFTPage = () => {
  const { address } = useAccount();
  const { planetId } = useTokenOf(address);

  return (
    <>
      <Header planetId={planetId} />
      <PioneerKey planetId={planetId} address={address} />
    </>
  );
};

export default PioneerNFTPage;
