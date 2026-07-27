<#PSScriptInfo

.VERSION 1.0

.GUID 90129629-3ed2-49ac-8864-743601f1d2e9

.AUTHOR Richard Hicks

.COMPANYNAME Richard M. Hicks Consulting, Inc.

.COPYRIGHT Copyright (C) 2026 Richard M. Hicks Consulting, Inc. All Rights Reserved.

.LICENSE Licensed under the MIT License. See LICENSE file in the project root for full license information.

.LICENSEURI <URL for license>

.PROJECTURI https://github.com/richardhicks/gsa/Set-PncDynamicPortRange.ps1

.TAGS Entra, PrivateNetworkConnector, PrivateAccess, GlobalSecureAccess, DynamicPortRange, ZTNA, ZeroTrust, TCP, UDP, IPv4, IPv6

#>

<#

.SYNOPSIS
    Expands the dynamic port range for TCP and UDP on servers running the Microsoft Entra Private Network Connector.

.DESCRIPTION
    Servers running the Microsoft Entra Private Network Connector service (WAPCSvc) may exhaust the default Windows
    dynamic port range under heavy load, resulting in failed connections. This script expands the dynamic port range
    for both TCP and UDP over IPv4 and IPv6 to ports 10000-65535, increasing the number of available ephemeral ports.

    The script first validates that the Entra Private Network Connector service is present and running and makes no
    changes otherwise. A server restart is required for the changes to take effect.

.INPUTS
    None. This script does not accept pipeline input.

.OUTPUTS
    None.

.EXAMPLE
    .\Set-PncDynamicPortRange.ps1

    Expands the dynamic port range for TCP and UDP over IPv4 and IPv6 if the Entra Private Network Connector service is present and running.

.LINK
    Link to online reference.

.NOTES
    Version:        1.0
    Creation Date:  July 27, 2026
    Last Updated:   July 27, 2026
    Author:         Richard Hicks
    Organization:   Richard M. Hicks Consulting, Inc.
    Contact:        rich@richardhicks.com
    Website:        https://www.richardhicks.com/

#>

[CmdletBinding()]

Param (


)

# Validate the Entra Private Network Connector service (WAPCSvc) is present and running
$Service = Get-Service -Name 'WAPCSvc' -ErrorAction SilentlyContinue

If ($Null -eq $Service) {

    Write-Warning 'The Microsoft Entra Private Network Connector service (WAPCSvc) is not installed on this server. No changes have been made.'
    Return

}

If ($Service.Status -ne 'Running') {

    Write-Warning "The Microsoft Entra Private Network Connector service (WAPCSvc) is not running (current status: $($Service.Status)). No changes have been made."
    Return

}

# Set dynamic port ranges for TCP and UDP protocols
$PortSettings = @(

    @{IpVersion = 'ipv4'; Protocol = 'tcp'}
    @{IpVersion = 'ipv4'; Protocol = 'udp'}
    @{IpVersion = 'ipv6'; Protocol = 'tcp'}
    @{IpVersion = 'ipv6'; Protocol = 'udp'}

)

$Failed = $False

ForEach ($Setting in $PortSettings) {

    Write-Verbose "Setting dynamic port range for $($Setting.Protocol.ToUpper()) over $($Setting.IpVersion.ToUpper())..."
    netsh.exe interface $Setting.IpVersion set dynamicportrange protocol=$($Setting.Protocol) startport=10000 numberofports=55535 | Out-Null

    If ($LASTEXITCODE -ne 0) {

        Write-Warning "Failed to set dynamic port range for $($Setting.Protocol.ToUpper()) over $($Setting.IpVersion.ToUpper()). Netsh.exe returned exit code $LASTEXITCODE."
        $Failed = $True

    }

}

If ($Failed) {

    Write-Warning 'One or more dynamic port range settings could not be applied. Review the warnings above and try again.'
    Return

}

Write-Output 'Dynamic port range settings updated successfully.'
Write-Warning 'The server must be restarted for these changes to take effect.'
