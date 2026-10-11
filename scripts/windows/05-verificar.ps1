# Consultas de solo lectura y conexiones TCP de prueba dentro del laboratorio.
param([ValidateSet('DC','Jump','Web')][string]$Rol = 'Jump')
Get-Date
hostname
whoami
Get-NetIPConfiguration
switch ($Rol) {
    'DC' {
        Get-ADDomain | Select-Object DNSRoot,NetBIOSName
        Get-ADUser usuario2139 | Select-Object SamAccountName,Enabled
        Get-ADUser soporte2139 | Select-Object SamAccountName,Enabled
        Get-ADGroupMember RDS-Web
        Get-ADGroupMember RDS-Admin
        Resolve-DnsName infra2139.test -Server 10.21.39.131 -DnsOnly
    }
    'Jump' {
        Get-RDRemoteApp -CollectionName 'Caja2139' -ConnectionBroker 'JUMP-2139.infra2139.test' | Format-Table Alias,DisplayName,UserGroups
        Get-NetFirewallRule -Name 'Bloquear-SSH-Usuario2139' | Format-List Name,Enabled,Direction,Action
        Get-NetFirewallRule -Name 'Bloquear-SSH-Usuario2139' | Get-NetFirewallSecurityFilter | Format-List LocalUser
        foreach ($puerto in 443,3389,22,445) {
            Test-NetConnection 10.21.39.138 -Port $puerto
        }
    }
    'Web' {
        Get-Service W3SVC,TermService,sshd
        Import-Module WebAdministration
        Get-WebBinding -Name 'Default Web Site' | Format-Table protocol,bindingInformation
        Get-NetFirewallRule -Name 'HTTPS-Desde-Jump','RDP-Desde-Jump','SSH-Desde-Jump' | Get-NetFirewallAddressFilter
    }
}
# Prueba por usuario: en una consola administrativa de Jump usar runas para abrir
# una consola como INFRA2139\usuario2139; alli ejecutar whoami y Test-NetConnection
# a .138 puerto 22 y 443. No ejecutar consultas administrativas RDS bajo esa cuenta.
