import { useState, useEffect } from 'react';
import { BattleReport } from './types';

export function useGetBattleReportsData(planetId: number | null) {
  const [battleReports, setBattleReports] = useState<BattleReport[]>([]);
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    if (planetId === null) {
      // If planetId is not set, clear the current data and do not fetch
      setBattleReports([]);
      setError(null);
      setIsLoading(false);
      return;
    }

    const apiUrl = `https://www.api.testnet.no-game.xyz/battle-reports?planet_id=${planetId}`;
    const fetchData = async () => {
      setIsLoading(true);
      setError(null);

      try {
        const response = await fetch(apiUrl);
        if (!response.ok) {
          throw new Error('Error fetching battle reports');
        }
        const data = await response.json();

        if (data.length === 0) {
          setError('No Battle Reports to show');
          setBattleReports([]);
        } else {
          setBattleReports(data);
        }
      } catch (err) {
        setError(
          err instanceof Error ? err.message : 'An unexpected error occurred'
        );
      } finally {
        setIsLoading(false);
      }
    };

    fetchData();
  }, [planetId]); // Re-fetch data when planetId changes

  return { battleReports, isLoading, error };
}

export function useCalculateWinsAndLosses(planetId: number) {
  const [winLoss, setWinLoss] = useState({ wins: 0, losses: 0 });

  const { battleReports, isLoading, error } = useGetBattleReportsData(planetId);
  useEffect(() => {
    if (!isLoading && !error && battleReports) {
      let wins = 0;
      let losses = 0;

      for (const report of battleReports) {
        const totalLoot =
          report.loot.steel + report.loot.quartz + report.loot.tritium;

        if (report.attacker_planet_id === planetId && totalLoot > 0) {
          wins++;
        } else if (report.defender_planet_id === planetId && totalLoot === 0) {
          wins++;
        } else {
          losses++;
        }
      }

      setWinLoss({ wins, losses });
    }
  }, [battleReports, isLoading, error, planetId]);

  return winLoss;
}
