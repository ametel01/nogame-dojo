import { useEffect, useState } from 'react';
import { useDojo } from '../dojo/useDojo';
import { Resources } from './usePlanetResources';

export const useGetPlanetUncollectedResources = (planetId: number) => {
  const {
    setup: {
      systemCalls: { getPlanetUncollectedResources },
    },
  } = useDojo();

  // State hooks for resources
  const [uncollectedResources, setUncollectedResources] = useState({
    steel: 0,
    quartz: 0,
    tritium: 0,
  });

  // Other hooks and component logic remain the same

  useEffect(() => {
    // Function to fetch and update resources
    const fetchUncollectedResources = async () => {
      try {
        const resources = await getPlanetUncollectedResources(planetId);
        setUncollectedResources(resources);
      } catch (error) {
        console.error('Failed to fetch uncollected resources:', error);
        // Handle error appropriately
      }
    };

    fetchUncollectedResources();
  }, [planetId, getPlanetUncollectedResources]);

  return uncollectedResources as Resources;
};
