#!/bin/bash
set -euo pipefail
pushd $(dirname "$0")/..

export RPC_URL="http://localhost:5050";

export WORLD_ADDRESS=$(cat ./target/dev/manifest.json | jq -r '.world.address')

export GAME_ADDRESS=$(cat ./target/dev/manifest.json | jq -r '.contracts[] | select(.name == "nogame::game::actions::gameactions" ).address')

export PLANET_ADDRESS=$(cat ./target/dev/manifest.json | jq -r '.contracts[] | select(.name == "nogame::planet::actions::planetactions" ).address')

echo "---------------------------------------------------------------------------"
echo world : $WORLD_ADDRESS 
echo " "
echo gameactions : $GAME_ADDRESS
echo " "
echo planetactions : $PLANET_ADDRESS
echo "---------------------------------------------------------------------------"

# enable system -> component authorizations
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

sozo execute $GAME_ADDRESS spawn -c 1

echo "Default authorizations have been successfully set."