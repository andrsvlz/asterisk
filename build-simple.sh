#!/bin/bash

echo "🚀 CONSTRUYENDO ASTERISK MOVILCOM CON DOCKERFILE"

# Limpiar contenedores anteriores
docker stop asterisk-movilcom-dockerfile 2>/dev/null || true
docker rm asterisk-movilcom-dockerfile 2>/dev/null || true

# Construir imagen
echo "🔨 Construyendo imagen..."
docker build -f Dockerfile.simple -t asterisk-movilcom:dockerfile .

if [ $? -eq 0 ]; then
    echo "✅ Imagen construida exitosamente"
else
    echo "❌ Error construyendo la imagen"
    exit 1
fi

# Desplegar
echo "🚀 Desplegando contenedor..."
docker run -d \
    --name asterisk-movilcom-dockerfile \
    --network host \
    --privileged \
    --restart unless-stopped \
    asterisk-movilcom:dockerfile

# Esperar
echo "⏳ Esperando que Asterisk esté listo..."
sleep 30

# Verificar
echo "🔍 Verificando estado..."
if docker ps | grep -q asterisk-movilcom-dockerfile; then
    echo "✅ Contenedor funcionando"
    
    # Verificar registro PJSIP
    echo "🔍 Verificando registro PJSIP..."
    sleep 10
    docker exec asterisk-movilcom-dockerfile asterisk -rx "pjsip list registrations" || echo "⚠️  Registro aún no disponible"
    
else
    echo "❌ El contenedor no está funcionando"
    docker logs asterisk-movilcom-dockerfile
    exit 1
fi

echo ""
echo "🎉 DESPLIEGUE CON DOCKERFILE COMPLETADO"
echo "======================================"
echo "✅ Contenedor: asterisk-movilcom-dockerfile"
echo "✅ Imagen: asterisk-movilcom:dockerfile"
echo ""
echo "📞 Para hacer una llamada:"
echo "docker exec asterisk-movilcom-dockerfile asterisk -rx \"channel originate PJSIP/3005050149@mysipbk extension 100@default\""
echo ""
echo "🎯 SISTEMA LISTO"
