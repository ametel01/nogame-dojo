import { createGlobalStyle } from 'styled-components'

export const GlobalStyle = createGlobalStyle`
  /* CSS Reset */
  *, *::before, *::after {
    margin: 0;
    padding: 0;
    border: 0;
    box-sizing: border-box;
  }

  /* Base font settings */
  html, body, input, textarea, button {
    font-family: 'Roboto', sans-serif;
    font-display: fallback;
    color: #F4F3EE;
    background-color: #151a1e;
  }

  /* Specific html settings */
  html {
    font-size: 17px;
    font-variant: none;
    -webkit-font-smoothing: antialiased;
    -moz-osx-font-smoothing: grayscale;
    -webkit-tap-highlight-color: rgba(0, 0, 0, 0);
    font-feature-settings: 'ss01' on, 'ss02' on, 'cv01' on, 'cv03' on;
    background-repeat: no-repeat;
    background-size: cover;
  }

  /* Full viewport height for body and root div, overflow handling */
  body, #root {
    height: 100vh;
    min-height: 100vh;
    width: 100%;
    overflow-x: hidden;
    overflow-y: auto;
  }

  /* Button specific settings */
  button {
    user-select: none;
  }

  /* Supports rule (if needed, can be more specific or removed if not used) */
  @supports (font-variation-settings: normal) {
    html, input, textarea, button {
      font-family: 'Share Tech Mono', sans-serif;
    }
  }
`

export default GlobalStyle
