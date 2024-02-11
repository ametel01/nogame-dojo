import { useEffect, useState } from 'react';

interface LeaderboardEntry {
  planet_id: number;
  account: string;
  net_amount: number;
}

export function useFetchLeaderboardData() {
  const [leaderboard, setLeaderboard] = useState<LeaderboardEntry[]>([]);
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState('');

  useEffect(() => {
    const nodeEnv = import.meta.env.VITE_NODE_ENV;
    const apiUrl =
      nodeEnv === 'production'
        ? 'https://www.api.testnet.no-game.xyz/leaderboard'
        : 'http://localhost:3001/leaderboard';

    const fetchData = async () => {
      setIsLoading(true);
      setError('');
      try {
        const response = await fetch(apiUrl);
        if (!response.ok) {
          throw new Error('Something went wrong!');
        }
        const data = await response.json();
        setLeaderboard(data);
      } catch (err) {
        setError(
          err instanceof Error ? err.message : 'An unexpected error occurred'
        );
      } finally {
        setIsLoading(false);
      }
    };

    fetchData();
  }, []);

  return { leaderboard, isLoading, error };
}

export function useGetPlanetRanking(planetId: number) {
  const { leaderboard, isLoading, error } = useFetchLeaderboardData();
  const [position, setPosition] = useState<number | string>('Loading...');

  useEffect(() => {
    if (!isLoading && !error) {
      const foundPosition = leaderboard.findIndex(
        (entry) => Number(entry.planet_id) === Number(planetId)
      );
      if (foundPosition === -1) {
        setPosition('Planet not found in the leaderboard');
      } else {
        setPosition(foundPosition + 1); // Adjusting for array index starting at 0
      }
    } else if (error) {
      setPosition('Error fetching leaderboard');
    }
  }, [leaderboard, isLoading, error, planetId]);

  return position;
}
