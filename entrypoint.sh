#!/bin/bash

# Script de entrada para Asterisk MovilCom
# Configuración automática y inicio del servicio

set -e

echo "�� Iniciando Asterisk MovilCom..."

# Verificar que los archivos de configuración existen
if [ ! -f /etc/asterisk/pjsip.conf ]; then
    echo "❌ Error: No se encontró pjsip.conf"
    exit 1
fi

if [ ! -f /etc/asterisk/extensions.conf ]; then
    echo "❌ Error: No se encontró extensions.conf"
    exit 1
fi

# Establecer permisos correctos
chown -R asterisk:asterisk /etc/asterisk
chown -R asterisk:asterisk /var/log/asterisk
chown -R asterisk:asterisk /var/lib/asterisk
chown -R asterisk:asterisk /var/spool/asterisk

echo "✅ Configuración verificada"
echo "✅ Permisos establecidos"

# Mostrar información del sistema
echo "📋 Información del sistema:"
echo "   - Asterisk Version: $(asterisk -V)"
echo "   - Configuración PJSIP: ✅"
echo "   - Puerto SIP: 5060"
echo "   - Puertos RTP: 10000-10020"

# Iniciar Asterisk en modo foreground
echo "🎯 Iniciando Asterisk..."
exec asterisk -f -U asterisk -G asterisk
