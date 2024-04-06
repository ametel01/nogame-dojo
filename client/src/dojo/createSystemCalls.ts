import { Account } from 'starknet';
import { getEvents, setComponentsFromEvents } from '@dojoengine/utils';
import {
  CompoundUpgradeType,
  ContractComponents,
  DefenceBuildType,
  ShipBuildType,
  TechUpgradeType,
  Resources,
  Position,
  Fleet,
} from './generated/typescript/models.gen';
import type { IWorld } from './generated/typescript/contracts.gen';

export type SystemCalls = ReturnType<typeof createSystemCalls>;

export function createSystemCalls(
  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  { client }: { client: IWorld },
  contractComponents: ContractComponents
  // { PlanetCompound }: ClientComponents
) {
  const generatePlanet = async (account: Account) => {
    try {
      const { transaction_hash } = await client.planetactions.generatePlanet({
        account,
      });

      console.log(
        await account.waitForTransaction(transaction_hash, {
          retryInterval: 100,
        })
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
      const { transaction_hash } = await client.colonyactions.generateColony({
        account,
      });

      console.log(
        await account.waitForTransaction(transaction_hash, {
          retryInterval: 100,
        })
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

  const startCompoundUpgrade = async (
    account: Account,
    component: CompoundUpgradeType,
    quantity: number
  ) => {
    try {
      const { transaction_hash } = await client.compoundactions.startUpgrade({
        account,
        component,
        quantity,
      });

      console.log(
        await account.waitForTransaction(transaction_hash, {
          retryInterval: 100,
        })
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

  const completeCompoundUpgrade = async (account: Account) => {
    try {
      const { transaction_hash } = await client.compoundactions.completeUpgrade(
        {
          account,
        }
      );

      console.log(
        await account.waitForTransaction(transaction_hash, {
          retryInterval: 100,
        })
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

  const startColonyCompoundUpgrade = async (
    account: Account,
    colonyId: number,
    component: CompoundUpgradeType,
    quantity: number
  ) => {
    try {
      const { transaction_hash } =
        await client.colonyactions.startCompoundUpgrade({
          account,
          colony_id: colonyId,
          name: component,
          quantity,
        });

      console.log(
        await account.waitForTransaction(transaction_hash, {
          retryInterval: 100,
        })
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

  const completColonyCompoundUpgrade = async (
    account: Account,
    colonyId: number
  ) => {
    try {
      const { transaction_hash } =
        await client.colonyactions.completeCompoundUpgrade({
          account,
          colony_id: colonyId,
        });

      console.log(
        await account.waitForTransaction(transaction_hash, {
          retryInterval: 100,
        })
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

  const startTechUpgrade = async (
    account: Account,
    component: TechUpgradeType,
    quantity: number
  ) => {
    try {
      const { transaction_hash } = await client.techactions.startUpgrade({
        account,
        component,
        quantity,
      });

      console.log(
        await account.waitForTransaction(transaction_hash, {
          retryInterval: 100,
        })
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

  const completeTechUpgrade = async (account: Account) => {
    try {
      const { transaction_hash } = await client.techactions.completeUpgrade({
        account,
      });

      console.log(
        await account.waitForTransaction(transaction_hash, {
          retryInterval: 100,
        })
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

  const startShipBuild = async (
    account: Account,
    component: ShipBuildType,
    quantity: number
  ) => {
    try {
      const { transaction_hash } = await client.dockyardactions.startBuild({
        account,
        component,
        quantity,
      });

      console.log(
        await account.waitForTransaction(transaction_hash, {
          retryInterval: 100,
        })
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

  const completeShipBuild = async (account: Account) => {
    try {
      const { transaction_hash } = await client.dockyardactions.completeBuild({
        account,
      });

      console.log(
        await account.waitForTransaction(transaction_hash, {
          retryInterval: 100,
        })
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

  const startColonyShipBuild = async (
    account: Account,
    colonyId: number,
    component: ShipBuildType,
    quantity: number
  ) => {
    try {
      const { transaction_hash } = await client.colonyactions.startShipBuild({
        account,
        colony_id: colonyId,
        name: component,
        quantity,
      });

      console.log(
        await account.waitForTransaction(transaction_hash, {
          retryInterval: 100,
        })
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

  const completeColonyShipBuild = async (
    account: Account,
    colonyId: number
  ) => {
    try {
      const { transaction_hash } = await client.colonyactions.completeShipBuild(
        {
          account,
          colony_id: colonyId,
        }
      );

      console.log(
        await account.waitForTransaction(transaction_hash, {
          retryInterval: 100,
        })
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

  const startDefenceBuild = async (
    account: Account,
    component: DefenceBuildType,
    quantity: number
  ) => {
    try {
      const { transaction_hash } = await client.defenceactions.startBuild({
        account,
        component,
        quantity,
      });

      console.log(
        await account.waitForTransaction(transaction_hash, {
          retryInterval: 100,
        })
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

  const completeDefenceBuild = async (account: Account) => {
    try {
      const { transaction_hash } = await client.defenceactions.completeBuild({
        account,
      });

      console.log(
        await account.waitForTransaction(transaction_hash, {
          retryInterval: 100,
        })
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

  const startColonyDefenceBuild = async (
    account: Account,
    colonyId: number,
    component: DefenceBuildType,
    quantity: number
  ) => {
    try {
      const { transaction_hash } = await client.colonyactions.startDefenceBuild(
        { account, colony_id: colonyId, name: component, quantity }
      );

      console.log(
        await account.waitForTransaction(transaction_hash, {
          retryInterval: 100,
        })
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

  const completColonyDefenceBuild = async (
    account: Account,
    colonyId: number
  ) => {
    try {
      const { transaction_hash } =
        await client.colonyactions.completeDefenceBuild({
          account,
          colony_id: colonyId,
        });

      console.log(
        await account.waitForTransaction(transaction_hash, {
          retryInterval: 100,
        })
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
      const { transaction_hash } = await client.fleetactions.sendFleet({
        account,
        fleet,
        destination,
        cargo,
        mission_type: missionType,
        speed_modifier: speedModifier,
        colony_id: colonyId,
      });

      console.log(
        await account.waitForTransaction(transaction_hash, {
          retryInterval: 100,
        })
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
      const { transaction_hash } = await client.fleetactions.attackPlanet({
        account,
        mission_id: missionId,
      });

      console.log(
        await account.waitForTransaction(transaction_hash, {
          retryInterval: 100,
        })
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
      const { transaction_hash } = await client.fleetactions.collectDebris({
        account,
        mission_id: missionId,
      });

      console.log(
        await account.waitForTransaction(transaction_hash, {
          retryInterval: 100,
        })
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
      const { transaction_hash } = await client.fleetactions.recallFleet({
        account,
        mission_id: missionId,
      });

      console.log(
        await account.waitForTransaction(transaction_hash, {
          retryInterval: 100,
        })
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
      const { transaction_hash } = await client.fleetactions.dockFleet({
        account,
        mission_id: missionId,
      });

      console.log(
        await account.waitForTransaction(transaction_hash, {
          retryInterval: 100,
        })
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

  const getPlanetUncollectedResources = async (planetId: number) => {
    try {
      const response: Resources =
        await client.planetactions.getUncollectedResources({
          planet_id: planetId,
        });

      return response;
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
      const response: Resources =
        await client.colonyactions.getUncollectedResources({
          planet_id: planetId,
          colony_id: colonyId,
        });

      return response;
    } catch (e) {
      console.log(e);
      throw e;
    }
  };

  return {
    generatePlanet,
    generateColony,
    startCompoundUpgrade,
    completeCompoundUpgrade,
    startColonyCompoundUpgrade,
    completColonyCompoundUpgrade,
    startTechUpgrade,
    completeTechUpgrade,
    startShipBuild,
    completeShipBuild,
    startColonyShipBuild,
    completeColonyShipBuild,
    startDefenceBuild,
    completeDefenceBuild,
    startColonyDefenceBuild,
    completColonyDefenceBuild,
    sendFleet,
    attackPlanet,
    collectDebris,
    recallFleet,
    dockFleet,
    getPlanetUncollectedResources,
    getColonyUncollectedResources,
  };
}
