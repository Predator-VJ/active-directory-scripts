<#
.SYNOPSIS
 Generates a comprehensive group membership report from Active Directory.
.DESCRIPTION
 Retrieves all security and distribution groups with their members,
 member counts, OU paths, and group scopes.
.PARAMETER GroupType
 Filter by group type: Security, Distribution, or All. Default: All
.PARAMETER SearchBase
 Optional OU or container path to search within.
.PARAMETER ExportPath
 Path for CSV output file. Default: .\ad-group-report.csv
.EXAMPLE
 .\Get-ADGroupReport.ps1
.EXAMPLE
 .\Get-ADGroupReport.ps1 -GroupType "Security" -ExportPath "C:\Reports\security-groups.csv"
.NOTES
 Requires ActiveDirectory module. Run as Administrator.
#>

param(
    [ValidateSet("Security", "Distribution", "All")]
    [string]$GroupType = "All",
    [string]$SearchBase = "",
    [string]$ExportPath = ".\ad-group-report.csv"
)

Import-Module ActiveDirectory -ErrorAction Stop

Write-Host "Gathering Active Directory group report..." -ForegroundColor Cyan

# Build group filter based on type
$groupFilter = "*"
if ($GroupType -eq "Security") {
    $groupFilter = "GroupCategory -eq 'Security'"
} elseif ($GroupType -eq "Distribution") {
    $groupFilter = "GroupCategory -eq 'Distribution'"
}

Write-Host "Searching for $GroupType groups..." -ForegroundColor Yellow
$groups = Get-ADGroup -Filter $groupFilter -SearchBase $SearchBase
Write-Host "Found $($groups.Count) groups." -ForegroundColor Green

$groupReport = @()

foreach ($group in $groups) {
    $groupName = $group.Name
    $groupDN = $group.DistinguishedName
    $groupScope = $group.GroupScope
    $category = $group.GroupCategory
    $ou = ($groupDN -split ',DC=')[1] -replace '^,', ''

    $members = Get-ADGroupMember -Identity $group -ErrorAction SilentlyContinue
    $memberCount = $members.Count

    # Get direct members only
    $directMembers = $members | Where-Object { $_.DistinguishedName -eq $group.DistinguishedName } -ne $true

    $groupReport += [PSCustomObject]@{
        GroupName            = $groupName
        GroupScope           = $groupScope
        Category             = $category
        DistinguishedName    = $groupDN
        OU                   = $ou
        MemberCount          = $memberCount
        IsNested             = if ($memberCount -gt 0) { "Yes" } else { "No" }
    }
}

# Display summary
$securityGroups = $groupReport | Where-Object { $_.Category -eq "Security" }
$distributionGroups = $groupReport | Where-Object { $_.Category -eq "Distribution" }

Write-Host ""
Write-Host "=== Group Summary ===" -ForegroundColor Cyan
Write-Host "Security Groups: $($securityGroups.Count)"
Write-Host "Distribution Groups: $($distributionGroups.Count)"
Write-Host "Total Groups: $($groupReport.Count)" -ForegroundColor Green

# Show groups with most members
Write-Host ""
Write-Host "Top 10 Groups by Member Count:" -ForegroundColor Yellow
$groupReport | Sort-Object MemberCount -Descending | Select-Object GroupName, Category, MemberCount, GroupScope -First 10 | Format-Table -AutoSize

# Show groups with no members
$emptyGroups = $groupReport | Where-Object { $_.MemberCount -eq 0 }
if ($emptyGroups.Count -gt 0) {
    Write-Host ""
    Write-Host "Groups with no members ($($emptyGroups.Count) found):" -ForegroundColor Red
    $emptyGroups | Select-Object GroupName, Category, GroupScope | Format-Table -AutoSize
}

# Export to CSV
$groupReport | Sort-Object GroupName | Export-Csv -Path $ExportPath -NoTypeInformation -Encoding UTF8

Write-Host ""
Write-Host "Report exported to $ExportPath" -ForegroundColor Green
