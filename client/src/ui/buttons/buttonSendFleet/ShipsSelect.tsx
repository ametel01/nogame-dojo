import React from 'react';
import styled from 'styled-components';
import { StyledInput } from '../../../shared/styled/input';
import KeyboardDoubleArrowUpIcon from '@mui/icons-material/KeyboardDoubleArrowUp';
import { Fleet } from '../../../hooks/usePlanetShips';
import armadeImg from '../../../assets/gameElements/ships/armade4.webp';
import frigateImg from '../../../assets/gameElements/ships/frigate4.webp';
import carrierImg from '../../../assets/gameElements/ships/carrier4.webp';
import sparrowImg from '../../../assets/gameElements/ships/sparrow4.webp';
import scraperImg from '../../../assets/gameElements/ships/scraper4.webp';
import { ShipName } from './ButtonSendFleet';
import Tooltip from '@mui/material/Tooltip';

export const FlexContainer = styled('div')({
  display: 'flex',
  alignItems: 'center',
  justifyContent: 'flex-start',
  borderRadius: '8px',
  gap: '4px',
  margin: '8px',
  flexDirection: 'row',
});

export const InputButtonContainer = styled('div')({
  display: 'flex',
  alignItems: 'center',
});

export const StyledUl = styled('ul')({
  padding: '2px',
  flexGrow: 1,
});

export const InputImage = styled('img')({
  width: '40px',
  height: '40px',
  margin: '0 4px',
  backgroundSize: 'cover',
  backgroundPosition: 'center',
  borderRadius: '8px',
  marginRight: '8px',
});

export const Text = styled('span')({
  flexGrow: 1,
  textAlign: 'center',
});

const shipImageMapping: Record<ShipName, string> = {
  carrier: carrierImg,
  scraper: scraperImg,
  sparrow: sparrowImg,
  frigate: frigateImg,
  armade: armadeImg,
};

interface Props {
  ownFleet: Fleet;
  quantities: Record<ShipName, number>;
  handleChange: (
    ship: ShipName,
    e: React.ChangeEvent<HTMLInputElement>
  ) => void;
  handleMaxQuantity: (ship: ShipName) => void;
}

export const ShipsSelect = ({
  quantities,
  handleChange,
  handleMaxQuantity,
}: Props) => {
  const ships: ShipName[] = [
    'carrier',
    'scraper',
    'sparrow',
    'frigate',
    'armade',
  ];

  return (
    <div>
      <StyledUl>
        {ships.map((ship) => (
          <FlexContainer key={ship}>
            <Tooltip title={ship.charAt(0).toUpperCase() + ship.slice(1)}>
              <InputImage
                src={shipImageMapping[ship as ShipName] || ''}
                alt={ship}
              />
            </Tooltip>
            <InputButtonContainer>
              <StyledInput
                type="number"
                value={quantities[ship] || 0}
                onChange={(e) => handleChange(ship, e)}
                color="neutral"
                style={{ width: '80px' }}
              />
              <KeyboardDoubleArrowUpIcon
                onClick={() => handleMaxQuantity(ship as ShipName)}
                style={{ cursor: 'pointer' }}
              />
            </InputButtonContainer>
          </FlexContainer>
        ))}
      </StyledUl>
    </div>
  );
};
