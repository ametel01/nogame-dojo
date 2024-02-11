import React from 'react';
import {
  EnergyDescription,
  energyTechImg,
  ArmourDescription,
  BeamDescription,
  CombustionDescription,
  ComputerDescription,
  IonDescription,
  PlasmaDescription,
  ShieldDescription,
  SpacetimeDescription,
  StyledTabPanel,
  ThrustDescription,
  UpgradeType,
  WarpDescription,
  WeaponsDescription,
  armourImg,
  armourRequirements,
  beamImg,
  beamTechRequirements,
  combustionImg,
  combustionRequirements,
  digitalImg,
  digitalRequirements,
  energyRequirements,
  ionImg,
  ionRequirements,
  plasmaImg,
  plasmaTechRequirements,
  shieldImg,
  shieldRequirements,
  spacetimeImg,
  spacetimeRequirements,
  thrustImg,
  thrustRequirements,
  warpEnginImg,
  warpRequirements,
  weaponsImg,
  weaponsRequirements,
  LabProps,
  ResearchConfigType,
  ExoDescription,
  exoImg,
  exoRequirements,
} from '.';
import ResearchBox from '../components/boxes/ResearchBox';

export const ResearchTabPanel = ({
  spendableResources,
  techLevels,
  labLevel,
  ...rest
}: LabProps) => {
  const researchConfig: ResearchConfigType[] = [
    {
      description: <EnergyDescription />,
      img: energyTechImg,
      title: 'Energy Innovation',
      functionCallName: UpgradeType.EnergyTech,
      techName: 'energy',
      requirements: energyRequirements(labLevel),
    },
    {
      description: <ComputerDescription />,
      img: digitalImg,
      title: 'Digital Systems',
      functionCallName: UpgradeType.Digital,
      techName: 'digital',
      requirements: digitalRequirements(labLevel),
    },
    {
      description: <BeamDescription />,
      img: beamImg,
      title: 'Beam Technology',
      functionCallName: UpgradeType.BeamTech,
      techName: 'beam',
      requirements: beamTechRequirements(labLevel, techLevels),
    },
    {
      description: <IonDescription />,
      img: ionImg,
      title: 'Ion Systems',
      functionCallName: UpgradeType.Ion,
      techName: 'ion',
      requirements: ionRequirements(labLevel, techLevels),
    },
    {
      description: <ExoDescription />,
      img: exoImg,
      title: 'Exocraft Technology',
      functionCallName: UpgradeType.Exocraft,
      techName: 'exocraft',
      requirements: exoRequirements(labLevel, techLevels),
    },
    {
      description: <PlasmaDescription />,
      img: plasmaImg,
      title: 'Plasma Engineering',
      functionCallName: UpgradeType.PlasmaTech,
      techName: 'plasma',
      requirements: plasmaTechRequirements(labLevel, techLevels),
    },
    {
      description: <SpacetimeDescription />,
      img: spacetimeImg,
      title: 'Spacetime Technology',
      functionCallName: UpgradeType.Warp,
      techName: 'spacetime',
      requirements: spacetimeRequirements(labLevel, techLevels),
    },
    {
      description: <CombustionDescription />,
      img: combustionImg,
      title: 'Combustion Drive',
      functionCallName: UpgradeType.Combustion,
      techName: 'combustion',
      requirements: combustionRequirements(labLevel, techLevels),
    },
    {
      description: <ThrustDescription />,
      img: thrustImg,
      title: 'Thrust Propulsion',
      functionCallName: UpgradeType.Thrust,
      techName: 'thrust',
      requirements: thrustRequirements(labLevel, techLevels),
    },
    {
      description: <WarpDescription />,
      img: warpEnginImg,
      title: 'Warp Drive',
      functionCallName: UpgradeType.Warp,
      techName: 'warp',
      requirements: warpRequirements(labLevel, techLevels),
    },
    {
      description: <ArmourDescription />,
      img: armourImg,
      title: 'Armour Innovation',
      functionCallName: UpgradeType.Armour,
      techName: 'armour',
      requirements: armourRequirements(labLevel),
    },
    {
      description: <WeaponsDescription />,
      img: weaponsImg,
      title: 'Weapons Development',
      functionCallName: UpgradeType.Weapons,
      techName: 'weapons',
      requirements: weaponsRequirements(labLevel),
    },
    {
      description: <ShieldDescription />,
      img: shieldImg,
      title: 'Shields Technology',
      functionCallName: UpgradeType.Shield,
      techName: 'shield',
      requirements: shieldRequirements(labLevel, techLevels),
    },
  ];

  return (
    <StyledTabPanel {...rest}>
      {researchConfig.map((research) => (
        <ResearchBox
          key={research.functionCallName}
          description={research.description}
          img={research.img}
          title={research.title}
          functionCallName={research.functionCallName}
          level={Number(techLevels?.[research.techName])}
          resourcesAvailable={spendableResources}
          requirementsMet={research.requirements}
          techs={techLevels!}
        />
      ))}
    </StyledTabPanel>
  );
};

ResearchTabPanel.tabsRole = 'TabPanel';
