#!/bin/bash
set -euo pipefail

LAST_LOG_FILE="1c_activation/log_$(date +%Y_%m_%d_%H_%M_%S).log"

touch "$LAST_LOG_FILE"
exec > >(tee -a "$LAST_LOG_FILE") 2>&1

echo "[INFO] Starting ragent..."
gosu usr1cv8 /1c_ragent \
  -debug \
  -d /home/usr1cv8/.1cv8/1C/1cv8 \
  -port 1540 \
  -regport 1541 \
  -range 1560:1591 \
  -pingPeriod 1000 \
  -pingTimeout 5000 &

echo "[INFO] Waiting for Ragent to be ready..."
until ss -ltn 2>/dev/null | grep -q ":1540" || true; do
  sleep 1
done

echo "[INFO] Starting ras..."
gosu usr1cv8 /1c_ras cluster \
  --port 1545 \
  "$HOSTNAME":1540 &

CLUSTER_HOST="$HOSTNAME":1545
CLUSTER_ID=""

echo "[INFO] Waiting for RAS to be ready..."
until [[ -n "$CLUSTER_ID" ]]; do
  CLUSTER_ID=$(/1c_rac "$CLUSTER_HOST" cluster list 2>/dev/null | grep -oP 'cluster\s*:\s*\K[0-9a-f-]+' | head -n1 || true)
  echo "$CLUSTER_ID"
  sleep 1
done

export CLUSTER_HOST CLUSTER_ID
echo "[INFO] Using  cluster host: $CLUSTER_HOST, cluster ID: $CLUSTER_ID"

if /1c_scripts/license_expiring_soon.sh >/dev/null 2>&1; then
    echo "[INFO] Need to [re]activate on the server side... Please, wait until finished."
    /1c_scripts/license_activator.sh
fi

echo "[INFO] The service is started successfully"

wait