import React from 'react';
import DefencesBox from '../components/boxes/DefencesBox';
import {
  DefenceProps,
  BlasterDescription,
  blasterImg,
  BuildType,
  blasterRequirements,
  BeamCannonDescription,
  beamImg,
  beamRequirements,
  AstralDescription,
  astralLauncherImg,
  astralRequirements,
  PlasmaDescription,
  plasmaImg,
  plasmaRequirements,
  StyledTabPanel,
  calculEnoughResources,
} from '.';

export const DefenceTabPanel = ({
  spendableResources,
  defenceLevels,
  defenceCost,
  dockyardLevel,
  techLevels,
  colonyId,
  ...rest
}: DefenceProps) => {
  const defencesConfig = [
    {
      description: <BlasterDescription />,
      img: blasterImg,
      title: 'Blaster',
      functionCallName: BuildType.Blaster,
      level: defenceLevels?.blaster,
      cost: defenceCost?.blaster,
      requirements: blasterRequirements(dockyardLevel),
    },
    {
      description: <BeamCannonDescription />,
      img: beamImg,
      title: 'Beam',
      functionCallName: BuildType.Beam,
      level: defenceLevels?.beam,
      cost: defenceCost?.beam,
      requirements: beamRequirements(dockyardLevel, techLevels),
    },
    {
      description: <AstralDescription />,
      img: astralLauncherImg,
      title: 'Astral Launcher',
      functionCallName: BuildType.Astral,
      level: defenceLevels?.astral,
      cost: defenceCost?.astral,
      requirements: astralRequirements(dockyardLevel, techLevels),
    },
    {
      description: <PlasmaDescription />,
      img: plasmaImg,
      title: 'Plasma Projector',
      functionCallName: BuildType.Plasma,
      level: defenceLevels?.plasma,
      cost: defenceCost?.plasma,
      requirements: plasmaRequirements(dockyardLevel, techLevels),
    },
  ];

  return (
    <StyledTabPanel {...rest}>
      {defencesConfig.map((defence) => (
        <DefencesBox
          key={defence.functionCallName}
          description={defence.description}
          img={defence.img}
          title={defence.title}
          functionCallName={defence.functionCallName}
          level={Number(defence.level)}
          costUpdate={defence.cost}
          hasEnoughResources={
            spendableResources &&
            defence.cost &&
            calculEnoughResources(defence.cost, spendableResources)
          }
          requirementsMet={defence.requirements}
          resourcesAvailable={spendableResources!}
          colonyId={colonyId}
        />
      ))}
    </StyledTabPanel>
  );
};

DefenceTabPanel.tabsRole = 'TabPanel';
