# Video individual — máximo 10 minutos

Preparar GNS3, GUI FortiGate, clientes y consolas. Mantener rostro visible y voz audible. Mostrar fecha y hora al inicio; por ejemplo `date` en Ubuntu o `Get-Date` en Windows. No grabar contraseñas ni claves. La hora del host y de las VMs debe revisarse antes de grabar, porque la GUI mostró desincronización.

## Guion completo (objetivo: 7–8 minutos)

| Tiempo | Mostrar | Narración orientativa |
|---|---|---|
| 0:00–0:30 | Rostro, fecha/hora y topología GNS3 | “Soy Adrian Magallanes Feliz. Esta infraestructura controla el acceso remoto a Caja mediante VPN, Jump Server y permisos por usuario.” |
| 0:30–1:15 | GUI: Network → Interfaces y Static Routes | “El enlace ISP usa IP públicas simuladas. Jump y Web están en redes /29 separadas. El DC es auxiliar para autenticación.” |
| 1:15–2:00 | SW-LAN VLAN 10; ISP DHCP; IP de ambos Ubuntu | “Los clientes pertenecen a 10.21.39.0/25, reciben DHCP del ISP y usan el gateway .1.” |
| 2:00–2:45 | GUI: VPN → IPsec Tunnels; políticas; status de clientes | “Los túneles permiten solamente el destino Jump /32. Jump puede acceder al Web por HTTPS, RDP y SSH.” |
| 2:45–4:00 | Usuario normal: catálogo y venta en Caja; prueba SSH desde Jump con su identidad | “Solo tiene publicada Caja. La venta calcula el cambio, y SSH está bloqueado explícitamente para su usuario.” |
| 4:00–5:45 | Soporte: tres aplicaciones, PuTTY hostname, RDP hostname | “Soporte administra WEB-2139 a través de aplicaciones ejecutadas en Jump.” |
| 5:45–7:00 | Intentos directos Web/DC; Jump→Web445; GUI Forward Traffic | “Los accesos no autorizados fallan. Aquí se ven los permisos y las denegaciones registrados.” |
| 7:00–7:30 | Repositorio: documentación, imágenes, diagramas, scripts y exports | “La documentación registra la arquitectura, configuración y resultados de las pruebas.” |

No narrar instalación ni troubleshooting durante el video. Validar antes que el Web Client vuelva a funcionar; existe una incidencia de conexión posterior a las capturas exitosas.

## Lista rápida: comandos y GUI

1. GNS3: topología. Ubuntu: `date`.
2. FortiGate GUI: Network → Interfaces; Network → Static Routes.
3. SW-LAN:

```text
enable
show vlan brief
show interfaces status
```

4. ISP:

```text
show ip interface brief
show ip dhcp binding
show running-config | section ip dhcp
```

5. Ambos Ubuntu:

```bash
hostname
ip -4 -br a
ip route
sudo ipsec status
```

6. FortiGate GUI: VPN → IPsec Tunnels → VPN-2139; Policy & Objects → Firewall Policy. Mostrar JUMP-A-WEB, DENEGAR-RESTO-A-WEB y VPN-SOLO-JUMP.
7. Ubuntu 1, Firefox:

```text
https://JUMP-2139.infra2139.test/RDWeb/webclient/index.html
INFRA2139\usuario2139
```

Mostrar solo Caja. Agregar 2 arroces; cobrar 200; mostrar cambio 50.
8. Jump, consola administrativa:

```powershell
runas /user:INFRA2139\usuario2139 powershell.exe
```

En la nueva ventana:

```powershell
whoami
Test-NetConnection 10.21.39.138 -Port 22
Test-NetConnection 10.21.39.138 -Port 443
```

Esperado: SSH False, HTTPS True.
9. Ubuntu 2, misma URL; usuario `INFRA2139\soporte2139`. Mostrar tres aplicaciones.
10. PuTTY RemoteApp: `.138`, puerto 22, SSH. Usuario local `Administrador`, contraseña del Web. Ejecutar `hostname`, luego `exit`.
11. RDP RemoteApp: `.138`; cuenta `WEB-2139\Administrador`. En PowerShell ejecutar `hostname`. Cerrar ventana sin apagar Web.
12. Ubuntu 1 con VPN:

```bash
nc -vz -w 3 10.21.39.138 443
nc -vz -w 3 10.21.39.131 53
```

13. Jump, como administrador:

```powershell
Test-NetConnection 10.21.39.138 -Port 445
```

14. FortiGate GUI: Log & Report → Forward Traffic; mostrar reglas de permiso/denegación. Abrir Details para identificar puertos cuando corresponda.
15. Repositorio y cierre. Revisar duración ≤10 minutos antes de publicar.
