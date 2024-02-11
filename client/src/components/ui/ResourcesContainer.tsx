import React, { useMemo, useState } from 'react';
import Tooltip from '@mui/material/Tooltip';
import styled from 'styled-components';
import { Typography } from '@mui/material';
import {
  QUARTZADDRESS,
  STEELADDRESS,
  TRITIUMADDRESS,
} from '../../constants/addresses';
import { numberWithCommas } from '../../shared/utils';
// Asset imports
import ironImg from '../../assets/gameElements/resources/steel-1.webp';
import quartzImg from '../../assets/gameElements/resources/quartz-2.webp';
import tritiumImg from '../../assets/gameElements/resources/tritium-1.webp';
import energyImg from '../../assets/gameElements/resources/energy-2.webp';
import {
  useCollectibleResources,
  // useEnergyAvailable,
  useSpendableResources,
} from '../../hooks/ResourcesHooks';
import { useGetCelestiaAvailable } from '../../hooks/EnergyHooks';
import CompoundsFormulas, {
  getCelestiaProduction,
} from '../../shared/utils/Formulas';
import { useCompoundsLevels } from '../../hooks/LevelsHooks';
import {
  useGetColonyCompounds,
  useGetColonyDefences,
  useGetColonyResources,
} from '../../hooks/ColoniesHooks';
import { Position } from '../../shared/types';

const Container = styled.div`
  display: flex;
  align-items: center;
  padding: 4px 16px;
  border-top: 2px solid #151a1e;
`;

const ImageAddressContainer = styled.div`
  display: flex;
  flex-direction: column;
  align-items: center;
  width: 50px;
  cursor: pointer;

  &:hover {
    opacity: 0.8;
  }
`;

const ImageStyle = styled.img`
  width: 50px;
  height: auto;
  object-fit: contain;
`;

const ResourceName = styled(Typography)({
  textTransform: 'uppercase',
  opacity: 0.5,
  fontWeight: 700,
  lineHeight: '16px',
  letterSpacing: '0.02em',
  margin: 0, // Make sure no external spacing
  padding: 0, // Make sure no internal spacing

  width: '64px',
});

const TotalResourceText = styled.div`
  color: #23ce6b;
  font-weight: 500;
  margin-left: 10px;
  padding-bottom: 6px;
`;

const TotalResourceContainer = styled.div`
  display: flex;
  align-items: center;
  padding: 16px;
`;

const TotalResourceWrapper = styled.div`
  margin-left: 30px;
  display: flex;
  flex-direction: column;
`;

interface Props {
  spendable?: string;
  collectible?: string;
  available?: number;
  img: string;
  title: string;
  address?: string;
  fromCelestia?: number;
}

const Energy = ({ available, img, title, fromCelestia }: Props) => {
  const energyAvailable = available != undefined ? Number(available) : 0;
  const availableStyle = {
    color: energyAvailable < 0 ? '#AB3836' : '#23CE6B', // Apply red color if available is negative
  };
  return (
    <Container>
      <div>
        <ResourceName style={{ fontSize: '16px' }}>{title}</ResourceName>
        <ImageAddressContainer>
          <div style={{ width: '30px' }}>
            <ImageStyle src={img} alt="resource" />
          </div>
        </ImageAddressContainer>
      </div>
      <TotalResourceWrapper>
        <TotalResourceContainer>
          <Tooltip
            title={'Energy must always be positive to avoid loosing production'}
            arrow
            placement="top"
          >
            <div>
              <ResourceName style={{ fontSize: '10px' }}>
                Available
              </ResourceName>
              <TotalResourceText style={availableStyle}>
                {numberWithCommas(available!)}
              </TotalResourceText>
              <ResourceName style={{ fontSize: '10px' }}>Celestia</ResourceName>
              <TotalResourceText>
                {numberWithCommas(fromCelestia!)}
              </TotalResourceText>
            </div>
          </Tooltip>
        </TotalResourceContainer>
      </TotalResourceWrapper>
    </Container>
  );
};

const Resource = ({ spendable, collectible, img, title, address }: Props) => {
  const [copied, setCopied] = useState(false);
  return (
    <Container>
      <Tooltip
        title={
          copied ? 'Copied' : 'Copy Token Address and add it to your wallet'
        }
        arrow
      >
        <div>
          <ResourceName style={{ fontSize: '16px' }}>{title}</ResourceName>
          <ImageAddressContainer
            onClick={() => {
              if (address) {
                const blob = new Blob([address], { type: 'text/plain' });
                const item = new ClipboardItem({ 'text/plain': blob });
                navigator.clipboard.write([item]).then(() => {
                  setCopied(true);
                });
              }
            }}
          >
            <div style={{ width: '30px' }}>
              <ImageStyle src={img} alt="resource" />
            </div>
          </ImageAddressContainer>
        </div>
      </Tooltip>
      <TotalResourceWrapper>
        <TotalResourceContainer>
          <div>
            <Tooltip
              title="Available for spending; 50% vulnerable to plundering in an attack."
              arrow
              placement="top"
            >
              <ResourceName style={{ fontSize: '10px' }}>
                Spendable
              </ResourceName>
            </Tooltip>
            <TotalResourceText>{String(spendable)}</TotalResourceText>
            <Tooltip
              title="
              Mined resources pending collection; not spendable and 100% at risk of plundering in an attack."
              arrow
            >
              <ResourceName style={{ fontSize: '10px' }}>
                Collectible
              </ResourceName>
            </Tooltip>
            <TotalResourceText>{String(collectible)}</TotalResourceText>
          </div>
        </TotalResourceContainer>
      </TotalResourceWrapper>
    </Container>
  );
};

