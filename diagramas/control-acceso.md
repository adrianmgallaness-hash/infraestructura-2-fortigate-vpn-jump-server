# Flujo lógico de acceso

```mermaid
flowchart TD
    U["Clientes Ubuntu: VLAN 10"] -->|"VPN IKEv2 / PSK"| F["FortiGate"]
    F -->|"HTTPS / RDP, solo .130"| J["Jump: RemoteApp y Web Client"]
    J -->|"HTTPS: Caja"| W["Web .138"]
    J -->|"SSH y RDP: soporte"| W
    J -->|"AD y DNS en la LAN"| D["DC .131"]
    N["usuario2139 en Jump"] -->|"Windows Firewall: bloquea TCP/22"| B["SSH denegado"]
```

La identidad se evalúa en RDS/Windows. FortiGate restringe el destino y los servicios. La VPN no da acceso directo a DC ni Web. El flujo AD/DNS entre Jump y DC es local a su LAN.
