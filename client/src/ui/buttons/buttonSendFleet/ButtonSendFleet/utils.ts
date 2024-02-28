import steelImg from '../../../../assets/gameElements/resources/steel-1.webp';
import quartzImg from '../../../../assets/gameElements/resources/quartz-2.webp';
import tritiumImg from '../../../../assets/gameElements/resources/tritium-1.webp';

export type ShipName = 'carrier' | 'scraper' | 'sparrow' | 'frigate' | 'armade';

export type ResourceName = 'steel' | 'quartz' | 'tritium';

export const resourceImageMapping: Record<ResourceName, string> = {
  steel: steelImg,
  quartz: quartzImg,
  tritium: tritiumImg,
};
