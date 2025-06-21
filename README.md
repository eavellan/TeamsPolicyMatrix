# 🧠 TeamsPolicyMatrix

Automate the discovery, organization, and export of Microsoft Teams policies into a clean CSV matrix — ready for audits, onboarding, or cross-tenant analysis.

Built for visibility. Built for scale. Built by [Edgar Avellan](https://github.com/your-profile).

---

## ⚡ What It Does

✅ Connects to Microsoft Teams via PowerShell  
✅ Inventories all Teams-related policies (Messaging, Calling, Meeting, etc.)  
✅ Transforms them into a matrix-style report  
✅ Optionally categorizes policies by **functional group** (e.g., Meetings, Security, Devices)  
✅ Exports as timestamped `.csv`  
✅ Displays report in the terminal with aligned columns

---

## 📦 Usage

1. Install the [Teams PowerShell Module](https://learn.microsoft.com/en-us/microsoftteams/teams-powershell-install):

   ```powershell
   Install-Module -Name PowerShellGet -Force -AllowClobber
   Install-Module -Name MicrosoftTeams -Force -AllowClobber
Clone this repo and run the script:

powershell
Copy
Edit
git clone https://github.com/your-username/TeamsPolicyMatrix.git
cd TeamsPolicyMatrix
.\Invoke-TeamsPolicyMatrix.ps1
Follow the prompt to enter your tenant domain.

🧩 Advanced Feature: Category Mapping
The script supports functional grouping of policies using a customizable dictionary:

powershell
Copy
Edit
$policyCategoryMap = @{
    Messaging   = @('TeamsMessagingPolicy', 'TeamsChannelsPolicy')
    Meetings    = @('TeamsMeetingPolicy', 'TeamsMeetingBroadcastPolicy')
    Calling     = @('TeamsCallingPolicy', 'OnlineVoiceRoutingPolicy')
    Devices     = @('TeamsIPPhonePolicy', 'TeamsRoomsVideoTeleConferencingPolicy')
    Security    = @('TeamsEnhancedEncryptionPolicy', 'TeamsFeedbackPolicy')
    # Add or move policy types freely here
}
Want to group all security-related policies under a new section? Easy.
Want to rename “Calling” to “VoiceInfra”? Just change the key.

You control the mapping.

📁 Output
Step1_Teams_PolicyFields.csv → Raw list of policy properties

Step2_TeamsPolicyMatrix_YYYYMMDD_HHmmss.csv → Sorted matrix by policy usage

Optionally displayed in PowerShell grid (on-screen)

💡 Why It Matters
This script is not just for data dumps — it’s for presentations, audits, and proactive governance.

By grouping policies meaningfully and giving yourself a single-pane export, you:

Save time onboarding new clients

Get ahead of security blind spots

Visualize configuration drift

✍️ Credit
Created by Edgar Avellan
Ideas, feedback, and contributions welcome — this is meant to grow.
