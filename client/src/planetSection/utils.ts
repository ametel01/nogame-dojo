const IMG_URL = '../../assets/planets';

export const getPlanetImageUrl = (imgId: number | undefined) =>
  imgId ? `${IMG_URL}/${imgId}.webp` : undefined;
