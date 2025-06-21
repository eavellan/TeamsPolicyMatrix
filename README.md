# 🧠 TeamsPolicyMatrix

Automate the discovery, organization, and export of Microsoft Teams policies into a clean CSV matrix — ready for audits, onboarding, or cross-tenant analysis.

Built for visibility. Built for scale. Built by [Edgar Avellan](https://github.com/eavellan).

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

## 🚀 Getting Started
Clone this repo and run the script:

powershell
Copy
Edit
git clone https://github.com/your-username/TeamsPolicyMatrix.git
cd TeamsPolicyMatrix
.\Invoke-TeamsPolicyMatrix.ps1
You'll be prompted to enter your tenant domain (e.g., contoso.com).

## 🧩 Advanced Feature: Category Mapping
This script supports customizable grouping of Teams policies using a dictionary:
 
  ```powershell
      $policyCategoryMap = @{
          Messaging = @('TeamsMessagingPolicy', 'TeamsChannelsPolicy')
          Meetings  = @('TeamsMeetingPolicy', 'TeamsMeetingBroadcastPolicy')
          Calling   = @('TeamsCallingPolicy', 'OnlineVoiceRoutingPolicy')
          Devices   = @('TeamsIPPhonePolicy', 'TeamsRoomsVideoTeleConferencingPolicy')
          Security  = @('TeamsEnhancedEncryptionPolicy', 'TeamsFeedbackPolicy')
```
    
 ## 🔧 Modify or extend freely
 ✅ Want to group all security-related policies under a new section? Easy.<br>
 ✅ Want to rename “Calling” to “VoiceInfra”? Just change the key.<br>

You're in control.

## 📁 Output Files
      Step1_Teams_PolicyFields.csv
   → Raw list of policy properties retrieved
   
      Step2_TeamsPolicyMatrix_YYYYMMDD_HHmmss.csv
   → Sorted matrix of policy names by category and usage count
   
   (Optional) Displayed live on screen in an interactive PowerShell grid

## 💡 Why This Matters
This tool isn’t just about data — it’s about presentation-ready insights:
✅ Save time onboarding clients.<br>
✅ Surface security blind spots early.<br>
✅ Visualize config drift across tenants.<br>
## ✍️ Credits
Created by: Edgar Avellan
## 🎯 Ideas, feedback, or contributions welcome — this project is built to evolve.

