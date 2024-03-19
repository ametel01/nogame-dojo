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