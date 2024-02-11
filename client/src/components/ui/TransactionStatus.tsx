import React, { useEffect, useState } from 'react';
import { useWaitForTransaction } from '@starknet-react/core';
import Modal from '@mui/material/Modal';
import CircularProgress from '@mui/material/CircularProgress';
import CheckCircleIcon from '@mui/icons-material/CheckCircle';
import { StyledBox, HeaderDiv } from '../buttons/ButtonAttackPlanet';

interface Props {
  name: string;
  tx: string | undefined;
}

export function TransactionStatus({ name, tx }: Props) {
  const [showModal, setShowModal] = useState(true);
  const [transactionSuccess, setTransactionSuccess] = useState(false);
  const { isLoading, data } = useWaitForTransaction({
    hash: tx,
    watch: true,
  });

  useEffect(() => {
    // Type guard to check if data is of the type with 'finality_status'
    if (data && 'finality_status' in data) {
      // Now TypeScript knows 'finality_status' is a valid property
      if (data.finality_status === 'ACCEPTED_ON_L2') {
        setTransactionSuccess(true);
      }
    }
  }, [data]);

  const handleModalClose = () => {
    setShowModal(false);
  };

  const loadingBody = (
    <div style={{ margin: '10px', padding: '10px' }}>
      <StyledBox style={{ width: '35%' }}>
        <HeaderDiv style={{ display: 'flex', justifyContent: 'center' }}>
          {name} Tx is being submitted
        </HeaderDiv>
        <div
          style={{ display: 'flex', justifyContent: 'center', margin: '30px' }}
        >
          <CircularProgress size={32} />
        </div>
      </StyledBox>
    </div>
  );

  const successBody = (
    <div style={{ margin: '10px', padding: '10px' }}>
      <StyledBox style={{ width: '40%' }}>
        <HeaderDiv style={{ display: 'flex', justifyContent: 'center' }}>
          {name} Tx Accepted On L2
        </HeaderDiv>
        <div
          style={{
            display: 'flex',
            justifyContent: 'center',
            alignItems: 'center',
            height: '100px',
            margin: '10px',
          }}
        >
          <CheckCircleIcon
            style={{
              fontSize: '64px',
              color: 'green',
            }}
          />
        </div>
        {/* Additional message about potential delay in data update */}
        <div
          style={{
            textAlign: 'center',
            marginTop: '20px',
            fontSize: '14px',
            color: 'gray',
          }}
        >
          Note: The displayed data might take several seconds to update. Try
          refreshing the page in a few minutes.
        </div>
      </StyledBox>
    </div>
  );

  return (
    <>
      {showModal && (
        <Modal
          open={showModal}
          onClose={handleModalClose}
          disableAutoFocus={true}
        >
          {isLoading || !transactionSuccess ? loadingBody : successBody}
        </Modal>
      )}
    </>
  );
}
