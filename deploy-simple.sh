#!/bin/bash
echo "🚀 DESPLEGANDO ASTERISK MOVILCOM"
docker run -d --name asterisk-movilcom --network host --privileged --restart unless-stopped debian:bullseye-slim bash -c "apt-get update && apt-get install -y asterisk asterisk-modules && mkdir -p /var/lib/asterisk /var/log/asterisk /var/spool/asterisk && asterisk -f"
sleep 60
echo "✅ Asterisk desplegado. Configurando..."
