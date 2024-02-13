import { BigNumberish, CairoCustomEnum } from 'starknet';
import { astralRequirements } from '../shared/utils/index';

export const CompoundUpgradeType = {
  SteelMine: 0 as BigNumberish,
  QuartzMine: 1 as BigNumberish,
  TritiumMine: 2 as BigNumberish,
  EnergyPlant: 3 as BigNumberish,
  Lab: 4 as BigNumberish,
};

export const DefenceBuildType = {
  celestia: 0 as BigNumberish,
  blaster: 1 as BigNumberish,
  beam: 2 as BigNumberish,
  astral: 3 as BigNumberish,
  plasma: 4 as BigNumberish,
};
