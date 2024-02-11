import React from 'react';
import styled from 'styled-components';

const HeaderWalletContainer = styled.div`
  color: #c5c6c7;
  font-weight: bold;
  opacity: 0.8;
  display: flex;
  padding: 12px;
  border-top: 2px solid #151a1e;
`;

interface WalletHeaderProps {
  account?: string;
}

const WalletHeader = ({ account }: WalletHeaderProps) => {
  const shortenedAddress = account
    ? `${account.substring(0, 6)}...${account.slice(-4)}`
    : 'null';

  return <HeaderWalletContainer>{shortenedAddress}</HeaderWalletContainer>;
};

export default WalletHeader;
