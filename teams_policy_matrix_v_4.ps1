# ===========================================
# TEAMS POLICY MATRIX GENERATOR (v4.0)
# Author: Edgar Avellan
# ===========================================

Clear-Host
$host.ui.RawUI.WindowTitle = "Teams Policy Matrix by Edgar Avellan"

Write-Host @"
 _______                                      
|__   __|                                     
   | | ___  _ __ ___  ___  ___ ___  ___ _ __  
   | |/ _ \| '__/ _ \ __|/ __/ _ \ / _ \ '_ \ 
   | | (_) | | |  __/\__ \ (_|  __/  __/ | | |
   |_|\___/|_|  \___||___/\___\___|\___|_| |_| 

Microsoft Teams Policy Matrix • by Edgar Avellan
"@ -ForegroundColor Cyan

Write-Host "Welcome! Let's showcase how I learn, automate, and elevate teams." -ForegroundColor Yellow

# ===========================================
# STEP 0: Check Microsoft Teams Connection
# ===========================================
try {
    Get-CsOnlineUser -ResultSize 1 -ErrorAction Stop | Out-Null
    Write-Host "✅ Teams PowerShell session is already active." -ForegroundColor Green
} catch {
    Write-Host "🔐 Connecting to Microsoft Teams..." -ForegroundColor Yellow
    try {
        Connect-MicrosoftTeams -ErrorAction Stop
        Write-Host "✅ Connected to Microsoft Teams." -ForegroundColor Green
    } catch {
        Write-Host "❌ Failed to connect. Please ensure you have Teams PowerShell Module and permissions." -ForegroundColor Red
        exit
    }
}

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
                    PolicyType  = $cmd
                    PolicyName  = $item.Identity
                    PolicyScope = if ($item.Identity -like "Tag:*") { 'Custom' } else { 'System' }
                    Properties  = $item
                }
            }
        } catch {}
    }
}

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
            Write-Host "  • $($_.Name)"
            foreach ($p in $_.Group) {
                Write-Host ("     - {0} [{1}]" -f $p.PolicyName.PadRight(45), $p.PolicyScope)
            }
        }
        Write-Host ""
    }
}

function Export-PolicySummary {
    $path = "$PSScriptRoot\Exports\TeamsPolicySummary.csv"
    $allPolicies | Select-Object Category, PolicyType, PolicyName, PolicyScope |
        Export-Csv -Path $path -NoTypeInformation -Encoding UTF8
    Write-Host " ✅ Exported to: $path" -ForegroundColor Green
}

function Prompt-CategorySelection {
    Write-Host "📂 Available Policy Categories:" -ForegroundColor Cyan
    $categories = $policyCategoryMap.Keys | Sort-Object
    foreach ($cat in $categories) {
        $count = ($allPolicies | Where-Object { $_.Category -eq $cat }).Count
        Write-Host "$($categories.IndexOf($cat) + 1). $cat ($count)"
    }
    $selection = Read-Host "`nEnter the number of the category to explore (or 'b' to go back or 'q' to quit)"
    if ($selection -eq 'q') { return }
    if ($selection -eq 'b') { Show-MainMenu; return }
    if ($selection -match '^\d+$' -and [int]$selection -le $categories.Count) {
        $selectedCategory = $categories[[int]$selection - 1]
        Show-PolicyTypesInCategory -Category $selectedCategory
    } else {
        Write-Host "❌ Invalid input." -ForegroundColor Red
        Prompt-CategorySelection
    }
}

function Show-PolicyTypesInCategory {
    param([string]$Category)
    $policyTypes = $policyCategoryMap[$Category]
    Write-Host "`n📄 Policy Types under '$Category':" -ForegroundColor Yellow
    for ($i = 0; $i -lt $policyTypes.Count; $i++) {
        $type = $policyTypes[$i]
        $count = ($allPolicies | Where-Object { $_.PolicyType -eq $type }).Count
        Write-Host ("$($i + 1). $type ($count)")
    }
    $selection = Read-Host "`nEnter the number of the policy type to explore (or 'b' to go back)"
    if ($selection -eq 'b') { Prompt-CategorySelection; return }
    if ($selection -match '^\d+$' -and [int]$selection -le $policyTypes.Count) {
        $selectedType = $policyTypes[[int]$selection - 1]
        Show-PoliciesByType -PolicyType $selectedType
    } else {
        Write-Host "❌ Invalid input." -ForegroundColor Red
        Show-PolicyTypesInCategory -Category $Category
    }
}

function Show-PoliciesByType {
    param([string]$PolicyType)
    $policies = $allPolicies | Where-Object { $_.PolicyType -eq $PolicyType }
    Write-Host "\n🔍 Policies under '$PolicyType':" -ForegroundColor Cyan
    if ($policies.Count -eq 0) {
        Write-Host "⚠️ No policies found." -ForegroundColor Red
    } else {
        foreach ($p in $policies) {
            Write-Host ("- {0} [{1}]" -f $p.PolicyName, $p.PolicyScope)
        }
    }
    Read-Host "\nPress Enter to return"
    Prompt-CategorySelection
}

function Show-MainMenu {
    while ($true) {
        Write-Host "`n💡 What would you like to do?" -ForegroundColor Cyan
        Write-Host "1. Display the policy summary on screen"
        Write-Host "2. Export the policy summary to CSV"
        Write-Host "3. Do both"
        Write-Host "4. Explore a policy category"
        Write-Host "5. Exit the script"
        $choice = Read-Host "Enter your choice (1-5)"
        switch ($choice) {
            '1' { Show-PolicySummary }
            '2' { Export-PolicySummary }
            '3' { Show-PolicySummary; Export-PolicySummary }
            '4' { Prompt-CategorySelection }
            '5' {
                $confirm = Read-Host "Are you sure you want to exit? (y/n)"
                if ($confirm -eq 'y') {
                    Write-Host "👋 Exiting the session. Thank you!" -ForegroundColor Cyan
                    exit
                }
            }
            default { Write-Host "❌ Invalid selection." -ForegroundColor Red }
        }
    }
}

Show-MainMenu
