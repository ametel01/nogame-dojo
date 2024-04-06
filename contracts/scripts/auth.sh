#!/bin/bash
set -euo pipefail
pushd $(dirname "$0")/..

export MANIFEST_PATH="manifests/dev/manifest.json"

export RPC_URL="http://localhost:5050";

export WORLD_ADDRESS=$(cat $MANIFEST_PATH | jq -r '.world.address')

export COLONY_ADDRESS=$(cat $MANIFEST_PATH | jq -r '.contracts[] | select(.name == "nogame::systems::colony::contract::colonyactions" ).address')

export COMPOUND_ADDRESS=$(cat $MANIFEST_PATH | jq -r '.contracts[] | select(.name == "nogame::systems::compound::contract::compoundactions" ).address')

export DEFENCE_ADDRESS=$(cat $MANIFEST_PATH | jq -r '.contracts[] | select(.name == "nogame::systems::defence::contract::defenceactions" ).address')

export DOCKYARD_ADDRESS=$(cat $MANIFEST_PATH | jq -r '.contracts[] | select(.name == "nogame::systems::dockyard::contract::dockyardactions" ).address')

export FLEET_ADDRESS=$(cat $MANIFEST_PATH | jq -r '.contracts[] | select(.name == "nogame::systems::fleet::contract::fleetactions" ).address')

export GAME_ADDRESS=$(cat $MANIFEST_PATH | jq -r '.contracts[] | select(.name == "nogame::systems::game::contract::gameactions" ).address')

export PLANET_ADDRESS=$(cat $MANIFEST_PATH | jq -r '.contracts[] | select(.name == "nogame::systems::planet::contract::planetactions" ).address')

export TECH_ADDRESS=$(cat $MANIFEST_PATH | jq -r '.contracts[] | select(.name == "nogame::systems::tech::contract::techactions" ).address')


# Display the addresses
echo "-------------------------ADDRESS----------------------------------------"
echo world : $WORLD_ADDRESS
echo colonyactions : $COLONY_ADDRESS
echo compoundactions : $COMPOUND_ADDRESS
echo defenceactions : $DEFENCE_ADDRESS
echo dockyardactions : $DOCKYARD_ADDRESS
echo fleetactions : $FLEET_ADDRESS
echo gameactions : $GAME_ADDRESS
echo planetactions : $PLANET_ADDRESS
echo techactions : $TECH_ADDRESS
echo "---------------------------------------------------------------------------"

# Function to grant writer authorization
grant_authorization() {
    local components=("${!1}")
    local address=$2
    for component in ${components[@]}; do
        sozo auth grant --world $WORLD_ADDRESS --wait writer $component,$address
        echo "Granted writer authorization for $component to $address"
        sleep 1
    done
}

# Arrays of component names for each contract type
COLONY_COMPONENTS=(PlanetResourcesSpent ColonyCompounds ColonyResource ColonyShips ColonyDefences ColonyPosition PositionToColony ColonyResourceTimer ColonyOwner PositionToPlanet PlanetPosition PlanetColoniesCount ColonyCount )
COMPOUND_COMPONENTS=(PlanetCompounds PlanetResource PlanetResourceTimer PlanetResourcesSpent)
DEFENCE_COMPONENTS=(PlanetDefences PlanetResource PlanetResourceTimer PlanetResourcesSpent)
DOCKYARD_COMPONENTS=(PlanetShips PlanetResource PlanetResourceTimer PlanetResourcesSpent)
FLEET_COMPONENTS=(PlanetResourcesSpent LastActive PlanetDebrisField ColonyResourceTimer PlanetResourceTimer ActiveMission ActiveMissionLen IncomingMissions IncomingMissionLen ColonyShips PlanetShips PlanetDefences PlanetResource ColonyResource)
GAME_COMPONENTS=(GameSetup GamePlanetCount)
PLANET_COMPONENTS=(PlanetPosition PositionToPlanet PlanetResourceTimer PlanetResource  GamePlanetCount GamePlanet GamePlanetOwner GameOwnerPlanet)
TECH_COMPONENTS=(PlanetTechs PlanetResource PlanetResourceTimer PlanetResourcesSpent)

# Granting authorizations
grant_authorization COLONY_COMPONENTS[@] "$COLONY_ADDRESS"
grant_authorization COMPOUND_COMPONENTS[@] "$COMPOUND_ADDRESS"
grant_authorization DEFENCE_COMPONENTS[@] "$DEFENCE_ADDRESS"
grant_authorization DOCKYARD_COMPONENTS[@] "$DOCKYARD_ADDRESS"
grant_authorization FLEET_COMPONENTS[@] "$FLEET_ADDRESS"
grant_authorization GAME_COMPONENTS[@] "$GAME_ADDRESS"
grant_authorization PLANET_COMPONENTS[@] "$PLANET_ADDRESS"
grant_authorization TECH_COMPONENTS[@] "$TECH_ADDRESS"

sozo execute --world $WORLD_ADDRESS $GAME_ADDRESS spawn -c 10000 --wait

echo "Default authorizations have been successfully set."
