/* Autogenerated file. Do not edit manually. */

import { defineComponent, Type as RecsType, World } from "@dojoengine/recs";

export type ContractComponents = Awaited<ReturnType<typeof defineContractComponents>>;

export function defineContractComponents(world: World) {
  return {
    ColonyCompounds: (() => {
      return defineComponent(
        world,
        { planet_id: RecsType.Number, colony_id: RecsType.Number, name: RecsType.Number, level: RecsType.Number },
        {
          metadata: {
            name: "ColonyCompounds",
            types: ["u32","u8","u8","u8"],
            customTypes: [],
          },
        }
      );
    })(),
    ColonyCount: (() => {
      return defineComponent(
        world,
        { game_id: RecsType.Number, count: RecsType.Number },
        {
          metadata: {
            name: "ColonyCount",
            types: ["u8","u8"],
            customTypes: [],
          },
        }
      );
    })(),
    ColonyDefences: (() => {
      return defineComponent(
        world,
        { planet_id: RecsType.Number, colony_id: RecsType.Number, name: RecsType.Number, count: RecsType.Number },
        {
          metadata: {
            name: "ColonyDefences",
            types: ["u32","u8","u8","u32"],
            customTypes: [],
          },
        }
      );
    })(),
    ColonyOwner: (() => {
      return defineComponent(
        world,
        { colony_planet_id: RecsType.Number, planet_id: RecsType.Number },
        {
          metadata: {
            name: "ColonyOwner",
            types: ["u32","u32"],
            customTypes: [],
          },
        }
      );
    })(),
    ColonyPosition: (() => {
      return defineComponent(
        world,
        { planet_id: RecsType.Number, colony_id: RecsType.Number, position: { system: RecsType.Number, orbit: RecsType.Number } },
        {
          metadata: {
            name: "ColonyPosition",
            types: ["u32","u8","u16","u8"],
            customTypes: ["Position"],
          },
        }
      );
    })(),
    ColonyResource: (() => {
      return defineComponent(
        world,
        { planet_id: RecsType.Number, colony_id: RecsType.Number, name: RecsType.Number, amount: RecsType.BigInt },
        {
          metadata: {
            name: "ColonyResource",
            types: ["u32","u8","u8","u128"],
            customTypes: [],
          },
        }
      );
    })(),
    ColonyResourceTimer: (() => {
      return defineComponent(
        world,
        { planet_id: RecsType.Number, colony_id: RecsType.Number, last_collection: RecsType.Number },
        {
          metadata: {
            name: "ColonyResourceTimer",
            types: ["u32","u8","u64"],
            customTypes: [],
          },
        }
      );
    })(),
    ColonyShips: (() => {
      return defineComponent(
        world,
        { planet_id: RecsType.Number, colony_id: RecsType.Number, name: RecsType.Number, count: RecsType.Number },
        {
          metadata: {
            name: "ColonyShips",
            types: ["u32","u8","u8","u32"],
            customTypes: [],
          },
        }
      );
    })(),
    PlanetColoniesCount: (() => {
      return defineComponent(
        world,
        { planet_id: RecsType.Number, count: RecsType.Number },
        {
          metadata: {
            name: "PlanetColoniesCount",
            types: ["u32","u8"],
            customTypes: [],
          },
        }
      );
    })(),
    PlanetCompounds: (() => {
      return defineComponent(
        world,
        { planet_id: RecsType.Number, name: RecsType.Number, level: RecsType.Number },
        {
          metadata: {
            name: "PlanetCompounds",
            types: ["u32","u8","u8"],
            customTypes: [],
          },
        }
      );
    })(),
    PlanetDefences: (() => {
      return defineComponent(
        world,
        { planet_id: RecsType.Number, name: RecsType.Number, count: RecsType.Number },
        {
          metadata: {
            name: "PlanetDefences",
            types: ["u32","u8","u32"],
            customTypes: [],
          },
        }
      );
    })(),
    PlanetShips: (() => {
      return defineComponent(
        world,
        { planet_id: RecsType.Number, name: RecsType.Number, count: RecsType.Number },
        {
          metadata: {
            name: "PlanetShips",
            types: ["u32","u8","u32"],
            customTypes: [],
          },
        }
      );
    })(),
    ActiveMission: (() => {
      return defineComponent(
        world,
        { planet_id: RecsType.Number, mission_id: RecsType.Number, mission: { id: RecsType.Number, time_start: RecsType.Number, origin: RecsType.Number, destination: RecsType.Number, cargo: { steel: RecsType.BigInt, quartz: RecsType.BigInt, tritium: RecsType.BigInt }, time_arrival: RecsType.Number, fleet: { carrier: RecsType.Number, scraper: RecsType.Number, sparrow: RecsType.Number, frigate: RecsType.Number, armade: RecsType.Number }, category: RecsType.Number, is_return: RecsType.Boolean } },
        {
          metadata: {
            name: "ActiveMission",
            types: ["u32","usize","u32","u64","u32","u32","u128","u128","u128","u64","u32","u32","u32","u32","u32","u8","bool"],
            customTypes: ["Mission","Resources","Fleet"],
          },
        }
      );
    })(),
    ActiveMissionLen: (() => {
      return defineComponent(
        world,
        { planet_id: RecsType.Number, lenght: RecsType.Number },
        {
          metadata: {
            name: "ActiveMissionLen",
            types: ["u32","usize"],
            customTypes: [],
          },
        }
      );
    })(),
    IncomingMissionLen: (() => {
      return defineComponent(
        world,
        { planet_id: RecsType.Number, lenght: RecsType.Number },
        {
          metadata: {
            name: "IncomingMissionLen",
            types: ["u32","usize"],
            customTypes: [],
          },
        }
      );
    })(),
    IncomingMissions: (() => {
      return defineComponent(
        world,
        { planet_id: RecsType.Number, mission_id: RecsType.Number, mission: { origin: RecsType.Number, id_at_origin: RecsType.Number, time_arrival: RecsType.Number, number_of_ships: RecsType.Number, destination: RecsType.Number } },
        {
          metadata: {
            name: "IncomingMissions",
            types: ["u32","usize","u32","usize","u64","u32","u32"],
            customTypes: ["IncomingMission"],
          },
        }
      );
    })(),
    GameOwnerPlanet: (() => {
      return defineComponent(
        world,
        { owner: RecsType.BigInt, planet_id: RecsType.Number },
        {
          metadata: {
            name: "GameOwnerPlanet",
            types: ["contractaddress","u32"],
            customTypes: [],
          },
        }
      );
    })(),
    GamePlanet: (() => {
      return defineComponent(
        world,
        { owner: RecsType.BigInt, planet_id: RecsType.Number },
        {
          metadata: {
            name: "GamePlanet",
            types: ["contractaddress","u32"],
            customTypes: [],
          },
        }
      );
    })(),
    GamePlanetCount: (() => {
      return defineComponent(
        world,
        { game_id: RecsType.Number, count: RecsType.Number },
        {
          metadata: {
            name: "GamePlanetCount",
            types: ["u8","u32"],
            customTypes: [],
          },
        }
      );
    })(),
    GamePlanetOwner: (() => {
      return defineComponent(
        world,
        { planet_id: RecsType.Number, owner: RecsType.BigInt },
        {
          metadata: {
            name: "GamePlanetOwner",
            types: ["u32","contractaddress"],
            customTypes: [],
          },
        }
      );
    })(),
    GameSetup: (() => {
      return defineComponent(
        world,
        { game_id: RecsType.Number, speed: RecsType.Number, start_time: RecsType.Number },
        {
          metadata: {
            name: "GameSetup",
            types: ["u8","usize","u64"],
            customTypes: [],
          },
        }
      );
    })(),
    LastActive: (() => {
      return defineComponent(
        world,
        { planet_id: RecsType.Number, time: RecsType.Number },
        {
          metadata: {
            name: "LastActive",
            types: ["u32","u64"],
            customTypes: [],
          },
        }
      );
    })(),
    PlanetDebrisField: (() => {
      return defineComponent(
        world,
        { planet_id: RecsType.Number, debris: { steel: RecsType.BigInt, quartz: RecsType.BigInt } },
        {
          metadata: {
            name: "PlanetDebrisField",
            types: ["u32","u128","u128"],
            customTypes: ["Debris"],
          },
        }
      );
    })(),
    PlanetPosition: (() => {
      return defineComponent(
        world,
        { planet_id: RecsType.Number, position: { system: RecsType.Number, orbit: RecsType.Number } },
        {
          metadata: {
            name: "PlanetPosition",
            types: ["u32","u16","u8"],
            customTypes: ["Position"],
          },
        }
      );
    })(),
    PlanetResource: (() => {
      return defineComponent(
        world,
        { planet_id: RecsType.Number, name: RecsType.Number, amount: RecsType.BigInt },
        {
          metadata: {
            name: "PlanetResource",
            types: ["u32","u8","u128"],
            customTypes: [],
          },
        }
      );
    })(),
    PlanetResourceTimer: (() => {
      return defineComponent(
        world,
        { planet_id: RecsType.Number, last_collection: RecsType.Number },
        {
          metadata: {
            name: "PlanetResourceTimer",
            types: ["u32","u64"],
            customTypes: [],
          },
        }
      );
    })(),
    PlanetResourcesSpent: (() => {
      return defineComponent(
        world,
        { planet_id: RecsType.Number, spent: RecsType.BigInt },
        {
          metadata: {
            name: "PlanetResourcesSpent",
            types: ["u32","u128"],
            customTypes: [],
          },
        }
      );
    })(),
    PositionToPlanet: (() => {
      return defineComponent(
        world,
        { position: { system: RecsType.Number, orbit: RecsType.Number }, planet_id: RecsType.Number },
        {
          metadata: {
            name: "PositionToPlanet",
            types: ["u16","u8","u32"],
            customTypes: ["Position"],
          },
        }
      );
    })(),
    PlanetTechs: (() => {
      return defineComponent(
        world,
        { planet_id: RecsType.Number, name: RecsType.Number, level: RecsType.Number },
        {
          metadata: {
            name: "PlanetTechs",
            types: ["u32","u8","u8"],
            customTypes: [],
          },
        }
      );
    })(),
  };
}
