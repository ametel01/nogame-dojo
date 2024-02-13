import { Account } from 'starknet';
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

  // const getColoniesForPlanet = async (account: Account, planetId: number) => {
  //   try {
  //     const { transaction_hash } = await provider.call({
  //       account,
  //       planetId,
  //     });

  //     setComponentsFromEvents(
  //       contractComponents,
  //       getEvents(
  //         await account.waitForTransaction(transaction_hash, {
  //           retryInterval: 100,
  //         })
  //       )
  //     );
  //   } catch (e) {
  //     console.log(e);
  //   }
  // };

  return {
    generatePlanet,
    // getColoniesForPlanet,
  };
}
