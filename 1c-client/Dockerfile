FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

ARG PLATFORM_VERSION
ARG PLATFORM_ARCH
ARG CLIENT_COMPONENTS

# Установка ВСЕХ необходимых зависимостей для графического клиента 1С
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    # GTK3 и базовые графические библиотеки
    libgtk-3-0 \
    libgtk2.0-0 \
    libgdk-pixbuf2.0-0 \
    libglib2.0-0 \
    # Для GTK модулей
    libcanberra-gtk3-module \
    libcanberra-gtk-module \
    packagekit-gtk3-module \
    # Для accessibility bus (предупреждение AT-SPI)
    at-spi2-core \
    # Для утилиты ip (замена net-tools)
    iproute2 \
    # OpenGL и графические библиотеки
    libglu1-mesa \
    mesa-utils \
    freeglut3 \
    libgl1-mesa-glx \
    libgl1-mesa-dri \
    libglapi-mesa \
    # Аудио/видео для отчетов
    libgstreamer1.0-0 \
    libgstreamer-plugins-base1.0-0 \
    gstreamer1.0-plugins-good \
    # Шрифты и локализация
    fonts-dejavu \
    fonts-dejavu-core \
    fonts-dejavu-extra \
    locales \
    ttf-mscorefonts-installer \
    # Системные утилиты для X11
    dbus-x11 \
    x11-utils \
    x11-xserver-utils \
    xauth \
    # Для работы с сетью и процессами
    net-tools \
    iputils-ping \
    curl \
    ca-certificates \
    # Дополнительные зависимости 1С
    libwebkit2gtk-4.0-37 \
    libatk-bridge2.0-0 \
    libcups2 \
    libpango-1.0-0 \
    && rm -rf /var/lib/apt/lists/*

# Настройка локали (обязательно для корректной работы 1С с русским интерфейсом)
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    sed -i -e 's/# ru_RU.UTF-8 UTF-8/ru_RU.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen en_US.UTF-8 ru_RU.UTF-8

# Создаем пользователя для запуска GUI приложения (важно для X11)
RUN useradd -m -s /bin/bash -u 1000 user && \
    mkdir -p /home/user/.1cv8/1C/1cv8/conf && \
    chown -R user:user /home/user

# Копируем установщик и устанавливаем
COPY /distr/setup-full-${PLATFORM_VERSION}-${PLATFORM_ARCH}.run /tmp/installer.run

RUN chmod +x /tmp/installer.run && \
    /tmp/installer.run --mode unattended \
        --enable-components ${CLIENT_COMPONENTS} \
        --installer-language ru && \
    rm /tmp/installer.run

# Создаем каталог для общих лицензий и симлинк
RUN mkdir -p /var/shared_licenses && \
    chmod 777 /var/shared_licenses && \
    ln -sf /var/shared_licenses /home/user/.1cv8/1C/1cv8/conf/licenses

# Переключаемся на непривилегированного пользователя
USER user
WORKDIR /home/user

# Команда запуска через shell для подстановки переменной
ENTRYPOINT ["sh", "-c", "/opt/1cv8/x86_64/${PLATFORM_VERSION}/1cv8"]
