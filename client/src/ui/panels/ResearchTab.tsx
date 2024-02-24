import React from 'react';
import * as deps from './deps';
import ResearchBox from '../boxes/ResearchBox';

export const ResearchTabPanel = ({
  resources,
  techLevels,
  labLevel,
  ...rest
}: deps.LabProps) => {
  const researchConfig: deps.ResearchConfigType[] = [
    {
      description: <deps.EnergyDescription />,
      img: deps.energyTechImg,
      title: 'Energy Innovation',
      functionCallName: deps.TechUpgradeType.energy,
      techName: 'energy',
      requirements: deps.energyRequirements(labLevel),
    },
    {
      description: <deps.ComputerDescription />,
      img: deps.digitalImg,
      title: 'Digital Systems',
      functionCallName: deps.TechUpgradeType.digital,
      techName: 'digital',
      requirements: deps.digitalRequirements(labLevel),
    },
    {
      description: <deps.BeamDescription />,
      img: deps.beamImg,
      title: 'Beam Technology',
      functionCallName: deps.TechUpgradeType.beam,
      techName: 'beam',
      requirements: deps.beamTechRequirements(labLevel, techLevels),
    },
    {
      description: <deps.IonDescription />,
      img: deps.ionImg,
      title: 'Ion Systems',
      functionCallName: deps.TechUpgradeType.ion,
      techName: 'ion',
      requirements: deps.ionRequirements(labLevel, techLevels),
    },
    {
      description: <deps.ExoDescription />,
      img: deps.exoImg,
      title: 'Exocraft Technology',
      functionCallName: deps.TechUpgradeType.exocraft,
      techName: 'exocraft',
      requirements: deps.exoRequirements(labLevel, techLevels),
    },
    {
      description: <deps.PlasmaDescription />,
      img: deps.plasmaImg,
      title: 'Plasma Engineering',
      functionCallName: deps.TechUpgradeType.plasma,
      techName: 'plasma',
      requirements: deps.plasmaTechRequirements(labLevel, techLevels),
    },
    {
      description: <deps.SpacetimeDescription />,
      img: deps.spacetimeImg,
      title: 'Spacetime Technology',
      functionCallName: deps.UpgradeType.Warp,
      techName: 'spacetime',
      requirements: deps.spacetimeRequirements(labLevel, techLevels),
    },
    {
      description: <deps.CombustionDescription />,
      img: deps.combustionImg,
      title: 'Combustion Drive',
      functionCallName: deps.TechUpgradeType.combustion,
      techName: 'combustion',
      requirements: deps.combustionRequirements(labLevel, techLevels),
    },
    {
      description: <deps.ThrustDescription />,
      img: deps.thrustImg,
      title: 'Thrust Propulsion',
      functionCallName: deps.TechUpgradeType.thrust,
      techName: 'thrust',
      requirements: deps.thrustRequirements(labLevel, techLevels),
    },
    {
      description: <deps.WarpDescription />,
      img: deps.warpEnginImg,
      title: 'Warp Drive',
      functionCallName: deps.TechUpgradeType.warp,
      techName: 'warp',
      requirements: deps.warpRequirements(labLevel, techLevels),
    },
    {
      description: <deps.ArmourDescription />,
      img: deps.armourImg,
      title: 'Armour Innovation',
      functionCallName: deps.TechUpgradeType.armour,
      techName: 'armour',
      requirements: deps.armourRequirements(labLevel),
    },
    {
      description: <deps.WeaponsDescription />,
      img: deps.weaponsImg,
      title: 'Weapons Development',
      functionCallName: deps.TechUpgradeType.weapons,
      techName: 'weapons',
      requirements: deps.weaponsRequirements(labLevel),
    },
    {
      description: <deps.ShieldDescription />,
      img: deps.shieldImg,
      title: 'Shields Technology',
      functionCallName: deps.TechUpgradeType.shield,
      techName: 'shield',
      requirements: deps.shieldRequirements(labLevel, techLevels),
    },
  ];

  return (
    <deps.StyledTabPanel {...rest}>
      {researchConfig.map((research) => {
        const level = techLevels[research.techName] || 0;
        return (
          <ResearchBox
            key={research.functionCallName}
            description={research.description}
            img={research.img}
            title={research.title}
            functionCallName={research.functionCallName}
            level={level}
            resources={resources}
            requirementsMet={research.requirements}
            techs={techLevels!}
          />
        );
      })}
    </deps.StyledTabPanel>
  );
};

ResearchTabPanel.tabsRole = 'TabPanel';
