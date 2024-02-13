import React from 'react';
import DockyardBox from '../boxes/DockyardBox';
import { ColonyBuildType } from '../shared/types/index';
import * as deps from '.';

export const DockyardTabPanel = ({
  resources,
  ships,
  shipsCost,
  dockyard,
  techs,
  celestia,
  colonyId,
  ...rest
}: deps.DockyardProps) => {
  const shipsConfig: deps.ShipConfigType[] = [
    {
      description: <deps.CarrierDescription />,
      img: deps.carrierImg,
      title: 'Carrier',
      functionCallName: deps.ShipBuildType.carrier,
      shipName: 'carrier',
      requirements: deps.carrierRequirements(dockyard, techs),
    },
    {
      description: <deps.CelestiaDescription />,
      img: deps.celestiaImg,
      title: 'Celestia',
      functionCallName: deps.DefenceBuildType.celestia,
      shipName: 'celestia',
      requirements: deps.celestiaRequirements(dockyard, techs),
    },
    {
      description: <deps.ScraperDescription />,
      img: deps.scraperImg,
      title: 'Scraper',
      functionCallName:
        colonyId == 0 ? deps.ShipBuildType.scraper : ColonyBuildType.Scraper,
      shipName: 'scraper',
      requirements: deps.scraperRequirements(dockyard, techs),
    },
    {
      description: <deps.SparrowDescription />,
      img: deps.sparrowImg,
      title: 'Sparrow',
      functionCallName:
        colonyId == 0 ? deps.ShipBuildType.sparrow : ColonyBuildType.Sparrow,
      shipName: 'sparrow',
      requirements: deps.sparrowRequirements(dockyard, techs),
    },
    {
      description: <deps.FrigateDescription />,
      img: deps.frigateImg,
      title: 'Frigate',
      functionCallName:
        colonyId == 0 ? deps.ShipBuildType.frigate : ColonyBuildType.Frigate,
      shipName: 'frigate',
      requirements: deps.frigateRequirements(dockyard, techs),
    },
    {
      description: <deps.ArmadeDescription />,
      img: deps.armadeImg,
      title: 'Armade',
      functionCallName:
        colonyId == 0 ? deps.ShipBuildType.armade : ColonyBuildType.Armade,
      shipName: 'armade',
      requirements: deps.armadeRequirements(dockyard, techs),
    },
  ];

  return (
    <deps.StyledTabPanel {...rest}>
      {shipsConfig.map((ship) => (
        <DockyardBox
          key={ship.functionCallName}
          description={ship.description}
          img={ship.img}
          title={ship.title}
          functionCallName={ship.functionCallName}
          level={
            ship.title === 'Celestia'
              ? celestia
              : ships?.[ship.shipName] || 
          }
          costUpdate={shipsCost?.[ship.shipName]}
          hasEnoughResources={
            resources &&
            shipsCost?.[ship.shipName] &&
            calculEnoughResources(shipsCost[ship.shipName], resources)
          }
          requirementsMet={ship.requirements}
          resourcesAvailable={resources!}
          colonyId={colonyId}
        />
      ))}
    </StyledTabPanel>
  );
};

DockyardTabPanel.tabsRole = 'TabPanel';
