import React from 'react'
import ReactDOM from 'react-dom/client'
import WebFont from 'webfontloader'
import { StarknetProvider } from './components/provider'
import App from './App_old'

// Load Orbitron font
WebFont.load({
  google: {
    families: ['Share Tech Mono:400,500,600,700']
  }
})

ReactDOM.createRoot(document.getElementById('root')!).render(
  <React.StrictMode>
    <StarknetProvider>
      <App />
    </StarknetProvider>
  </React.StrictMode>
)
