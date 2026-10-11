# Scripts y comandos utilizados

Las secuencias se organizaron a partir del historial compartido, eliminando contraseñas, repeticiones accidentales y errores de pegado. Los parámetros de red reflejan el estado documentado. Son cuadernos por etapas, **no un instalador automático probado**. Los archivos de configuración Windows incluyen un `throw` inicial para impedir que se ejecuten todas las etapas de una vez: abrirlos en un editor y seleccionar solo el bloque correspondiente, después de revisar la VM y los prerrequisitos.

| Archivo | Equipo / función |
|---|---|
| windows/01-dc.ps1 | IP, AD DS, bosque, grupos y usuarios |
| windows/02-jump.ps1 | IP, unión a dominio, RDS, RemoteApp y bloqueo SSH |
| windows/03-webclient-offline.ps1 | Descarga offline, certificados y publicación del Web Client |
| windows/04-web.ps1 | IIS HTTPS, RDP, OpenSSH y reglas locales |
| windows/05-verificar.ps1 | Consultas y pruebas TCP según rol |
| ubuntu/preparar-vpn.sh | Secuencia de instalación, hosts y conexión |
| ubuntu/verificar.sh | Estado de red, túnel y pruebas directas |

El código de Caja está en [web/index.html](../web/index.html). Los fragmentos Cisco están en [configs/referencia](../configs/referencia/README.md). FortiGate se configura por GUI, según el requisito.

Las contraseñas se solicitan interactivamente. No reutilizar contraseñas de ejemplo ni subir secretos. Las recetas de certificados reconstruyen el procedimiento conocido; no recuperan claves privadas del entorno original. Instalar roles o promover el DC solo en la etapa inicial, no repetir en servidores ya configurados.
