import styled from 'styled-components';

export const StyledInput = styled.input`
  max-width: 80px; // Set a maximum width or choose a specific width
  margin: 5px 5px;
  padding: 8px;
  border: none;
  border-radius: 5px;
  box-shadow: inset 0 2px 4px rgba(0, 0, 0, 0.3);
  background-color: #2c3e50;
  color: #23ce6b;
  &:focus {
    outline: none;
    box-shadow: 0 0 5px #4fd1c5; // Focus effect
  }
`;
