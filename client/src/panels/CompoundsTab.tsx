import React from 'react';

import CompoundsBox from '../boxes/CompoundsBox';
import * as deps from '.';

export const CompoundsTabPanel = ({
  resources,
  compounds,
  colonyId,
  ...rest
}: deps.CompoundProps) => {
  const compoundsConfig: deps.CompoundConfigType[] = [
    {
      description: <deps.SteelMineDescription currentLevel={compounds.steel} />,
      img: deps.steelImg,
      title: 'Steel Mine',
      functionCallName: deps.UpgradeType.SteelMine,
      compoundName: 'steel',
      energyKey: 'steel',
    },
    {
      description: (
        <deps.QuartzMineDescription currentLevel={compounds.quartz} />
      ),
      img: deps.quartzImg,
      title: 'Quartz Mine',
      functionCallName: deps.UpgradeType.QuartzMine,
      compoundName: 'quartz',
      energyKey: 'quartz',
    },
    {
      description: (
        <deps.TritiumMineDescription currentLevel={compounds.tritium} />
      ),
      img: deps.tritiumImg,
      title: 'Tritium Mine',
      functionCallName: deps.UpgradeType.TritiumMine,
      compoundName: 'tritium',
      energyKey: 'tritium',
    },
    {
      description: (
        <deps.EnergyPlantDescription currentLevel={compounds.energy} />
      ),
      img: deps.energyImg,
      title: 'Energy Plant',
      functionCallName: deps.UpgradeType.EnergyPlant,
      compoundName: 'energy',
      energyKey: 'energy',
    },
    {
      description: <deps.LabDescription currentLevel={compounds.lab} />,
      img: deps.labImg,
      title: 'Research Lab',
      functionCallName: deps.UpgradeType.Lab,
      compoundName: 'lab',
      energyKey: 'null',
    },
    {
      description: (
        <deps.DockyardDescription currentLevel={compounds.dockyard} />
      ),
      img: deps.dockyardImg,
      title: 'Dockyard',
      functionCallName: deps.UpgradeType.Dockyard,
      compoundName: 'dockyard',
      energyKey: 'null',
    },
  ];

  return (
    <deps.StyledTabPanel {...rest}>
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
    </deps.StyledTabPanel>
  );
};

CompoundsTabPanel.tabsRole = 'TabPanel';
