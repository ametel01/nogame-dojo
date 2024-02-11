import { overridableComponent } from "@dojoengine/recs";
import { ComponentDefinitions } from "./generated/contractComponents";

export type ClientComponents = ReturnType<typeof createClientComponents>;

export function createClientComponents({
    contractComponents,
}: {
    contractComponents: ComponentDefinitions;
}) {
    return {
        ...contractComponents,
        ColonyCompounds: overridableComponent(contractComponents.ColonyCompound),
        ColonyCount: overridableComponent(contractComponents.ColonyCount),
        ColonyDefence: overridableComponent(contractComponents.ColonyDefence),    
        ColonyOwner: overridableComponent(contractComponents.ColonyOwner),
        ColonyPosition: overridableComponent(contractComponents.ColonyPosition),
        ColonyResounce: overridableComponent(contractComponents.ColonyResource),
        ColonyResourceTimer: overridableComponent(contractComponents.ColonyResourceTimer),
        ColonyShip: overridableComponent(contractComponents.ColonyShip),
        PlanetColoniesCount: overridableComponent(contractComponents.PlanetColoniesCount),
        PlanetCompound: overridableComponent(contractComponents.PlanetCompound),
        PlanetDefence: overridableComponent(contractComponents.PlanetDefence),
        PlanetShip: overridableComponent(contractComponents.PlanetShip),
        ActiveMission: overridableComponent(contractComponents.ActiveMission),
        ActiveMissionLen: overridableComponent(contractComponents.ActiveMissionLen),
        IncomingMissionLen: overridableComponent(contractComponents.IncomingMissionLen),
        IncomingMissions: overridableComponent(contractComponents.IncomingMissions),
        GamePlanet: overridableComponent(contractComponents.GamePlanet),
        GamePlanetCount: overridableComponent(contractComponents.GamePlanetCount),
        GamePlanetOwner: overridableComponent(contractComponents.GamePlanetOwner),
        GameSetup: overridableComponent(contractComponents.GameSetup),
        LastActive: overridableComponent(contractComponents.LastActive),
        PlanetDebrisField: overridableComponent(contractComponents.PlanetDebrisField),
        PlanetPosition: overridableComponent(contractComponents.PlanetPosition),
        PlanetResource: overridableComponent(contractComponents.PlanetResource),
        PlanetResourceTimer: overridableComponent(contractComponents.PlanetResourceTimer),
        PlanetResourcesSpent: overridableComponent(contractComponents.PlanetResourcesSpent),
        PositionToPlanet: overridableComponent(contractComponents.PositionToPlanet),
        PlanetTech: overridableComponent(contractComponents.PlanetTech),
    };
}
