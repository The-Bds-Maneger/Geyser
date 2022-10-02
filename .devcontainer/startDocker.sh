#!/bin/bash
CUSTOMRUN="$@"
# Start docker
if command -v dockerd &> /dev/null; then
  if ! docker info &> /dev/null ;then
    (sudo dockerd "${DOCKERD_ARGS:---experimental}" &> /tmp/customDocker.log) &
  fi
fi

# User scripts
if [[ -d "/startScripts" ]];then
  cd "/startScripts"
  for script in *; do
    ("./$script") &
  done
fi

# Run script
if ! [[ -z "${CUSTOMRUN}" ]]; then
  set -ex
  bash -c "${CUSTOMRUN}"
  exit $?
fi

# Sleep script
sleep infinity