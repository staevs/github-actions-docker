#!/bin/bash

RUNNER_SUFFIX=$(< '/dev/urandom' tr -dc 'a-z0-9' | fold -w 5 | head -n 1)
RUNNER_NAME="docker-$RUNNER_SUFFIX"

RUNNER_REGISTRATION_TOKEN=$(curl -sX POST -H "Accept: application/vnd.github.v3+json" -H "Authorization: token $GH_TOKEN" https://api.github.com/repos/"$GH_OWNER"/"$GH_REPOSITORY"/actions/runners/registration-token | jq .token --raw-output)

sudo service docker start

./config.sh --unattended --url https://github.com/"$GH_OWNER"/"$GH_REPOSITORY" --token "$RUNNER_REGISTRATION_TOKEN" --name "$RUNNER_NAME"

cleanup() {
    echo "Removing runner..."
    ./config.sh remove --token "$RUNNER_REGISTRATION_TOKEN"
}

trap 'cleanup; exit 130' INT
trap 'cleanup; exit 143' TERM

./run.sh & wait $!
