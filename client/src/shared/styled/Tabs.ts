import { Tab, Tabs, TabPanel, TabList } from 'react-tabs'
import styled from '@emotion/styled'

export const ResourcesTabs = styled(Tabs)`
  width: 100%;
  display: flex;
  flex-direction: column;
  &.react-tabs__tab--selected {
    background: #1e2327;
    border-bottom: 2px solid white;
    position: relative; // Add relative positioning
    z-index: 1; // Increase z-index
  }
`

export const ResourcesTabList = styled(TabList)`
  border: none;
  display: flex;
  padding: 0px 24px 4px 24px; // Add some bottom padding
`

interface ResourceTabProps {
  active: string
}

export const ResourceTab = styled(Tab)<ResourceTabProps>`
  flex: 1;
  position: relative; // Ensure it's on top of other content
  display: flex;
  justify-content: center;
  align-items: center;
  font-weight: 500;
  font-size: 16px;
  line-height: 21px;
  letter-spacing: 0.02em;
  border: none;
  padding: 16px;
  cursor: pointer;
  border-radius: 4px 4px 0px 0px;
  opacity: ${(props) => (props.active == 'true' ? 1.0 : 0.3)};
`

export const StyledTabPanel = styled(TabPanel)`
  width: 100%;
  padding: 10px;
  //background: #1e2327;
  display: flex;
  flex-direction: column;
  //background-color: darkslategray;

  &.react-tabs__tab-panel--selected {
    //height: 300px;
    overflow: auto;
    //min-height: 200px;
  }
  overflow: auto;
`
