import { Tab, Tabs, TabPanel, TabList } from 'react-tabs'
import { styled } from '@mui/system'

export const ResourcesTabs = styled(Tabs)({
  width: '100%',
  display: 'flex',
  flexDirection: 'column'
})

export const ResourcesTabList = styled(TabList)({
  marginTop: '0px',
  border: 'none',
  display: 'flex',
  padding: '0px 24px'
})

export const ResourceTab = styled(Tab)({
  flex: 1,
  display: 'flex',
  justifyContent: 'center',
  alignItems: 'center',
  fontWeight: 500,
  fontSize: '16px',
  lineHeight: '21px',
  letterSpacing: '0.02em',
  border: 'none',
  padding: '16px',
  cursor: 'pointer',
  borderRadius: '4px 4px 0px 0px',
  '&[aria-selected="true"]': {
    backgroundColor: '#E0E0E0', // Lighter background
    borderColor: '#333333' // Darker border
  },
  ':focus-visible, :focus': {
    outline: 'none',
    border: 'none',
    '&:after': {
      background: 'transparent'
    }
  }
})

export const StyledTabPanel = styled(TabPanel)({
  marginTop: '0px',
  width: '100%',
  alignItems: 'flex-start',
  padding: '10px',
  display: 'none',
  flexDirection: 'column',
  overflow: 'auto',
  '&.react-tabs__tab-panel--selected': {
    display: 'flex',
    overflow: 'auto'
  }
})
