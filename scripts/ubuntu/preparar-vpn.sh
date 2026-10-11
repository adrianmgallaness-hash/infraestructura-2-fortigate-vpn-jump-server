#!/usr/bin/env bash
# Cuaderno de pasos documentados; copiar bloques, no ejecutar completo.
echo 'Abrir este archivo y ejecutar solo los pasos correspondientes al cliente.'
exit 1

sudo apt update
sudo apt install strongswan libstrongswan-standard-plugins libstrongswan-extra-plugins
# Copiar la plantilla segun cliente a /etc/ipsec.conf; crear el secreto localmente.
sudo nano /etc/ipsec.conf
sudo nano /etc/ipsec.secrets
sudo chmod 600 /etc/ipsec.secrets
# Agregar UNA sola vez, si no existe ya:
printf '\n10.21.39.130 JUMP-2139.infra2139.test\n' | sudo tee -a /etc/hosts
sudo ipsec restart
sudo ipsec up VPN-2139
sudo ipsec status
# Restaurar NIC a la red del proyecto antes de conectar, si se uso NAT temporal.
