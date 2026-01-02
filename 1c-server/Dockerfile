# Используем Ubuntu как базовый образ
FROM ubuntu:22.04

# Отключаем интерактивные вопросы при установке пакетов
ENV DEBIAN_FRONTEND=noninteractive

# Принимаем переменные окружения из .env или docker-compose
ARG PLATFORM_VERSION
ARG PLATFORM_ARCH
ARG SERVER_COMPONENTS

# Устанавливаем зависимости и создаём пользователя для запуска сервера
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    libgsf-1-114 \
    libglib2.0-0 \
    libgstreamer1.0-0 \
    sudo \
    net-tools \
    && rm -rf /var/lib/apt/lists/*

# Создаём системного пользователя usr1cv8, от имени которого будет работать сервер[citation:6]
RUN groupadd -g 1001 grp1cv8 && \
    useradd -u 1001 -g grp1cv8 --shell /bin/bash --create-home usr1cv8

# Копируем установщик 1С в контейнер (предполагается, что он лежит рядом с Dockerfile)
COPY /distr/setup-full-${PLATFORM_VERSION}-${PLATFORM_ARCH}.run /tmp/installer.run

# Устанавливаем платформу 1С в автоматическом режиме с выбранными компонентами
RUN chmod +x /tmp/installer.run && \
    /tmp/installer.run --mode unattended --enable-components ${SERVER_COMPONENTS} && \
    rm /tmp/installer.run

# Копируем скрипт для корректного запуска сервера
COPY /1c-server/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Создаём каталог для лицензий и настраиваем права
RUN mkdir -p /var/1C/licenses && \
    chown -R usr1cv8:grp1cv8 /var/1C && \
    chmod 777 /var/1C/licenses

# Открываем порты для сервера (основной и агента)
EXPOSE ${SERVER_PORT} ${SERVER_AGENT_PORT}

# Указываем скрипт запуска
ENTRYPOINT ["/entrypoint.sh"]
