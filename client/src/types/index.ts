import { BigNumberish, CairoCustomEnum } from 'starknet';
import { astralRequirements, frigateRequirements } from '../shared/utils/index';

export const CompoundUpgradeType = {
  SteelMine: 0 as BigNumberish,
  QuartzMine: 1 as BigNumberish,
  TritiumMine: 2 as BigNumberish,
  EnergyPlant: 3 as BigNumberish,
  Lab: 4 as BigNumberish,
};

export const TechUpgradeType = {
  energy: 0 as BigNumberish,
  digital: 1 as BigNumberish,
  beam: 2 as BigNumberish,
  armour: 3 as BigNumberish,
  ion: 4 as BigNumberish,
  plasma: 5 as BigNumberish,
  weapons: 6 as BigNumberish,
  shield: 7 as BigNumberish,
  spacetime: 8 as BigNumberish,
  combustion: 9 as BigNumberish,
  thrust: 10 as BigNumberish,
  warp: 11 as BigNumberish,
  exocraft: 12 as BigNumberish,
};

export const ShipBuildType = {
  carrier: 0 as BigNumberish,
  scraper: 1 as BigNumberish,
  sparrow: 2 as BigNumberish,
  frigate: 3 as BigNumberish,
  armade: 4 as BigNumberish,
};

export const DefenceBuildType = {
  celestia: 0 as BigNumberish,
  blaster: 1 as BigNumberish,
  beam: 2 as BigNumberish,
  astral: 3 as BigNumberish,
  plasma: 4 as BigNumberish,
};
