export interface Fleet {
  armade: number;
  carrier: number;
  frigate: number;
  scraper: number;
  sparrow: number;
}

export interface Defences {
  beam: number;
  astral: number;
  plasma: number;
  blaster: number;
  celestia: number;
}

export interface Loot {
  steel: number;
  quartz: number;
  tritium: number;
}

export interface Debris {
  steel: number;
  quartz: number;
}

export interface BattleReport {
  battle_id: number;
  time: string;
  attacker_planet_id: number;
  attacker_position: {
    orbit: number;
    system: number;
  };
  attacker_initial_fleet: Fleet;
  attacker_fleet_loss: Fleet;
  defender_planet_id: number;
  defender_position: {
    orbit: number;
    system: number;
  };
  defender_initial_fleet: Fleet;
  defender_fleet_loss: Fleet;
  initial_defences: Defences;
  defences_loss: Defences;
  loot: Loot;
  debris: Debris;
}

export interface DebrisCollection {
  collection_id: number;
  timestamp: string;
  planet_id: number;
  system: number;
  orbit: number;
  collectible_steel: number;
  collectible_quartz: number;
  collected_steel: number;
  collected_quartz: number;
}
