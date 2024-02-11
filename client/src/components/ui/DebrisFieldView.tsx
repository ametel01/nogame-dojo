import { Tooltip, Box, IconButton, Modal } from '@mui/material';
import DebrisIcon from '../../assets/uiIcons/debris.svg';
import { useGetDebrisField } from '../../hooks/useGetDebrisField';
import CircularProgress from '@mui/material/CircularProgress';
import { ButtonCollectDebris } from '../buttons/ButtonCollectDebris';
import {
  type DebrisField,
  type ShipsLevels,
  type TechLevels,
  type Position,
} from '../../shared/types';
import React from 'react';
import { numberWithCommas } from '../../shared/utils';

interface Props {
  planetId?: number;
  position?: string;
  ownFleet?: ShipsLevels;
  techs?: TechLevels;
  ownPosition?: Position;
  colonyId: number;
}

function DebrisFieldView({
  planetId,
  position,
  ownFleet,
  techs,
  ownPosition,
  colonyId,
}: Props) {
  const [modalOpen, setModalOpen] = React.useState(false);

  const debris: DebrisField = useGetDebrisField(Number(planetId));

  const handleOpenModal = () => {
    setModalOpen(true);
  };

  const handleCloseModal = () => {
    setModalOpen(false);
  };

  if (!planetId && !position && !ownFleet) {
    return (
      <Box
        display="flex"
        justifyContent="center"
        alignItems="center"
        height="100%"
      >
        <CircularProgress />
      </Box>
    );
  }

  const debrisPresent = debris ? debris.steel > 0 || debris.quartz > 0 : false;
  return (
    <Box
      sx={{
        width: '1%',
        height: 32,
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
        marginLeft: '10px',
      }}
    >
      {debrisPresent ? (
        <>
          <Tooltip
            title={
              <>
                <div>
                  <strong>Debris Field</strong>
                </div>
                <div>Steel: {numberWithCommas(debris.steel)}</div>
                <div>Quartz: {numberWithCommas(debris.quartz)}</div>
              </>
            }
            arrow
          >
            <IconButton onClick={handleOpenModal} size="large">
              <img
                src={DebrisIcon}
                alt="Debris"
                style={{
                  width: 40,
                  height: 40,
                  display: 'block',
                  color: '#F4F3EE',
                }}
              />
            </IconButton>
          </Tooltip>
          <Modal
            open={modalOpen}
            onClose={handleCloseModal}
            aria-labelledby="collect-debris-modal"
            aria-describedby="collect-debris-modal-description"
            disableAutoFocus={true}
          >
            <div>
              <ButtonCollectDebris
                onClose={handleCloseModal}
                position={position!}
                ownFleet={ownFleet!}
                techs={techs!}
                ownPosition={ownPosition!}
                debrisField={debris}
                colonyId={colonyId}
              />
            </div>
          </Modal>
        </>
      ) : (
        <div style={{ width: 40, height: 40 }} />
      )}
    </Box>
  );
}

export default DebrisFieldView;
