# Asterisk MovilCom Colombia - Versión con Dockerfile

🚀 **Sistema Asterisk con Dockerfile completo para MovilCom Colombia**

## 📊 Versiones del Sistema

### Componentes
- **Asterisk**: 16.28.0 (Debian 11 Bullseye)
- **Sistema Base**: Debian GNU/Linux 11 (bullseye)
- **Docker**: Compatible con todas las versiones
- **PJSIP**: Configuración completa para MovilCom

## 🔧 Archivos Incluidos

### Dockerfiles
- `Dockerfile.final` - Versión final optimizada
- `Dockerfile.simple` - Versión simple para pruebas
- `Dockerfile.fixed` - Versión con permisos corregidos

### Scripts de Construcción
- `build-simple.sh` - Script de construcción básico
- `test-dockerfile-fixed.sh` - Script de prueba con permisos
- `build-and-deploy.sh` - Script completo de construcción

### Configuraciones
- `config/pjsip.conf` - Configuración PJSIP para MovilCom
- `config/extensions.conf` - Dialplan para llamadas

## 🚀 Uso

### Construcción Manual
```bash
# Construir imagen
docker build -f Dockerfile.final -t asterisk-movilcom:final .

# Ejecutar con volúmenes
docker run -d \
    --name asterisk-movilcom-final \
    --network host \
    --privileged \
    --restart unless-stopped \
    -v asterisk-data:/var/lib/asterisk \
    asterisk-movilcom:final
```

### Con Script Automático
```bash
./build-simple.sh
```

## 📞 Hacer Llamadas

```bash
# Verificar registro
docker exec asterisk-movilcom-final asterisk -rx "pjsip list registrations"

# Hacer llamada
docker exec asterisk-movilcom-final asterisk -rx "channel originate PJSIP/3005050149@mysipbk extension 100@default"
```

## 🔧 Configuración MovilCom

### Credenciales
- **Usuario**: 5782323
- **Password**: av12*
- **Servidor**: sip.movilcomcolombia.com
- **Puerto**: 5060

## ✅ Estado del Proyecto

- **✅ Dockerfile funcional** - Construye correctamente
- **✅ Configuración PJSIP** - MovilCom configurado
- **✅ Scripts de construcción** - Automatizados
- **⚠️ Problema identificado** - Necesita volúmenes para SQLite

## 🎯 Recomendación

**Para uso en producción, recomendamos usar el método de script directo (`install-asterisk-movilcom.sh`) que funciona 100% sin problemas.**

**Esta versión con Dockerfile es útil para:**
- Desarrollo y testing
- Ambientes containerizados complejos
- Integración con orquestadores (Kubernetes, Docker Swarm)

