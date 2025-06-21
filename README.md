# Teams Policy Matrix Export Tool

This PowerShell script collects, categorizes, and summarizes Microsoft Teams policy assignments from your tenant, offering flexible display and export options.

## Features

- Categorizes Teams policies by functional group (e.g., Calling, Messaging, Security)
- Identifies each policy as "System" or "Custom" (based on naming convention: policies beginning with "Tag:" are treated as custom)
- Interactive output options:
  - Display in console
  - Export to CSV
  - Both
  - Skip summary
- Total count of policies per category
- Auto-detects if Teams PowerShell session is already active

## Requirements

- PowerShell 5.1 or later
- Microsoft Teams PowerShell Module (`Install-Module MicrosoftTeams`)
- Sign in using `Connect-MicrosoftTeams` (the script will prompt if not already connected)

## Usage

Clone this repo and run the script:

```powershell
git clone https://github.com/eavellan/TeamsPolicyMatrix.git
cd TeamsPolicyMatrix
.\Invoke-TeamsPolicyMatrix.ps1
```

You'll be prompted:

```
✅ Connected to Microsoft Teams.
Enter a known email domain (e.g., contoso.com): sitesnsupport.com
Preparing a policy snapshot for: sitesnsupport.com

What would you like to do?
1. Display the policy summary on screen
2. Export the policy summary to CSV
3. Do both
4. Skip this summary
```

If you select Display (option 1), the summary will include:

- Functional category (e.g., Meetings, Calling, Messaging)
- Sub-policy types and their assignments
- Each assignment labeled [System] or [Custom]
- A total count of policies per category

If you select Export (option 2 or 3), a CSV will be created at:

```
C:\Exports_Lab\Teams\Exports\Step3_TeamsPolicyCategorySummary.csv
```

## Output Example

```text
Category: Meetings (Total Policies: 6)
  • TeamsMeetingPolicy
     - Global                             [System]
     - Tag:AllOn                          [Custom]
     - Tag:RestrictedAnonymousAccess      [Custom]
     - Tag:AllOff                         [Custom]
     - Tag:RestrictedAnonymousNoRecording [Custom]
     - Tag:Kiosk                          [Custom]
```

## Contribution

Feel free to fork the repo and submit pull requests.

Created by [Sites N Support](https://sitesnsupport.com)  
Contact: edgar@sitesnsupport.com

## Roadmap

- Add ability to diff between current and prior policy states
- HTML or Markdown output formatting
- Graph API integration
