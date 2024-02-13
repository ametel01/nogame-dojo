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
import { getCompoundUpgradeType } from '../types';

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

  return {
    generatePlanet,
    generateColony,
    upgradeCompound,
  };
}
