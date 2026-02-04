FROM ubuntu:22.04 AS base_image
LABEL authors="Alexander Myasnikov"

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    # Основные утилиты и шрифты \
    libfreetype6 \
    libgsf-1-common \
    libfreetype6 \
    libglib2.0-0 \
    libgstreamer1.0-0 \
    net-tools \
    iproute2 \
    gosu \
    language-pack-ru \
    locales \
    ttf-mscorefonts-installer \
    # GUI библиотеки для активации лицензии на сервере :)
    libcups2 \
    libx11-6 \
    libxext6 \
    libxrender1 \
    libxtst6 \
    libxi6 \
    libxinerama1 \
    libxrandr2 \
    libatk1.0-0 \
    libgtk-3-0 \
    libwebkit2gtk-4.0-37 \
    libglu1-mesa \
    xvfb \
    && rm -rf /var/lib/apt/lists/*

RUN fc-cache -fv

RUN sed -i 's/# ru_RU.UTF-8 UTF-8/ru_RU.UTF-8 UTF-8/' /etc/locale.gen && locale-gen ru_RU.UTF-8

ENV LANG=ru_RU.UTF-8 LANGUAGE=ru_RU:ru LC_ALL=ru_RU.UTF-8

FROM base_image
LABEL authors="Alexander Myasnikov"

ARG PLATFORM_VERSION
ARG PLATFORM_ARCH=x86_64
ARG SERVER_COMPONENTS=client_thin_fib,server,server_admin,ws,liberica_jre,ru

ENV DEV_LOGIN=login DEV_PASSWORD=password

COPY /distr/setup-full-${PLATFORM_VERSION}-${PLATFORM_ARCH}.run /tmp/installer.run

RUN chmod +x /tmp/installer.run && \
    /tmp/installer.run --mode unattended --enable-components ${SERVER_COMPONENTS} && \
    rm /tmp/installer.run

EXPOSE 1540 1541 1545 1560-1591

ENV COMMUNITY_LICENSE_ACTIVATOR=ActivateCommunity.epf
ENV PLATFORM_VERSION=$PLATFORM_VERSION PLATFORM_ARCH=$PLATFORM_ARCH

COPY /1c-server/*.sh /opt/1cv8/scripts/
RUN chmod +x /opt/1cv8/scripts/*.sh && /opt/1cv8/scripts/init_symlinks.sh

COPY /${COMMUNITY_LICENSE_ACTIVATOR} /1c_activation

VOLUME /1c_conf /1c_licenses /1c_user_home

ENTRYPOINT ["/1c_scripts/entrypoint.sh"]
