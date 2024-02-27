import styled from 'styled-components';
import { ColonyResourcesSection } from './ColonyResourcesSection';
import { useColonyCompounds } from '../../hooks/useColonyCompounds';
import { useColonyDefences } from '../../hooks/useColonyDefences';
import { useColonyShips } from '../../hooks/useColonyShips';
import { useColonyResources } from '../../hooks/useColonyResources';

export const GameContainer = styled.div`
  display: grid;
  grid-template-rows: 34% auto;
  justify-items: center;
  align-items: center;
  height: 100%;
  max-height: 100vh;
  flex: 5;
`;

export const DashboardMainContainer = styled.div`
  height: 100vh;
  overflow: auto;
  width: 100vw;
  display: flex;
  flex-direction: row;
  justify-items: center;
  border: 2px solid #151a1e;
  align-items: stretch;
`;

export const DashboardSubBodyContainer = styled.section<{ border?: boolean }>`
  display: flex;
  flex-direction: row;
  justify-content: flex-start;
  justify-items: center;
  height: 100%;
  width: 100%;
  background-color: #151a1e;
`;

interface Props {
  planetId: number;
  colonyId: number;
}

export default function ColonyDashboard({ planetId, colonyId }: Props) {
  const resources = useColonyResources(planetId, colonyId);

  const compoundLevels = useColonyCompounds(planetId, colonyId);

  const defences = useColonyDefences(planetId, colonyId);

  const ships = useColonyShips(planetId, colonyId);

  const celestia = defences.celestia;

  return (
    <ColonyResourcesSection
      planetId={planetId}
      colonyId={colonyId}
      resources={resources}
      defences={defences}
      compounds={compoundLevels}
      ships={ships}
      celestia={celestia}
    />
  );
}
