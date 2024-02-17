import { useState, useEffect } from 'react';
import { useDojo } from '../dojo/useDojo';

export function usePlanetPoints(planetId: number): number {
  const [points, setPoints] = useState<number>(0);

  const {
    setup: { graphSdk },
  } = useDojo();

  useEffect(() => {
    async function fetchResourcePoints() {
      const response = await graphSdk.getResourcesSpent();
      if (response && response.data) {
        let totalSpent = 0;

        // Define a function to process event data
        const processEventData = (
          eventData: (typeof response.data)['event1']
        ) => {
          eventData?.edges?.forEach((edge) => {
            if (edge?.node?.data) {
              const [id, , resource1, resource2] = edge.node.data;

              // Ensure id, resource1, and resource2 are not null before parsing
              if (
                id &&
                resource1 &&
                resource2 &&
                parseInt(id, 16) === planetId
              ) {
                totalSpent += parseInt(resource1, 16) + parseInt(resource2, 16);
              }
            }
          });
        };

        // Process each event
        processEventData(response.data.event1);
        processEventData(response.data.event2);
        processEventData(response.data.event3);
        processEventData(response.data.event4);

        // Calculate points and update state
        setPoints(totalSpent / 1000);
      }
    }

    fetchResourcePoints();
  }, [graphSdk, planetId]);
  return points;
}
