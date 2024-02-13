import { BigNumberish, CairoCustomEnum } from 'starknet';

export const CompoundUpgradeType = {
  SteelMine: 0 as BigNumberish,
  QuartzMine: 1 as BigNumberish,
  TritiumMine: 2 as BigNumberish,
  EnergyPlant: 3 as BigNumberish,
  Lab: 4 as BigNumberish,
};

export function getCompoundUpgradeType(
  name: number
): CairoCustomEnum | undefined {
  switch (name) {
    case 0:
      return new CairoCustomEnum({ SteelMine: {} });
    case 1:
      return new CairoCustomEnum({ QuartzMine: {} });
    case 2:
      return new CairoCustomEnum({ TritiumMine: {} });
    case 3:
      return new CairoCustomEnum({ EnergyPlant: {} });
    case 4:
      return new CairoCustomEnum({ Lab: {} });
    case 5:
      return new CairoCustomEnum({ Dockyard: {} });
  }
}
