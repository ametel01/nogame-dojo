import { overridableComponent } from '@dojoengine/recs';
import { ContractComponents } from './generated/typescript/models.gen';

export type ClientComponents = ReturnType<typeof createClientComponents>;

export function createClientComponents({
  contractComponents,
}: {
  contractComponents: ContractComponents;
}) {
  return {
    ...contractComponents,
    ColonyCompounds: overridableComponent(contractComponents.ColonyCompounds),
    ColonyCompoundTimer: overridableComponent(
      contractComponents.ColonyCompoundTimer
    ),
    ColonyCount: overridableComponent(contractComponents.ColonyCount),
    ColonyDefence: overridableComponent(contractComponents.ColonyDefences),
    ColonyDefenceTimer: overridableComponent(
      contractComponents.ColonyDefenceTimer
    ),
    ColonyOwner: overridableComponent(contractComponents.ColonyOwner),
    ColonyPosition: overridableComponent(contractComponents.ColonyPosition),
    ColonyResounce: overridableComponent(contractComponents.ColonyResource),
    ColonyResourceTimer: overridableComponent(
      contractComponents.ColonyResourceTimer
    ),
    ColonyShip: overridableComponent(contractComponents.ColonyShips),
    ColonyDockyardTimer: overridableComponent(
      contractComponents.ColonyDockyardTimer
    ),
    PlanetColoniesCount: overridableComponent(
      contractComponents.PlanetColoniesCount
    ),
    PlanetCompound: overridableComponent(contractComponents.PlanetCompounds),
    PlanetCompoundTimer: overridableComponent(
      contractComponents.PlanetCompoundTimer
    ),
    PlanetDefence: overridableComponent(contractComponents.PlanetDefences),
    PlanetDefenceTimer: overridableComponent(
      contractComponents.PlanetDefenceTimer
    ),
    PlanetShip: overridableComponent(contractComponents.PlanetShips),
    PlanetShipTimer: overridableComponent(
      contractComponents.PlanetDockyardTimer
    ),
    ActiveMission: overridableComponent(contractComponents.ActiveMission),
    ActiveMissionLen: overridableComponent(contractComponents.ActiveMissionLen),
    IncomingMissionLen: overridableComponent(
      contractComponents.IncomingMissionLen
    ),
    IncomingMissions: overridableComponent(contractComponents.IncomingMissions),
    GamePlanet: overridableComponent(contractComponents.GamePlanet),
    GamePlanetCount: overridableComponent(contractComponents.GamePlanetCount),
    GamePlanetOwner: overridableComponent(contractComponents.GamePlanetOwner),
    GameSetup: overridableComponent(contractComponents.GameSetup),
    LastActive: overridableComponent(contractComponents.LastActive),
    PlanetDebrisField: overridableComponent(
      contractComponents.PlanetDebrisField
    ),
    PlanetPosition: overridableComponent(contractComponents.PlanetPosition),
    PlanetResource: overridableComponent(contractComponents.PlanetResource),
    PlanetResourceTimer: overridableComponent(
      contractComponents.PlanetResourceTimer
    ),
    PlanetResourcesSpent: overridableComponent(
      contractComponents.PlanetResourcesSpent
    ),
    PositionToPlanet: overridableComponent(contractComponents.PositionToPlanet),
    PlanetTech: overridableComponent(contractComponents.PlanetTechs),
    PlanetTechTimer: overridableComponent(contractComponents.PlanetTechTimer),
  };
}
