import React, { useState } from 'react';
import { RowCentered } from '../components/ui/Row';
import CircularProgress from '@mui/material/CircularProgress';
import { PrecisionManufacturing, Security } from '@mui/icons-material';
import {
  ResourceTab,
  ResourcesTabs,
  ResourcesTabList,
} from '../shared/styled/Tabs';
import { ColonyCompounds } from '../hooks/useColonyCompounds';
import { Techs } from '../hooks/usePlanetTechs';
import { Resources } from '../hooks/usePlanetResources';
import { Fleet } from '../hooks/usePlanetShips';
import { Defences } from '../hooks/usePlanetDefences';
import { type DefenceCost, type ShipsCost } from '../shared/types';
import { Typography } from '@mui/material';
import { getBaseDefenceCost, getBaseShipsCost } from '../constants/costs';
import { DefenceTabPanel } from '../panels/DefencesTab';
import { ColonyCompoundTabPanel } from './ColonyTab';
import RocketIcon from '@mui/icons-material/Rocket';
import { DockyardTabPanel } from '../panels/DockyardTab';
import { UniverseViewTabPanel } from '../panels/UniverseViewTab';
import { Explore } from '@mui/icons-material';
import { usePlanetTechs } from '../hooks/usePlanetTechs';

interface ResourcesSectionArgs {
  planetId: number;
  colonyId: number;
  resources: Resources;
  compounds: ColonyCompounds;
  defences: Defences;
  ships: Fleet;
  celestia: number;
}

export const ColonyResourcesSection = ({
  planetId,
  colonyId,
  resources,
  compounds,
  defences,
  ships,
  celestia,
}: ResourcesSectionArgs) => {
  const [activeTab, setActiveTab] = useState(1);
  const techLevels = usePlanetTechs(planetId);
  const shipsCost = getBaseShipsCost();
  const defencesCost = getBaseDefenceCost();

  if (!compounds || !techLevels || !resources) {
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
      {activeTab === 1 && renderCompounds(colonyId, resources, compounds)}
      {activeTab === 2 &&
        renderDockyardTab(
          resources,
          ships,
          shipsCost,
          compounds.dockyard || 0,
          techLevels,
          celestia,
          colonyId
        )}
      {activeTab === 3 &&
        renderDefencesPanel(
          resources,
          defences,
          defencesCost,
          compounds.dockyard || 0,
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
  compounds: ColonyCompounds
) {
  return (
    <ColonyCompoundTabPanel
      colonyId={colonyId}
      resources={spendable}
      compounds={compounds}
    />
  );
}

function renderDockyardTab(
  spendable: Resources,
  ships: Fleet,
  shipCost: ShipsCost,
  dockyard: number,
  techs: Techs,
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
  defences: Defences,
  defencesCost: DefenceCost,
  dockyard: number,
  techs: Techs,
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
  techLevels: Techs,
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
