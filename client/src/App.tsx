import React from 'react';
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import { GlobalStyle } from './shared/styled/Theme';
import AuthController from './components/auth/AuthController';

function App() {
  return (
    <>
      <GlobalStyle />
      <Router>
        <Routes>
          <Route path="/" element={<AuthController />} />
        </Routes>
      </Router>
    </>
  );
}

export default App;
