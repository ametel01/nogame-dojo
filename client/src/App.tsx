import React from 'react';
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import { GlobalStyle } from './shared/styled/Theme';
import AuthController from './components/auth/AuthController';
import GeneralLeaderboardPage from './pages/GeneralLeaderBoardPage';
import BattleReportsPage from './pages/BattleReportsPage';
import PioneerNFTPage from './pages/PioneerNFTPage';
import { BlockchainCallProvider } from './context/BlockchainCallContext'; // Import the provider
import { BattleSimulator } from './pages/Simulator';

function App() {
  return (
    <BlockchainCallProvider>
      <GlobalStyle />
      <Router>
        <Routes>
          <Route path="/" element={<AuthController />} />
          <Route path="/pioneer" element={<PioneerNFTPage />}></Route>
          <Route path="/leaderboard" element={<GeneralLeaderboardPage />} />
          <Route path="/battlereports" element={<BattleReportsPage />} />
          <Route path="/simulator" element={<BattleSimulator />} />
        </Routes>
      </Router>
    </BlockchainCallProvider>
  );
}

export default App;
