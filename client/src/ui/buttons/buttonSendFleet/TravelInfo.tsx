import React from 'react';
import styled from 'styled-components';
import { convertSecondsToTime, numberWithCommas } from '../../../shared/utils';

const TravelInfoContainer = styled('div')({
  // marginTop: '32px',
  margin: '8px 0',
});

const TravelInfoRow = styled('div')({
  marginBottom: '12px',
});

const TravelInfoData = styled('span')({
  color: '#23CE6B',
});

interface Props {
  destination: string;
  travelTime: number;
  timeOfArrival: Date | null;
  fuelConsumption: number;
  cargoCapacity: number;
}

export const TravelInfo = ({
  destination,
  travelTime,
  timeOfArrival,
  fuelConsumption,
  cargoCapacity,
}: Props) => {
  return (
    <TravelInfoContainer>
      <TravelInfoRow>
        Destination: <TravelInfoData>{destination}</TravelInfoData>
      </TravelInfoRow>
      <TravelInfoRow>
        Travel time:{' '}
        <TravelInfoData>{convertSecondsToTime(travelTime)}</TravelInfoData>
      </TravelInfoRow>
      <TravelInfoRow>
        Time arrival:{' '}
        <TravelInfoData>
          {timeOfArrival ? timeOfArrival.toLocaleTimeString() : null}
        </TravelInfoData>
      </TravelInfoRow>
      <TravelInfoRow>
        Fuel consumption:{' '}
        <TravelInfoData>{numberWithCommas(fuelConsumption)}</TravelInfoData>
      </TravelInfoRow>
      <TravelInfoRow>
        Cargo capacity:{' '}
        <TravelInfoData>{numberWithCommas(cargoCapacity)}</TravelInfoData>
      </TravelInfoRow>
    </TravelInfoContainer>
  );
};
