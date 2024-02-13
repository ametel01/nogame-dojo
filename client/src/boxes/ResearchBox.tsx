import {
  React,
  useMemo,
  useState,
  Styled,
  useTechUpgrade,
  baseTechCost,
  getCumulativeTechCost,
  calculEnoughResources,
  DescriptionModal,
  numberWithCommas,
  Tooltip,
  Input,
  AddTransactionIcon,
  ButtonUpgrade,
  LabBoxProps as Props,
  ButtonState,
} from '.';
import { InfoContainer } from './styled';

const ResearchBox = ({
  img,
  title,
  functionCallName,
  level,
  requirementsMet,
  description,
  resourcesAvailable,
}: Props) => {
  const [quantity, setQuantity] = useState(1);
  const [showTooltip, setShowTooltip] = useState(true);

  const { tx, writeAsync: upgrade } = useTechUpgrade(
    functionCallName,
    quantity
  );

  const baseCosts = baseTechCost[functionCallName];
  const isExo = functionCallName === 18;
  // Calculate the cumulative cost of the upgrade
  const upgradeCost = useMemo(() => {
    if (quantity > 0 && level != undefined) {
      const cost = getCumulativeTechCost(
        level,
        quantity,
        baseCosts.steel,
        baseCosts.quartz,
        baseCosts.tritium,
        isExo
      );
      return cost;
    }
    return { steel: 0, quartz: 0, tritium: 0 };
  }, [level, quantity, baseCosts, isExo]);

  const hasEnoughResources = calculEnoughResources(
    upgradeCost,
    resourcesAvailable
  );

  const buttonState = useMemo((): ButtonState => {
    if (!requirementsMet) {
      return 'noRequirements';
    } else if (!hasEnoughResources) {
      return 'noResource';
    }

    return 'valid';
  }, [hasEnoughResources, requirementsMet]);

  const hasRequirements = buttonState === 'noRequirements';

  const isDisabled = buttonState === 'noResource';

  const shouldShowTooltip =
    [
      'Ion Systems',
      'Plasma Engineering',
      'Spacetime Technology',
      'Warp Drive',
    ].includes(title) && showTooltip;

  const boxContent = (
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
            <Styled.NumberContainer>{level}</Styled.NumberContainer>
          </Styled.ResourceContainer>
          <Styled.ResourceContainer>
            <Styled.ResourceTitle>STEEL</Styled.ResourceTitle>
            <Styled.NumberContainer
              style={{
                color: resourcesAvailable
                  ? resourcesAvailable.steel < upgradeCost.steel
                    ? '#AB3836'
                    : 'inherit'
                  : 'inherit',
              }}
            >
              {numberWithCommas(upgradeCost.steel)}
            </Styled.NumberContainer>
          </Styled.ResourceContainer>
          <Styled.ResourceContainer>
            <Styled.ResourceTitle>QUARTZ</Styled.ResourceTitle>
            <Styled.NumberContainer
              style={{
                color: resourcesAvailable
                  ? resourcesAvailable.quartz < upgradeCost.quartz
                    ? '#AB3836'
                    : 'inherit'
                  : 'inherit',
              }}
            >
              {numberWithCommas(upgradeCost.quartz)}
            </Styled.NumberContainer>
          </Styled.ResourceContainer>
          <Styled.ResourceContainer>
            <Styled.ResourceTitle>TRITIUM</Styled.ResourceTitle>
            <Styled.NumberContainer
              style={{
                color: resourcesAvailable
                  ? resourcesAvailable.tritium < upgradeCost.tritium
                    ? '#AB3836'
                    : 'inherit'
                  : 'inherit',
              }}
            >
              {numberWithCommas(upgradeCost.tritium)}
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
          callType="tech"
          unitName={functionCallName}
          quantity={quantity}
          disabled={hasRequirements || !hasEnoughResources}
          colonyId={0}
        />
        <Styled.ButtonContainer>
          <ButtonUpgrade
            name={`Upgrade ${title}`}
            callback={upgrade}
            tx={tx?.transaction_hash}
            disabled={isDisabled}
            noRequirements={hasRequirements}
          />
        </Styled.ButtonContainer>
      </Styled.SubBox>
    </Styled.Box>
  );

  return shouldShowTooltip ? (
    <Tooltip title="Non available on testnet release" placement="top" arrow>
      {boxContent}
    </Tooltip>
  ) : (
    boxContent
  );
};

export default ResearchBox;
