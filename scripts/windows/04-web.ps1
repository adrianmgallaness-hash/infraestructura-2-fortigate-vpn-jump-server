# Cuaderno documentado para WEB-2139. Ejecutar por etapas como administrador.
throw 'Abrir en editor; no ejecutar el cuaderno completo.'
hostname
Get-NetAdapter | Format-Table ifIndex,Name,Status
netsh interface ipv4 set address name="Ethernet0 2" source=static address=10.21.39.138 mask=255.255.255.248 gateway=10.21.39.137

Install-WindowsFeature Web-Server -IncludeManagementTools
Import-Module WebAdministration
$certWeb = New-SelfSignedCertificate -Subject 'CN=WEB-2139' -TextExtension @('2.5.29.17={text}DNS=WEB-2139&IPAddress=10.21.39.138') -CertStoreLocation 'Cert:\LocalMachine\My' -NotAfter (Get-Date).AddYears(1)
New-WebBinding -Name 'Default Web Site' -Protocol https -Port 443 -IPAddress '*'
(Get-WebBinding -Name 'Default Web Site' -Protocol https -Port 443).AddSslCertificate($certWeb.Thumbprint, 'My')
Remove-WebBinding -Name 'Default Web Site' -Protocol http -Port 80
New-NetFirewallRule -Name 'HTTPS-Desde-Jump' -DisplayName 'HTTPS desde Jump' -Direction Inbound -Action Allow -Protocol TCP -LocalPort 443 -RemoteAddress 10.21.39.130 -Profile Any

Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server' -Name 'fDenyTSConnections' -Value 0
Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' -Name 'UserAuthentication' -Value 1
Start-Service TermService
New-NetFirewallRule -Name 'RDP-Desde-Jump' -DisplayName 'RDP desde Jump' -Direction Inbound -Action Allow -Protocol TCP -LocalPort 3389 -RemoteAddress 10.21.39.130 -Profile Any

# Instalador OpenSSH ya descargado en la VM. No se distribuye en este repositorio.
$p = Start-Process msiexec.exe -ArgumentList '/i C:\Instaladores\OpenSSH.msi ADDLOCAL=Server /passive /norestart' -Wait -PassThru
$p.ExitCode
Get-Service sshd
Set-Service -Name sshd -StartupType Automatic
Start-Service sshd
Get-NetFirewallRule -Direction Inbound -Action Allow |
    Where-Object { $_.Name -like '*ssh*' -or $_.DisplayName -like '*ssh*' } |
    Set-NetFirewallRule -RemoteAddress 10.21.39.130 -Profile Any
New-NetFirewallRule -Name 'SSH-Desde-Jump' -DisplayName 'SSH desde Jump' -Direction Inbound -Action Allow -Protocol TCP -LocalPort 22 -RemoteAddress 10.21.39.130 -Profile Any

# Copiar el HTML del repositorio a C:\inetpub\wwwroot\index.html.
# Ajustar ruta local del checkout antes de ejecutar:
# Copy-Item 'C:\ruta-del-repositorio\web\index.html' 'C:\inetpub\wwwroot\index.html'
Get-Item 'C:\inetpub\wwwroot\index.html' | Select-Object Name,Length
Get-WebBinding -Name 'Default Web Site' | Format-Table protocol,bindingInformation
# Si una regla ya existe, consultarla/editarla; no volver a crearla.
