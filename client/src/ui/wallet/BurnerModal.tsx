import React, { useState, useEffect } from 'react';
import styled from 'styled-components';
import Button from '@mui/material/Button';
import Modal from '@mui/material/Modal';
import { Box } from '@mui/system';
import { useDojo } from '../../dojo/useDojo';

const StyledBox = styled(Box)({
  fontWeight: 600,
  fontSize: 20,
  position: 'absolute',
  top: '50%',
  left: '50%',
  transform: 'translate(-50%, -50%)',
  backgroundColor: '#1B1E2A',
  border: '1px solid #282C3E',
  borderRadius: 16,
  boxShadow: '0px 3px 5px rgba(0, 0, 0, 0.2)',
  padding: '24px 12px',
  display: 'flex',
  flexDirection: 'column',
  width: '30%',
});

const WalletButton = styled(Button)({
  width: '100%',
  borderRadius: 8,
  padding: '8px 32px',
  textTransform: 'capitalize',
  letterSpacing: '0.1em',
  backgroundColor: '#282C3E', // Slightly lighter background for the WalletButton
  display: 'flex',
  color: '#F4F3EE',
  justifyContent: 'center',
  '&:hover': {
    background: '#202332', // Slightly lighter than #1B1E2A for a subtle hover effect
  },
});

const StyledUl = styled('ul')({
  padding: '8px',
  flexGrow: 1,
});

const StyledLi = styled('li')({
  listStyleType: 'none',
  margin: '8px',
});

interface BurnerModalProps {
  open: boolean;
  onClose: () => void;
}

export const BurnerModal = ({ open, onClose }: BurnerModalProps) => {
  const { account } = useDojo();
  console.log('Burner modal account list', account.list());

  const [clipboardStatus, setClipboardStatus] = useState({
    message: '',
    isError: false,
  });

  console.log('account', account);

  const handleRestoreBurners = async () => {
    try {
      await account?.applyFromClipboard();
      setClipboardStatus({
        message: 'Burners restored successfully!',
        isError: false,
      });
    } catch (error) {
      setClipboardStatus({
        message: `Failed to restore burners from clipboard`,
        isError: true,
      });
    }
  };

  useEffect(() => {
    if (clipboardStatus.message) {
      const timer = setTimeout(() => {
        setClipboardStatus({ message: '', isError: false });
      }, 3000);

      return () => clearTimeout(timer);
    }
  }, [clipboardStatus.message]);

  return (
    <>
      <Modal
        open={open}
        onClose={onClose}
        aria-label="Connect Wallet Modal"
        disableAutoFocus={true}
      >
        <StyledBox>
          <StyledUl>
            <StyledLi>
              <WalletButton onClick={account?.create}>
                {account?.isDeploying ? 'deploying burner' : 'create burner'}
              </WalletButton>
            </StyledLi>
            {account && account?.list().length > 0 && (
              <StyledLi>
                <WalletButton
                  onClick={async () => await account?.copyToClipboard()}
                >
                  Save Burners to Clipboard
                </WalletButton>
              </StyledLi>
            )}
            <StyledLi>
              <WalletButton onClick={handleRestoreBurners}>
                Restore Burners from Clipboard
              </WalletButton>
            </StyledLi>
            {clipboardStatus.message && (
              <div className={clipboardStatus.isError ? 'error' : 'success'}>
                {clipboardStatus.message}
              </div>
            )}
            <StyledLi>
              <WalletButton onClick={() => account.clear()}>
                Clear burners
              </WalletButton>
            </StyledLi>
            <StyledLi className="card" style={{ textAlign: 'center' }}>
              select signer:{' '}
              <select
                value={account ? account.account.address : ''}
                onChange={(e) => account.select(e.target.value)}
              >
                {account?.list().map((account, index) => {
                  return (
                    <option value={account.address} key={index}>
                      {account.address.substring(0, 6)}...
                      {account.address.slice(-4)}
                    </option>
                  );
                })}
              </select>
            </StyledLi>
          </StyledUl>
        </StyledBox>
      </Modal>
    </>
  );
};
