#!/bin/bash

KATANA_TOML_PATH="./manifests/deployments/KATANA.toml"

get_contract_address() {
    local contract_name="$1"
    awk -v name="$contract_name" '
    $1 == "address" { last_address = $3 }  # Store the last seen address
    $1 == "name" && $3 == "\"" name "\"" { print last_address; exit; }  # When name matches, print the last stored address
    ' "$KATANA_TOML_PATH"
}

export SOZO_WORLD=$(get_contract_address "dojo::world::world")

export DEFENCE_ADDRESS=$(get_contract_address "nogame::defence::actions::defenceactions")

export GAME_ADDRESS=$(get_contract_address "nogame::game::actions::gameactions")

export FLEET_ADDRESS=$(get_contract_address "nogame::fleet::actions::fleetactions")

export COMPOUND_ADDRESS=$(get_contract_address "nogame::compound::actions::compoundactions")

export DOCKYARD_ADDRESS=$(get_contract_address "nogame::dockyard::actions::dockyardactions")

export COLONY_ADDRESS=$(get_contract_address "nogame::colony::actions::colonyactions")

export PLANET_ADDRESS=$(get_contract_address "nogame::planet::actions::planetactions")

export TECH_ADDRESS=$(get_contract_address "nogame::tech::actions::techactions")


# Display the addresses
echo "-------------------------ADDRESS----------------------------------------"
echo world : $SOZO_WORLD
echo defenceactions : $DEFENCE_ADDRESS
echo gameactions : $GAME_ADDRESS
echo fleetactions : $FLEET_ADDRESS
echo compoundactions : $COMPOUND_ADDRESS
echo dockyardactions : $DOCKYARD_ADDRESS
echo colonyactions : $COLONY_ADDRESS
echo planetactions : $PLANET_ADDRESS
echo techactions : $TECH_ADDRESS
echo "---------------------------------------------------------------------------"

# Function to grant writer authorization
grant_authorization() {
    local components=("${!1}")
    local address=$2
    for component in ${components[@]}; do
        sozo auth grant writer "$component,$address"
        echo "Granted writer authorization for $component to $address"
        sleep 1
    done
}

# Arrays of component names for each contract type
COLONY_COMPONENTS=("PlanetResourcesSpent" "ColonyCompounds" "ColonyResource" "ColonyShips" "ColonyDefences" "ColonyPosition" "PositionToColony" "ColonyResourceTimer" "ColonyOwner" "PositionToPlanet" "PlanetPosition" "PlanetColoniesCount" "ColonyCount" )
COMPOUND_COMPONENTS=("PlanetCompounds" "PlanetResource" "PlanetResourceTimer" "PlanetResourcesSpent")
DEFENCE_COMPONENTS=("PlanetDefences" "PlanetResource" "PlanetResourceTimer" "PlanetResourcesSpent")
DOCKYARD_COMPONENTS=("PlanetShips" "PlanetResource" "PlanetResourceTimer" "PlanetResourcesSpent")
FLEET_COMPONENTS=("PlanetResourcesSpent" "LastActive" "PlanetDebrisField" "ColonyResourceTimer" "PlanetResourceTimer" "ActiveMission" "ActiveMissionLen" "IncomingMissions" "IncomingMissionLen" "ColonyShips" "PlanetShips" "PlanetDefences" "PlanetResource" "ColonyResource")
GAME_COMPONENTS=("GameSetup" "GamePlanetCount")
PLANET_COMPONENTS=("PlanetPosition" "PositionToPlanet"  "PlanetResourceTimer" "PlanetResource"  "GamePlanetCount" "GamePlanet" "GamePlanetOwner" "GameOwnerPlanet")
TECH_COMPONENTS=("PlanetTechs" "PlanetResource" "PlanetResourceTimer" "PlanetResourcesSpent")

# Granting authorizations
grant_authorization COLONY_COMPONENTS[@] "$COLONY_ADDRESS"
grant_authorization COMPOUND_COMPONENTS[@] "$COMPOUND_ADDRESS"
grant_authorization DEFENCE_COMPONENTS[@] "$DEFENCE_ADDRESS"
grant_authorization DOCKYARD_COMPONENTS[@] "$DOCKYARD_ADDRESS"
grant_authorization FLEET_COMPONENTS[@] "$FLEET_ADDRESS"
grant_authorization GAME_COMPONENTS[@] "$GAME_ADDRESS"
grant_authorization PLANET_COMPONENTS[@] "$PLANET_ADDRESS"
grant_authorization TECH_COMPONENTS[@] "$TECH_ADDRESS"

sozo execute $GAME_ADDRESS spawn -c 10000

echo "Default authorizations have been successfully set."
