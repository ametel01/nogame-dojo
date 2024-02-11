import React from 'react'
import {
  PopoverBox,
  PopoverHeaderDiv,
  PopoverInfoRow,
  PopoverTextBox,
  PopoverGridContainer,
  PopoverRequirements,
  PopoverLabel,
  PopoverInfoData
} from '../../shared/styled/PopoverStyle'
import { DefencesStats, ShipsStats } from '../../constants/Stats'
import armadeImg from '../../assets/gameElements/ships/armade4.webp'
import frigateImg from '../../assets/gameElements/ships/frigate4.webp'
import carrierImg from '../../assets/gameElements/ships/carrier4.webp'
import sparrowImg from '../../assets/gameElements/ships/sparrow4.webp'
import scraperImg from '../../assets/gameElements/ships/scraper4.webp'
import celestiaImg from '../../assets/gameElements/ships/celestia4.webp'
// Component props
interface DescriptionComponentProps {
  title: string
  image: string
  description: React.ReactNode
  stats: React.ReactNode
  requirements: React.ReactNode
}

const DescriptionComponent = ({
  title,
  image,
  description,
  stats,
  requirements
}: DescriptionComponentProps) => {
  return (
    <PopoverBox>
      <PopoverHeaderDiv>{title}</PopoverHeaderDiv>
      <div
        style={{
          display: 'flex',
          flexDirection: 'row',
          alignItems: 'flex-start',
          marginBottom: '24px'
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
          <div style={{ marginTop: '8px' }}>Requirements:</div>
          <PopoverRequirements>{requirements}</PopoverRequirements>
        </div>
      </div>
      {/* Stats */}
      {stats}
    </PopoverBox>
  )
}

interface StatsProps {
  cargo?: number
  speed?: number
  consumption?: number
  hull: number
  shield: number
  weapon: number
}

const StatsComponent = ({
  cargo,
  speed,
  consumption,
  hull,
  shield,
  weapon
}: StatsProps) => {
  return (
    <PopoverGridContainer>
      {cargo
        ? (
        <>
          <PopoverInfoRow>
            <PopoverLabel>Cargo Capacity:</PopoverLabel>
            <PopoverInfoData>{cargo}</PopoverInfoData>
          </PopoverInfoRow>
        </>
          )
        : null}
      {speed
        ? (
        <>
          <PopoverInfoRow>
            <PopoverLabel>Base Speed: </PopoverLabel>
            <PopoverInfoData>{speed}</PopoverInfoData>
          </PopoverInfoRow>
        </>
          )
        : null}
      {consumption
        ? (
        <>
          <PopoverInfoRow>
            <PopoverLabel>Consumption: </PopoverLabel>
            <PopoverInfoData>{consumption}</PopoverInfoData>
          </PopoverInfoRow>
        </>
          )
        : null}
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
  )
}

export const CarrierDescription = () => (
  <DescriptionComponent
    title="Carrier"
    image={carrierImg}
    description="Carriers are used to transport resources; they are inexpensive and available early in the game. Initially equipped with a combustion engine, their speed doubles at level 4 with thrust propulsion."
    stats={StatsComponent(ShipsStats.carrier)}
    requirements={
      <>
        <li>Dockyard level 2</li>
        <li>Combustion Drive level 2</li>
      </>
    }
  />
)
export const CelestiaDescription = () => (
  <DescriptionComponent
    title="Celestia"
    image={celestiaImg}
    description="Celestia orbit the planet and generate energy, with higher output in low orbits. They are efficient energy sources but are vulnerable to attacks and can be easily destroyed."
    stats={StatsComponent(DefencesStats.celestia)}
    requirements={
      <>
        <li>Dockyar level 1</li>
        <li>Combustion Drive level 1</li>
      </>
    }
  />
)
export const ScraperDescription = () => (
  <DescriptionComponent
    title="Scraper"
    image={scraperImg}
    description="Scrapers collect resources from debris fields around planets post-battles. They are slow-moving and consume a relatively high amount of fuel."
    stats={StatsComponent(ShipsStats.scraper)}
    requirements={
      <>
        <li>Dockyard level 4</li>
        <li>Combusiton drive level 6</li>
        <li>Shield Technology level 2</li>
      </>
    }
  />
)
export const SparrowDescription = () => (
  <DescriptionComponent
    title="Sparrow"
    image={sparrowImg}
    description="The Sparrow, the smallest warship, is available early in the game. It's fast and inexpensive but has limited weaponry and a small hull."
    stats={StatsComponent(ShipsStats.sparrow)}
    requirements={
      <>
        <li>Dockyard level 1</li>
        <li>Combustion Drive level 1</li>
      </>
    }
  />
)
export const FrigateDescription = () => (
  <DescriptionComponent
    title="Frigate"
    image={frigateImg}
    description="The Frigate is a mid-sized warship, known for its speed. It can be particularly powerful in the early game, when most players have only Sparrows and Blasters."
    stats={StatsComponent(ShipsStats.frigate)}
    requirements={
      <>
        <li>Dockyard level 5</li>
        <li>Ion Systems level 2</li>
        <li>Thrust Drive level 4</li>
      </>
    }
  />
)
export const ArmadeDescription = () => (
  <DescriptionComponent
    title="Armade"
    image={armadeImg}
    description="Armades are the most powerful warships, with their speed and heavy weaponry making them formidable against most defenses. They don't require tritium for construction but have high fuel consumption."
    stats={StatsComponent(ShipsStats.armade)}
    requirements={
      <>
        <li>Dockyard level 7</li>
        <li>Warp Drive level 4</li>
      </>
    }
  />
)
