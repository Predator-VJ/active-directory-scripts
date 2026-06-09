<div align="center">

<img src="https://capsule-render.vercel.app/api?type=waving&color=0:0d324d,50:7f5a83,100:0d324d&height=200&section=header&text=Active+Directory+Scripts&fontSize=60&fontColor=00d9ff&fontAlign=70&animation=fadeIn&fontAlignY=45&desc=PowerShell+scripts+for+AD+management+and+automation&descAlign=50&descSize=20"/></div>

<div align="center">

![PowerShell](https://img.shields.io/badge/PowerShell-5391FE?style=for-the-badge&logo=powershell&logoColor=white)
![Active Directory](https://img.shields.io/badge/Active+Directory-5C2D91?style=for-the-badge&logo=microsoft&logoColor=white)
![Windows Server](https://img.shields.io/badge/Windows+Server-0078D6?style=for-the-badge&logo=windows&logoColor=white)
![Scripts](https://img.shields.io/badge/Scripts-3-blueviolet?style=for-the-badge)
![Status](https://img.shields.io/badge/Status-Active-brightgreen?style=for-the-badge)
![License](https://img.shields.io/badge/License-MIT-yellow?style=for-the-badge)

</div>

<div align="center">
<a href="https://github.com/Predator-VJ/active-directory-scripts">
<img src="https://readme-typing-svg.demolab.com?font=JetBrains+Mono&weight=700&size=20&pause=1000&color=00d9ff&center=true&vCenter=true&multiline=false&width=435&lines=User+Management+Reports;Group+Membership+Audits;OU+Structure+Reports"/>
</a>
</div>

<br/>

---

## Script Arsenal

| Script | Description | Category |
|---|---|---|
| `Get-ADUserReport.ps1` | Comprehensive AD user report | Reporting |
| `Get-ADGroupReport.ps1` | Group membership & nesting | Auditing |
| `Get-ADOUReport.ps1` | OU structure & object counts | Hierarchy |

---

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

---

## Contributing

Contributions are welcome! Feel free to submit issues, feature requests, or pull requests.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Author

Maintained by Predator-VJ

---

<div align="center">
<img src="https://badges.pufler.dev/visits/Predator-VJ/active-directory-scripts"/>
</div>
