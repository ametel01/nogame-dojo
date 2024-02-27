/* eslint-disable @typescript-eslint/no-explicit-any */
import { useState, useEffect } from 'react';
import { useDojo } from '../dojo/useDojo';
import { GetPlanetColoniesCountQuery } from '../generated/graphql';
import { Position } from './usePlanetPosition';

// type ColonyPositionModel = {
//   __typename: 'ColonyPosition';
//   colony_id: number;
//   position: Position;
// };

// type EdgeType = {
//   node: {
//     entity: {
//       models: ColonyPositionModel[];
//     };
//   };
// };

export function usePlanetColonies(planetId: number): Array<[number, Position]> {
  const [colonies, setColonies] = useState<Array<[number, Position]>>([]);

  const {
    setup: { graphSdk },
  } = useDojo();

  useEffect(() => {
    async function fetchColonyPositions(planetId: number) {
      const countResponse = (await graphSdk.getPlanetColoniesCount({
        planet_id: planetId,
      })) as GetPlanetColoniesCountQuery;

      // Accessing the count using the generated type
      const edges = countResponse.data.planetColoniesCountModels.edges;

      if (edges.length > 0) {
        const count =
          edges[0].node.entity.models.find(
            (model: { __typename: string }) =>
              model.__typename === 'PlanetColoniesCount'
          )?.count ?? 0;

        const colonyPositions: Array<[number, Position]> = [];

        for (let i = 0; i < count; i++) {
          const colonyId = i + 1; // Adjust based on how colony IDs are determined
          const positionResponse = await graphSdk.getColonyPosition({
            planet_id: planetId,
            colony_id: colonyId,
          });
          const colonyPosition = extractColonyPosition(positionResponse);

          if (colonyPosition) {
            colonyPositions.push([colonyId, colonyPosition]);
          }
        }

        setColonies(colonyPositions);
      }
    }

    fetchColonyPositions(planetId);
  }, [graphSdk, planetId]);

  return colonies;
}

function extractColonyPosition(response: any): Position | undefined {
  const edges = response.data.colonyPositionModels?.edges;

  if (!edges || edges.length === 0) {
    return undefined;
  }

  for (const edge of edges) {
    for (const model of edge.node.entity.models) {
      if (model.__typename === 'ColonyPosition') {
        return {
          system: model.position.system,
          orbit: model.position.orbit,
        };
      }
    }
  }

  return undefined;
}
