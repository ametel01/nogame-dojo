import * as React from 'react';
import Box from '@mui/material/Box';
import Modal from '@mui/material/Modal';
import DialogContent from '@mui/material/DialogContent';
import CloseIcon from '@mui/icons-material/Close';
import styled from 'styled-components';
import { CircularProgress } from '@mui/material';
import {
  type DefenceLevels,
  type Resources,
  type ShipsLevels,
} from '../../shared/types';
import {
  useSpendableResources,
  useCollectibleResources,
} from '../../hooks/ResourcesHooks';
import { useShipsLevels, useDefencesLevels } from '../../hooks/LevelsHooks';
import { getPlanetAndColonyIds, numberWithCommas } from '../../shared/utils';
import {
  useGetColonyResources,
  useGetColonyDefences,
} from '../../hooks/ColoniesHooks';
import { useGetColonyShips } from '../../hooks/ColoniesHooks';

export const StyledBox = styled(Box)({
  fontWeight: 400,
  fontSize: 20,
  color: '#E7ECEE',
  position: 'absolute',
  top: '50%',
  left: '50%',
  transform: 'translate(-50%, -50%)',
  backgroundColor: '#1a2025',
  borderRadius: 16,
  boxShadow: '0px 3px 5px rgba(0, 0, 0, 0.2)',
  padding: '16px 32px',
  display: 'flex',
  flexDirection: 'column',
  width: '35%',
});

const StyledDialogContent = styled(DialogContent)`
  color: #f8f8ff;
  display: grid;
  grid-template-columns: 1fr 1fr; // Two columns for the main content
  gap: 20px;
  padding: 20px; // Padding inside the dialog content
`;

const GridSection = styled.div`
  display: flex;
  flex-direction: column;
  gap: 10px;
  opacity: 0.8;
  h4 {
    font-size: 18px; // Reduced font size for the title
    margin-bottom: 8px;
  }

  h5 {
    font-size: 16px; // Reduced font size for the content
    margin: 0;
  }
`;

const DetailGrid = styled.div`
  display: grid;
  grid-template-columns: 1fr 1fr; // Two columns for the details
  gap: 10px;
`;

const CloseStyledIcon = styled(CloseIcon)`
  cursor: pointer;
  color: #E7ECEE;
  position: absolute;
  top: 16px;
  right: 16px;

  &:hover {
    color: #ffffff;
  },
`;

const SubTitle = styled('h5')`
  // border-bottom: 1px solid;
`;

const Value = styled.span`
  color: #23ce6b; // Set the color for values
`;

const ImageContainer = styled.div`
  width: 70px;
  height: 70px; // Maintain aspect ratio for square appearance
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  background-color: #1a2025; // Dark background for depth
  border: 1px solid #343d4c; // Futuristic border color
  border-radius: 50%; // Circular shape to represent a planet
  box-shadow: 0 2px 4px rgba(255, 255, 255, 0.1),
    inset 0 2px 4px rgba(0, 0, 0, 0.5); // Outer glow and inner shadow for a 3D effect
  overflow: hidden; // Ensure the image does not bleed outside the container
  transition: transform 0.3s ease-in-out; // Smooth transition for hover effects

  &:hover {
    transform: scale(1.1); // Slightly enlarge on hover for interactivity
    box-shadow: 0 4px 8px rgba(255, 255, 255, 0.2),
      inset 0 4px 8px rgba(0, 0, 0, 0.7); // Enhanced shadow effect on hover
  }

  img {
    width: 100%; // Ensure the image covers the full container
    height: auto; // Maintain aspect ratio
    border-radius: 50%; // Circular shape for the image
  }
`;
interface Props {
  planetId: number;
  image: string;
  position: string;
}

export default function PlanetModal({ planetId, image, position }: Props) {
  const spendableResources = useSpendableResources(Number(planetId));
  const collectibleResources = useCollectibleResources(Number(planetId));
  const [planet, colony] = getPlanetAndColonyIds(planetId);

  const shipsLevels = useShipsLevels(Number(planetId));
  const colonyShips = useGetColonyShips(planet, colony);
  const actualShips =
    colonyShips && shipsLevels && colony === 0 ? shipsLevels : colonyShips;

  const defencesLevels = useDefencesLevels(Number(planetId));
  const colonyDefences = useGetColonyDefences(planet, colony);
  const actualDefences =
    defencesLevels && colony === 0
      ? defencesLevels
      : colonyDefences && colonyDefences;

  const colonyResources = useGetColonyResources(planet, colony);

  const [isModalOpen, setIsModalOpen] = React.useState(false);

  const handleClose = () => {
    setIsModalOpen(false);
  };

  const handleButtonClick = () => {
    setIsModalOpen(true);
  };

  return (
    <div>
      <ImageContainer onClick={handleButtonClick}>
        {image ? (
          <img
            src={image}
            alt={'planet'}
            style={{ maxWidth: '100%', height: 'auto' }}
          />
        ) : (
          <CircularProgress sx={{ color: '#ffffff', opacity: '0.5' }} />
        )}
      </ImageContainer>
      <Modal open={isModalOpen} onClose={handleClose} disableAutoFocus={true}>
        <StyledBox>
          <CloseStyledIcon onClick={handleClose} />
          <GridSection>
            <h5>
              Position: <Value>{position}</Value>
            </h5>
          </GridSection>
          <StyledDialogContent>
            <GridSection>
              <SubTitle>Spendable Resources</SubTitle>
              {Object.keys(spendableResources ?? {}).map((key) => (
                <h6 key={key}>
                  {key}:{' '}
                  <Value>
                    {numberWithCommas(
                      spendableResources[key as keyof Resources]
                    )}
                  </Value>
                </h6>
              ))}
            </GridSection>

            <GridSection>
              <SubTitle>Collectible Resources</SubTitle>
              {Object.keys(
                (planetId > 500 ? colonyResources : collectibleResources) ?? {}
              ).map((key) => (
                <h6 key={key}>
                  {key}:{' '}
                  <Value>
                    {numberWithCommas(
                      Math.round(
                        Number(
                          (planetId > 500
                            ? colonyResources
                            : collectibleResources)[key as keyof Resources]
                        )
                      )
                    )}
                  </Value>
                </h6>
              ))}
            </GridSection>

            <GridSection>
              <SubTitle>Fleet</SubTitle>
              <DetailGrid>
                {Object.keys(
                  (planetId > 500 ? shipsLevels : colonyShips) ?? {}
                ).map((key) => (
                  <h6 key={key}>
                    {key}:{' '}
                    <Value>
                      {numberWithCommas(
                        actualShips ? actualShips[key as keyof ShipsLevels] : 0
                      )}
                    </Value>
                  </h6>
                ))}
              </DetailGrid>
            </GridSection>

            <GridSection>
              <SubTitle>Defences</SubTitle>
              <DetailGrid>
                {Object.keys(
                  (planetId > 500 ? colonyDefences : defencesLevels) ?? {}
                ).map((key) => (
                  <h6 key={key}>
                    {key}:{' '}
                    <Value>
                      {numberWithCommas(
                        actualDefences[key as keyof DefenceLevels]
                      )}
                    </Value>
                  </h6>
                ))}
              </DetailGrid>
            </GridSection>
          </StyledDialogContent>
        </StyledBox>
      </Modal>
    </div>
  );
}
