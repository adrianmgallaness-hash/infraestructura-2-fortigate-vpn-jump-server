# Running-configs y respaldo real

## FortiGate — recibido

[FortiGate-sanitizado.conf](FortiGate-sanitizado.conf) procede del respaldo real `Fortigate-1_7-0_0444_202610101945.conf` aportado por el estudiante. Conserva la configuracion y reemplaza contrasenas, PSK, claves privadas y credenciales cifradas por `[REDACTADO]`.

El [registro de procedencia](FortiGate-procedencia.json) contiene hashes SHA-256 y el numero de campos saneados. El archivo publicado sirve para revision documental; no debe importarse como respaldo de recuperacion sin restituir localmente los secretos. El original no se publica.

## Cisco — pendientes

- ISP-running-config.txt
- SW-LAN-running-config.txt
- SW-JUMP-running-config.txt

Los fragmentos de [referencia](../referencia/README.md) son reconstrucciones, no salidas originales de los equipos. Ver [procedimiento de exportacion](../../docs/07-entrega.md).
