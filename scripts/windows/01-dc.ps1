# Cuaderno de comandos documentados: ejecutar BLOQUES en DC-2139 como administrador.
throw 'Abrir en editor y ejecutar por etapas; no ejecutar todo el cuaderno.'

# 1. Confirmar equipo y adaptador activo antes de cambiar IP.
hostname
Get-NetAdapter | Format-Table ifIndex,Name,Status
netsh interface ipv4 set address name="Ethernet0 2" source=static address=10.21.39.131 mask=255.255.255.248 gateway=10.21.39.129
Set-DnsClientServerAddress -InterfaceAlias 'Ethernet0 2' -ServerAddresses 10.21.39.131

# 2. Solo instalacion inicial del DC. La promocion solicita clave DSRM y reinicia.
Install-WindowsFeature AD-Domain-Services,DNS -IncludeManagementTools
Install-ADDSForest -DomainName 'infra2139.test' -DomainNetbiosName 'INFRA2139' -InstallDns

# 3. Despues del reinicio.
Get-ADDomain | Select-Object DNSRoot,NetBIOSName
New-ADGroup -Name 'RDS-Web' -GroupScope Global -GroupCategory Security
New-ADGroup -Name 'RDS-Admin' -GroupScope Global -GroupCategory Security
$clave = Read-Host 'Contrasena para usuario2139' -AsSecureString
New-ADUser -Name 'Usuario 2139' -SamAccountName 'usuario2139' -UserPrincipalName 'usuario2139@infra2139.test' -AccountPassword $clave -Enabled $true
Add-ADGroupMember -Identity 'RDS-Web' -Members 'usuario2139'
$clave = Read-Host 'Contrasena para soporte2139' -AsSecureString
New-ADUser -Name 'Soporte 2139' -SamAccountName 'soporte2139' -UserPrincipalName 'soporte2139@infra2139.test' -AccountPassword $clave -Enabled $true
Add-ADGroupMember -Identity 'RDS-Admin' -Members 'soporte2139'

# 4. Recuperacion documentada de una cuenta creada pero deshabilitada por clave invalida.
# Solo si aplica, NO repetir New-ADUser para una cuenta existente.
$clave = Read-Host 'Nueva contrasena para soporte2139' -AsSecureString
Set-ADAccountPassword -Identity 'soporte2139' -Reset -NewPassword $clave
Enable-ADAccount -Identity 'soporte2139'
Get-ADUser soporte2139 | Select-Object SamAccountName,Enabled

# 5. Despues de reasignar IP por cambio de NIC.
Restart-Service DNS
ipconfig /registerdns
Restart-Service Netlogon
Resolve-DnsName infra2139.test -Server 10.21.39.131 -DnsOnly
