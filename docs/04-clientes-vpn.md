# Ubuntu: VPN y operación

## Clientes observados

| Equipo | IP DHCP observada | Identidad IPsec | IP virtual observada |
|---|---|---|---|
| pc-usuarios-1 | 10.21.39.10/25 | usuario2139 | 10.21.39.200 |
| pc-usuarios-2 | 10.21.39.11/25 | soporte2139 | 10.21.39.201 |

Las asignaciones pueden variar al reconectar. Ambos usan VLAN 10 y gateway `10.21.39.1`.

## Instalación y archivos

Se instalaron `strongswan`, `libstrongswan-standard-plugins` y `libstrongswan-extra-plugins`. Para descargar paquetes se usó NAT temporalmente y después se restituyó la NIC a la red de usuarios del proyecto GNS3.

Copiar la plantilla correspondiente a `/etc/ipsec.conf`:

- [Usuario normal](../configs/referencia/ubuntu-usuario-ipsec.conf)
- [Soporte](../configs/referencia/ubuntu-soporte-ipsec.conf)

Configurar `/etc/ipsec.secrets` localmente a partir del [ejemplo sin secretos](../configs/referencia/ipsec.secrets.example). La PSK debe coincidir con la del FortiGate; no publicarla. Permisos `600`.

Agregar a `/etc/hosts` de cada cliente:

```text
10.21.39.130 JUMP-2139.infra2139.test
```

La configuración usa `auto=add`; después de reiniciar el servicio o el cliente, iniciar explícitamente la conexión cuando sea necesario:

```bash
sudo ipsec restart
sudo ipsec up VPN-2139
sudo ipsec status
```

No reiniciar el servicio mientras se graba una sesión RemoteApp activa. La VPN debe mostrar IKE/CHILD SA establecida, con destino `10.21.39.130/32`.

![VPN usuario](../evidencias/02-vpn-usuario.png)

![VPN soporte](../evidencias/03-vpn-soporte.png)

## Acceso al Web Client

En Firefox usar la URL completa:

```text
https://JUMP-2139.infra2139.test/RDWeb/webclient/index.html
```

Usuario normal `INFRA2139\usuario2139`; soporte `INFRA2139\soporte2139`. Estas credenciales son distintas de la PSK VPN y de la contraseña local de WEB-2139.

Si el certificado autofirmado genera advertencia, comprobar que corresponde al certificado del Jump del laboratorio antes de confiar en él. El certificado del sitio Caja es independiente.

## Incidencia posterior: “Unable to connect”

Tras las pruebas exitosas se recibió una captura con el Web Client inaccesible. No se recibió un resultado posterior que confirme su recuperación. No confundir ese fallo de transporte con un rechazo de contraseña.

Secuencia breve de diagnóstico:

```bash
ip -4 -br a
ip route
sudo ipsec status
getent hosts JUMP-2139.infra2139.test
nc -vz -w 3 10.21.39.130 443
```

1. Verificar que ISP, FortiGate, Jump y DC estén encendidos y que la NIC Ubuntu haya vuelto a la red de laboratorio.
2. Si no hay túnel, `sudo ipsec up VPN-2139` y repetir la prueba al puerto 443.
3. Si funciona por IP pero el nombre no resuelve a `.130`, revisar `/etc/hosts`.
4. Si el túnel está establecido pero TCP/443 falla, revisar en GUI los logs/política VPN-SOLO-JUMP y en Jump el servicio IIS y el binding HTTPS.
5. Si se presenta el login pero falla la autenticación, revisar credenciales de dominio, DNS de Jump hacia DC y hora de los equipos.

Comandos de observación: [Ubuntu](../scripts/ubuntu/verificar.sh). No se debe modificar indiscriminadamente las políticas funcionales para corregir un túnel desconectado.
