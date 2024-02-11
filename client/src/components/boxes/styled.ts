import { Styled, styled } from '.';

export const InfoContainer = styled(Styled.InfoContainer)({
  width: '45%',
});

export const Box = styled('div')({
  justifyContent: 'space-evenly',
  alignItems: 'center',
  padding: '0 5px',
  width: '100%',
  maxHeight: '70px',
  height: '100%',
  display: 'flex',
  flexDirection: 'row',
  marginBottom: '10px',
  backgroundColor: '#1A2025',
  borderRadius: '8px',
  overflow: 'hidden',
  boxShadow: '0 4px 8px rgba(0, 0, 0, 0.1)',
});

export const ImageContainer = styled('div')({
  flexShrink: 0,
  display: 'flex',
  alignItems: 'center',
  width: '60px',
  flex: '0 0 auto',
  margin: '0 10px',
  marginRight: '5px',
  marginLeft: '0',
});
