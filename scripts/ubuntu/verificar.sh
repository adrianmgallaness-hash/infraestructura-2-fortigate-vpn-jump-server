#!/usr/bin/env bash
# Observacion y pruebas sobre el laboratorio propio; VPN debe estar conectada.
date
hostname
ip -4 -br a
ip route
sudo ipsec status
getent hosts JUMP-2139.infra2139.test
nc -vz -w 3 10.21.39.130 443
nc -vz -w 3 10.21.39.138 443
nc -vz -w 3 10.21.39.131 53
# Esperado: Jump443 funciona; Web443 y DC53 directos fallan.
