# Windows Server, identidades y aplicaciones

## DC-2139

Windows Server 2019, IP `10.21.39.131/29`, gateway `.129`, DNS a sí mismo. Roles AD DS y DNS; bosque `infra2139.test`, NetBIOS `INFRA2139`.

| Cuenta | Grupo de seguridad | Aplicaciones publicadas |
|---|---|---|
| usuario2139 | RDS-Web | Sistema de Caja |
| soporte2139 | RDS-Admin | Sistema de Caja, PuTTY SSH, RDP al servidor Web |

Las claves se introducen de forma interactiva y no se publican. La cuenta de soporte no se agrega a Domain Admins. El usuario local de Ubuntu y el usuario de dominio son identidades distintas; las pruebas de privilegios se refieren al usuario de dominio dentro de Jump.

Comandos utilizados: [DC](../scripts/windows/01-dc.ps1).

## JUMP-2139

IP `10.21.39.130/29`, gateway `.129`, DNS `.131`; unido al dominio. Consola de administración con `INFRA2139\Administrador`.

Roles del despliegue: RD Connection Broker, RD Web Access, RD Session Host y RD Gateway. Colección `Caja2139`, grupos autorizados `INFRA2139\RDS-Web` y `INFRA2139\RDS-Admin`.

| Alias | Ejecutable en Jump | Grupos |
|---|---|---|
| WebCaja | C:\Program Files\Mozilla Firefox\firefox.exe | Ambos |
| PuTTY | C:\Program Files\PuTTY\putty.exe | RDS-Admin |
| RDP | C:\Windows\System32\mstsc.exe | RDS-Admin |

`WebCaja` requiere la línea `-new-window https://10.21.39.138`. PuTTY y RDP se publicaron con parámetros de línea de comandos no permitidos; el destino se introduce en su GUI. Las aplicaciones se ejecutan en Jump, aunque se ven desde el navegador Ubuntu.

La publicación por grupos limita el catálogo RemoteApp. No se configura ni se afirma un bloqueo integral del escritorio mediante AppLocker; ocultar una aplicación no sustituye controles de ejecución. Para SSH existe una regla adicional independiente.

### Bloqueo explícito de SSH

Regla de Windows Firewall `Bloquear-SSH-Usuario2139`: salida, TCP, destino puerto 22, acción Block, todos los perfiles. `LocalUser` contiene el SID de `INFRA2139\usuario2139`, resuelto dinámicamente. El bloqueo se aplica a procesos de esa identidad en Jump y a todos los destinos TCP/22, incluidos los servidores.

Se probó en una consola creada con `runas` para el usuario normal: SSH a `.138` falla y HTTPS a `.138` funciona. Desde el perfil de soporte, PuTTY logra iniciar sesión en WEB-2139.

![Prueba por identidad](../evidencias/09-ssh-bloqueado-usuario.png)

### Web Client y certificados

URL: `https://JUMP-2139.infra2139.test/RDWeb/webclient/index.html`.

Módulo observado `RDWebClientManagement 1.0.4`; paquete `rdwebclient-2.1.85.0.zip`, obtenido en un equipo con Internet y copiado a Jump. Se importó el certificado del Broker y se publicó el paquete Production.

Se utilizó un certificado autofirmado para el FQDN de Jump en RDRedirector, RDPublishing, RDWebAccess y RDGateway. Los clientes deben confiar en el certificado de laboratorio. Los PFX y claves privadas no forman parte del repositorio.

Se solicitó modo RDS PerUser. No existe evidencia de servidor de licencias activado y CAL instaladas; la demostración se realizó en evaluación. La configuración exacta de CAP/RAP y el respaldo RDS deben conservarse en las exportaciones originales; no se inventan valores ausentes.

Comandos y secuencias: [Jump y RemoteApp](../scripts/windows/02-jump.ps1), [Web Client offline](../scripts/windows/03-webclient-offline.ps1).

## WEB-2139

Windows Server 2019; IP `10.21.39.138/29`, gateway `.137`. El Web se utiliza con cuenta local `WEB-2139\Administrador`; no se requiere unirlo al dominio para estas pruebas.

- IIS: sitio `Default Web Site`, HTTPS 443 con certificado autofirmado, binding HTTP 80 eliminado.
- Caja: `C:\inetpub\wwwroot\index.html`.
- RDP: activado, NLA habilitado y regla de entrada para `.130`.
- OpenSSH: instalado mediante MSI, servicio `sshd` automático; entrada TCP/22 limitada a `.130`.
- Reglas de Windows: `HTTPS-Desde-Jump`, `RDP-Desde-Jump`, `SSH-Desde-Jump`.

La restricción de red también se aplica en FortiGate. Una regla Allow limitada no anula otras reglas Allow amplias: una auditoría del firewall local debe revisar el conjunto efectivo, no solo las reglas nombradas.

Comandos: [Web](../scripts/windows/04-web.ps1).

## Sistema de Caja

Aplicación de demostración HTML/CSS/JavaScript, servida por IIS sobre HTTPS. Catálogo de arroz RD$75, leche RD$85 y pan RD$50; carrito, cantidades, total, cobro y cambio. El historial se guarda en `localStorage` del navegador que ejecuta la aplicación (Firefox en Jump). No hay servidor de base de datos, API de ventas ni persistencia central compartida.

![Venta realizada](../evidencias/05-caja-venta.png)

El [código publicado](../web/index.html) se reconstruye del contenido pegado durante la sesión; no es una extracción directa del disco de WEB-2139.
