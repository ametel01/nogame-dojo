import React, { useState } from 'react';
import { StyledButton } from '../../shared/styled/Button';
import { TransactionStatus } from './TransactionStatus';
// import { InvokeFunctionResponse } from "starknet";
interface Props {
  name: string;
  callback?: () => void;
  tx: string | undefined;
  disabled?: boolean;
  noRequirements?: boolean;
}

export function ButtonUpgrade({
  name,
  callback,
  tx,
  disabled,
  noRequirements,
}: Props) {
  const [isClicked, setIsClicked] = useState(false);

  const handleOnClick = () => {
    callback!();
    setIsClicked(true);
  };

  return (
    <div>
      {!disabled && !noRequirements && (
        <StyledButton
          onClick={handleOnClick}
          fullWidth={true}
          sx={{
            background: '#4A63AA',
          }}
        >
          Upgrade
        </StyledButton>
      )}
      {isClicked ? <TransactionStatus name={name} tx={tx} /> : <></>}
      {!disabled && noRequirements && (
        <StyledButton
          disabled
          fullWidth={true}
          sx={{
            background: '#3B3F53',
          }}
        >
          No Requirements
        </StyledButton>
      )}
      {disabled && (
        <StyledButton
          fullWidth={true}
          disabled
          sx={{
            background: '#C47E33',
          }}
        >
          Needs Resources
        </StyledButton>
      )}
    </div>
  );
}

export function ButtonBuild({
  name,
  callback,
  tx,
  disabled,
  noRequirements,
}: Props) {
  const [isClicked, setIsClicked] = useState(false);

  const handleOnClick = () => {
    callback!();
    setIsClicked(true);
  };

  return (
    <div>
      {!disabled && !noRequirements && (
        <StyledButton
          onClick={handleOnClick}
          fullWidth={true}
          sx={{
            background: '#4A63AA',
          }}
        >
          Build
        </StyledButton>
      )}
      {isClicked ? <TransactionStatus name={name} tx={tx} /> : <></>}
      {!disabled && noRequirements && (
        <StyledButton
          disabled
          fullWidth={true}
          sx={{
            background: '#3B3F53',
          }}
        >
          No Requirements
        </StyledButton>
      )}
      {disabled && (
        <StyledButton
          fullWidth={true}
          disabled
          sx={{
            background: '#883606',
          }}
        >
          Needs Resources
        </StyledButton>
      )}
    </div>
  );
}
