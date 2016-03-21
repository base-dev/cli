#!/bin/bash
set -e
# -e  Exit immediately if a command exits with a non-zero status.

if [ ! -z "${USER_ID+x}" ]
then
    echo "entrypoint debug: MODDING USER TO ${USER_ID}"
    usermod -u "$USER_ID" -o worker
fi

if [ ! -z "${GROUP_ID+x}" ]
then 
    echo "entrypoint debug: MODDING GROUP TO ${GROUP_ID}"
    groupmod -g "$GROUP_ID" -o worker
fi

gosu worker exec "${*}"
