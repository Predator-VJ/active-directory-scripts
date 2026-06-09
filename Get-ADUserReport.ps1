<#
.SYNOPSIS
 Generates a comprehensive user account report from Active Directory.
.DESCRIPTION
 Retrieves user account details including name, email, OU, enabled status,
 last logon date, password age, and group memberships.
.PARAMETER SearchBase
 Optional OU or container path to search within.
.PARAMETER ExportPath
 Path for CSV output file. Default: .\ad-user-report.csv
.EXAMPLE
 .\Get-ADUserReport.ps1
.EXAMPLE
 .\Get-ADUserReport.ps1 -SearchBase "OU=Users,DC=contoso,DC=com" -ExportPath "C:\Reports\users.csv"
.NOTES
 Requires ActiveDirectory module. Run as Administrator.
#>

param(
    [string]$SearchBase = "",
    [string]$ExportPath = ".\ad-user-report.csv"
)

Import-Module ActiveDirectory -ErrorAction Stop

Write-Host "Gathering Active Directory user report..." -ForegroundColor Cyan

$properties = @(
    "DistinguishedName", "SamAccountName", "GivenName", "Surname",
    "EmailAddress", "Enabled", "LastLogonDate", "PasswordLastSet",
    "PasswordNeverExpires", "LockedOut", "DistinguishedName"
)

Write-Host "Querying all enabled and disabled user accounts..." -ForegroundColor Yellow

$users = Get-ADUser -Filter * -Properties $properties -SearchBase $SearchBase

$totalUsers = $users.Count
$enabledUsers = ($users | Where-Object { $_.Enabled }).Count
$disabledUsers = $totalUsers - $enabledUsers

Write-Host "Total users: $totalUsers | Enabled: $enabledUsers | Disabled: $disabledUsers" -ForegroundColor Green

Write-Host "Processing user details..." -ForegroundColor Yellow

$report = $users | ForEach-Object {
    $ouPath = $_.DistinguishedName -replace '^(?:CN|OU|DC)=.*?,|^(?:CN|OU|DC)=', '' -replace '^DC=', 'DC='
    $passwordAge = if ($_.PasswordLastSet) { (New-TimeSpan -Start $_.PasswordLastSet -End (Get-Date)).Days } else { "N/A" }

    [PSCustomObject]@{
        SamAccountName   = $_.SamAccountName
        FullName         = "$($_.GivenName) $($_.Surname)".Trim()
        EmailAddress     = $_.EmailAddress
        OU               = ($_.DistinguishedName -split ',DC=')[1] -replace '^,', ''
        Enabled          = $_.Enabled
        LastLogonDate    = if ($_.LastLogonDate) { $_.LastLogonDate.ToString('yyyy-MM-dd HH:mm') } else { "Never" }
        PasswordLastSet  = if ($_.PasswordLastSet) { $_.PasswordLastSet.ToString('yyyy-MM-dd') } else { "Never" }
        PasswordAgeDays  = $passwordAge
        PasswordNeverExpires = $_.PasswordNeverExpires
        LockedOut        = $_.LockedOut
        DistinguishedName = $_.DistinguishedName
    }
}

# Display a quick summary of accounts with stale passwords
Write-Host ""
Write-Host "=== Account Summary ===" -ForegroundColor Cyan
Write-Host "Users with passwords older than 90 days:" -ForegroundColor Yellow
$report | Where-Object { $_.PasswordAgeDays -ne "N/A" -and $_.PasswordAgeDays -gt 90 } |
    Select-Object SamAccountName, FullName, PasswordAgeDays | Format-Table -AutoSize

Write-Host "Locked-out accounts:" -ForegroundColor Yellow
$report | Where-Object { $_.LockedOut } |
    Select-Object SamAccountName, FullName | Format-Table -AutoSize

Write-Host "Disabled accounts:" -ForegroundColor Yellow
$report | Where-Object { -not $_.Enabled } |
    Select-Object SamAccountName, FullName | Format-Table -AutoSize

# Export the full report to CSV
$report | Export-Csv -Path $ExportPath -NoTypeInformation -Encoding UTF8

Write-Host ""
Write-Host "Full report exported to $ExportPath" -ForegroundColor Green
