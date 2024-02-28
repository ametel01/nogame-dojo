#!/bin/bash
set -euo pipefail
pushd $(dirname "$0")/..

export RPC_URL="http://localhost:5050";

export WORLD_ADDRESS=$(cat ./target/dev/manifest.json | jq -r '.world.address')

export COLONY_ADDRESS=$(cat ./target/dev/manifest.json | jq -r '.contracts[] | select(.name == "nogame::colony::actions::colonyactions" ).address')

export COMPOUND_ADDRESS=$(cat ./target/dev/manifest.json | jq -r '.contracts[] | select(.name == "nogame::compound::actions::compoundactions" ).address')

export DEFENCE_ADDRESS=$(cat ./target/dev/manifest.json | jq -r '.contracts[] | select(.name == "nogame::defence::actions::defenceactions" ).address')

export DOCKYARD_ADDRESS=$(cat ./target/dev/manifest.json | jq -r '.contracts[] | select(.name == "nogame::dockyard::actions::dockyardactions" ).address')

export FLEET_ADDRESS=$(cat ./target/dev/manifest.json | jq -r '.contracts[] | select(.name == "nogame::fleet::actions::fleetactions" ).address')

export GAME_ADDRESS=$(cat ./target/dev/manifest.json | jq -r '.contracts[] | select(.name == "nogame::game::actions::gameactions" ).address')

export PLANET_ADDRESS=$(cat ./target/dev/manifest.json | jq -r '.contracts[] | select(.name == "nogame::planet::actions::planetactions" ).address')

export TECH_ADDRESS=$(cat ./target/dev/manifest.json | jq -r '.contracts[] | select(.name == "nogame::tech::actions::techactions" ).address')

echo "---------------------------------------------------------------------------"
echo world : $WORLD_ADDRESS 
echo " "
echo colonyactions : $COLONY_ADDRESS
echo " "
echo compoundactions : $COMPOUND_ADDRESS
echo " "
echo defenceactions : $DEFENCE_ADDRESS
echo " "
echo dockyardactions : $DOCKYARD_ADDRESS
echo " "    
echo fleetactions : $FLEET_ADDRESS
echo " "
echo gameactions : $GAME_ADDRESS
echo " "
echo planetactions : $PLANET_ADDRESS
echo " "
echo techactions : $TECH_ADDRESS
echo "---------------------------------------------------------------------------"

# enable system -> component authorizations
COLONY_COMPONENTS=("PlanetResourcesSpent" "ColonyCompounds" "ColonyResource" "ColonyShips" "ColonyDefences" "ColonyPosition" "PositionToColony" "ColonyResourceTimer" "ColonyOwner" "PositionToPlanet" "PlanetPosition" "PlanetColoniesCount" "ColonyCount" )   
for component in ${COLONY_COMPONENTS[@]}; do
    sozo auth writer $component $COLONY_ADDRESS --world $WORLD_ADDRESS --rpc-url $RPC_URL
    sleep 1
done

COMPOUND_COMPONENTS=("PlanetCompounds" "PlanetResource" "PlanetResourceTimer" "PlanetResourcesSpent")
for component in ${COMPOUND_COMPONENTS[@]}; do
    sozo auth writer $component $COMPOUND_ADDRESS --world $WORLD_ADDRESS --rpc-url $RPC_URL
    sleep 1
done

DEFENCE_COMPONENTS=("PlanetDefences" "PlanetResource" "PlanetResourceTimer" "PlanetResourcesSpent")
for component in ${DEFENCE_COMPONENTS[@]}; do
    sozo auth writer $component $DEFENCE_ADDRESS --world $WORLD_ADDRESS --rpc-url $RPC_URL
    sleep 1
done

DOCKYARD_COMPONENTS=("PlanetShips" "PlanetResource" "PlanetResourceTimer" "PlanetResourcesSpent")
for component in ${DOCKYARD_COMPONENTS[@]}; do
    sozo auth writer $component $DOCKYARD_ADDRESS --world $WORLD_ADDRESS --rpc-url $RPC_URL
    sleep 1
done

FLEET_COMPONENTS=("PlanetResourcesSpent" "LastActive" "PlanetDebrisField" "ColonyResourceTimer" "PlanetResourceTimer" "ActiveMission" "ActiveMissionLen" "IncomingMissions" "IncomingMissionLen" "ColonyShips" "PlanetShips" "PlanetDefences" "PlanetResource" "ColonyResource")
for component in ${FLEET_COMPONENTS[@]}; do
    sozo auth writer $component $FLEET_ADDRESS --world $WORLD_ADDRESS --rpc-url $RPC_URL
    sleep 1
done

GAME_COMPONENTS=("GameSetup" "GamePlanetCount" )
for component in ${GAME_COMPONENTS[@]}; do
    sozo auth writer $component $GAME_ADDRESS --world $WORLD_ADDRESS --rpc-url $RPC_URL
    sleep 1
done

PLANET_COMPONENTS=("PlanetPosition" "PositionToPlanet"  "PlanetResourceTimer" "PlanetResource"  "GamePlanetCount" "GamePlanet" "GamePlanetOwner" "GameOwnerPlanet")
for component in ${PLANET_COMPONENTS[@]}; do
    sozo auth writer $component $PLANET_ADDRESS --world $WORLD_ADDRESS --rpc-url $RPC_URL
    sleep 1
done

TECH_COMPONENTS=("PlanetTechs" "PlanetResource" "PlanetResourceTimer" "PlanetResourcesSpent")
for component in ${TECH_COMPONENTS[@]}; do
    sozo auth writer $component $TECH_ADDRESS --world $WORLD_ADDRESS --rpc-url $RPC_URL
    sleep 1
done

sozo execute $GAME_ADDRESS spawn -c 10000

echo "Default authorizations have been successfully set."