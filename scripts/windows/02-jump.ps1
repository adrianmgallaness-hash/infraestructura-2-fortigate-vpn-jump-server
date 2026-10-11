# Cuaderno documentado/reconstruido para JUMP-2139. Ejecutar por bloques.
throw 'Abrir en editor; no ejecutar el cuaderno completo.'

hostname
Get-NetAdapter | Format-Table ifIndex,Name,Status
netsh interface ipv4 set address name="Ethernet0 2" source=static address=10.21.39.130 mask=255.255.255.248 gateway=10.21.39.129
Set-DnsClientServerAddress -InterfaceAlias 'Ethernet0 2' -ServerAddresses 10.21.39.131
Resolve-DnsName infra2139.test -Server 10.21.39.131 -DnsOnly

# Solo si no esta unido; reinicia.
Add-Computer -DomainName 'infra2139.test' -Credential 'INFRA2139\Administrador' -Restart

# Iniciar sesion como administrador del dominio antes de RDS.
whoami
Enable-PSRemoting -SkipNetworkProfileCheck -Force
Import-Module RemoteDesktop
$broker = 'JUMP-2139.infra2139.test'
New-RDSessionDeployment -ConnectionBroker $broker -WebAccessServer $broker -SessionHost $broker

# Receta para Gateway: solo si el rol aun no forma parte del despliegue.
# Esta linea documenta el requisito; confirmar estado con Get-RDServer antes de aplicar.
Get-RDServer -ConnectionBroker $broker
# Add-RDServer -Server $broker -Role RDS-GATEWAY -ConnectionBroker $broker -GatewayExternalFqdn $broker

# Crear coleccion una sola vez.
New-RDSessionCollection -CollectionName 'Caja2139' -SessionHost $broker -ConnectionBroker $broker -CollectionDescription 'Aplicaciones de la practica Infraestructura 2'
Set-RDSessionCollectionConfiguration -CollectionName 'Caja2139' -ConnectionBroker $broker -UserGroup 'INFRA2139\RDS-Web','INFRA2139\RDS-Admin'

# Requiere instaladores obtenidos y copiados previamente.
Start-Process -FilePath 'C:\Instaladores\Firefox Setup 157.0.1.exe' -ArgumentList '-ms' -Wait
New-Item -Path 'C:\Program Files\PuTTY' -ItemType Directory -Force
Copy-Item 'C:\Instaladores\putty.exe' 'C:\Program Files\PuTTY\putty.exe'

New-RDRemoteApp -CollectionName 'Caja2139' -ConnectionBroker $broker -Alias 'WebCaja' -DisplayName 'Sistema de Caja' -FilePath 'C:\Program Files\Mozilla Firefox\firefox.exe' -UserGroups 'INFRA2139\RDS-Web','INFRA2139\RDS-Admin' -CommandLineSetting Require -RequiredCommandLine '-new-window https://10.21.39.138'
New-RDRemoteApp -CollectionName 'Caja2139' -ConnectionBroker $broker -Alias 'PuTTY' -DisplayName 'PuTTY SSH' -FilePath 'C:\Program Files\PuTTY\putty.exe' -UserGroups 'INFRA2139\RDS-Admin' -CommandLineSetting DoNotAllow
New-RDRemoteApp -CollectionName 'Caja2139' -ConnectionBroker $broker -Alias 'RDP' -DisplayName 'RDP al servidor Web' -FilePath 'C:\Windows\System32\mstsc.exe' -UserGroups 'INFRA2139\RDS-Admin' -CommandLineSetting DoNotAllow

# Bloqueo explicito por identidad. Resolver SID, no copiar el SID de otro dominio.
$sid = ([System.Security.Principal.NTAccount]'INFRA2139\usuario2139').Translate([System.Security.Principal.SecurityIdentifier]).Value
New-NetFirewallRule -Name 'Bloquear-SSH-Usuario2139' -DisplayName 'Bloquear SSH para usuario2139' -Direction Outbound -Action Block -Protocol TCP -RemotePort 22 -Profile Any -LocalUser "D:(A;;CC;;;$sid)"

Get-RDRemoteApp -CollectionName 'Caja2139' -ConnectionBroker $broker | Format-Table Alias,DisplayName,UserGroups
Get-NetFirewallRule -Name 'Bloquear-SSH-Usuario2139' | Get-NetFirewallSecurityFilter | Format-List LocalUser

# Demostracion: abre OTRA consola con usuario normal; introducir clave interactivamente.
runas /user:INFRA2139\usuario2139 powershell.exe
# En la nueva consola: whoami; Test-NetConnection 10.21.39.138 -Port 22
