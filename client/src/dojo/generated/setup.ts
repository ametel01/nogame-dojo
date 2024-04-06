import { getSyncEntities } from '@dojoengine/state';
import { DojoConfig, DojoProvider } from '@dojoengine/core';
import * as torii from '@dojoengine/torii-client';
import { createClientComponents } from '../createClientComponents';
import { createSystemCalls } from '../createSystemCalls';
import { defineContractComponents } from './typescript/models.gen';
import { world } from './world';
import { setupWorld } from './typescript/contracts.gen';
import { Account } from 'starknet';
import { BurnerManager } from '@dojoengine/create-burner';
import { getSdk } from '../../generated/graphql';
import { GraphQLClient } from 'graphql-request';

export type SetupResult = Awaited<ReturnType<typeof setup>>;

export async function setup({ ...config }: DojoConfig) {
  // torii client
  const toriiClient = await torii.createClient([], {
    rpcUrl: config.rpcUrl,
    toriiUrl: config.toriiUrl,
    worldAddress: config.manifest.world.address || '',
  });
  const createGraphSdk = () =>
    getSdk(new GraphQLClient(config.toriiUrl + '/graphql'));

  // create contract components
  const contractComponents = defineContractComponents(world);

  // create client components
  const clientComponents = createClientComponents({ contractComponents });

  // fetch all existing entities from torii
  await getSyncEntities(toriiClient, contractComponents as never);

  // create dojo provider
  const dojoProvider = new DojoProvider(config.manifest, config.rpcUrl);

  // setup world
  const client = await setupWorld(dojoProvider);

  // create burner manager
  const burnerManager = new BurnerManager({
    masterAccount: new Account(
      dojoProvider.provider,
      config.masterAddress,
      config.masterPrivateKey
    ),
    accountClassHash: config.accountClassHash,
    rpcProvider: dojoProvider.provider,
  });

  burnerManager.init();

  return {
    client,
    clientComponents,
    contractComponents,
    systemCalls: createSystemCalls({ client }, contractComponents),
    config,
    dojoProvider,
    burnerManager,
    graphSdk: createGraphSdk(),
  };
}
