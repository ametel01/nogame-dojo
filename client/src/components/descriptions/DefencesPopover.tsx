import React from 'react';
import { DefencesStats } from '../../constants/Stats';
import {
  PopoverBox,
  PopoverHeaderDiv,
  PopoverInfoRow,
  PopoverTextBox,
  PopoverGridContainer,
  PopoverRequirements,
  PopoverInfoData,
  PopoverLabel,
} from '../../shared/styled/PopoverStyle';

import blasterImg from '../../assets/gameElements/defences/blaster4.webp';
import beamImg from '../../assets/gameElements/defences/beam4.webp';
import astralLauncherImg from '../../assets/gameElements/defences/astral4.webp';
import plasmaImg from '../../assets/gameElements/defences/plasma4.webp';

// Component props
interface DescriptionComponentProps {
  title: string;
  image: string;
  description: React.ReactNode;
  stats: React.ReactNode;
  requirements: React.ReactNode;
}

const DescriptionComponent = ({
  title,
  image,
  description,
  stats,
  requirements,
}: DescriptionComponentProps) => {
  return (
    <PopoverBox>
      <PopoverHeaderDiv>{title}</PopoverHeaderDiv>
      <div
        style={{
          display: 'flex',
          flexDirection: 'row',
          alignItems: 'flex-start',
          marginBottom: '24px',
        }}
      >
        {/* Image */}
        <img
          src={image}
          alt={`${title}`}
          style={{ width: '240px', marginRight: '16px', borderRadius: '8px' }}
        />
        {/* Description and Requirements */}
        <div>
          <PopoverTextBox>{description}</PopoverTextBox>
          <div style={{ margin: '8px' }}>Requirements:</div>
          <PopoverRequirements>{requirements}</PopoverRequirements>
        </div>
      </div>
      {/* Stats */}
      {stats}
    </PopoverBox>
  );
};

interface StatsProps {
  cargo?: number;
  speed?: number;
  consumption?: number;
  hull: number;
  shield: number;
  weapon: number;
}

const StatsComponent = ({
  cargo,
  speed,
  consumption,
  hull,
  shield,
  weapon,
}: StatsProps) => {
  return (
    <PopoverGridContainer>
      {cargo ? (
        <>
          <PopoverInfoRow>
            <PopoverLabel>Cargo Capacity:</PopoverLabel>
            <PopoverInfoData>{cargo}</PopoverInfoData>
          </PopoverInfoRow>
        </>
      ) : null}
      {speed ? (
        <>
          <PopoverInfoRow>
            <PopoverLabel>Base Speed: </PopoverLabel>
            <PopoverInfoData>{speed}</PopoverInfoData>
          </PopoverInfoRow>
        </>
      ) : null}
      {consumption ? (
        <>
          <PopoverInfoRow>
            <PopoverLabel>Consumption: </PopoverLabel>
            <PopoverInfoData>{consumption}</PopoverInfoData>
          </PopoverInfoRow>
        </>
      ) : null}
      <PopoverInfoRow>
        <PopoverLabel>Base Hull: </PopoverLabel>
        <PopoverInfoData>{hull}</PopoverInfoData>
      </PopoverInfoRow>
      <PopoverInfoRow>
        <PopoverLabel>Base Shield: </PopoverLabel>
        <PopoverInfoData>{shield}</PopoverInfoData>
      </PopoverInfoRow>
      <PopoverInfoRow>
        <PopoverLabel>Base Weapon: </PopoverLabel>
        <PopoverInfoData>{weapon}</PopoverInfoData>
      </PopoverInfoRow>
    </PopoverGridContainer>
  );
};

export const BlasterDescription = () => (
  <DescriptionComponent
    title="Blaster"
    image={blasterImg}
    description="Blasters are the first defense available, effective against Carriers and low in cost. They only require steel to be built, making them economical, but they are less effective against other ship types."
    stats={StatsComponent(DefencesStats.blaster)}
    requirements={
      <>
        <li>Dockyard level 1</li>
      </>
    }
  />
);
export const BeamDescription = () => (
  <DescriptionComponent
    title="Beam"
    image={beamImg}
    description="Beams represent the second stage of defense, being effective against Sparrows and Carriers but less effective against higher-grade ships."
    stats={StatsComponent(DefencesStats.beam)}
    requirements={
      <>
        <li>Dockyard level 4</li>
        <li>Energy Innovation level 3</li>
        <li>Beam Tech level 6</li>
      </>
    }
  />
);
export const AstralDescription = () => (
  <DescriptionComponent
    title="Astral Launcher"
    image={astralLauncherImg}
    description="Astral Launchers can counter attacks from fleets equipped with Frigates, but they struggle against Armades."
    stats={StatsComponent(DefencesStats.astral)}
    requirements={
      <>
        <li>Dockyard level 6</li>
        <li>Energy Innovation level 6</li>
        <li>Weapons tech level 3</li>
        <li>Shield Technology level 1</li>
      </>
    }
  />
);
export const PlasmaDescription = () => (
  <DescriptionComponent
    title="Plasma Projector"
    image={plasmaImg}
    description="Plasma Projectors, the ultimate defense, can withstand Armadas with their strong hulls and powerful weapons, but they come at a high cost."
    stats={StatsComponent(DefencesStats.plasma)}
    requirements={
      <>
        <li>Dockyard level 8</li>
        <li>Plasma tech level 7</li>
      </>
    }
  />
);
