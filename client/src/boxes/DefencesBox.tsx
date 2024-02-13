import * as deps from './deps';
import { InfoContainer } from './styled';
import { useDojo } from '../dojo/useDojo';

const DefencesBox = ({
  img,
  title,
  level,
  hasEnoughResources,
  costUpdate,
  functionCallName,
  requirementsMet,
  description,
  resourcesAvailable,
  colonyId,
}: deps.DefenceBoxProps) => {
  const [quantity, setQuantity] = deps.useState(1);
  const [showTooltip, setShowTooltip] = deps.useState(true);
  const {
    setup: {
      systemCalls: { buildDefence },
    },
    account,
  } = useDojo();

  const build = () => buildDefence(account.account, functionCallName, quantity);

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

  // Calculate the cost based on the quantity
  const adjustedSteel = costUpdate
    ? quantity === 0
      ? Number(costUpdate.steel)
      : Number(costUpdate.steel) * quantity
    : 0;
  const adjustedQuartz = costUpdate
    ? quantity === 0
      ? Number(costUpdate.quartz)
      : Number(costUpdate.quartz) * quantity
    : 0;
  const adjustedTritium = costUpdate
    ? quantity === 0
      ? Number(costUpdate.tritium)
      : Number(costUpdate.tritium) * quantity
    : 0;

  // Format the calculated costs to display with commas
  const steelDisplay = adjustedSteel ? deps.numberWithCommas(adjustedSteel) : 0;
  const quartzDisplay = adjustedQuartz
    ? deps.numberWithCommas(adjustedQuartz)
    : 0;
  const tritiumDisplay = adjustedTritium
    ? deps.numberWithCommas(adjustedTritium)
    : 0;

  const shouldShowTooltip =
    ['Astral Launcher', 'Plasma Projector'].includes(title) && showTooltip;

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
        <img
          src={img}
          alt={title}
          style={{ maxWidth: '100%', height: 'auto' }}
        />
      </deps.Styled.ImageContainer>
      <deps.Styled.SubBox>
        <deps.Styled.Title>{title}</deps.Styled.Title>
        <InfoContainer>
          <deps.Styled.ResourceContainer>
            <deps.Styled.ResourceTitle>READY</deps.Styled.ResourceTitle>
            <deps.Styled.NumberContainer>
              {String(level)}
            </deps.Styled.NumberContainer>
          </deps.Styled.ResourceContainer>
          <deps.Styled.ResourceContainer>
            <deps.Styled.ResourceTitle>STEEL</deps.Styled.ResourceTitle>
            <deps.Styled.NumberContainer
              style={{
                color: resourcesAvailable
                  ? resourcesAvailable.steel || 0 < adjustedSteel
                    ? '#AB3836'
                    : 'inherit'
                  : 'inherit',
              }}
            >
              {steelDisplay}
            </deps.Styled.NumberContainer>
          </deps.Styled.ResourceContainer>
          <deps.Styled.ResourceContainer>
            <deps.Styled.ResourceTitle>QUARTZ</deps.Styled.ResourceTitle>
            <deps.Styled.NumberContainer
              style={{
                color: resourcesAvailable
                  ? resourcesAvailable.quartz || 0 < adjustedQuartz
                    ? '#AB3836'
                    : 'inherit'
                  : 'inherit',
              }}
            >
              {quartzDisplay}
            </deps.Styled.NumberContainer>
          </deps.Styled.ResourceContainer>
          <deps.Styled.ResourceContainer>
            <deps.Styled.ResourceTitle>TRITIUM</deps.Styled.ResourceTitle>
            <deps.Styled.NumberContainer
              style={{
                color: resourcesAvailable
                  ? resourcesAvailable.tritium || 0 < adjustedTritium
                    ? '#AB3836'
                    : 'inherit'
                  : 'inherit',
              }}
            >
              {tritiumDisplay}
            </deps.Styled.NumberContainer>
          </deps.Styled.ResourceContainer>
        </InfoContainer>
        <deps.Styled.ResourceContainer>
          <deps.Tooltip title="Select the number of units to build" arrow>
            <deps.Input
              type="number"
              value={quantity}
              defaultValue={1}
              size="sm"
              color="neutral"
              variant="soft"
              style={{ width: '80px' }}
              onChange={(e) => {
                const newValue = parseInt(e.target.value, 10);
                if (!isNaN(newValue) && newValue > 0) {
                  setQuantity(newValue);
                }
              }}
            />
          </deps.Tooltip>
        </deps.Styled.ResourceContainer>
        <deps.AddTransactionIcon
          callType="defence"
          unitName={functionCallName}
          quantity={quantity}
          disabled={hasRequirements || !hasEnoughResources}
          colonyId={colonyId}
        />
        <deps.Styled.ButtonContainer>
          <deps.ButtonBuild
            name={`Build ${quantity} ${title}`}
            callback={build}
            // tx={tx?.transaction_hash}
            disabled={isDisabled}
            noRequirements={hasRequirements}
          />
        </deps.Styled.ButtonContainer>
      </deps.Styled.SubBox>
    </deps.Styled.Box>
  );
};

export default DefencesBox;
