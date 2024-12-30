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

# Make sed command compatible in both Mac and Linux environments.
# Reference: https://stackoverflow.com/a/38595160/8696958
sedi () {
  sed --version >/dev/null 2>&1 && sed -i -- "$@" || sed -i "" "$@"
}

# Putting the new name and description in the README.md file
sedi "s/# 🌕 Moonrepo Fullstack Template/# $name/g" README.md
sedi "s/This repository is a Moonrepo project template for multi-language fullstack apps. For now, it supports Python, NestJS backends, and NextJS and Expo frontends./$description/g" README.md
