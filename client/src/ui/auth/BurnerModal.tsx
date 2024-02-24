import React, { useState, useEffect } from 'react';
import Modal from '@mui/material/Modal';
import { useDojo } from '../../dojo/useDojo';
import * as styles from './styled';

interface BurnerModalProps {
  open: boolean;
  onClose: () => void;
}

export const BurnerModal = ({ open, onClose }: BurnerModalProps) => {
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
      <Modal
        open={open}
        onClose={onClose}
        aria-label="Connect Wallet Modal"
        disableAutoFocus={true}
      >
        <styles.BurnerModalBox>
          <styles.BurnerModalUl>
            <styles.BurnerModalLi>
              <styles.BurnerModalWalletButton onClick={account?.create}>
                {account?.isDeploying ? 'deploying burner' : 'create burner'}
              </styles.BurnerModalWalletButton>
            </styles.BurnerModalLi>
            {account && account?.list().length > 0 && (
              <styles.BurnerModalLi>
                <styles.BurnerModalWalletButton
                  onClick={async () => await account?.copyToClipboard()}
                >
                  Save Burners to Clipboard
                </styles.BurnerModalWalletButton>
              </styles.BurnerModalLi>
            )}
            <styles.BurnerModalLi>
              <styles.BurnerModalWalletButton onClick={handleRestoreBurners}>
                Restore Burners from Clipboard
              </styles.BurnerModalWalletButton>
            </styles.BurnerModalLi>
            {clipboardStatus.message && (
              <div className={clipboardStatus.isError ? 'error' : 'success'}>
                {clipboardStatus.message}
              </div>
            )}
            <styles.BurnerModalLi>
              <styles.BurnerModalWalletButton onClick={() => account.clear()}>
                Clear burners
              </styles.BurnerModalWalletButton>
            </styles.BurnerModalLi>
            <styles.BurnerModalLi
              className="card"
              style={{ textAlign: 'center' }}
            >
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
            </styles.BurnerModalLi>
          </styles.BurnerModalUl>
        </styles.BurnerModalBox>
      </Modal>
    </>
  );
};
