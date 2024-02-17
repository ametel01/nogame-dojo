/* eslint-disable @typescript-eslint/no-explicit-any */
import { useState, useEffect } from 'react';
import { useDojo } from '../dojo/useDojo';
import { GetIncomingMissionQuery } from '../generated/graphql';

export interface IncomingMission {
  origin: number;
  id_at_origin: number;
  time_arrival: number;
  number_of_ships: number;
  destination: number;
}

type IncomingMissionModel = {
  __typename: 'ActiveMission';
  planet_id: number;
  mission_id: number;
};

type EdgeType = {
  node: {
    entity: {
      models: IncomingMissionModel[];
    };
  };
};

export function useIncomingMissions(planetId: number): Array<IncomingMission> {
  const [missions, setMissions] = useState<Array<IncomingMission>>([]);
  console.log('planetId', planetId);
  const {
    setup: { graphSdk },
  } = useDojo();

  useEffect(() => {
    async function fetchIncomingMissions(planetId: number) {
      const countResponse = (await graphSdk.getIncomingMissionsCount({
        planet_id: planetId,
      })) as GetIncomingMissionQuery;

      // Accessing the count using the generated type
      const edges = countResponse.data.incomingMissionLenModels.edges;
      console.log('edges', edges);
      if (edges && edges.length > 0) {
        const count = edges[0].node.entity.keys.length;
        console.log('count', count);
        const activeMissions: Array<IncomingMission> = [];

        for (let i = 0; i < count; i++) {
          const missionId = i + 1; // Adjust based on how colony IDs are determined
          const missionResponse = await graphSdk.getIncomingMission({
            planet_id: planetId,
            mission_id: missionId,
          });
          const mission = extractMission(missionResponse);
          console.log('missionResponse', missionResponse);

          if (mission) {
            if (mission.origin !== 0) {
              activeMissions.push(mission);
            }
          }
        }

        setMissions(activeMissions);
      }
    }

    fetchIncomingMissions(planetId);
  }, [graphSdk, planetId]);

  return missions;
}

function extractMission(response: any): IncomingMission | undefined {
  const missionModel = response.data.incomingMissionsModels?.edges?.find(
    (edge: EdgeType) => isIncomingMissionModel(edge.node.entity.models)
  )?.node.entity.models[0];
  console.log('missionModel', missionModel);

  if (missionModel) {
    return {
      origin: missionModel.mission.origin,
      id_at_origin: missionModel.mission.id_at_origin,
      time_arrival: missionModel.mission.time_arrival,
      number_of_ships: missionModel.mission.number_of_ships,
      destination: missionModel.mission.destination,
    };
  }

  return undefined;
}

function isIncomingMissionModel(
  models: any[]
): models is IncomingMissionModel[] {
  return models.length > 0 && models[0].__typename === 'IncomingMissions';
}
