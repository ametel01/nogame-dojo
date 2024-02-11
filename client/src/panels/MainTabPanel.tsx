import {
  React,
  useState,
  useCompoundsLevels,
  useTechLevels,
  useSpendableResources,
  useCollectibleResources,
  useShipsLevels,
  getBaseShipsCost,
  useDefencesLevels,
  useGetCelestiaAvailable,
  getBaseDefenceCost,
  ResourcesTabs,
  ResourcesTabList,
  CircularProgress,
  Resources,
  ResourceTab,
  RowCentered,
  PrecisionManufacturing,
  Typography,
  Biotech,
  Rocket,
  Security,
  Explore,
  CompoundsLevels,
  CompoundsTabPanel,
  TechLevels,
  ResearchTabPanel,
  ShipsLevels,
  ShipsCost,
  DockyardTabPanel,
  DefenceLevels,
  DefenceCost,
  DefenceTabPanel,
  UniverseViewTabPanel,
  ResourcesSectionArgs,
} from '.';

import { useEffect } from 'react';
import { useDestination } from '../context/DestinationContext';

export const ResourcesSection = ({
  planetId,
  colonyId,
}: ResourcesSectionArgs) => {
  const [activeTab, setActiveTab] = useState(1);
  const compoundsLevels = useCompoundsLevels(planetId);
  const techLevels = useTechLevels(planetId);
  const spendableResources = useSpendableResources(planetId);
  const collectibleResource = useCollectibleResources(planetId);
  const shipsLevels = useShipsLevels(planetId);
  const shipsCost = getBaseShipsCost();
  const defencesLevels = useDefencesLevels(planetId);
  const celestiaAvailable = useGetCelestiaAvailable(planetId);
  const defencesCost = getBaseDefenceCost();

  const { selectedDestination } = useDestination();

  useEffect(() => {
    if (selectedDestination !== null) {
      setActiveTab(5); // Set to Universe tab
    }
  }, [selectedDestination]);

  if (
    !compoundsLevels ||
    !techLevels ||
    !spendableResources ||
    !collectibleResource
  ) {
    // Centered CircularProgress
    return (
      <div
        style={{
          display: 'flex',
          justifyContent: 'center',
          alignItems: 'center',
          height: '100vh',
        }}
      >
        <ResourcesTabs>
          <ResourcesTabList>
            <div
              style={{
                display: 'flex',
                justifyContent: 'center',
                height: '100vh',
                width: '100vh',
              }}
            >
              <CircularProgress />
            </div>
          </ResourcesTabList>
        </ResourcesTabs>
      </div>
    );
  }

  const totalResources: Resources = {
    steel: spendableResources.steel + (collectibleResource?.steel ?? 0),
    quartz: spendableResources.quartz + (collectibleResource?.quartz ?? 0),
    tritium: spendableResources.tritium + (collectibleResource?.tritium ?? 0),
  };

  return (
    <ResourcesTabs>
      <ResourcesTabList>
        <ResourceTab
          onClick={() => {
            setActiveTab(1);
          }}
          active={activeTab === 1 ? 'true' : 'false'}
        >
          <RowCentered gap={'8px'}>
            <PrecisionManufacturing />
            <Typography>Compounds</Typography>
          </RowCentered>
        </ResourceTab>
        <ResourceTab
          onClick={() => {
            setActiveTab(2);
          }}
          active={activeTab === 2 ? 'true' : 'false'}
        >
          <RowCentered gap={'8px'}>
            <Biotech />
            <Typography>Research Lab</Typography>
          </RowCentered>
        </ResourceTab>
        <ResourceTab
          onClick={() => {
            setActiveTab(3);
          }}
          active={activeTab === 3 ? 'true' : 'false'}
        >
          <RowCentered gap={'8px'}>
            <Rocket />
            <Typography>Dockyard</Typography>
          </RowCentered>
        </ResourceTab>
        <ResourceTab
          onClick={() => {
            setActiveTab(4);
          }}
          active={activeTab === 4 ? 'true' : 'false'}
        >
          <RowCentered gap={'8px'}>
            <Security />
            <Typography>Defences</Typography>
          </RowCentered>
        </ResourceTab>
        <ResourceTab
          onClick={() => {
            setActiveTab(5);
          }}
          active={activeTab === 5 ? 'true' : 'false'}
        >
          <RowCentered gap={'8px'}>
            <Explore />
            <Typography>Universe</Typography>
          </RowCentered>
        </ResourceTab>
      </ResourcesTabList>
      {activeTab === 1 &&
        renderCompounds(colonyId, totalResources, compoundsLevels)}
      {activeTab === 2 &&
        renderLabPanel(totalResources, techLevels, Number(compoundsLevels.lab))}
      {activeTab === 3 &&
        renderDockyardTab(
          totalResources,
          shipsLevels,
          shipsCost,
          compoundsLevels.dockyard,
          techLevels,
          celestiaAvailable,
          colonyId
        )}
      {activeTab === 4 &&
        renderDefencesPanel(
          totalResources,
          defencesLevels,
          defencesCost,
          compoundsLevels.dockyard,
          techLevels,
          colonyId
        )}
      {activeTab === 5 && renderUniversePanel(planetId, techLevels, colonyId)}
    </ResourcesTabs>
  );
};

function renderCompounds(
  colonyId: number,
  spendable: Resources,
  compounds: CompoundsLevels
) {
  return (
    <CompoundsTabPanel
      spendableResources={spendable}
      compoundsLevels={compounds}
      colonyId={colonyId}
    />
  );
}

function renderLabPanel(
  spendable: Resources,
  techs: TechLevels,
  labLevel: number
) {
  return (
    <ResearchTabPanel
      spendableResources={spendable}
      techLevels={techs}
      labLevel={labLevel}
    />
  );
}

function renderDockyardTab(
  spendable: Resources,
  ships: ShipsLevels,
  shipCost: ShipsCost,
  dockyard: number,
  techs: TechLevels,
  celestia: number,
  colonyId: number
) {
  return (
    <DockyardTabPanel
      spendableResources={spendable}
      shipsLevels={ships}
      shipsCost={shipCost}
      dockyardLevel={dockyard}
      techLevels={techs}
      celestia={celestia}
      colonyId={colonyId}
    />
  );
}

function renderDefencesPanel(
  spendable: Resources,
  defences: DefenceLevels,
  defencesCost: DefenceCost,
  dockyard: number,
  techs: TechLevels,
  colonyId: number
) {
  return (
    <DefenceTabPanel
      spendableResources={spendable}
      defenceLevels={defences}
      defenceCost={defencesCost}
      dockyardLevel={dockyard}
      techLevels={techs}
      colonyId={colonyId}
    />
  );
}

function renderUniversePanel(
  planetId: number,
  techLevels: TechLevels,
  colonyId: number
) {
  return (
    <UniverseViewTabPanel
      ownPlanetId={planetId}
      ownTechs={techLevels}
      colonyId={colonyId}
    />
  );
}
