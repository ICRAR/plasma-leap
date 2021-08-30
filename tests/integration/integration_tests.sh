#!/usr/bin/env bash

# Make the container names unique
export COMPOSE_PROJECT_NAME=$(git rev-parse --short HEAD)

# the docker-compose file uses $IMAGE to set the project name
docker_compose_cmd="docker-compose -f docker-compose.yml"

${docker_compose_cmd} build

# Run services
${docker_compose_cmd} up -d plasma-store mswriter emu-receive emu-send

# wait for output
while read i; do if [ "$i" = 1197638568-split-plasma.ms ]; then break; fi; done \
   < <(inotifywait  -e create,open --format '%f' --quiet /tmp --monitor)

# Run tests
${docker_compose_cmd} run --rm integration-tests

exit_codes=$?

# Clean up
${docker_compose_cmd} down

exit ${exit_code}