import { Account, BigNumberish } from 'starknet';
import { getEvents, setComponentsFromEvents } from '@dojoengine/utils';
import { ContractComponents } from './generated/contractComponents';
import type { IWorld } from './generated/generated';
import { DojoProvider } from '@dojoengine/core';
import { Fleet } from '../hooks/usePlanetShips';
import { Position } from '../hooks/usePlanetPosition';
import { Resources } from '../hooks/usePlanetResources';

export type SystemCalls = ReturnType<typeof createSystemCalls>;

export function createSystemCalls(
  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  { client }: { client: IWorld },
  contractComponents: ContractComponents,
  provider: DojoProvider
) {
  const generatePlanet = async (account: Account) => {
    try {
      const { transaction_hash } = await provider.execute(
        account,
        'planetactions',
        'generate_planet',
        []
      );

      setComponentsFromEvents(
        contractComponents,
        getEvents(
          await account.waitForTransaction(transaction_hash, {
            retryInterval: 100,
          })
        )
      );
    } catch (e) {
      console.log(e);
    }
  };

  const generateColony = async (account: Account) => {
    try {
      const { transaction_hash } = await provider.execute(
        account,
        'colonyactions',
        'generate_colony',
        []
      );

      setComponentsFromEvents(
        contractComponents,
        getEvents(
          await account.waitForTransaction(transaction_hash, {
            retryInterval: 100,
          })
        )
      );
    } catch (e) {
      console.log(e);
    }
  };

  const upgradeCompound = async (
    account: Account,
    component: BigNumberish,
    quantity: number
  ) => {
    try {
      const { transaction_hash } = await provider.execute(
        account,
        'compoundactions',
        'process_upgrade',
        [component, quantity]
      );

      setComponentsFromEvents(
        contractComponents,
        getEvents(
          await account.waitForTransaction(transaction_hash, {
            retryInterval: 100,
          })
        )
      );
    } catch (e) {
      console.log(e);
    }
  };

  const upgradeTech = async (
    account: Account,
    component: BigNumberish,
    quantity: number
  ) => {
    try {
      const { transaction_hash } = await provider.execute(
        account,
        'techactions',
        'process_upgrade',
        [component, quantity]
      );

      setComponentsFromEvents(
        contractComponents,
        getEvents(
          await account.waitForTransaction(transaction_hash, {
            retryInterval: 100,
          })
        )
      );
    } catch (e) {
      console.log(e);
    }
  };

  const buildShip = async (
    account: Account,
    component: BigNumberish,
    quantity: number
  ) => {
    try {
      const { transaction_hash } = await provider.execute(
        account,
        'dockyardactions',
        'process_ship_build',
        [component, quantity]
      );

      setComponentsFromEvents(
        contractComponents,
        getEvents(
          await account.waitForTransaction(transaction_hash, {
            retryInterval: 100,
          })
        )
      );
    } catch (e) {
      console.log(e);
    }
  };

  const buildDefence = async (
    account: Account,
    component: BigNumberish,
    quantity: number
  ) => {
    try {
      const { transaction_hash } = await provider.execute(
        account,
        'defenceactions',
        'process_defence_build',
        [component, quantity]
      );

      setComponentsFromEvents(
        contractComponents,
        getEvents(
          await account.waitForTransaction(transaction_hash, {
            retryInterval: 100,
          })
        )
      );
    } catch (e) {
      console.log(e);
    }
  };

  const sendFleet = async (
    account: Account,
    fleet: Fleet,
    destination: Position,
    cargo: Resources,
    missionType: number,
    speedModifier: number,
    colonyId: number
  ) => {
    try {
      const { transaction_hash } = await provider.execute(
        account,
        'fleetactions',
        'send_fleet',
        // eslint-disable-next-line @typescript-eslint/ban-ts-comment
        // @ts-expect-error
        [fleet, destination, cargo, missionType, speedModifier, colonyId]
      );

      setComponentsFromEvents(
        contractComponents,
        getEvents(
          await account.waitForTransaction(transaction_hash, {
            retryInterval: 100,
          })
        )
      );
    } catch (e) {
      console.log(e);
    }
  };

  const attackPlanet = async (account: Account, missionId: number) => {
    try {
      const { transaction_hash } = await provider.execute(
        account,
        'fleetactions',
        'attack_planet',
        [missionId]
      );

      setComponentsFromEvents(
        contractComponents,
        getEvents(
          await account.waitForTransaction(transaction_hash, {
            retryInterval: 100,
          })
        )
      );
    } catch (e) {
      console.log(e);
    }
  };

  const collectDebris = async (account: Account, missionId: number) => {
    try {
      const { transaction_hash } = await provider.execute(
        account,
        'fleetactions',
        'collect_debris',
        [missionId]
      );

      setComponentsFromEvents(
        contractComponents,
        getEvents(
          await account.waitForTransaction(transaction_hash, {
            retryInterval: 100,
          })
        )
      );
    } catch (e) {
      console.log(e);
    }
  };

  const recallFleet = async (account: Account, missionId: number) => {
    try {
      const { transaction_hash } = await provider.execute(
        account,
        'fleetactions',
        'recall_fleet',
        [missionId]
      );

      setComponentsFromEvents(
        contractComponents,
        getEvents(
          await account.waitForTransaction(transaction_hash, {
            retryInterval: 100,
          })
        )
      );
    } catch (e) {
      console.log(e);
    }
  };

  const dockFleet = async (account: Account, missionId: number) => {
    try {
      const { transaction_hash } = await provider.execute(
        account,
        'fleetactions',
        'dock_fleet',
        [missionId]
      );

      setComponentsFromEvents(
        contractComponents,
        getEvents(
          await account.waitForTransaction(transaction_hash, {
            retryInterval: 100,
          })
        )
      );
    } catch (e) {
      console.log(e);
    }
  };

  interface PlanetResourcesResponse {
    steel: bigint;
    quartz: bigint;
    tritium: bigint;
  }

  const getPlanetUncollectedResources = async (
    planetId: number
  ): Promise<Resources> => {
    try {
      const tx = (await provider.callContract(
        'planetactions',
        'get_uncollected_resources',
        [planetId.toString()]
      )) as PlanetResourcesResponse;

      return {
        steel: Number(tx.steel),
        quartz: Number(tx.quartz),
        tritium: Number(tx.tritium),
      };
    } catch (e) {
      console.log(e);
      throw e;
    }
  };

  const getColonyUncollectedResources = async (
    planetId: number,
    colonyId: number
  ): Promise<Resources> => {
    try {
      const tx = (await provider.callContract(
        'colonyactions',
        'get_uncollected_resources',
        [planetId, colonyId]
      )) as PlanetResourcesResponse;

      return {
        steel: Number(tx.steel),
        quartz: Number(tx.quartz),
        tritium: Number(tx.tritium),
      };
    } catch (e) {
      console.log(e);
      throw e;
    }
  };

  return {
    generatePlanet,
    generateColony,
    upgradeCompound,
    upgradeTech,
    buildShip,
    buildDefence,
    sendFleet,
    attackPlanet,
    collectDebris,
    recallFleet,
    dockFleet,
    getPlanetUncollectedResources,
    getColonyUncollectedResources,
  };
}
