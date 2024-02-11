import { type Resources } from '../shared/types';

export const baseTechCost: Record<number, Resources> = {
  6: { steel: 0, quartz: 800, tritium: 400 },
  7: { steel: 0, quartz: 400, tritium: 600 },
  8: { steel: 0, quartz: 800, tritium: 400 },
  9: { steel: 1000, quartz: 0, tritium: 0 },
  10: { steel: 1000, quartz: 300, tritium: 1000 },
  11: { steel: 2000, quartz: 4000, tritium: 1000 },
  12: { steel: 800, quartz: 200, tritium: 0 },
  13: { steel: 200, quartz: 600, tritium: 0 },
  14: { steel: 0, quartz: 4000, tritium: 2000 },
  15: { steel: 400, quartz: 0, tritium: 600 },
  16: { steel: 2000, quartz: 4000, tritium: 600 },
  17: { steel: 10000, quartz: 20000, tritium: 6000 },
  18: { steel: 4000, quartz: 8000, tritium: 4000 },
};

export function getBaseShipsCost() {
  return {
    celestia: { steel: 0, quartz: 2000, tritium: 500 },
    carrier: { steel: 2000, quartz: 2000, tritium: 0 },
    scraper: { steel: 10000, quartz: 6000, tritium: 2000 },
    sparrow: { steel: 3000, quartz: 1000, tritium: 0 },
    frigate: { steel: 20000, quartz: 7000, tritium: 2000 },
    armade: { steel: 45000, quartz: 15000, tritium: 0 },
  };
}

export const baseShipCost: Record<number, Resources> = {
  2: { steel: 0, quartz: 2000, tritium: 500 },
  0: { steel: 2000, quartz: 2000, tritium: 0 },
  1: { steel: 10000, quartz: 6000, tritium: 2000 },
  3: { steel: 3000, quartz: 1000, tritium: 0 },
  4: { steel: 20000, quartz: 7000, tritium: 200 },
  5: { steel: 45000, quartz: 15000, tritium: 0 },
};

export function getBaseDefenceCost() {
  return {
    celestia: { steel: 0, quartz: 2000, tritium: 500 },
    blaster: { steel: 2000, quartz: 0, tritium: 0 },
    beam: { steel: 6000, quartz: 2000, tritium: 0 },
    astral: { steel: 20000, quartz: 15000, tritium: 0 },
    plasma: { steel: 50000, quartz: 50000, tritium: 0 },
  };
}
export const baseDefenceCost: Record<number, Resources> = {
  6: { steel: 2000, quartz: 0, tritium: 0 },
  7: { steel: 6000, quartz: 2000, tritium: 0 },
  8: { steel: 20000, quartz: 15000, tritium: 0 },
  9: { steel: 50000, quartz: 50000, tritium: 0 },
};
