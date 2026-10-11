# Exportaciones y entrega

## Pendientes que requieren datos reales del laboratorio

- [x] [Video de Práctica 3 · Infraestructura 2](https://youtu.be/gYIoC38Pk3w), colocado al principio del README.
- [ ] Verificar video ≤10 minutos, con rostro, voz, fecha y hora.
- [ ] Confirmar matrícula completa para el TXT; número de práctica confirmado: P3.
- [ ] Incorporar ISP-running-config.txt, SW-LAN-running-config.txt y SW-JUMP-running-config.txt exportados de equipos reales.
- [x] Incorporar respaldo FortiGate recibido y saneado para publicación: [archivo](../configs/running-configs/FortiGate-sanitizado.conf).
- [ ] Confirmar recuperación de la incidencia posterior de acceso al Web Client.
- [ ] Agregar evidencia final de VLAN y concesiones DHCP a los dos clientes.

## Cisco: exportación real

En cada equipo, capturar la salida completa (sin paginación):

```text
enable
terminal length 0
show running-config
```

Guardar por separado en `configs/running-configs/`:

- `ISP-running-config.txt`
- `SW-LAN-running-config.txt`
- `SW-JUMP-running-config.txt`

Conservar una copia original privada. Antes de publicar, reemplazar secretos, hashes de contraseñas, SNMP community y material criptográfico por `[REDACTADO]`; indicar las redacciones. No reemplazar los exports por los fragmentos de `configs/referencia/`.

Para persistir cambios en Cisco:

```text
copy running-config startup-config
```

## FortiGate: exportación por GUI

En el menú del usuario administrador, abrir **Configuration → Backup**, seleccionar destino local y descargar el respaldo de la configuración. Si la versión presenta una opción de contraseña, conservar el respaldo cifrado de recuperación en privado; para el repositorio preparar una copia de texto saneada y legible.

Nombre sugerido: `configs/running-configs/FortiGate-sanitizado.conf`. Sustituir PSK, claves privadas, contraseñas (también valores ENC), tokens, secretos de usuarios/LDAP/RADIUS/SNMP y otros datos de autenticación. Nunca publicar PFX, claves privadas ni el archivo `/etc/ipsec.secrets` real. No es necesario usar la CLI del FortiGate para exportar.

Los valores de red y nombres de políticas del laboratorio se conservan para revisión. Anotar qué categorías se redactaron, sin revelar sus valores.

## Windows y Ubuntu

El repositorio incluye comandos organizados desde el historial y plantillas de configuración. Para reflejar el estado final, adjuntar salidas no sensibles de `Get-RDRemoteApp`, reglas de firewall y servicios; revisar antes de publicar. El script `scripts/windows/05-verificar.ps1` facilita estas consultas. De Ubuntu puede exportarse `ipsec.conf`, sin PSK, y resultados de `ipsec status`.

No subir discos VMDK/QCOW2, ISOs o instaladores de terceros. El código Caja sí está incluido. Si se entrega el proyecto GNS3, excluir imágenes de sistemas y comprobar que su configuración no contiene credenciales.

## Archivo TXT obligatorio

Usar exactamente el patrón del docente:

```text
<Nombre>_<Matrícula>_<P#>.txt
```

Para este estudiante, la parte del nombre puede ser `AdrianMagallanesFeliz`, sin espacios. El número de práctica confirmado es P3. Falta confirmar la matrícula completa; conocer el sufijo 2139 no basta para asumirla.

Contenido:

```text
Nombre: Adrian Magallanes Feliz
Matricula: COMPLETAR_MATRICULA
Practica: P3
Infraestructura: 2
Repositorio: https://github.com/adrianmgallaness-hash/infraestructura-2-fortigate-vpn-jump-server
Video: https://youtu.be/gYIoC38Pk3w
```

La plantilla `entregables/PLANTILLA_NO_ENTREGAR.txt` no es el entregable final. Cambiar contenido y nombre antes de subir a la plataforma. Mantener repositorio y video propios de Infraestructura 2.
