# Dockerfile para Asterisk con MovilCom Colombia
# Configuración optimizada para llamadas salientes

FROM debian:bullseye-slim

# Información del mantenedor
LABEL maintainer="steve@example.com"
LABEL description="Asterisk PJSIP configurado para MovilCom Colombia"
LABEL version="1.0"

# Variables de entorno
ENV DEBIAN_FRONTEND=noninteractive
ENV ASTERISK_VERSION=18.10.0

# Instalar dependencias
RUN apt-get update && apt-get install -y \
    asterisk \
    asterisk-modules \
    asterisk-config \
    asterisk-core-sounds-en \
    asterisk-core-sounds-es \
    curl \
    vim \
    net-tools \
    && rm -rf /var/lib/apt/lists/*

# Crear directorios necesarios
RUN mkdir -p /etc/asterisk \
    && mkdir -p /var/log/asterisk \
    && mkdir -p /var/lib/asterisk \
    && mkdir -p /var/spool/asterisk

# Copiar archivos de configuración
COPY config/ /etc/asterisk/

# Crear usuario asterisk si no existe
RUN useradd -r -d /var/lib/asterisk -s /bin/false asterisk || true

# Establecer permisos
RUN chown -R asterisk:asterisk /etc/asterisk \
    && chown -R asterisk:asterisk /var/log/asterisk \
    && chown -R asterisk:asterisk /var/lib/asterisk \
    && chown -R asterisk:asterisk /var/spool/asterisk

# Exponer puertos
EXPOSE 5060/udp 5060/tcp
EXPOSE 10000-10020/udp

# Script de entrada
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Comando por defecto
CMD ["/entrypoint.sh"]
