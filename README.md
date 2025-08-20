# Asterisk MovilCom Colombia

Sistema Asterisk configurado para realizar llamadas salientes a través del proveedor MovilCom Colombia usando PJSIP.

## 🚀 Características

- ✅ **PJSIP configurado** para MovilCom Colombia
- ✅ **Registro automático** con credenciales
- ✅ **Llamadas salientes** a celulares y fijos
- ✅ **Network host** para acceso directo a la red
- ✅ **Docker Compose** para despliegue fácil
- ✅ **Healthcheck** integrado

## 📋 Requisitos

- Docker
- Docker Compose
- Credenciales válidas de MovilCom

## 🔧 Configuración

### 1. Clonar el repositorio
```bash
git clone <repository-url>
cd asterisk-movilcom
```

### 2. Configurar credenciales
Editar `config/pjsip.conf` y actualizar:
```ini
[mysipbk-auth]
type=auth
auth_type=userpass
username=TU_USUARIO
password=TU_PASSWORD
```

### 3. Desplegar con Docker Compose
```bash
docker-compose up -d
```

### 4. Verificar estado
```bash
docker-compose logs -f
docker exec -it asterisk-movilcom asterisk -rx "pjsip list registrations"
```

## 📞 Uso

### Realizar llamadas
```bash
# Llamada a celular
docker exec -it asterisk-movilcom asterisk -rx "channel originate PJSIP/3001234567@mysipbk extension 100@default"

# Llamada a fijo
docker exec -it asterisk-movilcom asterisk -rx "channel originate PJSIP/6012345678@mysipbk extension 100@default"
```

### Verificar registro
```bash
docker exec -it asterisk-movilcom asterisk -rx "pjsip show registrations"
```

### Ver logs
```bash
docker-compose logs -f asterisk-movilcom
```

## 🔍 Solución de problemas

### Verificar conectividad
```bash
ping sip.movilcomcolombia.com
```

### Habilitar debug
```bash
docker exec -it asterisk-movilcom asterisk -rx "pjsip set logger on"
docker exec -it asterisk-movilcom asterisk -rx "core set verbose 5"
```

### Reiniciar servicio
```bash
docker-compose restart
```

## 📁 Estructura del proyecto

```
asterisk-movilcom/
├── Dockerfile              # Imagen Docker
├── docker-compose.yml      # Configuración de servicios
├── entrypoint.sh           # Script de inicio
├── config/                 # Configuraciones Asterisk
│   ├── pjsip.conf         # Configuración PJSIP
│   ├── extensions.conf    # Dialplan
│   └── asterisk.conf      # Configuración general
├── logs/                  # Logs del sistema
└── README.md              # Este archivo
```

## 🌐 Puertos

- **5060/UDP**: SIP
- **10000-10020/UDP**: RTP

## 📝 Notas

- El contenedor usa `network_mode: host` para acceso directo a la red
- Las credenciales deben ser proporcionadas por MovilCom
- El sistema está optimizado para llamadas salientes

## 🤝 Contribuir

1. Fork el proyecto
2. Crear rama feature (`git checkout -b feature/nueva-funcionalidad`)
3. Commit cambios (`git commit -am 'Agregar nueva funcionalidad'`)
4. Push a la rama (`git push origin feature/nueva-funcionalidad`)
5. Crear Pull Request

## 📄 Licencia

Este proyecto está bajo la Licencia MIT.
