#!/bin/bash
set -euo pipefail

ln -s /opt/1cv8/"${PLATFORM_ARCH}"/"${PLATFORM_VERSION}" /1c_dir

ln -s /1c_dir/ragent /1c_ragent
ln -s /1c_dir/ras /1c_ras
ln -s /1c_dir/rac /1c_rac

ln -s /1c_dir/1cv8c /1c_thin_client

ln -s /opt/1cv8/conf /1c_conf
ln -s /var/1C/licenses /1c_licenses

ln -s /home/usr1cv8 /1c_user_home

mkdir -p /opt/1cv8/scripts &&  ln -s /opt/1cv8/scripts /1c_scripts
mkdir -p /1c_dir/activation && ln -s /1c_dir/activation /1c_activation
