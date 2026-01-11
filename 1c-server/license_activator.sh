#!/bin/bash
set -euo pipefail

echo "[INFO] License activation started."

export DISPLAY=:99
Xvfb :99 -screen 0 1920x1080x24 &
XVFB_PID=$!

echo "[INFO] Waiting for Xvfb to start..."
until pgrep -x Xvfb >/dev/null; do
  sleep 1
done

cleanup() {
    echo "[INFO] Cleaning up processes..."
    kill -15 "${CLIENT_PID:-0}" "${SERVER_PID:-0}" "$XVFB_PID" 2>/dev/null || true
    wait "${CLIENT_PID:-}" "${SERVER_PID:-}" 2>/dev/null || true
}
trap cleanup EXIT INT TERM

ACTIVATION_DB_NAME=EmptyIB_Activation
ACTIVATION_DB_PATH="/home/usr1cv8/Documents/$ACTIVATION_DB_NAME"

if [[ ! -d "$ACTIVATION_DB_PATH" ]]; then
    echo "[INFO] Creating empty infobase: $ACTIVATION_DB_PATH"

    /1c_dir/ibcmd infobase create --db-path="$ACTIVATION_DB_PATH"

    printf "\nDisableUnsafeActionProtection=.*%s.*\n" "$ACTIVATION_DB_NAME" >> /1c_conf/conf.cfg
else
    echo "[INFO] Infobase already exists: $ACTIVATION_DB_PATH"
fi

ACTIVATION_IB_REGPORT=9141
ACTIVATION_IB_DIRECT_RANGE=9160:9161

/1c_dir/ibsrv \
  --db-path="$ACTIVATION_DB_PATH" \
  --name="$ACTIVATION_DB_NAME" \
  --direct-regport="$ACTIVATION_IB_REGPORT" \
  --direct-range="$ACTIVATION_IB_DIRECT_RANGE" \
  </dev/null &
SERVER_PID=$!

echo "[INFO] Waiting for the activation db server is started... (PID=$SERVER_PID)"
until netstat -tln | grep -q "$ACTIVATION_IB_REGPORT"; do
    sleep 1
done

echo "[INFO] Perform an attempt to get developer license..."
/1c_dir/1cv8c ENTERPRISE \
  /S "$HOSTNAME:$ACTIVATION_IB_REGPORT/$ACTIVATION_DB_NAME" \
  /Execute "1c_activation/$COMMUNITY_LICENSE_ACTIVATOR" \
  /C "login=$DEV_LOGIN;password=$DEV_PASSWORD;acceptLicense=true;forAllUsers=true" \
  /DisableStartupMessages \
  /UseHwLicenses-

echo "[INFO] Last EPF activation logs:"

cat "$(ls -t /1c_activation/epf_logs/*.log 2>/dev/null | head -1)"

LICENSE_DIR=$(readlink -f /1c_licenses)
chown -R usr1cv8:grp1cv8 "$LICENSE_DIR"
chmod -R 755 "$LICENSE_DIR"

echo "[INFO] License activator finished."