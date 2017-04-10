#!/bin/sh

return_code=0

containers=$(docker ps --all --format "{{.Names}}")
containers=$(echo ${containers})
if [ -n "${containers}" ]; then
  for container in ${containers}; do
    [ "${container}" = "mackerel-agent" ] && continue
    status=$(docker inspect --format "{{.State.Status}}" ${container})
    case "${status}" in
      "created" | "running")
        echo "[${container}] is ${status}."
        ;;
      "restarting" | "removing" | "paused")
        echo "[${container}] is ${status}."
        [ ${return_code} -lt 1 ] && return_code=1
        ;;
      "exited")
        exit_code=$(docker inspect --format "{{.State.ExitCode}}" ${container})
        echo "[${container}] is ${status} (${exit_code})."
        if [ "${exit_code}" = "0" ]; then
          [ ${return_code} -lt 1 ] && return_code=1
        else
          [ ${return_code} -lt 2 ] && return_code=2
        fi
        ;;
      "dead")
        echo "[${container}] is ${status}."
        [ ${return_code} -lt 2 ] && return_code=2
        ;;
    esac
  done
fi

exit ${return_code}
