import React from 'react';
import { StyledTabPanel } from '../panels/styleds';
import steelImg from '../assets/gameElements/compounds/steel4.webp';
import quartzImg from '../assets/gameElements/compounds/quartz4.webp';
import tritiumImg from '../assets/gameElements/compounds/tritium4.webp';
import energyImg from '../assets/gameElements/compounds/energy4.webp';
import dockyardImg from '../assets/gameElements/compounds/dockyard4.webp';
import {
  type CompoundsLevels,
  type EnergyCost,
  type Resources,
  ColonyUpgradeType,
} from '../shared/types';
import CompoundsBox from '../components/boxes/CompoundsBox';
import {
  EnergyPlantDescription,
  QuartzMineDescription,
  SteelMineDescription,
  TritiumMineDescription,
  DockyardDescription,
} from '../components/descriptions/CompoundsPopover';

interface CompoundConfigType {
  description: React.ReactNode;
  img: string;
  title: string;
  functionCallName: number;
  compoundName: keyof CompoundsLevels;
  energyKey: keyof EnergyCost;
}

interface Props {
  spendableResources?: Resources;
  compoundsLevels: CompoundsLevels;
  colonyId: number;
}

export const ColonyCompoundTabPanel = ({
  spendableResources,
  compoundsLevels,
  colonyId,
  ...rest
}: Props) => {
  const compoundsConfig: CompoundConfigType[] = [
    {
      description: (
        <SteelMineDescription currentLevel={Number(compoundsLevels?.steel)} />
      ),
      img: steelImg,
      title: 'Steel Mine',
      functionCallName: ColonyUpgradeType.SteelMine,
      compoundName: 'steel',
      energyKey: 'steel',
    },
    {
      description: (
        <QuartzMineDescription currentLevel={Number(compoundsLevels?.quartz)} />
      ),
      img: quartzImg,
      title: 'Quartz Mine',
      functionCallName: ColonyUpgradeType.QuartzMine,
      compoundName: 'quartz',
      energyKey: 'quartz',
    },
    {
      description: (
        <TritiumMineDescription
          currentLevel={Number(compoundsLevels?.tritium)}
        />
      ),
      img: tritiumImg,
      title: 'Tritium Mine',
      functionCallName: ColonyUpgradeType.TritiumMine,
      compoundName: 'tritium',
      energyKey: 'tritium',
    },
    {
      description: (
        <EnergyPlantDescription
          currentLevel={Number(compoundsLevels?.energy)}
        />
      ),
      img: energyImg,
      title: 'Energy Plant',
      functionCallName: ColonyUpgradeType.EnergyPlant,
      compoundName: 'energy',
      energyKey: 'energy',
    },
    {
      description: (
        <DockyardDescription currentLevel={Number(compoundsLevels?.dockyard)} />
      ),
      img: dockyardImg,
      title: 'Dockyard',
      functionCallName: ColonyUpgradeType.Dockyard,
      compoundName: 'dockyard',
      energyKey: 'null',
    },
  ];

  return (
    <StyledTabPanel {...rest}>
      {compoundsConfig.map((compound) => {
        const level = Number(compoundsLevels?.[compound.compoundName]);

        return (
          <CompoundsBox
            key={compound.functionCallName}
            description={compound.description}
            img={compound.img}
            title={compound.title}
            functionCallName={compound.functionCallName}
            level={level}
            resourcesAvailable={spendableResources}
            colonyId={colonyId}
          />
        );
      })}
    </StyledTabPanel>
  );
};

ColonyCompoundTabPanel.tabsRole = 'TabPanel';
