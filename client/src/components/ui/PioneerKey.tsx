import React, { useState } from 'react';
import { useContract, useContractWrite } from '@starknet-react/core';
import { Box } from '@mui/system';
import { Input } from '@mui/joy';
import styled from 'styled-components';
import GeneratedKey from './GeneratedKey';
import { GAMEADDRESS } from '../../constants/addresses';
import game from '../../constants/nogame.json';
import { StyledButton } from '../../shared/styled/Button';
import { TransactionStatus } from '../../components/ui/TransactionStatus';
import nftImage from '../../assets/logos/nogame-pioneer.webp';

const StyledBox = styled(Box)({
  display: 'flex',
  flexDirection: 'row',
  justifyContent: 'center',
  alignItems: 'center',
  backgroundColor: '#1a2025',
  borderRadius: 16,
  boxShadow: '0px 5px 10px rgba(0, 0, 0, 0.3)', // Increased shadow
  padding: '30px', // Increased padding
  color: 'inherit',
  width: '70%',
  position: 'relative',
  margin: '20px auto', // Adjusted margin
});

const ImageContainer = styled.div({
  maxWidth: '50%',
  display: 'flex',
  justifyContent: 'center',
  alignItems: 'center',
  marginRight: '5%',
});

const ContentContainer = styled.div({
  display: 'flex',
  flexDirection: 'column',
  alignItems: 'flex-start',
  maxWidth: '50%',
});

const InstructionText = styled.div({
  color: '#E0E0E0',
  fontSize: '16px',
  marginBottom: '20px',
  lineHeight: '1.5',
  letterSpacing: '.05rem',
  '& a': {
    color: '#4B9CD3', // Link color
    textDecoration: 'none',
    '&:hover': {
      textDecoration: 'underline', // Underline on hover
    },
  },
});

export const HighlightedText = styled.span({
  color: '#4B9CD3', // A bright blue in line with the NFT image
  textTransform: 'capitalize',
});

interface Props {
  address: string | undefined;
  planetId?: number;
}

const PioneerKey = ({ address, planetId }: Props) => {
  const [isButtonClicked, setIsButtonClicked] = useState(false);
  const [inputValue, setInputValue] = useState(''); // Keep as string for controlled input

  const { contract } = useContract({
    abi: game.abi,
    address: GAMEADDRESS,
  });

  const calls = inputValue
    ? [contract?.populateTransaction.generate_mint_key(Number(inputValue))]
    : [];

  const { writeAsync, data } = useContractWrite({
    calls,
  });

  const handleInputChange = (event: React.ChangeEvent<HTMLInputElement>) => {
    const value = event.target.value;
    // Allow only numeric input (including empty string for backspace/delete)
    if (!value || value.match(/^\d*$/)) {
      setInputValue(value);
    }
  };

  const handleButtonClick = () => {
    writeAsync();
    setIsButtonClicked(true);
  };

  return (
    <div style={{ marginTop: '5%' }}>
      <StyledBox>
        <ImageContainer>
          <img
            src={nftImage}
            alt="NFT"
            style={{ width: '100%', height: 'auto', borderRadius: '8px' }}
          />
        </ImageContainer>
        <ContentContainer>
          <InstructionText>
            Generate a key to mint the exclusive{' '}
            <HighlightedText> NoGame Pioneer NFT</HighlightedText>. To be
            eligible, you must have{' '}
            <HighlightedText>earned at least 300 points</HighlightedText> during
            the game. Enter a <HighlightedText>unique number</HighlightedText>{' '}
            and remember it, as it will be required to claim the NFT on{' '}
            <HighlightedText>starknet mainnet</HighlightedText>. Visit{' '}
            <a
              href="https://www.no-game.xyz"
              target="_blank"
              rel="noopener noreferrer"
            >
              www.no-game.xyz
            </a>{' '}
            and connect your <HighlightedText>mainnet wallet</HighlightedText>,
            then provide your <HighlightedText>planet ID</HighlightedText>,{' '}
            <HighlightedText>sepolia wallet address</HighlightedText>, the{' '}
            <HighlightedText>secret number</HighlightedText> you have entered
            and the <HighlightedText>key</HighlightedText> that you will
            generate with this transaction.
          </InstructionText>
          <Input
            placeholder="numeric value"
            value={inputValue}
            onChange={handleInputChange}
            style={{ marginBottom: '20px' }}
            size="sm"
            color="neutral"
            variant="soft"
          />
          <StyledButton
            variant="contained"
            onClick={handleButtonClick}
            disabled={!inputValue}
          >
            Generate Mint Key
          </StyledButton>
          {isButtonClicked && (
            <TransactionStatus
              name="Generate Key"
              tx={data?.transaction_hash}
            />
          )}
          <GeneratedKey address={address} planetId={planetId} />
        </ContentContainer>
      </StyledBox>
    </div>
  );
};

export default PioneerKey;
