/* eslint-disable @typescript-eslint/no-explicit-any */
import { useState, useEffect } from 'react';
import { useDojo } from '../dojo/useDojo';
import { GetPlanetColoniesCountQuery } from '../generated/graphql';
import { Position } from './usePlanetPosition';

type ColonyPositionModel = {
  __typename: 'ColonyPosition';
  colony_id: number;
  position: Position;
};

type EdgeType = {
  node: {
    entity: {
      models: ColonyPositionModel[];
    };
  };
};

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
      if (edges && edges.length > 0) {
        const count = edges[0].node.count;
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
  const positionModel = response.data.planetPositionModels?.edges?.find(
    (edge: EdgeType) => isColonyPositionModel(edge.node.entity.models)
  )?.node.entity.models[0];

  if (positionModel) {
    return {
      system: positionModel.position.system,
      orbit: parseInt(positionModel.position.orbit, 16),
    };
  }

  return undefined;
}

function isColonyPositionModel(models: any[]): models is ColonyPositionModel[] {
  return models.length > 0 && models[0].__typename === 'ColonyPosition';
}
