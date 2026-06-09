# active-directory-scripts

A collection of PowerShell scripts for managing and automating Active Directory tasks including user management, group membership reporting, OU audits, stale account cleanup, and GPO management.

## Requirements

- PowerShell 5.1 or later
- ActiveDirectory module (`Install-WindowsFeature RSAT-AD-PowerShell` on Windows Server)
- Domain admin or delegated permissions

## Installation

```powershell
# Install RSAT AD PowerShell tools
Install-WindowsFeature RSAT-AD-PowerShell

# Clone the repository
git clone https://github.com/Predator-VJ/active-directory-scripts.git

# Navigate to the directory
cd active-directory-scripts

# Import Active Directory module
Import-Module ActiveDirectory
```

## Scripts

### 1. Get-ADUserReport.ps1
Generates a comprehensive Active Directory user report.

**Features:**
- Lists all AD users with properties (name, UPN, email, last logon, etc.)
- Exports to CSV or on-screen display
- Filters enabled/disabled accounts
- Shows account lockout status

**Usage:**
```powershell
# Generate full user report
.\Get-ADUserReport.ps1

# Generate for specific OU
.\Get-ADUserReport.ps1 -SearchBase "OU=Users,DC=domain,DC=local"
```

### 2. Get-ADGroupReport.ps1
Generates Active Directory group membership reports.

**Features:**
- Lists AD groups with member counts
- Shows nested group memberships
- Exports to CSV
- Filter by group type or OU

**Usage:**
```powershell
# List all groups
.\Get-ADGroupReport.ps1
```

### 3. Get-ADOUReport.ps1
Generates an OU structure report with child object counts.

**Features:**
- Maps OU hierarchy
- Shows object counts per OU
- Exports to CSV
- Color-coded output

**Usage:**
```powershell
# Generate OU structure report
.\Get-ADOUReport.ps1
```

## README

This project uses an MIT license. See the LICENSE file for details.

## Contributing

Contributions are welcome! Feel free to submit issues, feature requests, or pull requests.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Author

Maintained by Predator-VJ

---
*For questions or issues, please open a GitHub issue.*
