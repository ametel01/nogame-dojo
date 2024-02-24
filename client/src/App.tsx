import React from 'react';
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import { GlobalStyle } from './shared/styled/Theme';
import AuthController from './ui/auth/AuthController';
import GeneralLeaderboardPage from './ui/pages/GeneralLeaderboardPage';

function App() {
  return (
    <>
      <GlobalStyle />
      <Router>
        <Routes>
          <Route path="/" element={<AuthController />} />
          <Route path="/leaderboard" element={<GeneralLeaderboardPage />} />
        </Routes>
      </Router>
    </>
  );
}

export default App;
