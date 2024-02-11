import {
  React,
  useState,
  useEffect,
  Styled,
  useCompoundUpgrade,
  numberWithCommas,
  getCompoundCost,
  getCumulativeEnergyChange,
  calculEnoughResources,
  DescriptionModal,
  Tooltip,
  Input,
  AddTransactionIcon,
  ButtonUpgrade,
  CompoundsBoxProps as Props,
} from '.';
import { InfoContainer } from './styled';

const CompoundsBox = ({
  img,
  title,
  level,
  functionCallName,
  description,
  resourcesAvailable,
  colonyId,
}: Props) => {
  const [quantity, setQuantity] = useState(1);
  const [, setShowTooltip] = useState(true);
  const [costUpdate, setCostUpdate] = useState({
    steel: 0,
    quartz: 0,
    tritium: 0,
  });
  const [energyRequired, setEnergyRequired] = useState(0);

  const { tx, writeAsync: upgrade } = useCompoundUpgrade(
    functionCallName,
    quantity,
    colonyId
  );

  const energy = numberWithCommas(energyRequired);

  useEffect(() => {
    const newCost = getCompoundCost(functionCallName, level + 1, quantity);
    setCostUpdate(newCost);
  }, [quantity, level, functionCallName]);

  useEffect(() => {
    const newConsumption = getCumulativeEnergyChange(
      functionCallName,
      level + 1,
      quantity
    );
    setEnergyRequired(newConsumption);
  }, [quantity, level, functionCallName]);

  const hasEnoughResources = calculEnoughResources(
    costUpdate,
    resourcesAvailable
  );

  const currentButtonState = hasEnoughResources ? 'valid' : 'noResource';
  const isDisabled = currentButtonState === 'noResource';

  return (
    <Styled.Box>
      <Styled.ImageContainer>
        <DescriptionModal
          onClick={() => {
            setShowTooltip(false);
          }}
          image={img}
          title={title}
          description={description}
        />
      </Styled.ImageContainer>
      <Styled.SubBox>
        <Styled.Title>{title}</Styled.Title>
        <InfoContainer>
          <Styled.ResourceContainer>
            <Styled.ResourceTitle>STAGE</Styled.ResourceTitle>
            <Styled.NumberContainer>{String(level)}</Styled.NumberContainer>
          </Styled.ResourceContainer>
          <Styled.ResourceContainer>
            <Styled.ResourceTitle>STEEL</Styled.ResourceTitle>
            <Styled.NumberContainer
              style={{
                color: resourcesAvailable
                  ? resourcesAvailable.steel < costUpdate.steel
                    ? '#AB3836'
                    : 'inherit'
                  : 'inherit',
              }}
            >
              {numberWithCommas(costUpdate.steel)}
            </Styled.NumberContainer>
          </Styled.ResourceContainer>
          <Styled.ResourceContainer>
            <Styled.ResourceTitle>QUARTZ</Styled.ResourceTitle>
            <Styled.NumberContainer
              style={{
                color: resourcesAvailable
                  ? resourcesAvailable.quartz < costUpdate.quartz
                    ? '#AB3836'
                    : 'inherit'
                  : 'inherit',
              }}
            >
              {numberWithCommas(costUpdate.quartz)}
            </Styled.NumberContainer>
          </Styled.ResourceContainer>
          <Styled.ResourceContainer>
            <Styled.ResourceTitle>TRITIUM</Styled.ResourceTitle>
            <Styled.NumberContainer
              style={{
                color: resourcesAvailable
                  ? resourcesAvailable.tritium < costUpdate.tritium
                    ? '#AB3836'
                    : 'inherit'
                  : 'inherit',
              }}
            >
              {numberWithCommas(costUpdate.tritium)}
            </Styled.NumberContainer>
          </Styled.ResourceContainer>
          <Styled.ResourceContainer>
            <Styled.ResourceTitle>ENERGY</Styled.ResourceTitle>
            <Styled.NumberContainer>
              {Number(energy) > 0 ? `+${energy}` : String(energy)}
            </Styled.NumberContainer>
          </Styled.ResourceContainer>
        </InfoContainer>
        <Styled.ResourceContainer>
          <Tooltip title="Select the number of levels to upgrade" arrow>
            <Input
              type="number"
              value={quantity}
              onChange={(e) => {
                if (e.target.value === '') {
                  setQuantity(0);
                } else {
                  setQuantity(parseInt(e.target.value, 10));
                }
              }}
              size="sm"
              color="neutral"
              variant="soft"
              style={{ width: '80px' }}
            />
          </Tooltip>
        </Styled.ResourceContainer>
        <AddTransactionIcon
          callType="compound"
          unitName={functionCallName}
          quantity={quantity}
          disabled={isDisabled}
          colonyId={colonyId}
        />
        <Styled.ButtonContainer>
          <ButtonUpgrade
            name={`Upgrade ${title}`}
            callback={upgrade}
            tx={tx?.transaction_hash}
            disabled={isDisabled}
            noRequirements={false}
          />
        </Styled.ButtonContainer>
      </Styled.SubBox>
    </Styled.Box>
  );
};

export default CompoundsBox;
