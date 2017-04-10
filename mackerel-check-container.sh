#!/bin/sh

container=$1

if [ -z "${container}" ]; then
  echo "Usage: $(basename $0) <container-name>" >&2
  exit -1
fi

status=$(docker inspect --format "{{.State.Status}}" ${container})
case "${status}" in
  "created" | "running")
    echo "[${container}] is ${status}."
    exit 0
    ;;
  "restarting" | "removing" | "paused")
    echo "[${container}] is ${status}."
    exit 1
    ;;
  "exited")
    exit_code=$(docker inspect --format "{{.State.ExitCode}}" ${container})
    echo "[${container}] is ${status} (${exit_code})."
    if [ "${exit_code}" == "0" ]; then
      exit 1
    else
      exit 2
    fi
    ;;
  "dead")
    echo "[${container}] is ${status}."
    exit 2
    ;;
  *)
    echo "[${container}] doesn't exist."
    exit -1
    ;;
esac
