import { Account } from 'starknet';
// import { Entity, getComponentValue } from '@dojoengine/recs';
// import { ClientComponents } from './createClientComponents';
import {
//   getEntityIdFromKeys,
  getEvents,
  setComponentsFromEvents,
} from '@dojoengine/utils';
import { ComponentDefinitions } from './generated/contractComponents';
import type { IWorld } from './generated/generated';

export type SystemCalls = ReturnType<typeof createSystemCalls>;

export function createSystemCalls(
  { client }: { client: IWorld },
  contractComponents: ComponentDefinitions,
//   {
    // ColonyCompound,
    // ColonyCount,
    // ColonyDefence,
    // ColonyOwner,
    // ColonyPosition,
    // ColonyResource,
    // ColonyResourceTimer,
    // ColonyShip,
    // PlanetColoniesCount,
    // PlanetCompound,
    // PlanetDefence,
    // PlanetShip,
    // ActiveMission,
    // ActiveMissionLen,
    // IncomingMissionLen,
    // IncomingMissions,
    // GamePlanet,
    // GamePlanetCount,
    // GamePlanetOwner,
    // GameSetup,
    // LastActive,
    // PlanetDebrisField,
    // PlanetPosition,
    // PlanetResource,
    // PlanetResourceTimer,
    // PlanetResourcesSpent,
    // PositionToPlanet,
    // PlanetTech,
//   }: ClientComponents
) {
  const generatePlanet = async (account: Account) => {

    try {
      const { transaction_hash } = await client.actions.generatePlanet({
        account
      });

      setComponentsFromEvents(
        contractComponents,
        getEvents(
          await account.waitForTransaction(transaction_hash, {
            retryInterval: 100,
          })
        )
      );
    } catch (e) {
      console.log(e);}
  };

//   const move = async (account: Account, direction: Direction) => {
//     const entityId = getEntityIdFromKeys([BigInt(account.address)]) as Entity;

//     const positionId = uuid();
//     Position.addOverride(positionId, {
//       entity: entityId,
//       value: {
//         player: BigInt(entityId),
//         vec: updatePositionWithDirection(
//           direction,
//           getComponentValue(Position, entityId) as any
//         ).vec,
//       },
//     });

//     const movesId = uuid();
//     Moves.addOverride(movesId, {
//       entity: entityId,
//       value: {
//         player: BigInt(entityId),
//         remaining: (getComponentValue(Moves, entityId)?.remaining || 0) - 1,
//       },
//     });

//     try {
//       const { transaction_hash } = await client.actions.move({
//         account,
//         direction,
//       });

//       setComponentsFromEvents(
//         contractComponents,
//         getEvents(
//           await account.waitForTransaction(transaction_hash, {
//             retryInterval: 100,
//           })
//         )
//       );
//     } catch (e) {
//       console.log(e);
//       Position.removeOverride(positionId);
//       Moves.removeOverride(movesId);
//     } finally {
//       Position.removeOverride(positionId);
//       Moves.removeOverride(movesId);
//     }
//   };

  return {
    generatePlanet,
  };
}
