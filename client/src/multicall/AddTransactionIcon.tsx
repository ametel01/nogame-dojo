import React, { useState } from 'react';
import AddCircleIcon from '@mui/icons-material/AddCircle';
import CheckCircleIcon from '@mui/icons-material/CheckCircle'; // For indicating successful addition
import styled from 'styled-components';
import { useBlockchainCall } from '../context/BlockchainCallContext'; // adjust the path as necessary

type CallType = 'compound' | 'tech' | 'ship' | 'defence'; // adjust as necessary

interface AddTransactionIconProps {
  callType: CallType;
  unitName: number;
  quantity: number;
  disabled: boolean;
  colonyId: number;
}

const StyledIcon = styled(AddCircleIcon)<{ disabled: boolean; added: boolean }>`
  cursor: ${({ disabled }) => (disabled ? 'default' : 'pointer')};
  color: ${({ disabled, added }) =>
    disabled
      ? '#bdbdbd'
      : added
      ? '#4caf50'
      : '#FFD700'}; // Gold when not added, green when added
  &:hover {
    color: ${({ disabled, added }) =>
      disabled ? '#bdbdbd' : added ? '#66bb6a' : '#FFD700'};
  }
  transition: color 0.3s ease;
`;

const AddTransactionIcon: React.FC<AddTransactionIconProps> = ({
  callType,
  unitName,
  quantity,
  disabled,
  colonyId,
}) => {
  const [added, setAdded] = useState(false);
  const { addCall } = useBlockchainCall();

  const handleAddTransaction = () => {
    if (!disabled && !added) {
      addCall(callType, unitName, quantity, colonyId);
      setAdded(true);
    }
  };

  return (
    <StyledIcon
      as={added ? CheckCircleIcon : AddCircleIcon}
      onClick={handleAddTransaction}
      disabled={disabled}
      added={added}
    />
  );
};

export default AddTransactionIcon;
