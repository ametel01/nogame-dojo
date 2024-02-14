import React from 'react';
import * as deps from '.';
import DefencesBox from '../boxes/DefencesBox';

export const DefenceTabPanel = ({
  resources,
  defences,
  defenceCost,
  dockyard,
  techs,
  colonyId,
  ...rest
}: deps.DefenceProps) => {
  const defencesConfig = [
    {
      description: <deps.BlasterDescription />,
      img: deps.blasterImg,
      title: 'Blaster',
      functionCallName: deps.DefenceBuildType.blaster,
      level: defences?.blaster,
      cost: defenceCost?.blaster,
      requirements: deps.blasterRequirements(dockyard),
    },
    {
      description: <deps.BeamCannonDescription />,
      img: deps.beamImg,
      title: 'Beam',
      functionCallName: deps.DefenceBuildType.beam,
      level: defences?.beam,
      cost: defenceCost?.beam,
      requirements: deps.beamRequirements(dockyard, techs),
    },
    {
      description: <deps.AstralDescription />,
      img: deps.astralLauncherImg,
      title: 'Astral Launcher',
      functionCallName: deps.DefenceBuildType.astral,
      level: defences?.astral,
      cost: defenceCost?.astral,
      requirements: deps.astralRequirements(dockyard, techs),
    },
    {
      description: <deps.PlasmaDescription />,
      img: deps.plasmaImg,
      title: 'Plasma Projector',
      functionCallName: deps.DefenceBuildType.plasma,
      level: defences?.plasma,
      cost: defenceCost?.plasma,
      requirements: deps.plasmaRequirements(dockyard, techs),
    },
  ];

  return (
    <deps.StyledTabPanel {...rest}>
      {defencesConfig.map((defence) => (
        <DefencesBox
          key={defence.functionCallName}
          description={defence.description}
          img={defence.img}
          title={defence.title}
          functionCallName={defence.functionCallName}
          level={defence.level || 0}
          costUpdate={defence.cost}
          hasEnoughResources={
            resources &&
            defence.cost &&
            deps.calculEnoughResources(defence.cost, resources)
          }
          requirementsMet={defence.requirements}
          resourcesAvailable={resources}
          colonyId={colonyId}
        />
      ))}
    </deps.StyledTabPanel>
  );
};

DefenceTabPanel.tabsRole = 'TabPanel';
