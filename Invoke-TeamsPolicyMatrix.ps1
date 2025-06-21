

# ===========================================
# TEAMS POLICY MATRIX GENERATOR
# Author: Edgar Avellan
# ===========================================

Clear-Host
$host.ui.RawUI.WindowTitle = "Teams Policy Matrix by Edgar Avellan"

Write-Host @"
 _______                                      
|__   __|                                     
   | | ___  _ __ ___  ___  ___ ___  ___ _ __  
   | |/ _ \| '__/ _ \/ __|/ __/ _ \/ _ \ '_ \ 
   | | (_) | | |  __/\__ \ (_|  __/  __/ | | |
   |_|\___/|_|  \___||___/\___\___|\___|_| |_|

Microsoft Teams Policy Matrix • by Edgar Avellan
"@ -ForegroundColor Cyan

Write-Host "Welcome! Let's showcase how I learn, automate, and elevate teams." -ForegroundColor Yellow

# ===========================================
# STEP 0: Check Microsoft Teams Connection
# ===========================================
try {
    # Test if session is active
    Get-CsOnlineUser -ResultSize 1 -ErrorAction Stop | Out-Null
    Write-Host "`✅ Teams PowerShell session is already active." -ForegroundColor Green
} catch {
    Write-Host "`🔐 Connecting to Microsoft Teams..." -ForegroundColor Yellow
    try {
        Connect-MicrosoftTeams -ErrorAction Stop
        Write-Host "✅ Connected to Microsoft Teams." -ForegroundColor Green
    } catch {
        Write-Host "❌ Failed to connect. Please ensure you have Teams PowerShell Module and permissions." -ForegroundColor Red
        exit
    }
}
# ===========================================
# STEP 0: Ask user for domain
# ===========================================
$domainInput = Read-Host "Enter a known email domain (e.g., contoso.com)"
Write-Host "Preparing a policy snapshot for: $domainInput" -ForegroundColor Cyan
Start-Sleep -Seconds 2

# ===========================================
# STEP 1: Discover policy fields
# ===========================================
$TeamsCustomPolicyList = (Get-CsOnlineUser -ResultSize 1 |
    Get-Member -MemberType Properties |
    Where-Object { $_.Name -like "*Policy*" } |
    Select-Object -ExpandProperty Name)

$step1Export = "C:\Exports_Lab\Teams\Exports\Step1_Teams_PolicyFields.csv"
New-Item -ItemType Directory -Path (Split-Path $step1Export) -Force | Out-Null
$TeamsCustomPolicyList | Sort-Object | Set-Content -Encoding UTF8 -Path $step1Export
Write-Host "✅ Step 1: Found $($TeamsCustomPolicyList.Count) policy fields." -ForegroundColor Green

$policyCategoryMap = @{
    # Calling & Voice
    "TeamsCallingPolicy" = "Calling"
    "TeamsCallParkPolicy" = "Calling"
    "OnlineVoiceRoutingPolicy" = "Calling"
    "TeamsEmergencyCallingPolicy" = "Calling"
    "TeamsEmergencyCallRoutingPolicy" = "Calling"
    "TeamsSharedCallingRoutingPolicy" = "Calling"
    "TeamsSurvivableBranchAppliancePolicy" = "Calling"
    "TeamsVoiceApplicationsPolicy" = "Calling"
    "OnlineAudioConferencingRoutingPolicy" = "Calling"
    "OnlineDialOutPolicy" = "Calling"
    "OnlineVoicemailPolicy" = "Calling"
    
    # Meetings
    "TeamsMeetingPolicy" = "Meetings"
    "TeamsMeetingBroadcastPolicy" = "Meetings"
    "TeamsMeetingBrandingPolicy" = "Meetings"
    "TeamsMeetingTemplatePermissionPolicy" = "Meetings"
    "TeamsVideoInteropServicePolicy" = "Meetings"

    # Messaging
    "TeamsMessagingPolicy" = "Messaging"

    # Apps & Permissions
    "TeamsAppPermissionPolicy" = "Apps"
    "TeamsAppSetupPolicy" = "Apps"
    "ApplicationAccessPolicy" = "Apps"
    "TeamsTemplatePermissionPolicy" = "Apps"
    
    # Compliance
    "TeamsComplianceRecordingPolicy" = "Compliance"
    "TeamsFeedbackPolicy" = "Compliance"
    "TeamsUpdateManagementPolicy" = "Compliance"
    "TeamsEnhancedEncryptionPolicy" = "Compliance"

    # Devices
    "TeamsVdiPolicy" = "Devices"
    "TeamsIPPhonePolicy" = "Devices"
    "TeamsRoomVideoTeleConferencingPolicy" = "Devices"
    "TeamsByodAndDesksPolicy" = "Devices"

    # Location / Mobility
    "TeamsMobilityPolicy" = "Location"
    "TeamsWorkLocationDetectionPolicy" = "Location"
    "TeamsNetworkRoamingPolicy" = "Location"

    # Shifts
    "TeamsShiftsAppPolicy" = "Shifts"
    "TeamsShiftsPolicy" = "Shifts"

    # Other / Default catch-all
    "TeamsCortanaPolicy" = "Cortona"
    "TeamsNotificationAndFeedsPolicy" = "Other"
    "TeamsWorkLoadPolicy" = "Other"
    "TeamsChannelsPolicy" = "Channels"
    "TeamsEventsPolicy" = "Meetings"
    "TeamsUpgradePolicy" = "Upgrades"
    "ExternalAccessPolicy" = "External Access"
    "TeamsEducationAssignmentsAppPolicy" = "Education"
    "TeamsAiPolicy" = "Ai"
    "TeamsMediaLoggingPolicy" = "Meetings"
    "TeamsMediaConnectivityPolicy" = "Media Connectivity"
    "TeamsCallHoldPolicy" = "Calling"
}

# ===========================================
# STEP 2: Inventory each policy type
# ===========================================
$allPolicies = @()

foreach ($policyType in $TeamsCustomPolicyList) {
    $cmd = "Get-Cs$policyType"
    Write-Host "→ Running: $cmd" -ForegroundColor DarkCyan

    try {
        $results = Invoke-Expression $cmd
        foreach ($policy in $results) {
            $allPolicies += [PSCustomObject]@{
                PolicyType = $policyType
                PolicyName = $policy.Identity
            }
        }
        Write-Host "✔ $($results.Count) policies found." -ForegroundColor Gray
    } catch {
        Write-Warning "⚠ Skipped $cmd - may not exist or permission issue."
    }
}

# ===========================================
# STEP 3: Transform data into Matrix Format and Export (Sorted by Usage)
# ===========================================

# Group policies by their type
$grouped = $allPolicies | Group-Object PolicyType

# Determine the max number of rows needed
$maxLength = ($grouped | ForEach-Object { $_.Count } | Measure-Object -Maximum).Maximum

# Build a hashtable of policy types → padded arrays of policy names
$columns = @{ }
foreach ($group in $grouped) {
    $names = @($group.Group | Select-Object -ExpandProperty PolicyName)
    $padCount = [Math]::Max(0, $maxLength - $names.Count)
    $padding = 1..$padCount | ForEach-Object { '' }
    $columns[$group.Name] = $names + $padding
}

# Sort policy types by how many populated names they have (descending)
$sortedKeys = $columns.Keys | Sort-Object { ($columns[$_] | Where-Object { $_ -ne '' }).Count } -Descending

# Build matrix rows
$matrixTable = @()
for ($i = 0; $i -lt $maxLength; $i++) {
    $row = @{ }
    foreach ($col in $sortedKeys) {
        $row[$col] = $columns[$col][$i]
    }
    $matrixTable += [PSCustomObject]$row
}

# Add timestamp and generate CSV path
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$matrixExportPath = "C:\Exports_Lab\Teams\Exports\Step2_TeamsPolicyMatrix_$timestamp.csv"

# Ensure destination file is not locked
if (Test-Path $matrixExportPath) {
    try {
        Remove-Item $matrixExportPath -Force
    } catch {
        Write-Warning "⚠ Please close the file: $matrixExportPath"
        return
    }
}

# Export matrix
$matrixTable | Export-Csv $matrixExportPath -NoTypeInformation -Encoding UTF8
Write-Host "`n✅ Step 2 Complete: Exported matrix to:" -ForegroundColor Green
Write-Host $matrixExportPath -ForegroundColor DarkGray


# ===========================================
# STEP 4: Wrap Up
# ===========================================
Write-Host "Done. What you've just seen is my way of thinking." -ForegroundColor Yellow
Write-Host "Rather than memorize every syntax, I build systems to learn, automate, and scale." -ForegroundColor Yellow
Write-Host "This is how I would approach onboarding, audits, or unknown environments at scale." -ForegroundColor Cyan

Start-Sleep -Seconds 2
Start-Process $matrixExportPath

# ===========================================
# STEP 5: Summary by Category
# ===========================================
$userInput = Read-Host "`Would you like a summary grouped by Teams service category? (Y/N)"

if ($userInput -match "^(Y|y)$") {
    $categorized = $allPolicies | ForEach-Object {
        $category = $policyCategoryMap[$_.PolicyType]
        if (-not $category) { $category = "Uncategorized" }
        [PSCustomObject]@{
            Category    = $category
            PolicyType  = $_.PolicyType
            PolicyName  = $_.PolicyName
        }
    }

    # Count by Category + PolicyType
    $summary = $categorized | Group-Object Category | ForEach-Object {
        [PSCustomObject]@{
            Category = $_.Name
            TotalPolicies = $_.Group.Count
            DistinctPolicyTypes = ($_.Group | Select-Object -ExpandProperty PolicyType -Unique).Count
        }
    }

    $summaryPath = "C:\Exports_Lab\Teams\Exports\Step3_TeamsPolicyCategorySummary.csv"
    $summary | Export-Csv $summaryPath -NoTypeInformation -Encoding UTF8

    Write-Host "`✅ Summary generated → $summaryPath" -ForegroundColor Green
    Start-Process $summaryPath
} else {
    Write-Host "Skipped category summary." -ForegroundColor DarkGray
}

# Ask viewer if they want to display the report in the console
$displayMatrix = Read-Host "`Would you like to view the matrix in this window? (Y/N)"
if ($displayMatrix -match '^[Yy]') {
    Write-Host "🖥 Displaying Teams Policy Matrix (limited to first 20 rows for readability):" -ForegroundColor Cyan
    $summary
} else {
    Write-Host "`✅ Matrix saved to:" -ForegroundColor Green
    Write-Host $matrixExportPath -ForegroundColor DarkGray
}

