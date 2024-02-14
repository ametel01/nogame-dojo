import * as deps from './deps';
import { InfoContainer } from './styled';
import { useDojo } from '../dojo/useDojo';

const DockyardBox = ({
  img,
  title,
  level,
  hasEnoughResources,
  costUpdate,
  functionCallName,
  requirementsMet,
  description,
  resourcesAvailable,
}: // colonyId,
deps.DockyardBoxProps) => {
  const [quantity, setQuantity] = deps.useState(1);
  const {
    setup: {
      systemCalls: { buildShip },
    },
    account,
  } = useDojo();

  const build = () => buildShip(account.account, functionCallName, quantity);

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
      ? costUpdate.steel
      : costUpdate.steel * quantity
    : 0;
  const adjustedQuartz = costUpdate
    ? quantity === 0
      ? costUpdate.quartz
      : costUpdate.quartz * quantity
    : 0;
  const adjustedTritium = costUpdate
    ? quantity === 0
      ? costUpdate.tritium
      : costUpdate.tritium * quantity
    : 0;

  // Format the calculated costs to display with commas
  const steelDisplay = adjustedSteel ? deps.numberWithCommas(adjustedSteel) : 0;
  const quartzDisplay = adjustedQuartz
    ? deps.numberWithCommas(adjustedQuartz)
    : 0;
  const tritiumDisplay = adjustedTritium
    ? deps.numberWithCommas(adjustedTritium)
    : 0;

  const boxContent = (
    <deps.Styled.Box>
      <deps.Styled.ImageContainer>
        <deps.DescriptionModal
          onClick={() => {}}
          image={img}
          title={title}
          description={description}
        />
        <img src={img} alt={title} />
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
                color:
                  (resourcesAvailable.steel || 0) < adjustedSteel
                    ? '#AB3836'
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
                color:
                  (resourcesAvailable.quartz || 0) < adjustedQuartz
                    ? '#AB3836'
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
                color:
                  (resourcesAvailable.tritium || 0) < adjustedTritium
                    ? '#AB3836'
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

  return boxContent;
};

export default DockyardBox;
