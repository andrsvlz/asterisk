#!/bin/bash

echo "🚀 PROBANDO DOCKERFILE CORREGIDO"

# Limpiar contenedor anterior
docker stop asterisk-movilcom-dockerfile 2>/dev/null || true
docker rm asterisk-movilcom-dockerfile 2>/dev/null || true

# Construir imagen corregida
echo "🔨 Construyendo imagen corregida..."
docker build -f Dockerfile.fixed -t asterisk-movilcom:fixed .

if [ $? -eq 0 ]; then
    echo "✅ Imagen construida exitosamente"
else
    echo "❌ Error construyendo la imagen"
    exit 1
fi

# Desplegar con volúmenes para persistencia
echo "🚀 Desplegando contenedor corregido..."
docker run -d \
    --name asterisk-movilcom-fixed \
    --network host \
    --privileged \
    --restart unless-stopped \
    -v asterisk-lib:/var/lib/asterisk \
    -v asterisk-logs:/var/log/asterisk \
    -v asterisk-spool:/var/spool/asterisk \
    asterisk-movilcom:fixed

# Esperar
echo "⏳ Esperando que Asterisk esté listo..."
sleep 30

# Verificar
echo "🔍 Verificando estado..."
if docker ps | grep -q asterisk-movilcom-fixed; then
    echo "✅ Contenedor funcionando correctamente"
    
    # Verificar registro PJSIP
    echo "🔍 Verificando registro PJSIP..."
    sleep 10
    docker exec asterisk-movilcom-fixed asterisk -rx "pjsip list registrations" || echo "⚠️  Registro aún no disponible"
    
else
    echo "❌ El contenedor no está funcionando"
    docker logs asterisk-movilcom-fixed
    exit 1
fi

echo ""
echo "🎉 DOCKERFILE CORREGIDO FUNCIONANDO"
echo "=================================="
echo "✅ Contenedor: asterisk-movilcom-fixed"
echo "✅ Imagen: asterisk-movilcom:fixed"
echo ""
echo "📞 Para hacer una llamada:"
echo "docker exec asterisk-movilcom-fixed asterisk -rx \"channel originate PJSIP/3005050149@mysipbk extension 100@default\""
echo ""
echo "🎯 SISTEMA LISTO CON DOCKERFILE"
