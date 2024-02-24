import * as deps from './deps';
import { InfoContainer } from './styled';
import { useDojo } from '../../dojo/useDojo';

const CompoundsBox = ({
  img,
  title,
  level,
  functionCallName,
  description,
  resourcesAvailable,
}: // colonyId,
deps.CompoundsBoxProps) => {
  const [quantity, setQuantity] = deps.useState(1);
  const [, setShowTooltip] = deps.useState(true);
  const [costUpdate, setCostUpdate] = deps.useState({
    steel: 0,
    quartz: 0,
    tritium: 0,
  });
  const [energyRequired, setEnergyRequired] = deps.useState(0);
  const {
    setup: {
      systemCalls: { upgradeCompound },
    },
    account,
  } = useDojo();

  const energy = deps.numberWithCommas(energyRequired);

  const upgrade = () => {
    upgradeCompound(account.account, functionCallName, quantity);
    window.location.reload();
  };

  deps.useEffect(() => {
    const newCost = deps.getCompoundCost(
      functionCallName as number,
      level + 1,
      quantity
    );
    setCostUpdate(newCost);
  }, [quantity, level, functionCallName]);

  deps.useEffect(() => {
    const newConsumption = deps.getCumulativeEnergyChange(
      functionCallName as number,
      level + 1,
      quantity
    );
    setEnergyRequired(newConsumption);
  }, [quantity, level, functionCallName]);

  const hasEnoughResources = deps.calculEnoughResources(
    costUpdate,
    resourcesAvailable
  );

  const currentButtonState = hasEnoughResources ? 'valid' : 'noResource';
  const isDisabled = currentButtonState === 'noResource';

  return (
    <deps.Styled.Box>
      <deps.Styled.ImageContainer>
        <deps.DescriptionModal
          onClick={() => {
            setShowTooltip(false);
          }}
          image={img}
          title={title}
          description={description}
        />
      </deps.Styled.ImageContainer>
      <deps.Styled.SubBox>
        <deps.Styled.Title>{title}</deps.Styled.Title>
        <InfoContainer>
          <deps.Styled.ResourceContainer>
            <deps.Styled.ResourceTitle>STAGE</deps.Styled.ResourceTitle>
            <deps.Styled.NumberContainer>
              {String(level)}
            </deps.Styled.NumberContainer>
          </deps.Styled.ResourceContainer>
          <deps.Styled.ResourceContainer>
            <deps.Styled.ResourceTitle>STEEL</deps.Styled.ResourceTitle>
            <deps.Styled.NumberContainer
              style={{
                color:
                  (resourcesAvailable.steel ?? 0) < costUpdate.steel
                    ? '#AB3836'
                    : 'inherit',
              }}
            >
              {deps.numberWithCommas(costUpdate.steel)}
            </deps.Styled.NumberContainer>
          </deps.Styled.ResourceContainer>
          <deps.Styled.ResourceContainer>
            <deps.Styled.ResourceTitle>QUARTZ</deps.Styled.ResourceTitle>
            <deps.Styled.NumberContainer
              style={{
                color:
                  (resourcesAvailable.quartz ?? 0) < costUpdate.quartz
                    ? '#AB3836'
                    : 'inherit',
              }}
            >
              {deps.numberWithCommas(costUpdate.quartz)}
            </deps.Styled.NumberContainer>
          </deps.Styled.ResourceContainer>
          <deps.Styled.ResourceContainer>
            <deps.Styled.ResourceTitle>TRITIUM</deps.Styled.ResourceTitle>
            <deps.Styled.NumberContainer
              style={{
                color:
                  (resourcesAvailable.tritium ?? 0) < costUpdate.tritium
                    ? '#AB3836'
                    : 'inherit',
              }}
            >
              {deps.numberWithCommas(costUpdate.tritium)}
            </deps.Styled.NumberContainer>
          </deps.Styled.ResourceContainer>
          <deps.Styled.ResourceContainer>
            <deps.Styled.ResourceTitle>ENERGY</deps.Styled.ResourceTitle>
            <deps.Styled.NumberContainer>
              {Number(energy) > 0 ? `+${energy}` : String(energy)}
            </deps.Styled.NumberContainer>
          </deps.Styled.ResourceContainer>
        </InfoContainer>
        <deps.Styled.ResourceContainer>
          <deps.Tooltip title="Select the number of levels to upgrade" arrow>
            <deps.Input
              type="number"
              value={quantity}
              onChange={(e) => {
                if (e.target.value === '') {
                  setQuantity(0);
                } else {
                  setQuantity(parseInt(e.target.value, 10));
                }
              }}
              color="neutral"
              style={{ width: '80px' }}
            />
          </deps.Tooltip>
        </deps.Styled.ResourceContainer>
        <deps.Styled.ButtonContainer>
          <deps.ButtonUpgrade
            name={`Upgrade ${title}`}
            callback={upgrade}
            disabled={isDisabled}
            noRequirements={false}
          />
        </deps.Styled.ButtonContainer>
      </deps.Styled.SubBox>
    </deps.Styled.Box>
  );
};

export default CompoundsBox;
