import { useState, useEffect } from 'react';
import { useDojo } from '../dojo/useDojo';

export type Position = {
  system: number | undefined;
  orbit: number | undefined;
};

type PlanetPositionModel = {
  __typename: 'PlanetPosition';
  position: {
    system: number;
    orbit: string;
  };
};

export function usePlanetPosition(planetId: number): Position {
  const [system, setSystem] = useState<number | undefined>();
  const [orbit, setOrbit] = useState<number | undefined>();

  const {
    setup: { graphSdk },
  } = useDojo();

  useEffect(() => {
    async function fetchPlanetPosition(planetId: number) {
      const response = await graphSdk.getPlanetPosition({
        planet_id: planetId,
      });

      const edges = response.data.planetPositionModels?.edges;
      if (edges) {
        for (const edge of edges) {
          if (
            edge &&
            edge.node &&
            edge.node.entity &&
            edge.node.entity.models
          ) {
            const models = edge.node.entity.models;
            for (const model of models) {
              if (isPlanetPositionModel(model)) {
                setSystem(model.position.system);
                setOrbit(parseInt(model.position.orbit, 16));
                return; // Exit once the data is found
              }
            }
          }
        }
      }
    }

    fetchPlanetPosition(planetId);
  }, [graphSdk, planetId]);

  return { system, orbit };
}

function isPlanetPositionModel(model: any): model is PlanetPositionModel {
  return model.__typename === 'PlanetPosition';
}
