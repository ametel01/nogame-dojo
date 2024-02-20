import React from 'react';
import { Select, MenuItem, SelectChangeEvent } from '@mui/material';
import FormControl from '@mui/material/FormControl';
import Box from '@mui/material/Box';
import { GenerateColony } from '../buttons/GenerateColony';
// import { useTechLevels } from '../panels';
// import { useDojo } from '../dojo/useDojo';
// import { useComponentValue } from '@dojoengine/react';
// import { getEntityIdFromKeys } from '@dojoengine/utils';
// import { Entity } from '@dojoengine/recs';
import { usePlanetColonies } from '../../hooks/usePlanetColonies';
import { usePlanetTechs } from '../../hooks/usePlanetTechs';

interface Props {
  planetId: number;
  selectedColonyId: string | number;
  handleChange: (event: SelectChangeEvent<unknown>) => void;
}

const selectStyles = {
  color: '#c5c6c7',
  '& .MuiOutlinedInput-root': {
    borderRadius: '4px',
    padding: '8px 16px',
    margin: '8px 0',
    '& .MuiSelect-select': {
      padding: '8px',
      borderRadius: '4px',
      background: '#1c242c',
    },
    '& .MuiOutlinedInput-notchedOutline': {
      borderColor: '#2a3f55',
    },
    '&:hover .MuiOutlinedInput-notchedOutline': {
      borderColor: '#3b506a',
    },
    '&.Mui-focused .MuiOutlinedInput-notchedOutline': {
      borderColor: '#4c6a8e',
    },
  },
};

const menuProps = {
  PaperProps: {
    style: {
      backgroundColor: '#1c242c', // Set the background color for the dropdown menu
      color: '#c5c6c7', // Set the text color for the dropdown menu
      // Add any additional styles for the dropdown menu here
    },
  },
};

const ColonySelect = ({ planetId, selectedColonyId, handleChange }: Props) => {
  // const {
  //   setup: {
  //     clientComponents: { ColonyCount },
  //   },
  // } = useDojo();

  // const planteIdEntity = getEntityIdFromKeys([BigInt(planetId)]) as Entity;
  const coloniesArray = usePlanetColonies(planetId);
  const techs = usePlanetTechs(planetId);
  const maxColonies = techs
    ? Math.floor(Number(techs.exocraft) / 2) +
      (Number(techs.exocraft) % 2 === 1 ? 1 : 0)
    : 0;
  const isActivated =
    coloniesArray && techs ? coloniesArray.length < maxColonies : false;

  const menuItems = Array.isArray(coloniesArray)
    ? coloniesArray.map((colony, index) => {
        const colonyId = colony[0];
        return (
          <MenuItem key={index} value={colonyId.toString()}>
            colony {colonyId.toString()} - {Number(colony[1].system)}/
            {Number(colony[1].orbit)}
          </MenuItem>
        );
      })
    : [];

  const defaultOption = (
    <MenuItem key="default-option" value="0">
      mother planet
    </MenuItem>
  );

  return (
    <Box>
      <FormControl fullWidth>
        <Select
          labelId="planet-select-label"
          id="planet-select"
          value={selectedColonyId.toString()}
          onChange={handleChange}
          sx={selectStyles}
          MenuProps={menuProps}
          autoWidth
        >
          {defaultOption}
          {menuItems}
        </Select>
      </FormControl>
      <GenerateColony isActivated={isActivated} />
    </Box>
  );
};

export default ColonySelect;
