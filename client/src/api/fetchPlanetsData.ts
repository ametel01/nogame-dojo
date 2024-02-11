import { type PlanetDetails, type Position } from '../shared/types';

interface ApiPlanetData {
  planet_id: number;
  account: string;
  system: number;
  orbit: number;
  total_points: number;
  last_active: string;
}

const fetchPlanetsData = async (): Promise<PlanetDetails[]> => {
  // const nodeEnv = import.meta.env.MODE;
  const apiUrl = 'https://www.api.testnet.no-game.xyz/universe';
  try {
    const response = await fetch(apiUrl);
    if (!response.ok) {
      throw new Error(`HTTP error! Status: ${response.status}`);
    }
    const data = await response.json();

    if (data.length === 0) {
      throw new Error('No data found in universe.');
    }

    return data.map((planet: ApiPlanetData) => ({
      planetId: planet.planet_id,
      account: planet.account,
      position: {
        system: planet.system,
        orbit: planet.orbit,
      } satisfies Position,
      points: planet.total_points,
      lastActive: new Date(planet.last_active).getTime() / 1000, // Unix timestamp in seconds
    }));
  } catch (error) {
    console.error('Error fetching universe data:', error);
    throw error;
  }
};

export default fetchPlanetsData;
