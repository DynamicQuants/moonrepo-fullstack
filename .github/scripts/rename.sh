#!/usr/bin/env bash

# This command will exit the script if any command fails.
set -euo pipefail

# Get the new package name from the command line
name=$1
description=$2

# Set the new name and description in one command.
jq_output=$(jq --arg name "$name" --arg description "$description" '.name = $name | .description = $description' package.json)

# Write the output to the package.json file
echo "$jq_output" > package.json

# Remove packageManager and engines from package.json
rm_jq_output=$(jq 'del(.packageManager, .engines)' package.json)

# Write the output to the package.json file
echo "$rm_jq_output" > package.json

# Create a new README.md file with the new name and description
rm -f README.md
echo "# $name" > README.md
echo "" >> README.md
echo "$description" >> README.md
