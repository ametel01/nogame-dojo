import { BattleReport, DebrisCollection } from './types';

export async function fetchBattleReports(
  planetId: number
): Promise<BattleReport[]> {
  const nodeEnv = import.meta.env.VITE_NODE_ENV;
  const apiUrl =
    nodeEnv === 'production'
      ? `https://www.api.testnet.no-game.xyz/battle-reports?planet_id=${planetId}`
      : `http://localhost:3001/battle-reports?planet_id=${planetId}`;

  try {
    const response = await fetch(apiUrl);
    if (!response.ok) {
      throw new Error('Failed to fetch battle reports');
    }
    const battleReports: BattleReport[] = await response.json();
    return battleReports;
  } catch (error) {
    if (error instanceof Error) {
      console.error(error.message);
    } else {
      console.error('An unknown error occurred');
    }
    // Depending on how you want to handle errors, you can either return an empty array or rethrow the error
    return [];
  }
}

export async function fetchDebrisCollections(
  planetId: number
): Promise<DebrisCollection[]> {
  const nodeEnv = import.meta.env.VITE_NODE_ENV;
  const apiUrl =
    nodeEnv === 'production'
      ? `https://www.api.testnet.no-game.xyz/debris-collection?planet_id=${planetId}`
      : `http://localhost:3001/debris-collection?planet_id=${planetId}`;

  try {
    const response = await fetch(apiUrl);
    if (!response.ok) {
      throw new Error('Failed to fetch debris collections');
    }
    const debrisCollections: DebrisCollection[] = await response.json();
    return debrisCollections;
  } catch (error) {
    if (error instanceof Error) {
      console.error(error.message);
    } else {
      console.error('An unknown error occurred');
    }
    // Depending on how you want to handle errors, you can either return an empty array or rethrow the error
    return [];
  }
}
