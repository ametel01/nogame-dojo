import { useState, useEffect } from 'react';
import { useDojo } from '../dojo/useDojo';
import { World__EventEdge } from '../generated/graphql';
import { Position } from './usePlanetPosition';

export type Planet = {
  planetId: number;
  position: Position;
  account: string;
};

type CustomEventConnection = {
  edges?: (World__EventEdge | null)[] | null;
};

export function useGeneratedPlanets(): Planet[] {
  const [planets, setPlanets] = useState<Planet[]>([]);

  const {
    setup: { graphSdk },
  } = useDojo();

  useEffect(() => {
    async function fetchPlanets() {
      const response = await graphSdk.getGeneratedPlanets();

      if (response && response.data && response.data.events) {
        const eventConnection: CustomEventConnection = response.data.events;
        if (eventConnection.edges) {
          const transformedPlanets = eventConnection.edges
            .map((edge: World__EventEdge | null) => {
              if (!edge || !edge.node || !edge.node.data) {
                return null;
              }

              const [planetId, system, orbit, account] = edge.node.data.map(
                (value: string | null, index: number) => {
                  // Parse all values as numbers except for the account (last element)
                  return index < 3 && value ? parseInt(value, 16) : value;
                }
              ) as [number, number, number, string | null];

              return {
                planetId: planetId,
                position: {
                  system: system,
                  orbit: orbit,
                },
                account: account as string,
              } as Planet;
            })
            .filter(
              (planet: Planet | null): planet is Planet => planet !== null
            );

          setPlanets(transformedPlanets);
        }
      }
    }

    fetchPlanets();
  }, [graphSdk]);

  return planets;
}