interface ResourceContainerArgs {
  planetId: number;
  selectedColonyId: number;
  planetPosition: Position;
}

const ResourcesContainer = ({
  planetId,
  selectedColonyId,
  planetPosition,
}: ResourceContainerArgs) => {
  const compoundsLevels = useCompoundsLevels(planetId);
  const colonyCompounds = useGetColonyCompounds(planetId, selectedColonyId);

  const spendable = useSpendableResources(planetId);

  const collectible = useCollectibleResources(planetId);
  const colonyCollectible = useGetColonyResources(planetId, selectedColonyId);

  const solarEnergy =
    selectedColonyId === 0
      ? compoundsLevels
        ? CompoundsFormulas.energyProduction(Number(compoundsLevels.energy))
        : 0
      : CompoundsFormulas.energyProduction(Number(colonyCompounds?.energy));

  const celestia = useGetCelestiaAvailable(planetId);
  const colonyCelestia = useGetColonyDefences(planetId, selectedColonyId);

  const celestiaProduction = getCelestiaProduction(
    Number(planetPosition?.orbit)
  );
  const energyFromCelestia =
    selectedColonyId === 0
      ? Number(celestia) * celestiaProduction
      : Number(colonyCelestia?.celestia) * celestiaProduction;

  const steelConsumption =
    selectedColonyId === 0
      ? CompoundsFormulas.steelConsumption(Number(compoundsLevels?.steel))
      : CompoundsFormulas.steelConsumption(Number(colonyCompounds?.steel));

  const quartzConsumption =
    selectedColonyId === 0
      ? CompoundsFormulas.quartzConsumption(Number(compoundsLevels?.quartz))
      : CompoundsFormulas.quartzConsumption(Number(colonyCompounds?.quartz));

  const tritiumConsumption =
    selectedColonyId === 0
      ? CompoundsFormulas.tritiumConsumption(Number(compoundsLevels?.tritium))
      : CompoundsFormulas.tritiumConsumption(Number(colonyCompounds?.tritium));

  const netEnergy =
    solarEnergy +
    energyFromCelestia -
    (steelConsumption + quartzConsumption + tritiumConsumption);

  const spendableResources = useMemo(() => {
    if (spendable) {
      return {
        steel: numberWithCommas(Number(spendable.steel)),
        quartz: numberWithCommas(Number(spendable.quartz)),
        tritium: numberWithCommas(Number(spendable.tritium)),
      };
    }
  }, [spendable]);

  const motherCollectibleResources = useMemo(() => {
    if (collectible) {
      return {
        steel: numberWithCommas(Math.round(Number(collectible.steel))),
        quartz: numberWithCommas(Math.round(Number(collectible.quartz))),
        tritium: numberWithCommas(Math.round(Number(collectible.tritium))),
      };
    }
  }, [collectible]);

  const colonyCollectibleResources = useMemo(() => {
    if (colonyCollectible) {
      return {
        steel: numberWithCommas(Math.round(Number(colonyCollectible.steel))),
        quartz: numberWithCommas(Math.round(Number(colonyCollectible.quartz))),
        tritium: numberWithCommas(
          Math.round(Number(colonyCollectible.tritium))
        ),
      };
    }
  }, [colonyCollectible]);

  return (
    <div>
      <Resource
        title="Steel"
        address={STEELADDRESS}
        img={ironImg}
        spendable={spendableResources?.steel}
        collectible={
          selectedColonyId === 0
            ? motherCollectibleResources?.steel
            : colonyCollectibleResources?.steel
        }
      />
      <Resource
        title="Quartz"
        address={QUARTZADDRESS}
        img={quartzImg}
        spendable={spendableResources?.quartz}
        collectible={
          selectedColonyId == 0
            ? motherCollectibleResources?.quartz
            : colonyCollectibleResources?.quartz
        }
      />
      <Resource
        title="Tritium"
        address={TRITIUMADDRESS}
        img={tritiumImg}
        spendable={spendableResources?.tritium}
        collectible={
          selectedColonyId == 0
            ? motherCollectibleResources?.tritium
            : colonyCollectibleResources?.tritium
        }
      />
      <Energy
        title="Energy"
        img={energyImg}
        available={netEnergy}
        fromCelestia={energyFromCelestia}
      />
    </div>
  );
};

export default ResourcesContainer;
