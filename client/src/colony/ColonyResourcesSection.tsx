import React, { useState } from 'react';
import { RowCentered } from '../components/ui/Row';
import CircularProgress from '@mui/material/CircularProgress';
import { PrecisionManufacturing, Security } from '@mui/icons-material';
import {
  ResourceTab,
  ResourcesTabs,
  ResourcesTabList,
} from '../shared/styled/Tabs';
import { useTechLevels } from '../hooks/LevelsHooks';
import {
  type CompoundsLevels,
  type Resources,
  type TechLevels,
  type DefenceCost,
  type DefenceLevels,
  type ShipsLevels,
  type ShipsCost,
} from '../shared/types';
import { Typography } from '@mui/material';
import { getBaseDefenceCost } from '../constants/costs';
import { DefenceTabPanel } from '../panels/DefencesTab';
import { ColonyCompoundTabPanel } from './ColonyTab';
import RocketIcon from '@mui/icons-material/Rocket';
import { DockyardTabPanel } from '../panels/DockyardTab';
import { UniverseViewTabPanel } from '../panels/UniverseViewTab';
import { Explore } from '@mui/icons-material';

interface ResourcesSectionArgs {
  planetId: number;
  colonyId: number;
  spendableResources: Resources;
  collectibleResource: Resources;
  compoundsLevels: CompoundsLevels;
  defencesLevels: DefenceLevels;
  shipsLevels: ShipsLevels;
  shipsCost: ShipsCost;
  celestiaAvailable: number;
}

export const ColonyResourcesSection = ({
  planetId,
  colonyId,
  spendableResources,
  collectibleResource,
  compoundsLevels,
  defencesLevels,
  shipsLevels,
  shipsCost,
  celestiaAvailable,
}: ResourcesSectionArgs) => {
  const [activeTab, setActiveTab] = useState(1);
  const techLevels = useTechLevels(planetId);
  const defencesCost = getBaseDefenceCost();

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
            <RocketIcon />
            <Typography>Dockyard</Typography>
          </RowCentered>
        </ResourceTab>
        <ResourceTab
          onClick={() => {
            setActiveTab(3);
          }}
          active={activeTab === 3 ? 'true' : 'false'}
        >
          <RowCentered gap={'8px'}>
            <Security />
            <Typography>Defences</Typography>
          </RowCentered>
        </ResourceTab>
        <ResourceTab
          onClick={() => {
            setActiveTab(4);
          }}
          active={activeTab === 4 ? 'true' : 'false'}
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
        renderDockyardTab(
          totalResources,
          shipsLevels,
          shipsCost,
          compoundsLevels.dockyard,
          techLevels,
          celestiaAvailable,
          colonyId
        )}
      {activeTab === 3 &&
        renderDefencesPanel(
          totalResources,
          defencesLevels,
          defencesCost,
          compoundsLevels.dockyard,
          techLevels,
          colonyId
        )}
      {activeTab === 4 && renderUniversePanel(planetId, techLevels, colonyId)}
    </ResourcesTabs>
  );
};

function renderCompounds(
  colonyId: number,
  spendable: Resources,
  compounds: CompoundsLevels
) {
  return (
    <ColonyCompoundTabPanel
      colonyId={colonyId}
      spendableResources={spendable}
      compoundsLevels={compounds}
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
