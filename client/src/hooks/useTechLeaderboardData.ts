import { useState, useEffect, useCallback } from 'react';
import { useDojo } from '../dojo/useDojo';
import { World__EventEdge } from '../generated/graphql';

interface PointsData {
  [key: number]: number;
}

interface OwnerAndPositionData {
  [key: number]: { owner: string; position: { system: string; orbit: string } };
}

interface LeaderboardEntry {
  planetId: number;
  position: { system: string; orbit: string };
  owner: string;
  points: number;
}

export function useTechLeaderboard() {
  const [leaderboardData, setLeaderboardData] = useState<LeaderboardEntry[]>(
    []
  );
  const {
    setup: { graphSdk },
  } = useDojo();

  const fetchResourcePoints = useCallback(async (): Promise<PointsData> => {
    const response = await graphSdk.getTechSpent();
    if (response && response.data) {
      const pointsData: PointsData = {};

      const processEventData = (
        eventData:
          | {
              __typename?: 'World__EventConnection' | undefined;
              edges?:
                | ({
                    __typename?: 'World__EventEdge' | undefined;
                    node?:
                      | {
                          __typename?: 'World__Event' | undefined;
                          data?: (string | null)[] | null | undefined;
                        }
                      | null
                      | undefined;
                  } | null)[]
                | null
                | undefined;
            }
          | null
          | undefined
      ) => {
        eventData?.edges?.forEach((edge) => {
          if (edge?.node?.data) {
            const [id, , resource1, resource2] = edge.node.data;
            if (id && resource1 && resource2) {
              const planetId = parseInt(id, 16);
              pointsData[planetId] =
                (pointsData[planetId] || 0) +
                parseInt(resource1, 16) +
                parseInt(resource2, 16);
            }
          }
        });
      };

      // Process each event
      processEventData(response.data.event);

      // Convert points to required format
      Object.keys(pointsData).forEach((planetId) => {
        pointsData[parseInt(planetId)] = Math.ceil(
          pointsData[parseInt(planetId)] / 1000
        );
      });

      return pointsData;
    }
    return {};
  }, [graphSdk]); // graphSdk as dependency

  // Function to fetch and process resource points
  const fetchPlanetOwners =
    useCallback(async (): Promise<OwnerAndPositionData> => {
      const response = await graphSdk.getGeneratedPlanets();
      const ownerAndPositionData: OwnerAndPositionData = {};

      response?.data?.events?.edges?.forEach(
        (edge: World__EventEdge | null) => {
          if (edge?.node?.data) {
            const [planetIdStr, system, orbit, ownerAddress] = edge.node.data;
            const planetId = parseInt(planetIdStr || '', 16);
            if (planetIdStr && ownerAddress) {
              ownerAndPositionData[planetId] = {
                owner: ownerAddress,
                position: { system: system || '', orbit: orbit || '' },
              };
            }
          }
        }
      );

      return ownerAndPositionData;
    }, [graphSdk]);

  // Combine data and create leaderboard
  useEffect(() => {
    async function createLeaderboard() {
      const pointsData = await fetchResourcePoints();
      const ownerAndPositionData = await fetchPlanetOwners();

      const combinedData: LeaderboardEntry[] = Object.keys(pointsData).map(
        (planetIdStr) => {
          const planetId = parseInt(planetIdStr);
          const ownerData = ownerAndPositionData[planetId];
          return {
            planetId: planetId,
            owner: ownerData ? ownerData.owner : 'Unknown',
            position: ownerData
              ? ownerData.position
              : { system: 'Unknown', orbit: 'Unknown' },
            points: pointsData[planetId] || 0,
          };
        }
      );

      combinedData.sort((a, b) => b.points - a.points);
      setLeaderboardData(combinedData);
    }

    createLeaderboard();
  }, [fetchPlanetOwners, fetchResourcePoints, graphSdk]);

  return leaderboardData;
}
