#!/bin/bash
set -e

groupmod -g "$HOST_GID" grp1cv8
usermod -u "$HOST_UID" -g "$HOST_GID" usr1cv8
chown -R "$HOST_UID":"$HOST_GID" /1c_user_home/

exec gosu usr1cv8 /1c_dir/1cv8s
