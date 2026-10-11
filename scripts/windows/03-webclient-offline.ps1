# Cuaderno por etapas; PC con Internet y luego JUMP. No ejecutar entero.
throw 'Seleccionar la etapa y el equipo correctos antes de ejecutar.'

# ETAPA A: PC Windows con Internet, PowerShell elevado.
New-Item -Path 'C:\WebClient' -ItemType Directory -Force
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Set-ExecutionPolicy -Scope Process -ExecutionPolicy RemoteSigned -Force
Install-PackageProvider -Name NuGet -Scope CurrentUser -Force
# Si PowerShellGet es demasiado antiguo: instalar 2.2.5 y abrir otra consola.
Install-Module PowerShellGet -RequiredVersion 2.2.5 -Scope CurrentUser -Force -AllowClobber
# En consola nueva, si son las versiones instaladas:
Import-Module PackageManagement -RequiredVersion 1.4.8.1 -Force
Import-Module PowerShellGet -RequiredVersion 2.2.5 -Force
Install-Module RDWebClientManagement -Scope CurrentUser -Force -AcceptLicense
Import-Module RDWebClientManagement
Save-RDWebClientPackage 'C:\WebClient'
Save-Module RDWebClientManagement -Path 'C:\WebClient' -AcceptLicense

# ETAPA B: copiar fisicamente C:\WebClient al JUMP antes de continuar alli.
Copy-Item 'C:\WebClient\RDWebClientManagement' 'C:\Program Files\WindowsPowerShell\Modules' -Recurse -Force
Import-Module RDWebClientManagement
# Ruta del ZIP observado. Esta receta requiere el paquete descargado, no se incluye en git.
Install-RDWebClientPackage -Source 'C:\WebClient\rdwebclient-2.1.85.0.zip'

# ETAPA C: receta de certificado de laboratorio. Reutilizar el certificado existente
# si ya esta desplegado; no sustituirlo sin coordinar confianza y bindings.
$broker = 'JUMP-2139.infra2139.test'
$claveCert = Read-Host 'Contrasena privada para proteger el PFX' -AsSecureString
$cert = New-SelfSignedCertificate -DnsName $broker -CertStoreLocation 'Cert:\LocalMachine\My' -KeyExportPolicy Exportable -KeyLength 2048 -HashAlgorithm SHA256 -Provider 'Microsoft RSA SChannel Cryptographic Provider' -NotAfter (Get-Date).AddYears(1)
Export-Certificate -Cert $cert -FilePath 'C:\WebClient\jump2139.cer'
Export-PfxCertificate -Cert $cert -FilePath 'C:\WebClient\jump2139.pfx' -Password $claveCert
Import-Certificate -FilePath 'C:\WebClient\jump2139.cer' -CertStoreLocation 'Cert:\LocalMachine\Root'
foreach ($rol in 'RDRedirector','RDPublishing','RDWebAccess','RDGateway') {
    Set-RDCertificate -Role $rol -ImportPath 'C:\WebClient\jump2139.pfx' -Password $claveCert -ConnectionBroker $broker -Force
}
Import-RDWebClientBrokerCert 'C:\WebClient\jump2139.cer'
Set-RDLicenseConfiguration -Mode PerUser -ConnectionBroker $broker -Force
# PerUser no instala CAL. Los roles RDS/Gateway deben existir previamente.
Publish-RDWebClientPackage -Type Production -Latest
Get-RDCertificate -ConnectionBroker $broker | Format-Table Role,Level,Thumbprint

# Incidencia documentada: CommitChanges en IIS fallo por cambio concurrente.
# Se reintento publicar; si se requiere retirar la publicacion, hacerlo solo
# como mantenimiento, no ejecutar estas lineas sobre sesiones activas.
# Unpublish-RDWebClientPackage -Type Production
# Publish-RDWebClientPackage -Type Production -Latest
