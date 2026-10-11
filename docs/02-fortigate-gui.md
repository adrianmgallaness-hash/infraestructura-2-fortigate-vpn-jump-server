# FortiGate: configuración y demostración por GUI

Toda modificación y demostración del FortiGate se realiza desde su interfaz gráfica. No se incluye un script CLI para aplicar su configuración.

## 1. Interfaces y ruta

En **Network → Interfaces**, configurar:

| Puerto | Alias | Dirección | Rol |
|---|---|---|---|
| port1 | WAN-ISP | 203.0.113.2/30 | WAN |
| port2 | LAN-JUMP | 10.21.39.129/29 | LAN |
| port3 | LAN-WEB | 10.21.39.137/29 | LAN |

El DHCP de usuarios reside en ISP, no en estas LAN. En **Network → Static Routes** crear la ruta `0.0.0.0/0`, gateway `203.0.113.1`, interfaz port1.

El acceso administrativo utilizado en el laboratorio fue `http://203.0.113.2`, debido al problema TLS de la VM de evaluación. Debe permanecer dentro del entorno controlado del laboratorio. La GUI de administración y el portal HTTPS del Jump son servicios diferentes.

## 2. Objetos

En **Policy & Objects → Addresses**:

| Nombre | Tipo | Dirección | Interfaz |
|---|---|---|---|
| JUMP-2139 | Subnet | 10.21.39.130/32 | LAN-JUMP / port2 |
| WEB-2139 | Subnet | 10.21.39.138/32 | LAN-WEB / port3 |

Usar /32 evita que el objeto del Jump incluya también al DC.

## 3. VPN IPsec de acceso remoto

En **VPN → IPsec Tunnels**, crear/editar un túnel personalizado `VPN-2139`:

| Parámetro | Configuración documentada |
|---|---|
| Remote Gateway | Dialup User |
| Interfaz | port1 / WAN-ISP |
| IKE | Versión 2 |
| Autenticación | Pre-shared key, mantenida fuera del repositorio |
| Peer ID | Accept any peer ID |
| Mode Config | Activado |
| Pool IPv4 | 10.21.39.200–10.21.39.210 |
| Máscara de clientes | 255.255.255.255 |
| Split tunnel IPv4 | Activado; red accesible JUMP-2139 /32 |
| DNS del túnel | Sin proporcionar acceso al DNS del DC; resolución local en Ubuntu |
| NAT Traversal | Enable |
| DPD | On Demand |
| Propuesta fase 1 | DES / SHA1, DH 14, 86400 segundos |
| Selector local fase 2 | 10.21.39.130/32 |
| Selector remoto fase 2 | 0.0.0.0/0 para clientes dialup |
| Propuesta fase 2 | DES / SHA1, PFS desactivado, 3600 segundos |

Los selectores efectivos observados en cada cliente son `.200/32 === .130/32` y `.201/32 === .130/32`. La combinación de selector /32 y política impide ampliar el acceso al resto de servidores.

**Alcance criptográfico:** DES/SHA1 refleja la negociación del entorno evaluativo. No equivale a una recomendación de seguridad actual. La PSK autentica el túnel; `usuario2139` y `soporte2139` se autentican por separado contra Active Directory en el Web Client. No se configuró autenticación VPN individual por AD/EAP.

## 4. Políticas

En **Policy & Objects → Firewall Policy**:

| Nombre | Entrada → salida | Origen | Destino | Servicios | Acción | NAT |
|---|---|---|---|---|---|---|
| JUMP-A-WEB | port2 → port3 | JUMP-2139 | WEB-2139 | HTTPS, RDP, SSH | ACCEPT | Disabled |
| DENEGAR-RESTO-A-WEB | port2 → port3 | all | all | ALL | DENY | No aplica |
| VPN-SOLO-JUMP | VPN-2139 → port2 | all | JUMP-2139 | HTTPS, RDP | ACCEPT | Disabled |

Schedule `always`; registrar todo el tráfico. `JUMP-A-WEB` debe evaluarse antes que `DENEGAR-RESTO-A-WEB` dentro del mismo par de interfaces. Se mantiene la denegación implícita para el resto de tráfico no autorizado. No crear permisos WAN → LAN amplios.

![Políticas reales](../evidencias/01-politicas-fortigate.png)

## 5. Registro y comprobación

En **Log & Report → Forward Traffic** mostrar origen, destino, acción y Policy ID. Los registros aportados muestran tráfico de `.200` y `.201` hacia Jump bajo `VPN-SOLO-JUMP`, y denegaciones de Jump a Web bajo `DENEGAR-RESTO-A-WEB`.

![Registros reales](../evidencias/12-registros-fortigate.png)

Para asociar un registro con la prueba al puerto 445, seleccionar la fila y abrir **Details**, verificando Destination Port. La captura general no muestra el puerto y no se atribuye automáticamente cada denegación a SMB.

La GUI muestra una advertencia de reloj desincronizado. Antes de la grabación, revisar **System → Settings**, ajustar hora/zona horaria o sincronización disponible y comprobarla. Las marcas temporales de las VMs no deben usarse como una cronología exacta mientras persista esa diferencia.
