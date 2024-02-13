import * as React from 'react';
import { useEffect, useState } from 'react';
import Button from '@mui/material/Button';
import AccountBalanceWalletIcon from '@mui/icons-material/AccountBalanceWallet';
import Modal from '@mui/material/Modal';
// import CloseIcon from '@mui/icons-material/Close';
import Box from '@mui/material/Box';
import { styled } from '@mui/system';
import { useDojo } from '../../dojo/useDojo';
// import { useConnect } from '@starknet-react/core';
// import argenWallet from '../../assets/uiIcons/argent.png';
// import braavosWallet from '../../assets/uiIcons/braavos.svg';
// import ArgentMobileWalletIcon from './ArgentMobileWallet';
// import ArgentWebWalletIcon from './ArgentWebWallet';

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
  // display: "grid",
  display: 'flex',
  flexDirection: 'column',
  width: '30%',
});

// const HeaderDiv = styled('div')({
//   display: 'flex',
//   justifyContent: 'space-between',
//   alignItems: 'center',
//   marginBottom: '12px',
//   fontWeight: 'bold',
// });

// const CloseStyledIcon = styled(CloseIcon)({
//   cursor: 'pointer',
//   padding: '0 8px',
//   fontSize: '2em',
//   position: 'absolute',
//   top: 8, // You can adjust this value as needed
//   right: 8, // You can adjust this value as needed
//   transition: 'boxShadow 0.3s ease', // Smooth transition for the shadow on hover

//   '&:hover': {
//     boxShadow: '0px 0px 10px 3px rgba(0, 0, 0, 0.2)', // Circle shadow effect
//     borderRadius: '50%', // Ensures the shadow takes a circular form
//   },
// });

const StyledUl = styled('ul')({
  padding: '8px',
  flexGrow: 1,
});

const StyledLi = styled('li')({
  listStyleType: 'none',
  margin: '8px',
});

// const ConnectorText = styled('span')({
//   flexGrow: 1,
//   textAlign: 'center',
//   fontWeight: 'bold',
// });

// const DisclaimerText = styled('div')({
//   fontSize: '12px',
//   fontWeight: '400',
//   width: '100%',
//   margin: '2px auto',
//   textAlign: 'center',
// });

const ToolbarWalletButton = styled(Button)({
  width: 'auto',
  borderRadius: 8,
  padding: '8px 32px',
  fontWeight: 'bold',
  textTransform: 'capitalize',
  letterSpacing: '0.1em',
  backgroundColor: '#4A63AA', // Slightly lighter background for the WalletButton
  border: '1px solid #28408F', // Darker border for definition
  display: 'flex',
  color: '#F4F3EE',
  justifyContent: 'center',
  '&:hover': {
    background: '#445C9C', // Slightly lighter than #1B1E2A for a subtle hover effect
  },
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

export default function ConnectWallet() {
  const [open, setOpen] = React.useState(false);
  const toggleModal = () => {
    setOpen((prevState) => !prevState);
  };
  // const handleClose = () => {
  //   setOpen(false);
  // };
  const { account } = useDojo();

  const [clipboardStatus, setClipboardStatus] = useState({
    message: '',
    isError: false,
  });

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
      <ToolbarWalletButton
        startIcon={<AccountBalanceWalletIcon />}
        onClick={toggleModal}
      >
        Create Burner
      </ToolbarWalletButton>
      <Modal
        open={open}
        onClose={toggleModal}
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
}
