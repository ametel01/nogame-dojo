import * as deps from '.';

import { useEffect, useState } from 'react';
import { usePlanetCompounds } from '../../hooks/usePlanetCompounds';
import { usePlanetTechs } from '../../hooks/usePlanetTechs';
import { usePlanetShips } from '../../hooks/usePlanetShips';
import { usePlanetDefences } from '../../hooks/usePlanetDefences';
import { useDojo } from '../../dojo/useDojo';
import { Resources } from '../../hooks/usePlanetResources';

export const ResourcesSection = ({
  planetId,
  colonyId,
}: deps.ResourcesSectionArgs) => {
  const {
    setup: {
      systemCalls: { getPlanetResources },
    },
  } = useDojo();
  const [planetResources, setPlanetResources] = useState<Resources | null>(
    null
  );

  useEffect(() => {
    getPlanetResources(planetId)
      .then((resources) => {
        setPlanetResources(resources);
      })
      .catch((error) => {
        console.error('Error fetching planet resources:', error);
      });
  }, [planetId, getPlanetResources, setPlanetResources]);

  const [activeTab, setActiveTab] = deps.useState(1);

  const compoundsLevels = usePlanetCompounds(planetId);

  const techLevels = usePlanetTechs(planetId);

  const shipsLevels = usePlanetShips(planetId);

  const shipsCost = deps.getBaseShipsCost();

  const defencesLevels = usePlanetDefences(planetId);

  const celestiaAvailable = defencesLevels.celestia;

  const defencesCost = deps.getBaseDefenceCost();

  // const { selectedDestination } = useDestination();

  // useEffect(() => {
  //   if (selectedDestination !== null) {
  //     setActiveTab(5); // Set to Universe tab
  //   }
  // }, [selectedDestination, setActiveTab]);

  if (!compoundsLevels || !techLevels || !planetResources || !shipsLevels) {
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
        <deps.ResourcesTabs>
          <deps.ResourcesTabList>
            <div
              style={{
                display: 'flex',
                justifyContent: 'center',
                height: '100vh',
                width: '100vh',
              }}
            >
              <deps.CircularProgress />
            </div>
          </deps.ResourcesTabList>
        </deps.ResourcesTabs>
      </div>
    );
  }

  return (
    <deps.ResourcesTabs>
      <deps.ResourcesTabList>
        <deps.ResourceTab
          onClick={() => {
            setActiveTab(1);
          }}
          active={activeTab === 1 ? 'true' : 'false'}
        >
          <deps.RowCentered gap={'8px'}>
            <deps.PrecisionManufacturing />
            <deps.Typography>Compounds</deps.Typography>
          </deps.RowCentered>
        </deps.ResourceTab>
        <deps.ResourceTab
          onClick={() => {
            setActiveTab(2);
          }}
          active={activeTab === 2 ? 'true' : 'false'}
        >
          <deps.RowCentered gap={'8px'}>
            <deps.Biotech />
            <deps.Typography>Research Lab</deps.Typography>
          </deps.RowCentered>
        </deps.ResourceTab>
        <deps.ResourceTab
          onClick={() => {
            setActiveTab(3);
          }}
          active={activeTab === 3 ? 'true' : 'false'}
        >
          <deps.RowCentered gap={'8px'}>
            <deps.Rocket />
            <deps.Typography>Dockyard</deps.Typography>
          </deps.RowCentered>
        </deps.ResourceTab>
        <deps.ResourceTab
          onClick={() => {
            setActiveTab(4);
          }}
          active={activeTab === 4 ? 'true' : 'false'}
        >
          <deps.RowCentered gap={'8px'}>
            <deps.Security />
            <deps.Typography>Defences</deps.Typography>
          </deps.RowCentered>
        </deps.ResourceTab>
        <deps.ResourceTab
          onClick={() => {
            setActiveTab(5);
          }}
          active={activeTab === 5 ? 'true' : 'false'}
        >
          <deps.RowCentered gap={'8px'}>
            <deps.Explore />
            <deps.Typography>Universe</deps.Typography>
          </deps.RowCentered>
        </deps.ResourceTab>
      </deps.ResourcesTabList>
      {activeTab === 1 &&
        renderCompounds(colonyId, planetResources, compoundsLevels)}
      {activeTab === 2 &&
        renderLabPanel(
          planetResources,
          techLevels,
          Number(compoundsLevels.lab)
        )}
      {activeTab === 3 &&
        renderDockyardTab(
          planetResources,
          shipsLevels,
          shipsCost,
          compoundsLevels?.dockyard || 0,
          techLevels,
          celestiaAvailable || 0,
          colonyId
        )}
      {activeTab === 4 &&
        renderDefencesPanel(
          planetResources,
          defencesLevels,
          defencesCost,
          compoundsLevels.dockyard || 0,
          techLevels,
          colonyId
        )}
      {activeTab === 5 &&
        renderUniversePanel(planetId, techLevels, colonyId, planetResources)}
    </deps.ResourcesTabs>
  );
};

function renderCompounds(
  colonyId: number,
  spendable: deps.Resources,
  compounds: deps.Compounds
) {
  return (
    <deps.CompoundsTabPanel
      resources={spendable}
      compounds={compounds}
      colonyId={colonyId}
    />
  );
}

function renderLabPanel(
  spendable: deps.Resources,
  techs: deps.Techs,
  labLevel: number
) {
  return (
    <deps.ResearchTabPanel
      resources={spendable}
      techLevels={techs}
      labLevel={labLevel}
    />
  );
}

function renderDockyardTab(
  spendable: deps.Resources,
  ships: deps.Fleet,
  shipCost: deps.ShipsCost,
  dockyard: number,
  techs: deps.Techs,
  celestia: number,
  colonyId: number
) {
  return (
    <deps.DockyardTabPanel
      resources={spendable}
      ships={ships}
      shipsCost={shipCost}
      dockyard={dockyard}
      techs={techs}
      celestia={celestia}
      colonyId={colonyId}
    />
  );
}

function renderDefencesPanel(
  spendable: deps.Resources,
  defences: deps.Defences,
  defencesCost: deps.DefenceCost,
  dockyard: number,
  techs: deps.Techs,
  colonyId: number
) {
  return (
    <deps.DefenceTabPanel
      resources={spendable}
      defences={defences}
      defenceCost={defencesCost}
      dockyard={dockyard}
      techs={techs}
      colonyId={colonyId}
    />
  );
}

function renderUniversePanel(
  planetId: number,
  techLevels: deps.Techs,
  colonyId: number,
  resources: deps.Resources
) {
  return (
    <deps.UniverseViewTabPanel
      ownPlanetId={planetId}
      ownTechs={techLevels}
      colonyId={colonyId}
      resources={resources}
    />
  );
}
