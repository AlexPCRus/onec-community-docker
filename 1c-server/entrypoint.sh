#!/bin/bash
# Запускаем сервер 1С от имени созданного пользователя
exec sudo -u usr1cv8 /opt/1cv8/x86_64/${PLATFORM_VERSION}/ragent -d /var/1C/1cv8 -port ${SERVER_PORT}
