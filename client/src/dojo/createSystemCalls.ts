import { Account, BigNumberish } from 'starknet';
// import { Entity, getComponentValue } from '@dojoengine/recs';
// import { ClientComponents } from './createClientComponents';
import {
  //   getEntityIdFromKeys,
  getEvents,
  setComponentsFromEvents,
} from '@dojoengine/utils';
import { ContractComponents } from './generated/contractComponents';
import type { IWorld } from './generated/generated';
import { DojoProvider } from '@dojoengine/core';
import { GenerateColony } from '../components/buttons/GenerateColony';
import { getBaseDefenceCost } from '../constants/costs';
import { CompoundsCostUpgrade } from '../shared/types';
import { Resources } from '../hooks/usePlanetResources';

export type SystemCalls = ReturnType<typeof createSystemCalls>;

export function createSystemCalls(
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

  const getPlanetResources = async (planetId: number) => {
    try {
      const tx = await provider.call(
        'planetactions',
        'get_resources_available',
        [planetId]
      );
      return tx.result[0];
    } catch (e) {
      console.log(e);
    }
  };

  const getColonyResources = async (planetId: number, colonyId: number) => {
    try {
      const tx = await provider.call(
        'colonyactions',
        'get_resources_available',
        [planetId, colonyId]
      );

      return {
        steel: parseInt(tx.result[0]),
        quartz: parseInt(tx.result[1]),
        tritium: parseInt(tx.result[2]),
      };
    } catch (e) {
      console.log(e);
    }
  };

  return {
    generatePlanet,
    generateColony,
    upgradeCompound,
    upgradeTech,
    buildShip,
    buildDefence,
    getPlanetResources,
    getColonyResources,
  };
}
