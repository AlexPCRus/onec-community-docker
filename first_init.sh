#!/bin/bash

export "$(cat .env | grep BASE_MOUNT_DIR)"
mkdir -p "${BASE_MOUNT_DIR}"/data/{1c-postgres_data,1c-server_data,1c-server_licenses,1c-client_data}
chmod -R 777 data

if [ -z "$DISPLAY" ]; then
    echo "No DISPLAY env found. Check X11 or XWayland settings."
    exit 1
fi

chmod +x ./run_services.sh && ./run_services.sh
