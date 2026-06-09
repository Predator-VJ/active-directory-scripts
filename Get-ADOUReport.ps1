<#
.SYNOPSIS
 Generates an Organizational Unit (OU) structure report from Active Directory.
.DESCRIPTION
 Lists all OUs with their distinguished names, counts of child objects
 (users, groups, computers), and protected-from-accidental-deletion status.
.PARAMETER SearchBase
 Optional OU or container path to search within.
.PARAMETER ExportPath
 Path for CSV output file. Default: .\ad-ou-report.csv
.EXAMPLE
 .\Get-ADOUReport.ps1
.EXAMPLE
 .\Get-ADOUReport.ps1 -ExportPath "C:\Reports\ou-structure.csv"
.NOTES
 Requires ActiveDirectory module. Run as Administrator.
#>

param(
    [string]$SearchBase = "",
    [string]$ExportPath = ".\ad-ou-report.csv"
)

Import-Module ActiveDirectory -ErrorAction Stop

Write-Host "Gathering Active Directory OU report..." -ForegroundColor Cyan

$allOUs = Get-ADOrganizationalUnit -Filter * -SearchBase $SearchBase -Properties ProtectedFromAccidentalDeletion
Write-Host "Found $($allOUs.Count) OUs." -ForegroundColor Green

$ouReport = @()

foreach ($ou in $allOUs) {
    $ouDN = $ou.DistinguishedName
    $enabledUsers = (Get-ADUser -Filter {Enabled -eq $true} -SearchBase $ouDN).Count
    $disabledUsers = (Get-ADUser -Filter {Enabled -eq $false} -SearchBase $ouDN).Count
    $totalUsers = $enabledUsers + $disabledUsers
    $groups = (Get-ADGroup -Filter * -SearchBase $ouDN).Count
    $computers = (Get-ADComputer -Filter * -SearchBase $ouDN).Count
    $protected = $ou.ProtectedFromAccidentalDeletion

    $ouReport += [PSCustomObject]@{
        OUPath               = $ouDN
        EnabledUsers         = $enabledUsers
        DisabledUsers        = $disabledUsers
        TotalUsers           = $totalUsers
        Groups               = $groups
        Computers            = $computers
        TotalChildObjects    = $totalUsers + $groups + $computers
        ProtectedFromDeletion = $protected
    }
}

# Display summary
$topOUs = $ouReport | Sort-Object TotalChildObjects -Descending
$unprotected = $ouReport | Where-Object { -not $_.ProtectedFromDeletion }

Write-Host ""
Write-Host "=== OU Summary ===" -ForegroundColor Cyan
Write-Host "Total OUs: $($ouReport.Count)" -ForegroundColor Green

Write-Host ""
Write-Host "Top 10 OUs by Total Child Objects:" -ForegroundColor Yellow
$topOUs | Select-Object OUPath, TotalUsers, Groups, Computers, TotalChildObjects | Format-Table -AutoSize

Write-Host "OUs NOT protected from accidental deletion ($($unprotected.Count) found):" -ForegroundColor Red
$unprotected | Select-Object OUPath, TotalChildObjects | Format-Table -AutoSize

# Export to CSV
$ouReport | Sort-Object TotalChildObjects -Descending | Export-Csv -Path $ExportPath -NoTypeInformation -Encoding UTF8

Write-Host ""
Write-Host "OU report exported to $ExportPath" -ForegroundColor Green
