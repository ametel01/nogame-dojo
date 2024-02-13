import * as deps from './deps';
import { InfoContainer } from './styled';
import { useDojo } from '../dojo/useDojo';

const ResearchBox = ({
  img,
  title,
  functionCallName,
  level,
  requirementsMet,
  description,
  resources,
}: deps.LabBoxProps) => {
  const [quantity, setQuantity] = deps.useState(1);
  const [showTooltip, setShowTooltip] = deps.useState(true);
  const {
    setup: {
      systemCalls: { upgradeTech },
    },
    account,
  } = useDojo();

  const upgrade = () =>
    upgradeTech(account.account, functionCallName, quantity);

  const baseCosts = deps.baseTechCost[functionCallName as number];
  const isExo = functionCallName === 18;
  // Calculate the cumulative cost of the upgrade
  const upgradeCost = deps.useMemo(() => {
    if (quantity > 0 && level != undefined) {
      const cost = deps.getCumulativeTechCost(
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

  const hasEnoughResources = deps.calculEnoughResources(upgradeCost, resources);

  const buttonState = deps.useMemo((): deps.ButtonState => {
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
            <deps.Styled.NumberContainer>{level}</deps.Styled.NumberContainer>
          </deps.Styled.ResourceContainer>
          <deps.Styled.ResourceContainer>
            <deps.Styled.ResourceTitle>STEEL</deps.Styled.ResourceTitle>
            <deps.Styled.NumberContainer
              style={{
                color: resources
                  ? resources.steel || 0 < upgradeCost.steel
                    ? '#AB3836'
                    : 'inherit'
                  : 'inherit',
              }}
            >
              {deps.numberWithCommas(upgradeCost.steel)}
            </deps.Styled.NumberContainer>
          </deps.Styled.ResourceContainer>
          <deps.Styled.ResourceContainer>
            <deps.Styled.ResourceTitle>QUARTZ</deps.Styled.ResourceTitle>
            <deps.Styled.NumberContainer
              style={{
                color: resources
                  ? resources.quartz || 0 < upgradeCost.quartz
                    ? '#AB3836'
                    : 'inherit'
                  : 'inherit',
              }}
            >
              {deps.numberWithCommas(upgradeCost.quartz)}
            </deps.Styled.NumberContainer>
          </deps.Styled.ResourceContainer>
          <deps.Styled.ResourceContainer>
            <deps.Styled.ResourceTitle>TRITIUM</deps.Styled.ResourceTitle>
            <deps.Styled.NumberContainer
              style={{
                color: resources
                  ? resources.tritium || 0 < upgradeCost.tritium
                    ? '#AB3836'
                    : 'inherit'
                  : 'inherit',
              }}
            >
              {deps.numberWithCommas(upgradeCost.tritium)}
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
              size="sm"
              color="neutral"
              variant="soft"
              style={{ width: '80px' }}
            />
          </deps.Tooltip>
        </deps.Styled.ResourceContainer>
        <deps.Styled.ButtonContainer>
          <deps.ButtonUpgrade
            name={`Upgrade ${title}`}
            callback={upgrade}
            // tx={tx?.transaction_hash}
            disabled={isDisabled}
            noRequirements={hasRequirements}
          />
        </deps.Styled.ButtonContainer>
      </deps.Styled.SubBox>
    </deps.Styled.Box>
  );

  return shouldShowTooltip ? (
    <deps.Tooltip
      title="Non available on testnet release"
      placement="top"
      arrow
    >
      {boxContent}
    </deps.Tooltip>
  ) : (
    boxContent
  );
};

export default ResearchBox;
