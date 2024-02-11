import styled from 'styled-components'
import { Box } from '@mui/system'

export const PopoverBox = styled(Box)({
  fontWeight: 400,
  position: 'absolute',
  top: '50%',
  left: '50%',
  transform: 'translate(-50%, -50%)',
  backgroundColor: '#1a2025',
  borderRadius: 16,
  boxShadow: '0px 3px 5px rgba(0, 0, 0, 0.2)',
  padding: '24px 24px',
  flexDirection: 'column',
  width: '40%',
  display: 'grid',
  gridTemplateRows: 'auto 1fr auto', // Three rows: header, main content, stats
  gap: '16px' // Space between grid rows
})

export const PopoverHeaderDiv = styled('div')({
  fontSize: 20,
  marginBottom: '16px',
  textTransform: 'uppercase'
})

export const PopoverInfoRow = styled('div')({
  display: 'flex',
  justifyContent: 'start', // Aligned to the start, closer together
  alignItems: 'center',
  marginBottom: '16px'
})

export const PopoverTextBox = styled('div')`
  font-size: 16px;
  line-height: 1.5;
  margin-bottom: 24px;
`

export const PopoverGridContainer = styled('div')({
  display: 'grid',
  gridTemplateColumns: 'repeat(2, 1fr)', // Two columns
  gridAutoRows: 'minmax(32px, auto)', // Row height
  gap: '4px' // Reduced space between grid items
})

export const PopoverInfoData = styled('span')({
  color: '#23CE6B'
})

export const PopoverLabel = styled('span')({
  marginRight: '8px' // Adjust this value as needed to control spacing
})

export const PopoverRequirements = styled('ul')({
  color: '#23CE6B',
  margin: '16px'
})
