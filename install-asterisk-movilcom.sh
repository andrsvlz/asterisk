#!/bin/bash

# ASTERISK MOVILCOM COLOMBIA - INSTALACIÓN COMPLETA
# Funciona en cualquier equipo con Docker

echo "🚀 INSTALANDO ASTERISK MOVILCOM COLOMBIA"
echo "========================================"

# Verificar Docker
if ! command -v docker &> /dev/null; then
    echo "❌ Docker no está instalado. Instalando..."
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    sudo usermod -aG docker $USER
    echo "✅ Docker instalado. Reinicia la sesión y ejecuta el script nuevamente."
    exit 1
fi

# Limpiar contenedores anteriores
echo "🧹 Limpiando contenedores anteriores..."
docker stop asterisk-movilcom 2>/dev/null || true
docker rm asterisk-movilcom 2>/dev/null || true

# Desplegar Asterisk
echo "🚀 Desplegando Asterisk..."
docker run -d --name asterisk-movilcom \
  --network host \
  --privileged \
  --restart unless-stopped \
  debian:bullseye-slim bash -c "
    apt-get update && 
    DEBIAN_FRONTEND=noninteractive apt-get install -y asterisk asterisk-modules iputils-ping dnsutils &&
    mkdir -p /var/lib/asterisk /var/log/asterisk /var/spool/asterisk &&
    asterisk -f"

echo "⏳ Esperando que Asterisk esté listo..."
sleep 60

# Verificar que esté funcionando
if ! docker ps | grep -q asterisk-movilcom; then
    echo "❌ Error: El contenedor no está funcionando"
    exit 1
fi

echo "📋 Configurando PJSIP..."
# Configurar PJSIP
docker exec asterisk-movilcom bash -c 'cat > /etc/asterisk/pjsip.conf << "EOF"
[transport-udp]
type=transport
protocol=udp
bind=0.0.0.0:5060

[global]
type=global
max_forwards=70
user_agent=Asterisk-MovilCom

[mysipbk-auth]
type=auth
auth_type=userpass
username=5782323
password=av12*

[mysipbk-aor]
type=aor
contact=sip:sip.movilcomcolombia.com:5060
qualify_frequency=60

[mysipbk]
type=endpoint
context=celular
disallow=all
allow=ulaw
allow=alaw
allow=gsm
outbound_auth=mysipbk-auth
aors=mysipbk-aor
direct_media=no
dtmf_mode=rfc4733
from_user=5782323
from_domain=sip.movilcomcolombia.com
rtp_symmetric=yes
force_rport=yes
rewrite_contact=yes

[mysipbk-identify]
type=identify
endpoint=mysipbk
match=sip.movilcomcolombia.com

[mysipbk-reg]
type=registration
transport=transport-udp
outbound_auth=mysipbk-auth
server_uri=sip:sip.movilcomcolombia.com
client_uri=sip:5782323@sip.movilcomcolombia.com
contact_user=5782323
retry_interval=60
forbidden_retry_interval=600
expiration=3600
EOF'

echo "📋 Configurando dialplan..."
# Configurar Extensions
docker exec asterisk-movilcom bash -c 'cat > /etc/asterisk/extensions.conf << "EOF"
[general]
static=yes
writeprotect=no

[default]
exten => 100,1,Answer()
exten => 100,n,Playback(hello-world)
exten => 100,n,Hangup()

exten => _3XXXXXXXXX,1,Dial(PJSIP/${EXTEN}@mysipbk,60)
exten => _3XXXXXXXXX,n,Hangup()

[celular]
exten => _X.,1,Answer()
exten => _X.,n,Playback(hello-world)
exten => _X.,n,Hangup()
EOF'

echo "🔄 Reiniciando Asterisk..."
docker restart asterisk-movilcom
sleep 30

echo "🔍 Verificando registro..."
docker exec asterisk-movilcom asterisk -rx "pjsip list registrations"

echo ""
echo "🎉 INSTALACIÓN COMPLETADA"
echo "========================"
echo "✅ Contenedor: asterisk-movilcom"
echo "✅ Configuración: MovilCom Colombia"
echo ""
echo "📞 Para hacer una llamada:"
echo "docker exec -it asterisk-movilcom asterisk -rx \"channel originate PJSIP/3005050149@mysipbk extension 100@default\""
echo ""
echo "🎯 SISTEMA LISTO PARA USAR"
