import React, { useState, useEffect } from 'react';
import logoRound from '../../assets/logos/logo-round.png';

const RotatingLogo = () => {
  const [showLogo, setShowLogo] = useState(false);

  useEffect(() => {
    const timer = setTimeout(() => {
      setShowLogo(true);
    }, 1000); // 2 seconds timeout

    return () => clearTimeout(timer); // Clear the timer if the component unmounts
  }, []);

  if (showLogo) {
    return (
      <>
        <style>
          {`
            @keyframes rotate {
              from { transform: rotate(0deg); }
              to { transform: rotate(360deg); }
            }
            .rotating-logo {
              animation: rotate 2s linear infinite;
            }
          `}
        </style>
        <div
          style={{
            display: 'flex',
            justifyContent: 'center',
            alignItems: 'center',
            height: '100vh',
            width: '100vw',
          }}
        >
          <img
            src={logoRound}
            className="rotating-logo"
            alt="Logo"
            style={{ width: '7em' }}
          />
        </div>
      </>
    );
  } else {
    return null; // or some loading indicator, or whatever should be shown before the logo appears
  }
};

export default RotatingLogo;
