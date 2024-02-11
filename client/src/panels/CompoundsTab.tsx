import React from 'react';

import CompoundsBox from '../components/boxes/CompoundsBox';
import {
  CompoundConfigType,
  CompoundProps,
  SteelMineDescription,
  steelImg,
  UpgradeType,
  QuartzMineDescription,
  quartzImg,
  TritiumMineDescription,
  tritiumImg,
  EnergyPlantDescription,
  energyImg,
  LabDescription,
  labImg,
  DockyardDescription,
  dockyardImg,
  StyledTabPanel,
} from '.';

export const CompoundsTabPanel = ({
  spendableResources,
  compoundsLevels,
  colonyId,
  ...rest
}: CompoundProps) => {
  const compoundsConfig: CompoundConfigType[] = [
    {
      description: (
        <SteelMineDescription currentLevel={compoundsLevels.steel} />
      ),
      img: steelImg,
      title: 'Steel Mine',
      functionCallName: UpgradeType.SteelMine,
      compoundName: 'steel',
      energyKey: 'steel',
    },
    {
      description: (
        <QuartzMineDescription currentLevel={compoundsLevels.quartz} />
      ),
      img: quartzImg,
      title: 'Quartz Mine',
      functionCallName: UpgradeType.QuartzMine,
      compoundName: 'quartz',
      energyKey: 'quartz',
    },
    {
      description: (
        <TritiumMineDescription currentLevel={compoundsLevels.tritium} />
      ),
      img: tritiumImg,
      title: 'Tritium Mine',
      functionCallName: UpgradeType.TritiumMine,
      compoundName: 'tritium',
      energyKey: 'tritium',
    },
    {
      description: (
        <EnergyPlantDescription currentLevel={compoundsLevels.energy} />
      ),
      img: energyImg,
      title: 'Energy Plant',
      functionCallName: UpgradeType.EnergyPlant,
      compoundName: 'energy',
      energyKey: 'energy',
    },
    {
      description: <LabDescription currentLevel={compoundsLevels.lab} />,
      img: labImg,
      title: 'Research Lab',
      functionCallName: UpgradeType.Lab,
      compoundName: 'lab',
      energyKey: 'null',
    },
    {
      description: (
        <DockyardDescription currentLevel={compoundsLevels.dockyard} />
      ),
      img: dockyardImg,
      title: 'Dockyard',
      functionCallName: UpgradeType.Dockyard,
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

CompoundsTabPanel.tabsRole = 'TabPanel';
