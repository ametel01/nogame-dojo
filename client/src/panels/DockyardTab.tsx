import React from 'react';
import DockyardBox from '../components/boxes/DockyardBox';
import { ColonyBuildType } from '../shared/types/index';
import {
  ArmadeDescription,
  BuildType,
  CarrierDescription,
  CelestiaDescription,
  DockyardProps,
  FrigateDescription,
  ScraperDescription,
  ShipConfigType,
  SparrowDescription,
  StyledTabPanel,
  armadeImg,
  armadeRequirements,
  calculEnoughResources,
  carrierImg,
  carrierRequirements,
  celestiaImg,
  celestiaRequirements,
  frigateImg,
  frigateRequirements,
  scraperImg,
  scraperRequirements,
  sparrowImg,
  sparrowRequirements,
} from '.';

export const DockyardTabPanel = ({
  spendableResources,
  shipsLevels,
  shipsCost,
  dockyardLevel,
  techLevels,
  celestia,
  colonyId,
  ...rest
}: DockyardProps) => {
  const shipsConfig: ShipConfigType[] = [
    {
      description: <CarrierDescription />,
      img: carrierImg,
      title: 'Carrier',
      functionCallName:
        colonyId == 0 ? BuildType.Carrier : ColonyBuildType.Carrier,
      shipName: 'carrier',
      requirements: carrierRequirements(dockyardLevel, techLevels),
    },
    {
      description: <CelestiaDescription />,
      img: celestiaImg,
      title: 'Celestia',
      functionCallName:
        colonyId == 0 ? BuildType.Celestia : ColonyBuildType.Celestia,
      shipName: 'celestia',
      requirements: celestiaRequirements(dockyardLevel, techLevels),
    },
    {
      description: <ScraperDescription />,
      img: scraperImg,
      title: 'Scraper',
      functionCallName:
        colonyId == 0 ? BuildType.Scraper : ColonyBuildType.Scraper,
      shipName: 'scraper',
      requirements: scraperRequirements(dockyardLevel, techLevels),
    },
    {
      description: <SparrowDescription />,
      img: sparrowImg,
      title: 'Sparrow',
      functionCallName:
        colonyId == 0 ? BuildType.Sparrow : ColonyBuildType.Sparrow,
      shipName: 'sparrow',
      requirements: sparrowRequirements(dockyardLevel, techLevels),
    },
    {
      description: <FrigateDescription />,
      img: frigateImg,
      title: 'Frigate',
      functionCallName:
        colonyId == 0 ? BuildType.Frigate : ColonyBuildType.Frigate,
      shipName: 'frigate',
      requirements: frigateRequirements(dockyardLevel, techLevels),
    },
    {
      description: <ArmadeDescription />,
      img: armadeImg,
      title: 'Armade',
      functionCallName:
        colonyId == 0 ? BuildType.Armade : ColonyBuildType.Armade,
      shipName: 'armade',
      requirements: armadeRequirements(dockyardLevel, techLevels),
    },
  ];

  return (
    <StyledTabPanel {...rest}>
      {shipsConfig.map((ship) => (
        <DockyardBox
          key={ship.functionCallName}
          description={ship.description}
          img={ship.img}
          title={ship.title}
          functionCallName={ship.functionCallName}
          level={
            ship.title === 'Celestia'
              ? Number(celestia)
              : Number(shipsLevels?.[ship.shipName])
          }
          costUpdate={shipsCost?.[ship.shipName]}
          hasEnoughResources={
            spendableResources &&
            shipsCost?.[ship.shipName] &&
            calculEnoughResources(shipsCost[ship.shipName], spendableResources)
          }
          requirementsMet={ship.requirements}
          resourcesAvailable={spendableResources!}
          colonyId={colonyId}
        />
      ))}
    </StyledTabPanel>
  );
};

DockyardTabPanel.tabsRole = 'TabPanel';
