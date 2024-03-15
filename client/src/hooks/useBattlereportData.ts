import { useState, useEffect } from 'react';
import { useDojo } from '../dojo/useDojo';
import { Position } from './usePlanetPosition';
import { Fleet } from './usePlanetShips';
import { Defences } from './usePlanetDefences';
import { Resources } from './usePlanetResources';
import { Debris } from './usePlanetDebris';

interface BattleReport {
  time: number;
  attacker: number;
  attackerPosition: Position;
  attackerInitialFleet: Fleet;
  attackerFleetLoss: Fleet;
  defender: number;
  defenderPosition: Position;
  defenderInitialFleet: Fleet;
  defenderFleetLoss: Fleet;
  initialDefences: Defences;
  defencesLoss: Defences;
  loot: Resources;
  debris: Debris;
}

const parseHex = (hexString: string) => parseInt(hexString, 16);

// Assuming the order of fields based on your description
const decodePosition = (data: string[]): Position => ({
  system: parseHex(data[0]),
  orbit: parseHex(data[1]),
});

const decodeFleet = (data: string[]): Fleet => ({
  carrier: parseHex(data[0]),
  scraper: parseHex(data[1]),
  sparrow: parseHex(data[2]),
  frigate: parseHex(data[3]),
  armade: parseHex(data[4]),
});

const decodeDefences = (data: string[]): Defences => ({
  celestia: parseHex(data[0]),
  blaster: parseHex(data[1]),
  beam: parseHex(data[2]),
  astral: parseHex(data[3]),
  plasma: parseHex(data[4]),
});

const decodeLoot = (data: string[]): Resources => ({
  steel: parseHex(data[0]),
  quartz: parseHex(data[1]),
  tritium: parseHex(data[2]),
});

const decodeDebris = (data: string[]): Debris => ({
  steel: parseHex(data[0]),
  quartz: parseHex(data[1]),
});

export function useBattleReports() {
  const [battleReports, setBattleReports] = useState<BattleReport[]>([]);
  const {
    setup: { graphSdk },
  } = useDojo();

  useEffect(() => {
    const fetchBattleReports = async () => {
      const response = await graphSdk.getBattlereport();
      if (!response || !response.data) return [];

      const rawReports = response.data.event?.edges;

      // Assuming response.data is an array of BattleReportAPIResponse
      return rawReports?.map((hexData) => {
        const data = hexData?.node?.data as string[] | undefined;
        if (!data) return null;

        return {
          time: parseHex(data[0]),
          attacker: parseHex(data[1]),
          attackerPosition: decodePosition(data.slice(2, 4)),
          attackerInitialFleet: decodeFleet(data.slice(4, 9)),
          attackerFleetLoss: decodeFleet(data.slice(9, 14)),
          defender: parseHex(data[14]),
          defenderPosition: decodePosition(data.slice(15, 17)),
          defenderInitialFleet: decodeFleet(data.slice(17, 22)),
          defenderFleetLoss: decodeFleet(data.slice(22, 27)),
          initialDefences: decodeDefences(data.slice(27, 32)),
          defencesLoss: decodeDefences(data.slice(32, 37)),
          loot: decodeLoot(data.slice(37, 40)),
          debris: decodeDebris(data.slice(40, 42)),
        };
      });
    };

    const loadBattleReports = async () => {
      const reports = await fetchBattleReports();
      setBattleReports(
        reports?.filter((report) => report !== null) as BattleReport[]
      );
    };

    loadBattleReports();
  }, [graphSdk]); // Re-run if graphSdk changes

  return battleReports;
}
