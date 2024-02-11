import React, { useState, useEffect } from 'react';
import Tooltip from '@mui/material/Tooltip';
import ContentCopyIcon from '@mui/icons-material/ContentCopy';
import RotatingLogo from '../components/ui/RotatingLogo';
import * as Styled from './styledComponents';
import * as Types from './types';
import { numberWithCommas } from '../shared/utils/index';

interface Props {
  planetId: number;
}

const BattleReports = ({ planetId }: Props) => {
  const [battleReports, setBattleReports] = useState<Types.BattleReport[]>([]);
  const [debriReports, setDerisReports] = useState<Types.DebrisCollection[]>(
    []
  );
  const [sortedReports, setSortedReports] = useState<
    (Types.BattleReport | (Types.DebrisCollection & { reportType: string }))[]
  >([]);
  const [expandedReports, setExpandedReports] = useState<Set<string>>(
    new Set()
  );
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [copyTooltipMessage, setCopyTooltipMessage] =
    useState<string>('Copy to clipboard');

  useEffect(() => {
    const combinedReports: CombinedReport[] = [
      ...battleReports.map((report) => ({
        ...report,
        reportType: 'battle' as const,
      })),
      ...debriReports.map((report) => ({
        ...report,
        reportType: 'debris' as const,
      })),
    ];

    combinedReports.sort((a, b) => {
      const dateA =
        a.reportType === 'battle' ? new Date(a.time) : new Date(a.timestamp);
      const dateB =
        b.reportType === 'battle' ? new Date(b.time) : new Date(b.timestamp);
      return dateB.getTime() - dateA.getTime();
    });

    setSortedReports(combinedReports);
  }, [battleReports, debriReports]);

  const nodeEnv = import.meta.env.VITE_NODE_ENV;
  const battleApiUrl =
    nodeEnv === 'production'
      ? `https://www.api.testnet.no-game.xyz/battle-reports?planet_id=${planetId}`
      : `http://localhost:3001/battle-reports?planet_id=${planetId}`;

  useEffect(() => {
    const fetchData = async () => {
      setIsLoading(true);
      setError(null);
      try {
        const response = await fetch(battleApiUrl);
        if (!response.ok) {
          setError('Error battle debris reports');
          setBattleReports([]);
        } else {
          const data = await response.json();
          // Sort data by most recent first
          data.sort(
            (
              a: { time: string | number | Date },
              b: { time: string | number | Date }
            ) => new Date(b.time).getTime() - new Date(a.time).getTime()
          );
          setBattleReports(data);
        }
      } catch (error) {
        if (error instanceof Error) {
          setError(error.message);
        } else {
          setError('An unexpected error occurred');
        }
      } finally {
        setIsLoading(false);
      }
    };

    if (planetId !== undefined) {
      fetchData();
    }
  }, [battleApiUrl, planetId]);

  const debrisApiUrl =
    nodeEnv === 'production'
      ? `https://www.api.testnet.no-game.xyz/debris-collection?planet_id=${planetId}`
      : `http://localhost:3001/debris-collection?planet_id=${planetId}`;

  useEffect(() => {
    const fetchData = async () => {
      setIsLoading(true);
      setError(null);
      try {
        const response = await fetch(debrisApiUrl);
        if (!response.ok) {
          setError('Error fetching debris reports');
          setDerisReports([]);
        } else {
          const data = await response.json();
          // Sort data by most recent first
          data.sort(
            (
              a: { time: string | number | Date },
              b: { time: string | number | Date }
            ) => new Date(b.time).getTime() - new Date(a.time).getTime()
          );
          setDerisReports(data);
        }
      } catch (error) {
        if (error instanceof Error) {
          setError(error.message);
        } else {
          setError('An unexpected error occurred');
        }
      } finally {
        setIsLoading(false);
      }
    };

    if (planetId !== undefined) {
      fetchData();
    }
  }, [debrisApiUrl, planetId]);

  const toggleExpand = (id: number, type: 'battle' | 'debris') => {
    setExpandedReports((prevExpandedReports) => {
      const newExpandedReports = new Set(prevExpandedReports);
      const uniqueId = `${type}-${id}`;
      if (newExpandedReports.has(uniqueId)) {
        newExpandedReports.delete(uniqueId);
      } else {
        newExpandedReports.add(uniqueId);
      }
      return newExpandedReports;
    });
  };

  if (isLoading) {
    return <RotatingLogo />;
  }

  if (error || battleReports.length === 0) {
    return (
      <Styled.CenteredMessage>
        No Battle Reports Available
      </Styled.CenteredMessage>
    );
  }

  const copyToClipboard = (report: Types.BattleReport) => {
    const formatFleetComposition = (fleet: Types.Fleet) => {
      return (
        Object.entries(fleet)
          .filter(([, quantity]) => quantity > 0)
          .map(
            ([type, quantity]) =>
              `- ${type.charAt(0).toUpperCase() + type.slice(1)}: ${quantity}`
          )
          .join('\n') || '- No active fleet units detected.'
      );
    };

    const formatDefences = (defences: Types.Defences) => {
      return (
        Object.entries(defences)
          .filter(([, quantity]) => quantity > 0)
          .map(
            ([type, quantity]) =>
              `- ${type.charAt(0).toUpperCase() + type.slice(1)}: ${quantity}`
          )
          .join('\n') || '- No defenses were present.'
      );
    };

    const formatLoot = (loot: Types.Loot) => {
      return (
        Object.entries(loot)
          .filter(([, quantity]) => quantity > 0)
          .map(
            ([resourceType, quantity]) =>
              `- ${
                resourceType.charAt(0).toUpperCase() + resourceType.slice(1)
              }: ${quantity}`
          )
          .join('\n') || '- None'
      );
    };

    const formatDebris = (loot: Types.Debris) => {
      return (
        Object.entries(loot)
          .filter(([, quantity]) => quantity > 0)
          .map(
            ([resourceType, quantity]) =>
              `- ${
                resourceType.charAt(0).toUpperCase() + resourceType.slice(1)
              }: ${quantity}`
          )
          .join('\n') || '- None'
      );
    };

    const formatCasualties = (losses: Types.Fleet) => {
      return (
        Object.entries(losses)
          .filter(([, quantity]) => quantity > 0)
          .map(
            ([fleetType, quantity]) =>
              `${quantity} ${
                fleetType.charAt(0).toUpperCase() + fleetType.slice(1)
              }`
          )
          .join(', ') || 'None'
      );
    };

    const formatReportForDiscord = (report: Types.BattleReport) => {
      let formattedReport = `**Battle Report ID**: [${report.battle_id}]\n`;
      formattedReport += `**Timestamp**: [${new Date(
        report.time
      ).toLocaleString()}]\n`;
      formattedReport += '**Operational Summary**:\n';
      formattedReport += `- Attacking Planet: System ${report.attacker_position.system} Orbit ${report.attacker_position.orbit}\n`;
      formattedReport += `- Defending Planet: System ${report.defender_position.system} Orbit ${report.defender_position.orbit}\n`;
      formattedReport += `**Attacker Fleet Composition**:\n${formatFleetComposition(
        report.attacker_initial_fleet
      )}\n`;
      formattedReport += `**Defender Fleet Composition**:\n${formatFleetComposition(
        report.defender_initial_fleet
      )}\n`;
      formattedReport += `**Defender Planetary Defenses**:\n${formatDefences(
        report.initial_defences
      )}\n`;
      formattedReport += '**Casualty and Damage Report**:\n';
      formattedReport += `- Attacker Losses: ${formatCasualties(
        report.attacker_fleet_loss
      )}\n`;
      formattedReport += `- Defender Losses: ${formatCasualties({
        ...report.defender_fleet_loss,
        ...report.defences_loss,
      })}\n`;
      formattedReport += `**Resource Acquisition**:\n${formatLoot(
        report.loot
      )}\n`;
      formattedReport += '**Post-Combat Assessment**:\n';
      formattedReport += `- Outcome: ${
        Object.values(report.loot).some((value) => value > 0)
          ? 'Decisive Attacker Victory'
          : 'Attacker Defeat'
      }\n`;
      formattedReport += `- Debris Analysis: ${formatDebris(report.debris)}`;

      return formattedReport;
    };

    const formattedReport = formatReportForDiscord(report);

    navigator.clipboard
      .writeText(formattedReport)
      .then(() => {
        setCopyTooltipMessage('Copied to clipboard'); // Update tooltip message
        setTimeout(() => {
          setCopyTooltipMessage('Copy to clipboard');
        }, 2000); // Reset message after 2 seconds
      })
      .catch((err) => {
        console.error('Error in copying text: ', err);
      });
  };

  type CombinedReport =
    | (Types.BattleReport & { reportType: 'battle' })
    | (Types.DebrisCollection & { reportType: 'debris' });

  function isBattleReport(
    report: CombinedReport
  ): report is Types.BattleReport & { reportType: 'battle' } {
    return report.reportType === 'battle';
  }

  const renderReport = (report: CombinedReport) => {
    const uniqueKey =
      report.reportType === 'battle'
        ? `battle-${report.battle_id}`
        : `debris-${report.collection_id}`;
    const isExpanded = expandedReports.has(uniqueKey);
    if (isBattleReport(report)) {
      return (
        <Styled.BattleReportContainer key={report.battle_id}>
          <Styled.BattleReportHeader
            onClick={() => toggleExpand(report.battle_id, report.reportType)}
            reportType={report.reportType}
          >
            <span>Battle Report</span>
            <span>{new Date(report.time).toLocaleString()}</span>
          </Styled.BattleReportHeader>
          <Styled.BattleReportDetails className={isExpanded ? 'expanded' : ''}>
            <Tooltip title={copyTooltipMessage}>
              <Styled.CopyButton
                onClick={(e) => {
                  e.stopPropagation(); // Prevents the collapsing of the report
                  copyToClipboard(report);
                }}
              >
                <ContentCopyIcon />
              </Styled.CopyButton>
            </Tooltip>
            {/* Display the military-style narrative of the battle */}
            <Styled.DetailItem>
              Time: [{new Date(report.time).toLocaleString()}]
            </Styled.DetailItem>

            <Styled.DetailItem>Operational Summary:</Styled.DetailItem>
            <Styled.DetailItem>
              - Attacking Planet: System {report.attacker_position.system} Orbit{' '}
              {report.attacker_position.orbit}
            </Styled.DetailItem>
            <Styled.DetailItem>
              - Defending Planet: System {report.defender_position.system} Orbit{' '}
              {report.defender_position.orbit}
            </Styled.DetailItem>

            <Styled.DetailItem>Attacker Fleet Composition:</Styled.DetailItem>
            {Object.entries(report.attacker_initial_fleet)
              .filter(([, quantity]) => quantity > 0)
              .map(([fleetType, quantity]) => (
                <Styled.DetailItem key={fleetType}>
                  - {fleetType.charAt(0).toUpperCase() + fleetType.slice(1)}:{' '}
                  {quantity}
                </Styled.DetailItem>
              ))}

            <Styled.DetailItem>Defender Fleet Composition:</Styled.DetailItem>
            {Object.entries(report.defender_initial_fleet).filter(
              ([, quantity]) => quantity > 0
            ).length > 0 ? (
              Object.entries(report.defender_initial_fleet)
                .filter(([, quantity]) => quantity > 0)
                .map(([defenceType, quantity]) => (
                  <Styled.DetailItem key={defenceType}>
                    -{' '}
                    {defenceType.charAt(0).toUpperCase() + defenceType.slice(1)}
                    : {quantity}
                  </Styled.DetailItem>
                ))
            ) : (
              <Styled.DetailItem>
                - No active fleet units detected.
              </Styled.DetailItem>
            )}

            <Styled.DetailItem>Defender Planetary Defences:</Styled.DetailItem>
            {Object.entries(report.initial_defences).filter(
              ([, quantity]) => quantity > 0
            ).length > 0 ? (
              Object.entries(report.initial_defences)
                .filter(([, quantity]) => quantity > 0)
                .map(([defenceType, quantity]) => (
                  <Styled.DetailItem key={defenceType}>
                    -{' '}
                    {defenceType.charAt(0).toUpperCase() + defenceType.slice(1)}
                    : {quantity}
                  </Styled.DetailItem>
                ))
            ) : (
              <Styled.DetailItem>- No defenses were present.</Styled.DetailItem>
            )}

            <Styled.DetailItem>Casualty and Damage Report:</Styled.DetailItem>
            <Styled.DetailItem>
              - Attacker Losses:{' '}
              {Object.entries(report.attacker_fleet_loss)
                .filter(([, quantity]) => quantity > 0)
                .map(
                  ([fleetType, quantity]) =>
                    `${quantity} ${
                      fleetType.charAt(0).toUpperCase() + fleetType.slice(1)
                    }`
                )
                .join(', ') || 'None'}
            </Styled.DetailItem>
            <Styled.DetailItem>
              - Defender Losses:{' '}
              {Object.entries({
                ...report.defender_fleet_loss,
                ...report.defences_loss,
              })
                .filter(([, quantity]) => quantity > 0)
                .map(
                  ([fleetType, quantity]) =>
                    `${quantity} ${
                      fleetType.charAt(0).toUpperCase() + fleetType.slice(1)
                    }`
                )
                .join(', ') || 'None'}
            </Styled.DetailItem>

            <Styled.DetailItem>Resource Acquisition:</Styled.DetailItem>
            {Object.values(report.loot).some((quantity) => quantity > 0) ? (
              Object.entries(report.loot)
                .filter(([, quantity]) => quantity > 0)
                .map(([resourceType, quantity]) => (
                  <Styled.DetailItem key={resourceType}>
                    -{' '}
                    {resourceType.charAt(0).toUpperCase() +
                      resourceType.slice(1)}
                    : {quantity}
                  </Styled.DetailItem>
                ))
            ) : (
              <Styled.DetailItem>- None</Styled.DetailItem>
            )}

            <Styled.DetailItem>Post-Combat Assessment:</Styled.DetailItem>
            <Styled.DetailItem>
              - Outcome:{' '}
              {Object.values(report.loot).some((value) => value > 0)
                ? 'Decisive Attacker Victory'
                : 'Attacker Defeat'}{' '}
              {/* Updated logic for determining the outcome */}
            </Styled.DetailItem>
            <Styled.DetailItem>
              - Debris Analysis:{' '}
              {Object.entries(report.debris)
                .filter(([, quantity]) => quantity > 0)
                .map(
                  ([resourceType, quantity]) =>
                    `${
                      resourceType.charAt(0).toUpperCase() +
                      resourceType.slice(1)
                    }: ${quantity}`
                )
                .join(', ') || 'No debris field generated post-engagement.'}
            </Styled.DetailItem>
          </Styled.BattleReportDetails>
        </Styled.BattleReportContainer>
      );
    } else {
      return (
        <Styled.BattleReportContainer key={report.collection_id}>
          <Styled.BattleReportHeader
            onClick={() =>
              toggleExpand(report.collection_id, report.reportType)
            }
            reportType={report.reportType}
          >
            <span>Debris Report</span>
            <span>{new Date(report.timestamp).toLocaleString()}</span>
          </Styled.BattleReportHeader>
          <Styled.BattleReportDetails
            className={
              expandedReports.has(`debris-${report.collection_id}`)
                ? 'expanded'
                : ''
            }
          >
            <Styled.DetailItem>Debris Field Location:</Styled.DetailItem>
            <Styled.DetailItem>- System: {report.system}</Styled.DetailItem>
            <Styled.DetailItem>- Orbit: {report.orbit}</Styled.DetailItem>
            <Styled.DetailItem>Resources Present at Location</Styled.DetailItem>
            <Styled.DetailItem>
              - Steel: {numberWithCommas(report.collectible_steel)}
            </Styled.DetailItem>
            <Styled.DetailItem>
              - Quartz: {numberWithCommas(report.collectible_quartz)}
            </Styled.DetailItem>
            <Styled.DetailItem>Resources Collected:</Styled.DetailItem>
            <Styled.DetailItem>
              - Steel: {numberWithCommas(report.collected_steel)}
            </Styled.DetailItem>
            <Styled.DetailItem>
              - Quartz: {numberWithCommas(report.collected_quartz)}
            </Styled.DetailItem>
          </Styled.BattleReportDetails>
        </Styled.BattleReportContainer>
      );
    }
  };

  return (
    <>
      <Styled.ContentWrapper>
        {sortedReports.map((report) => (
          <React.Fragment
            key={
              isBattleReport(report as CombinedReport)
                ? `battle-${(report as Types.BattleReport).battle_id}`
                : `debris-${(report as Types.DebrisCollection).collection_id}`
            }
          >
            {renderReport(report as CombinedReport)}
          </React.Fragment>
        ))}
      </Styled.ContentWrapper>
    </>
  );
};

export default BattleReports;
