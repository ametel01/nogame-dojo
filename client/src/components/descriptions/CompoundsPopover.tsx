import React, { useState } from 'react';
import styled from 'styled-components';
import { Input } from '@mui/joy';
import CompoundsFormulas from '../../shared/utils/Formulas';
import Box from '@mui/material/Box';
import steelImg from '../../assets/gameElements/compounds/steel4.webp';
import quartzImg from '../../assets/gameElements/compounds/quartz4.webp';
import tritiumImg from '../../assets/gameElements/compounds/tritium4.webp';
import energyImg from '../../assets/gameElements/compounds/energy4.webp';
import labImg from '../../assets/gameElements/compounds/lab4.webp';
import dockyardImg from '../../assets/gameElements/compounds/dockyard4.webp';
import { numberWithCommas } from '../../shared/utils';

export const StyledBox = styled(Box)({
  fontWeight: 400,
  position: 'absolute',
  top: '50%',
  left: '50%',
  transform: 'translate(-50%, -50%)',
  backgroundColor: '#1a2025',
  borderRadius: 16,
  boxShadow: '0px 3px 5px rgba(0, 0, 0, 0.2)',
  padding: '32px 32px',
  display: 'flex',
  flexDirection: 'column',
  width: '25%',
  textTransform: 'capitalize',
});

const HeaderDiv = styled('div')({
  fontSize: 20,
  marginBottom: '16px',
  textTransform: 'uppercase',
});

const InfoRow = styled('div')({
  display: 'flex',
  justifyContent: 'space-between',
  alignItems: 'center',
  marginBottom: '16px',
});

const InfoData = styled('span')({
  color: '#23CE6B',
});

const StyledImage = styled('img')({
  width: '100%',
  height: 'auto',
  marginBottom: '32px',
  borderRadius: '8px',
});

const Label = styled('span')({});

interface Cost {
  steel: number;
  quartz: number;
  tritium: number;
}

function useMineInformation(
  level: number,
  costFunc: (arg0: number) => Cost,
  productionFunc?: (arg0: number) => number,
  consumptionFunc?: (arg0: number) => number
) {
  const production = productionFunc ? productionFunc(Number(level)) : undefined;
  const cost = costFunc(level);
  const consumption = consumptionFunc
    ? consumptionFunc(Number(level))
    : undefined;

  return { production, cost, consumption };
}

interface DescriptionProps {
  title: string;
  image: string;
  currentLevel?: number;
  costFunc: (arg0: number) => Cost;
  productionFunc?: (arg0: number) => number;
  consumptionFunc?: (arg0: number) => number;
}

function CompoundDescription({
  title,
  image,
  productionFunc,
  costFunc,
  consumptionFunc,
  currentLevel,
}: DescriptionProps) {
  const [level, setLevel] = useState(Number(currentLevel!));
  const { production, cost, consumption } = useMineInformation(
    level,
    costFunc,
    productionFunc,
    consumptionFunc
  );

  return (
    <div>
      <StyledBox>
        <HeaderDiv>{title}</HeaderDiv>
        <StyledImage src={image} alt={`${title} Image`} />
        <InfoRow>
          <Label>Level:</Label>
          <Input
            type="number"
            value={level}
            defaultValue={currentLevel}
            onChange={(e) => {
              setLevel(Number(e.target.value));
            }}
            // size="small"
            color="neutral"
            variant="soft"
            style={{ width: '80px' }}
          />
        </InfoRow>
        <InfoRow>
          <Label>Cost Steel:</Label>
          <InfoData>{numberWithCommas(cost.steel)}</InfoData>
        </InfoRow>
        <InfoRow>
          <Label>Cost Quartz:</Label>
          <InfoData>{numberWithCommas(cost.quartz)}</InfoData>
        </InfoRow>
        {cost.tritium != 0 ? (
          <InfoRow>
            <Label>Cost Tritium:</Label>
            <InfoData>{numberWithCommas(cost.tritium)}</InfoData>
          </InfoRow>
        ) : null}
        {productionFunc && (
          <InfoRow>
            <Label>Hourly Production:</Label>
            <InfoData>{numberWithCommas(production!)}</InfoData>
          </InfoRow>
        )}
        {consumptionFunc && (
          <InfoRow>
            <Label>Energy Consumption:</Label>
            <InfoData>{numberWithCommas(consumption!)}</InfoData>
          </InfoRow>
        )}
      </StyledBox>
    </div>
  );
}

interface MineDescriptionProps {
  currentLevel?: number;
}

export function SteelMineDescription({ currentLevel }: MineDescriptionProps) {
  return (
    <CompoundDescription
      title="Steel Mine"
      image={steelImg}
      currentLevel={currentLevel}
      productionFunc={CompoundsFormulas.steelProduction}
      costFunc={CompoundsFormulas.steelCost}
      consumptionFunc={CompoundsFormulas.steelConsumption}
    />
  );
}

export function QuartzMineDescription({ currentLevel }: MineDescriptionProps) {
  return (
    <CompoundDescription
      title="Quartz Mine"
      image={quartzImg}
      currentLevel={currentLevel}
      productionFunc={CompoundsFormulas.quartzProduction}
      costFunc={CompoundsFormulas.quartzCost}
      consumptionFunc={CompoundsFormulas.quartzConsumption}
    />
  );
}

export function TritiumMineDescription({ currentLevel }: MineDescriptionProps) {
  return (
    <CompoundDescription
      title="Tritium Mine"
      image={tritiumImg}
      currentLevel={currentLevel}
      productionFunc={CompoundsFormulas.tritiumProduction}
      costFunc={CompoundsFormulas.tritiumCost}
      consumptionFunc={CompoundsFormulas.tritiumConsumption}
    />
  );
}

export function EnergyPlantDescription({ currentLevel }: MineDescriptionProps) {
  return (
    <CompoundDescription
      title="Energy Plant"
      image={energyImg}
      currentLevel={currentLevel}
      productionFunc={CompoundsFormulas.energyProduction}
      costFunc={CompoundsFormulas.energyCost}
    />
  );
}

export function LabDescription({ currentLevel }: MineDescriptionProps) {
  return (
    <CompoundDescription
      title="Research Lab"
      image={labImg}
      currentLevel={currentLevel}
      costFunc={CompoundsFormulas.labCost}
    />
  );
}
export function DockyardDescription({ currentLevel }: MineDescriptionProps) {
  return (
    <CompoundDescription
      title="Dockyard"
      image={dockyardImg}
      currentLevel={currentLevel}
      costFunc={CompoundsFormulas.dockyardCost}
    />
  );
}
