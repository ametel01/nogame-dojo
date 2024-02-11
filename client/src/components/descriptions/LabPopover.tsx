import React from 'react';
import styled from 'styled-components';
import armourImg from '../../assets/gameElements/techs/armour4.webp';
import beamImg from '../../assets/gameElements/techs/beam4.webp';
import ionImg from '../../assets/gameElements/techs/ion4.webp';
import plasmaImg from '../../assets/gameElements/techs/plasma4.webp';
import spacetimeImg from '../../assets/gameElements/techs/spacetime4.webp';
import warpEnginImg from '../../assets/gameElements/techs/warp4.webp';
import combustionImg from '../../assets/gameElements/techs/combustion4.webp';
import thrustImg from '../../assets/gameElements/techs/thrust4.webp';
import weaponsImg from '../../assets/gameElements/techs/weapons4.webp';
import digitalImg from '../../assets/gameElements/techs/digital4.webp';
import shieldImg from '../../assets/gameElements/techs/shield4.webp';
import energyImg from '../../assets/gameElements/techs/energy4.webp';
import exoImg from '../../assets/gameElements/techs/exocraft.webp';
import {
  PopoverBox,
  PopoverHeaderDiv,
  PopoverRequirements,
} from '../../shared/styled/PopoverStyle';

const TextBox = styled('div')`
  font-size: 16px;
  line-height: 1.5;
`;

// Component props
interface DescriptionComponentProps {
  title: string;
  image: string;
  description: string;
  requirements: React.ReactNode;
}

// Description component
const DescriptionComponent = ({
  title,
  image,
  description,
  requirements,
}: DescriptionComponentProps) => {
  return (
    <PopoverBox>
      <PopoverHeaderDiv>{title}</PopoverHeaderDiv>
      <div style={{ display: 'flex', flexDirection: 'row' }}>
        {/* Image Section */}
        <div style={{ marginRight: '16px' }}>
          <img
            src={image}
            alt={title}
            style={{ width: '240px', height: 'auto', borderRadius: '8px' }}
          />
        </div>
        <div style={{ display: 'grid' }}></div>
        <TextBox>
          {description}
          <br />
          <br />
          <div>Requirements:</div>
          <PopoverRequirements>{requirements}</PopoverRequirements>
        </TextBox>
      </div>
    </PopoverBox>
  );
};

// Usage of DescriptionComponent for different purposes
export const ArmourDescription = () => (
  <DescriptionComponent
    title="Armour Technology"
    image={armourImg}
    description="Armour Innovation increases fleet and defense hull durability by 10%."
    requirements={
      <li>
        <div>Research Lab Level 2</div>
      </li>
    }
  />
);
export const CombustionDescription = () => (
  <DescriptionComponent
    title="Combustion Drive"
    image={combustionImg}
    description="Each level increases the base speed of Carrier, Sparrow, and Scraper by 10%"
    requirements={
      <>
        <li>Research Lab Level 1</li>
        <li>Energy Innovation Level 1</li>
      </>
    }
  />
);
export const ComputerDescription = () => (
  <DescriptionComponent
    title="Digital Systems"
    image={digitalImg}
    description="Increases the fleet slots by 1 for each level. Specifically, the number of
    fleet slots equals the level of digital systems plus one"
    requirements={
      <>
        <li>Research Lab Level 1</li>
      </>
    }
  />
);
export const EnergyDescription = () => (
  <DescriptionComponent
    title="Energy Innovation"
    image={energyImg}
    description="Each upgrade in Energy
    Innovation leads to new research opportunities, enabling the
    development of advanced ships and defenses."
    requirements={
      <>
        <li>Research Lab Level 1</li>
      </>
    }
  />
);
export const BeamDescription = () => (
  <DescriptionComponent
    title="Beam Technology"
    image={beamImg}
    description="This technology is an essential prerequisite for the
    progression into ion and plasma-based weaponry systems. The utility of
    Beam Technology research exhibits a saturation point at Level 12."
    requirements={
      <>
        <li>Research Lab Level 1</li>
        <li>Energy Innovation Level 2</li>
      </>
    }
  />
);
export const IonDescription = () => (
  <DescriptionComponent
    title="Ion Systems"
    image={ionImg}
    description="This technology aids in developing weapon systems. Successful integration leads to advancements like
    deploying Frigate-class vessels and initiating Plasma Engineering
    research"
    requirements={
      <>
        <li>Research Lab Level 4</li>
        <li>Beam Technology Level 5</li>
        <li>Energy Innovation Level 4</li>
      </>
    }
  />
);

export const PlasmaDescription = () => (
  <DescriptionComponent
    title="Plasma Engineering"
    image={plasmaImg}
    description="Used for heavy weaponry development. Upon collision with a target, plasma is capable of
    causing substantial structural damage."
    requirements={
      <>
        <li>Research Lab Level 4</li>
        <li>Beam Technology Level 10</li>
        <li>Energy Innovation Level 8</li>
        <li>Ion Systems Level 5</li>
      </>
    }
  />
);

export const ShieldDescription = () => (
  <DescriptionComponent
    title="Shields Technology"
    image={shieldImg}
    description="Advancements in this domain increment shield
    efficiency by a factor equivalent to 10% of the intrinsic baseline
    value for each subsequent level of development."
    requirements={
      <>
        <li>Research Lab Level 6</li>
        <li>Energy Innovation Level 3</li>
      </>
    }
  />
);

export const SpacetimeDescription = () => (
  <DescriptionComponent
    title="Spacetime Technology"
    image={spacetimeImg}
    description=" With enough
    advancement in Spacetime Warp Technology, Hyperspatial Propulsion
    becomes more than just a theoretical concept, allowing for the development of the Warp Drive"
    requirements={
      <>
        <li>Research Lab Level 7</li>
        <li>Energy Innovation Level 5</li>
        <li>Shield Technology Level 5</li>
      </>
    }
  />
);

export const ThrustDescription = () => (
  <DescriptionComponent
    title="Thrust Propulsion"
    image={thrustImg}
    description="After level 4 is reached, Carriers are equipped
    with thrust propulsion, doubling their base speed. For every
    subsequent level of advancement in the Thrust Propulsion technology,
    the Base Speed is further boosted by a noteworthy percentage of 20%."
    requirements={
      <>
        <li>Research Lab Level 2</li>
        <li>Energy Innovation Level 1</li>
      </>
    }
  />
);

export const WarpDescription = () => (
  <DescriptionComponent
    title="Warp Drive"
    image={warpEnginImg}
    description="Ships equipped with this technology (Armades) experience a 30% increase in Base
    Speed for each level of proficiency in the Warp Drive"
    requirements={
      <>
        <li>Research Lab Level 7</li>
        <li>Energy Innovation Level 5</li>
        <li>Spacetime Technology Level 3</li>
      </>
    }
  />
);

export const WeaponsDescription = () => (
  <DescriptionComponent
    title="Weapons Technology"
    image={weaponsImg}
    description="Allowes the development of advanced ships and defences. Each levele advancement
    yealds a 10% increase in weapons power"
    requirements={
      <>
        <li>Research Lab Level 4</li>
      </>
    }
  />
);

export const ExoDescription = () => (
  <DescriptionComponent
    title="Exocraft Technology"
    image={exoImg}
    description="Recent astrophysics advancements enable equipping more ships with laboratories for deep space exploration and facilitate the colonization of additional planets. Every two-level advancement in this technology allows for the utilization of one extra planet."
    requirements={
      <>
        <li>Research Lab Level 3</li>
        <li>Thrust Propulsion Level 3</li>
      </>
    }
  />
);
