import React, { useState, useEffect } from 'react';
import * as deps from '.';
import { useDestination } from '../context/DestinationContext';
import TextField from '@mui/material/TextField';
import { styled as muiStyled } from '@mui/material/styles';
import { usePlanetShips } from '../hooks/usePlanetShips';
import { useColonyShips } from '../hooks/useColonyShips';

const PaginationContainer = muiStyled('div')({
  display: 'flex',
  alignItems: 'center',
  justifyContent: 'center',
  width: '100%',
  marginTop: '16px', // Adjust as needed for spacing
});

const PageInput = muiStyled(TextField)({
  '& .MuiInputBase-input': {
    color: 'white', // Set the color you prefer
    textAlign: 'center',
  },
  '& .MuiOutlinedInput-root': {
    '& fieldset': {
      borderColor: 'rgba(255, 255, 255, 0.23)', // Border color
    },
    '&:hover fieldset': {
      borderColor: 'white', // Border color on hover
    },
    '&.Mui-focused fieldset': {
      borderColor: 'white', // Border color when focused
    },
  },
  width: '60px', // Adjust as needed
  marginRight: '8px', // Space between input and pagination
});

const UniverseBoxItem = ({
  ownPlanetId,
  planet,
  ownTechs,
  colonyId,
}: deps.UniverseProps) => {
  const highlighted = parseInt(address, 16) === parseInt(planet.account, 16);

  const motherPlanet =
    planet.planetId > 500
      ? Math.floor(Number(planet.planetId) / 1000)
      : planet.planetId;

  const planetRanking = useGetPlanetRanking(motherPlanet);
  const winLoss = useCalculateWinsAndLosses(motherPlanet);
  const lastActive = useLastActive(motherPlanet);
  const isNoobProtected = useGetIsNoobProtected(
    Number(ownPlanetId),
    motherPlanet
  );

  const ownFleetData = usePlanetShips(ownPlanetId);
  const ownFleet: deps.Fleet = ownFleetData || {
    carrier: 0,
    scraper: 0,
    sparrow: 0,
    frigate: 0,
    armade: 0,
  };

  const colonyFleetData = useColonyShips(ownPlanetId, colonyId);
  const colonyFleet: deps.Fleet = colonyFleetData || {
    carrier: 0,
    scraper: 0,
    sparrow: 0,
    frigate: 0,
    armade: 0,
  };

  const img = deps.getPlanetImage(
    planet.position.orbit.toString() as unknown as deps.ImageId
  );

  const shortenedAddress = `${planet.account.slice(
    0,
    4
  )}...${planet.account.slice(-4)}`;

  return (
    <deps.UniverseViewBox
      planetId={planet.planetId}
      img={img}
      owner={shortenedAddress}
      position={planet.position}
      points={planetRanking}
      highlighted={highlighted}
      ownPlanetId={ownPlanetId}
      ownFleet={colonyId === 0 ? ownFleet : colonyFleet}
      ownTechs={ownTechs}
      isNoobProtected={isNoobProtected}
      lastActive={Number(lastActive)}
      winLoss={[winLoss.wins, winLoss.losses]}
      colonyId={colonyId}
    />
  );
};

interface UniverseViewTabPanelProps {
  resources: deps.Resources;
  ownTechs?: deps.Techs;
  fleet?: deps.Fleet;
  defences?: deps.Defences;
  ownPlanetId: number;
  colonyId: number;
}

export const UniverseViewTabPanel = ({
  ownPlanetId,
  ownTechs,
  colonyId,
  ...rest
}: UniverseViewTabPanelProps) => {
  const [planetsData, setPlanetsData] = useState<deps.PlanetDetails[]>([]);
  const [currentPage, setCurrentPage] = useState(1);
  const [inputPage, setInputPage] = useState('');
  const [pageError, setPageError] = useState(false);
  const itemsPerPage = 6;
  const pageCount = Math.ceil(planetsData.length / itemsPerPage);

  const { selectedDestination } = useDestination();

  const startIndex = (currentPage - 1) * itemsPerPage;
  const selectedPlanets = planetsData.slice(
    startIndex,
    startIndex + itemsPerPage
  );

  const handlePageChange = (
    event: React.ChangeEvent<unknown>,
    page: number
  ) => {
    setCurrentPage(page);
    setInputPage(page.toString());
  };

  const handleInputChange = (event: React.ChangeEvent<HTMLInputElement>) => {
    const inputVal = event.target.value;
    setInputPage(inputVal);

    const pageNumber = parseInt(inputVal, 10);
    if (!isNaN(pageNumber) && pageNumber >= 1 && pageNumber <= pageCount) {
      setCurrentPage(pageNumber); // Update page immediately if valid
      setPageError(false);
    } else {
      setPageError(true);
    }
  };

  const handleInputBlur = () => {
    const pageNumber = parseInt(inputPage, 10);
    if (!isNaN(pageNumber) && pageNumber >= 1 && pageNumber <= pageCount) {
      setCurrentPage(pageNumber);
      setPageError(false);
    } else {
      setInputPage(currentPage.toString());
      setPageError(false);
    }
  };

  return (
    <StyledTabPanel {...rest}>
      {selectedPlanets.map((planet, index) => (
        <UniverseBoxItem
          ownPlanetId={ownPlanetId}
          ownTechs={ownTechs}
          key={index}
          planet={planet}
          colonyId={colonyId}
        />
      ))}
      <PaginationContainer>
        <Pagination
          count={pageCount}
          page={currentPage}
          onChange={handlePageChange}
          variant="outlined"
          shape="rounded"
          sx={{
            '.MuiPaginationItem-root.MuiPaginationItem-root': {
              color: 'white',
            },
            '.MuiPaginationItem-root.Mui-selected': {
              backgroundColor: 'rgba(211, 211, 211, 0.5)',
            },
          }}
        />
        <PageInput
          value={inputPage}
          onChange={handleInputChange}
          onBlur={handleInputBlur}
          error={pageError}
          variant="outlined"
          size="small"
        />
      </PaginationContainer>
    </StyledTabPanel>
  );
};

UniverseViewTabPanel.tabsRole = 'TabPanel';
