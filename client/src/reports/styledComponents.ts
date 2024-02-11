import styled from 'styled-components';

export const ContentWrapper = styled.div`
  margin-top: 24px;
  width: 50%;
  margin: 0 auto; // This centers the box
  background-color: #0d1117; // Dark background for terminal effect
  color: #58a6ff; // Light blue color for text
  font-family: 'Courier New', Courier, monospace; // Monospaced font for a terminal look
`;

export const BattleReportContainer = styled.div`
  margin-bottom: 10px;
  border-radius: 5px;
  overflow: hidden;
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
  border: 1px solid #30363d; // Border for each report
`;

interface BattleReportHeaderProps {
  reportType: 'battle' | 'debris';
}

export const BattleReportHeader = styled.div<BattleReportHeaderProps>`
  cursor: pointer;
  padding: 10px;
  display: flex;
  justify-content: space-between;
  align-items: center;
  background: linear-gradient(180deg, #161b22 0%, #0d1117 100%);
  color: ${(props) =>
    props.reportType === 'battle' ? '#4caf50' : '#ff9800'}; // Conditional color
  &:hover {
    background: linear-gradient(180deg, #21262d 0%, #161b22 100%);
  }
`;

export const BattleReportDetails = styled.div`
  background-color: #0d1117;
  padding: 10px;
  position: relative; // Add this to position children absolutely relative to this container
  display: none;
  &.expanded {
    display: block;
  }
`;

export const DetailItem = styled.div`
  color: #8b949e; // Grey color for details
  margin-bottom: 5px;
  padding-left: 20px; // Indentation for readability
`;

export const CopyButton = styled.button`
  position: absolute;
  top: 10px; // Adjust as necessary
  right: 10px; // Adjust as necessary
  cursor: pointer;
`;

export const CenteredMessage = styled.div`
  text-align: center; // Center the text horizontally
  margin-top: 50px; // Add some space at the top
  color: #58a6ff; // Use the same light blue color for consistency
  font-size: 24px; // Larger font size for visibility
`;
