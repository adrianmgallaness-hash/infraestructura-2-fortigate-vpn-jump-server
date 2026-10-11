# Configuraciones de referencia

Archivos reconstruidos a partir de la configuración conocida durante la práctica; no son salidas originales de show running-config. Se omiten parámetros no documentados y secretos. Revisar nombres de interfaz y configuración existente antes de aplicar.

- ISP.cfg: interfaces, DHCP, ruta upstream y NAT de usuarios.
- SW-LAN.cfg: VLAN 10 y puertos de acceso de clientes/ISP.
- SW-JUMP.cfg: VLAN 20 y puertos de acceso Jump/DC/FortiGate.
- ubuntu-usuario-ipsec.conf / ubuntu-soporte-ipsec.conf: perfiles de strongSwan documentados.
- ipsec.secrets.example: marcador para secreto local; nunca una PSK real.

FortiGate se documenta exclusivamente en la [guía GUI](../../docs/02-fortigate-gui.md).
