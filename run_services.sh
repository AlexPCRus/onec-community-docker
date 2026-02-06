#!/bin/bash
set -e

HOST_UID="$(id -u)"
HOST_GID="$(id -g)"

export HOST_UID
export HOST_GID

xhost +local:docker >/dev/null 2>&1 || true
xhost +SI:localuser:"$HOST_UID" >/dev/null 2>&1 || true

docker compose up
