# GSA

[![License](https://img.shields.io/badge/License-MIT-green)](https://github.com/richardhicks/gsa/blob/main/LICENSE)

PowerShell scripts and tools for administrators deploying, configuring, and troubleshooting Microsoft Entra Global Secure Access (GSA).

## Description

This repository is a collection of tools designed to help administrators working with Microsoft Entra Global Secure Access (GSA), Microsoft's Security Service Edge (SSE) solution. It includes scripts for optimizing and troubleshooting GSA components such as the Entra Private Network Connector. Additional tools will be added over time.

## Scripts

| Script                        | Description                                                                                             |
| ----------------------------- | ------------------------------------------------------------------------------------------------------- |
| `Set-PncDynamicPortRange.ps1` | Expands the dynamic port range for TCP and UDP on servers running the Microsoft Entra Private Network Connector |

### Set-PncDynamicPortRange.ps1

Servers running the Microsoft Entra Private Network Connector service (WAPCSvc) may exhaust the default Windows dynamic port range under heavy load, resulting in failed connections. This script expands the dynamic port range for both TCP and UDP over IPv4 and IPv6 to ports 10000-65535, increasing the number of available ephemeral ports.

The script first validates that the Entra Private Network Connector service is present and running and makes no changes otherwise. A server restart is required for the changes to take effect.

```
.\Set-PncDynamicPortRange.ps1
```

More information: [Preventing Port Exhaustion on Entra Private Network Connector Servers](https://directaccess.richardhicks.com/2025/11/11/preventing-port-exhaustion-on-entra-private-network-connector-servers/)

## Requirements

- Windows Server with the Microsoft Entra Private Network Connector installed.
- Administrative privileges (for scripts that modify server configuration or services).

## Author

**Richard Hicks** - [Richard M. Hicks Consulting, Inc.](https://www.richardhicks.com/)

- Website: <https://www.richardhicks.com/>
- GitHub: <https://github.com/richardhicks/gsa>
- X: [@richardhicks](https://x.com/richardhicks)

## License

This project is licensed under the [MIT License](https://github.com/richardhicks/gsa/blob/main/LICENSE).

## Copyright

© 2026 Richard M. Hicks Consulting, Inc. All rights reserved.
