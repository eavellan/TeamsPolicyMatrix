

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


# ===========================
# STEP 1: Category Definitions
# ===========================
$policyCategoryMap = @{
    Messaging = @('Get-CsTeamsMessagingPolicy', 'Get-CsTeamsChannelsPolicy')
    Meetings = @('Get-CsTeamsMeetingPolicy', 'Get-CsTeamsMeetingBroadcastPolicy', 'Get-CsTeamsEventsPolicy', 'Get-CsTeamsMediaLoggingPolicy', 'Get-CsTeamsMeetingBrandingPolicy')
    Calling = @('Get-CsTeamsCallingPolicy', 'Get-CsOnlineVoiceRoutingPolicy', 'Get-CsTeamsCallParkPolicy', 'Get-CsTeamsSharedCallingRoutingPolicy', 'Get-CsOnlineDialOutPolicy')
    Devices = @('Get-CsTeamsIPPhonePolicy', 'Get-CsTeamsRoomVideoTeleConferencingPolicy', 'Get-CsTeamsByodAndDesksPolicy', 'Get-CsTeamsVdiPolicy')
    Security = @('Get-CsTeamsEnhancedEncryptionPolicy', 'Get-CsTeamsFeedbackPolicy', 'Get-CsTeamsComplianceRecordingPolicy', 'Get-CsTeamsUpdateManagementPolicy')
    Apps = @('Get-CsTeamsAppSetupPolicy', 'Get-CsTeamsAppPermissionPolicy', 'Get-CsApplicationAccessPolicy', 'Get-CsTeamsTemplatePermissionPolicy')
    Location = @('Get-CsTeamsWorkLocationDetectionPolicy', 'Get-CsTeamsMobilityPolicy', 'Get-CsTeamsNetworkRoamingPolicy')
    Shifts = @('Get-CsTeamsShiftsPolicy', 'Get-CsTeamsShiftsAppPolicy')
    Education = @('Get-CsTeamsEducationAssignmentsAppPolicy')
    ExternalAccess = @('Get-CsExternalAccessPolicy')
    Cortona = @('Get-CsTeamsCortanaPolicy')
    Ai = @('Get-CsTeamsAiPolicy')
    Other = @('Get-CsTeamsNotificationAndFeedsPolicy', 'Get-CsTeamsWorkLoadPolicy')
    Upgrades = @('Get-CsTeamsUpgradePolicy')
    MediaConnectivity = @('Get-CsTeamsMediaConnectivityPolicy')
}

# ===========================
# STEP 2: Collect All Policies
# ===========================
$allPolicies = @()
foreach ($category in $policyCategoryMap.Keys) {
    foreach ($cmd in $policyCategoryMap[$category]) {
        try {
            $results = & $cmd -ErrorAction Stop
            foreach ($item in $results) {
                $allPolicies += [PSCustomObject]@{
                    Category    = $category
                    PolicyType  = $cmd.Replace('Get-Cs','')
                    PolicyName  = $item.Identity
                    PolicyScope = if ($item.Identity -like "Tag:*") { 'Custom' } else { 'System' }
                }
            }
        } catch {
            # Skip any unsupported or failed cmdlets
        }
    }
}

# ===========================
# STEP 3: Display Function
# ===========================
function Show-PolicySummary {
    if ($allPolicies.Count -eq 0) {
        Write-Host " ⚠️  No policies were found to display." -ForegroundColor Red
        return
    }

    Write-Host " 📊 Policy Summary by Functional Category: " -ForegroundColor Cyan

    $allPolicies | Group-Object Category | Sort-Object Name | ForEach-Object {
        $cat = $_.Name
        $items = $_.Group
        Write-Host "Category: $cat (Total Policies: $($items.Count))" -ForegroundColor Yellow

        $items | Group-Object PolicyType | ForEach-Object {
            Write-Host "  • $($_.Name)" -ForegroundColor DarkGray
            foreach ($p in $_.Group) {
                Write-Host ("     - {0} [{1}]" -f $p.PolicyName.PadRight(45), $p.PolicyScope)
            }
        }
        Write-Host ""
    }
}

# ===========================
# STEP 4: Export Function
# ===========================
function Export-PolicySummary {
    $path = "$PSScriptRoot\Exports\TeamsPolicySummary.csv"
    $allPolicies | Select-Object Category, PolicyType, PolicyName, PolicyScope |
        Export-Csv -Path $path -NoTypeInformation -Encoding UTF8
    Write-Host " ✅ Exported to: $path" -ForegroundColor Green
}

# ===========================
# STEP 5: Primary Prompt
# ===========================
<
Write-Host " What would you like to do?" -ForegroundColor Cyan
Write-Host "1. Display the policy summary on screen"
Write-Host "2. Export the policy summary to CSV"
Write-Host "3. Do both"
Write-Host "4. Skip this summary"

$choice = Read-Host "Enter your choice (1-4)"

switch ($choice) {
    '1' {
        Show-PolicySummary
        # Prompt again after showing
        Write-Host " Would you like to:"
        Write-Host "1. Export the policy summary to CSV"
        Write-Host "2. Exit"
        $followup = Read-Host "Enter your choice (1-2)"
        switch ($followup) {
            '1' { Export-PolicySummary }
            '2' { Write-Host " 👋 Done." -ForegroundColor Gray }
            default { Write-Host "Invalid follow-up choice." -ForegroundColor Red }
        }
    }
    '2' { Export-PolicySummary }
    '3' {
        Show-PolicySummary
        Export-PolicySummary
    }
    '4' { Write-Host " ⏭️  Skipping summary." -ForegroundColor DarkYellow }
    default { Write-Host "Invalid selection." -ForegroundColor Red }
}
