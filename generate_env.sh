#!/bin/bash

echo "Enter access token (default \$GH_TOKEN):"
read -r GH_TOKEN
GH_TOKEN="${GH_TOKEN:-"\$GH_TOKEN"}"

echo "Enter repository owner (default \$GH_OWNER):"
read -r GH_OWNER
GH_OWNER="${GH_OWNER:-"\$GH_OWNER"}"

echo "Enter repository name (default \$GH_REPOSITORY):"
read -r GH_REPOSITORY
GH_REPOSITORY="${GH_REPOSITORY:-"\$GH_REPOSITORY"}"

printf "GH_TOKEN=%s\nGH_OWNER=%s\nGH_REPOSITORY=%s" "$GH_TOKEN" "$GH_OWNER" "$GH_REPOSITORY" >variables.env

echo "File \"variables.env\" successfully generated!"
