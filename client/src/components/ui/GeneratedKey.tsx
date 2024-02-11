import React, { useState } from 'react';
import styled from 'styled-components';
import { useContractRead } from '@starknet-react/core';
import { GAMEADDRESS } from '../../constants/addresses';
import game from '../../constants/nogame.json';
import Tooltip from '@mui/material/Tooltip';
import IconButton from '@mui/material/IconButton';
import ContentCopyIcon from '@mui/icons-material/ContentCopy';
import { BlockTag } from 'starknet';

const KeyInfoContainer = styled.div({
  width: '100%',
  marginTop: '20px', // Add margin for spacing
  backgroundColor: '#2c3135', // Optional: different background for emphasis
  padding: '15px', // Padding inside the container
  borderRadius: '8px', // Rounded corners
  boxShadow: '0px 4px 8px rgba(0, 0, 0, 0.15)', // Subtle shadow for depth
});

const KeyInfoLabel = styled.span({
  color: '#E0E0E0',
  fontSize: '14px',
  textTransform: 'uppercase',
  marginRight: '10px', // Space between label and value
  display: 'inline-block',
});

const KeyInfoValue = styled.span({
  color: '#A9BACD', // Different color for distinction
  fontSize: '14px',
  display: 'inline-block',
  textAlign: 'right',
  flexGrow: 1, // Grow to take available space
});

const CustomIconButton = styled(IconButton)({
  '&:hover': {
    transform: 'scale(1.1)',
    color: '#1A1A1A',
  },
});

const iconStyle = {
  color: '#4A4A4A',
  fontSize: '20px',
  transition: 'transform 0.2s ease-in-out',
};

interface Props {
  address: string | undefined;
  planetId?: number;
}

const GeneratedKey = ({ address, planetId }: Props) => {
  const { data } = useContractRead({
    address: GAMEADDRESS,
    abi: game.abi,
    functionName: 'get_mint_key',
    args: [address ? address : ''],
    blockIdentifier: BlockTag.pending,
  });

  const hexData = data ? `0x${data.toString(16)}` : 'Key Not Generated Yet';
  const [tooltipKeyOpen, setTooltipKeyOpen] = useState(false);
  const [tooltipPlanetIdOpen, setTooltipPlanetIdOpen] = useState(false);
  const [tooltipAddressOpen, setTooltipAddressOpen] = useState(false);

  const copyToClipboard = (
    text: string,
    setTooltipOpen: React.Dispatch<React.SetStateAction<boolean>>
  ) => {
    navigator.clipboard.writeText(text).then(
      () => {
        setTooltipOpen(true);
        setTimeout(() => setTooltipOpen(false), 2000); // Tooltip will close after 2 seconds
      },
      (err) => {
        console.error('Error in copying text: ', err);
      }
    );
  };

  return (
    <KeyInfoContainer>
      <div>
        <KeyInfoLabel>Mint Key</KeyInfoLabel>
        <KeyInfoValue>
          {hexData != 'Key Not Generated'
            ? `${hexData.substring(0, 6)}...${hexData.substring(
                hexData.length - 4
              )}`
            : 'Key Not Generated'}
        </KeyInfoValue>
        <Tooltip title="Copied!" open={tooltipKeyOpen} arrow>
          <CustomIconButton
            onClick={() => copyToClipboard(hexData, setTooltipKeyOpen)}
          >
            <ContentCopyIcon style={iconStyle} />
          </CustomIconButton>
        </Tooltip>
      </div>
      <div>
        <KeyInfoLabel>Your Planet ID</KeyInfoLabel>
        <KeyInfoValue>{Number(planetId)}</KeyInfoValue>
        <Tooltip title="Copied!" open={tooltipPlanetIdOpen} arrow>
          <CustomIconButton
            onClick={() =>
              planetId !== undefined &&
              copyToClipboard(planetId.toString(), setTooltipPlanetIdOpen)
            }
            style={iconStyle}
          >
            <ContentCopyIcon style={iconStyle} />
          </CustomIconButton>
        </Tooltip>
      </div>
      <div>
        <KeyInfoLabel>Your Sepolia Address</KeyInfoLabel>
        <KeyInfoValue>
          {`${address?.substring(0, 6)}...${address?.substring(
            address.length - 4
          )}`}
        </KeyInfoValue>
        <Tooltip title="Copied!" open={tooltipAddressOpen} arrow>
          <CustomIconButton
            onClick={() =>
              address !== undefined &&
              copyToClipboard(address, setTooltipAddressOpen)
            }
            style={iconStyle}
          >
            <ContentCopyIcon style={iconStyle} />
          </CustomIconButton>
        </Tooltip>
      </div>
    </KeyInfoContainer>
  );
};

export default GeneratedKey;
