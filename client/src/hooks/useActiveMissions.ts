/* eslint-disable @typescript-eslint/no-explicit-any */
import { useState, useEffect } from 'react';
import { useDojo } from '../dojo/useDojo';
import { GetActiveMissionsCountQuery } from '../generated/graphql';
import { Fleet } from './usePlanetShips';
import { Resources } from './usePlanetResources';

export type Mission = {
  id: number;
  time_start: number;
  origin: number;
  destination: number;
  cargo: Resources;
  time_arrival: number;
  fleet: Fleet;
  category: number;
};

type ActiveMissionModel = {
  __typename: 'ActiveMission';
  planet_id: number;
  mission_id: number;
};

type EdgeType = {
  node: {
    entity: {
      models: ActiveMissionModel[];
    };
  };
};

export function useActiveMissions(planetId: number): Array<Mission> {
  const [missions, setMissions] = useState<Array<Mission>>([]);

  const {
    setup: { graphSdk },
  } = useDojo();

  useEffect(() => {
    async function fetchActiveMissions(planetId: number) {
      const countResponse = (await graphSdk.getActiveMissionsCount({
        planet_id: planetId,
      })) as GetActiveMissionsCountQuery;

      // Accessing the count using the generated type
      const edges = countResponse.data.activeMissionLenModels.edges;
      if (edges && edges.length > 0) {
        const count = edges[0].node.entity.models[0].lenght;
        const activeMissions: Array<Mission> = [];

        for (let i = 0; i < count; i++) {
          const missionId = i + 1; // Adjust based on how colony IDs are determined
          const missionResponse = await graphSdk.getActiveMission({
            planet_id: planetId,
            mission_id: missionId,
          });
          const mission = extractMission(missionResponse);

          if (mission) {
            if (mission.origin !== 0) {
              activeMissions.push(mission);
            }
          }
        }

        setMissions(activeMissions);
      }
    }

    fetchActiveMissions(planetId);
  }, [graphSdk, planetId]);

  return missions;
}

function extractMission(response: any): Mission | undefined {
  const missionModel = response.data.activeMissionModels?.edges?.find(
    (edge: EdgeType) => isActiveMissionModel(edge.node.entity.models)
  )?.node.entity.models[0];

  if (missionModel) {
    return {
      id: missionModel.mission.id,
      time_start: missionModel.mission.time_start,
      origin: missionModel.mission.origin,
      destination: missionModel.mission.destination,
      cargo: missionModel.mission.cargo,
      time_arrival: missionModel.mission.time_arrival,
      fleet: missionModel.mission.fleet,
      category: missionModel.mission.category,
    };
  }

  return undefined;
}

function isActiveMissionModel(models: any[]): models is ActiveMissionModel[] {
  return models.length > 0 && models[0].__typename === 'ActiveMission';
}
