import React, { useState, useEffect } from 'react';
import { styled } from '@mui/system';
import MenuItem from '@mui/material/MenuItem';
import FormControl from '@mui/material/FormControl';
import Select, { SelectChangeEvent } from '@mui/material/Select';
import { CallType } from './MultiCallTransaction';
import TextField from '@mui/material/TextField';
import { callTypeOptions } from '../shared/types';
import { Box } from '@mui/system';
import { InputLabel } from '@mui/material';

const StyledFormControl = styled(FormControl)`
  & .MuiInputBase-root {
    color: #cfd8dc; // Light grey text for visibility
    background-color: #263238; // Dark grey, slightly lighter than the background for contrast
    border-radius: 4px;
  }

  & .MuiOutlinedInput-notchedOutline {
    border-color: #37474f; // Subtle border color
  }

  &:hover .MuiOutlinedInput-notchedOutline {
    border-color: #607d8b; // Lighter border color on hover
  }

  & .Mui-focused .MuiOutlinedInput-notchedOutline {
    border-color: #29b6f6; // Highlight color when focused
  }

  & .MuiInputLabel-root {
    color: #b0bec5; // Light grey label for visibility
  }

  & .MuiInputLabel-shrink {
    color: #29b6f6; // Highlight color when the label is shrunk after focus
  }
`;

const StyledTextField = styled(TextField)`
  & .MuiInputBase-root {
    color: #cfd8dc; // Light grey text for visibility
    background-color: #263238; // Dark grey, slightly lighter than the background for contrast
  }

  & .MuiOutlinedInput-notchedOutline {
    border-color: #37474f; // Subtle border color
  }

  &:hover .MuiOutlinedInput-notchedOutline {
    border-color: #607d8b; // Lighter border color on hover
  }

  & .Mui-focused .MuiOutlinedInput-notchedOutline {
    border-color: #29b6f6; // Highlight color when focused
  }
`;

const StyledMenuItem = styled(MenuItem)`
  &.MuiMenuItem-root {
    &:hover {
      background-color: #37474f; // Slightly lighter background on hover
    }
    &:selected {
      background-color: #546e7a; // Distinct background color when selected
    }
  }
`;

interface CallTypeSelectorProps {
  onSelect: (callType: CallType, callName: number, quantity: number) => void;
}

export function CallTypeSelector({ onSelect }: CallTypeSelectorProps) {
  const [callType, setCallType] = useState<CallType>('compound');
  const [callName, setCallName] = useState<number>(0);
  const [quantity, setQuantity] = useState<number>(0);

  useEffect(() => {
    onSelect(callType, callName, quantity);
  }, [callType, callName, quantity, onSelect]);

  const handleTypeChange = (event: SelectChangeEvent<CallType>) => {
    setCallType(event.target.value as CallType);
  };

  const handleNameChange = (event: SelectChangeEvent<number>) => {
    setCallName(event.target.value as number);
  };

  const handleQuantityChange = (event: React.ChangeEvent<HTMLInputElement>) => {
    setQuantity(parseInt(event.target.value, 10) || 0);
  };

  return (
    <>
      <Box sx={{ maxWidth: 240, marginTop: 4, marginBottom: 2 }}>
        <StyledFormControl fullWidth>
          <InputLabel id="call-type-select-label">Type</InputLabel>
          <Select
            labelId="call-type-select-label"
            id="call-type-select"
            value={callType}
            label="Call Type"
            onChange={handleTypeChange}
          >
            {Object.keys(callTypeOptions).map((type) => (
              <StyledMenuItem key={type} value={type}>
                {type}
              </StyledMenuItem>
            ))}
          </Select>
        </StyledFormControl>
      </Box>
      <Box sx={{ maxWidth: 240, marginBottom: 2 }}>
        <StyledFormControl fullWidth>
          <InputLabel id="call-type-select-label">Name</InputLabel>
          <Select
            labelId="call-name-select-label"
            id="call-name-select"
            value={callName}
            label="Name"
            onChange={handleNameChange}
          >
            {callTypeOptions[callType].map((option) => (
              <StyledMenuItem key={option.value} value={option.value}>
                {option.label}
              </StyledMenuItem>
            ))}
          </Select>
        </StyledFormControl>
      </Box>
      <Box sx={{ maxWidth: 240, marginBottom: 2 }}>
        <StyledFormControl fullWidth>
          <StyledTextField
            id="quantity-input"
            label="Quantity"
            type="number"
            InputLabelProps={{
              shrink: true,
            }}
            variant="outlined"
            value={quantity}
            onChange={handleQuantityChange}
          />
        </StyledFormControl>
      </Box>
    </>
  );
}
