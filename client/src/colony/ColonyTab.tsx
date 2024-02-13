import React from 'react';
import { StyledTabPanel } from '../panels/styleds';
import steelImg from '../assets/gameElements/compounds/steel4.webp';
import quartzImg from '../assets/gameElements/compounds/quartz4.webp';
import tritiumImg from '../assets/gameElements/compounds/tritium4.webp';
import energyImg from '../assets/gameElements/compounds/energy4.webp';
import dockyardImg from '../assets/gameElements/compounds/dockyard4.webp';
import { ColonyCompounds } from '../hooks/useColonyCompounds';
import { type EnergyCost, ColonyUpgradeType } from '../shared/types';
import CompoundsBox from '../boxes/CompoundsBox';
import { Resources } from '../hooks/usePlanetResources';
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
  compoundName: keyof ColonyCompounds;
  energyKey: keyof EnergyCost;
}

interface Props {
  resources?: Resources;
  compounds: ColonyCompounds;
  colonyId: number;
}

export const ColonyCompoundTabPanel = ({
  resources,
  compounds,
  colonyId,
  ...rest
}: Props) => {
  const compoundsConfig: CompoundConfigType[] = [
    {
      description: <SteelMineDescription currentLevel={compounds?.steel} />,
      img: steelImg,
      title: 'Steel Mine',
      functionCallName: ColonyUpgradeType.SteelMine,
      compoundName: 'steel',
      energyKey: 'steel',
    },
    {
      description: <QuartzMineDescription currentLevel={compounds?.quartz} />,
      img: quartzImg,
      title: 'Quartz Mine',
      functionCallName: ColonyUpgradeType.QuartzMine,
      compoundName: 'quartz',
      energyKey: 'quartz',
    },
    {
      description: <TritiumMineDescription currentLevel={compounds?.tritium} />,
      img: tritiumImg,
      title: 'Tritium Mine',
      functionCallName: ColonyUpgradeType.TritiumMine,
      compoundName: 'tritium',
      energyKey: 'tritium',
    },
    {
      description: <EnergyPlantDescription currentLevel={compounds?.energy} />,
      img: energyImg,
      title: 'Energy Plant',
      functionCallName: ColonyUpgradeType.EnergyPlant,
      compoundName: 'energy',
      energyKey: 'energy',
    },
    {
      description: <DockyardDescription currentLevel={compounds?.dockyard} />,
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
        const level = compounds[compound.compoundName] || 0;

        return (
          <CompoundsBox
            key={compound.functionCallName}
            description={compound.description}
            img={compound.img}
            title={compound.title}
            functionCallName={compound.functionCallName}
            level={level}
            resourcesAvailable={resources}
            colonyId={colonyId}
          />
        );
      })}
    </StyledTabPanel>
  );
};

ColonyCompoundTabPanel.tabsRole = 'TabPanel';
