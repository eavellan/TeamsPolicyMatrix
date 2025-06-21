📊 Teams Policy Matrix v4
A PowerShell-based tool to explore, summarize, and analyze Microsoft Teams policies—built for IT admins, by an IT admin learning out loud.

👨‍💻 Author
Edgar Avellan
🚀 Automating my Teams knowledge journey, one script at a time.

🧠 About This Script
teams_policy_matrix_v_4.ps1 is a lightweight, menu-driven PowerShell utility that connects to Microsoft Teams via PowerShell and lets you:

✅ Display a policy summary grouped by functional categories (e.g., Calling, Messaging, Devices)

🔍 Explore policies by category and type, including custom vs. global policy comparisons

📁 Export a clean CSV snapshot of all retrieved policies

🧭 Navigate back and forth in an intuitive CLI experience

🔒 Gracefully handle authentication, missing cmdlets, and malformed objects

🛠️ Features
Feature	Description
🎯 Policy Explorer	Browse categorized Teams policies and drill down by type
🗂️ CSV Export	Output a policy matrix CSV for auditing or documentation
💬 Interactive CLI	Step-by-step prompts to choose your path, with safe exits
🔐 Session-Aware	Auto-detects if you're already connected to Microsoft Teams
🧪 Experimental Scenarios	Designed to support future DSC, CI/CD and M365 security workflows

🏁 Getting Started
1. Requirements
PowerShell 7+ (recommended)

Microsoft Teams PowerShell Module installed
Install-Module -Name MicrosoftTeams -Scope CurrentUser

2. Clone this repo
bash
Copy
Edit
git clone https://github.com/YOURUSERNAME/teams-policy-matrix.git
cd teams-policy-matrix
3. Run the script
powershell
Copy
Edit
.\teams_policy_matrix_v_4.ps1
🧬 Why I Built This
I needed a way to:

Practice what I was learning in Microsoft Teams policy management

Showcase automation skills using PowerShell

Export repeatable documentation for Teams environments

Help small IT shops (and myself) get clarity fast without bloated tools

📷 Screenshots
Include screenshots here showing:

Main menu

Policy categories with counts

Policy drill-down

CSV export confirmation

📤 Share the Journey
This is part of my personal learning challenge: build real tools while studying.

👉 Follow me on LinkedIn
👉 Star this repo if you find it helpful
👉 Fork it to build your own matrix or integrate with Graph API next!

🗃️ Future Ideas
GUI version with WinForms or WPF

Graph API integration

Teams tenant diffing across environments

Scheduled email report version

🧾 License
MIT — use, modify, or fork freely.
Credit appreciated, especially if you're learning too. 💙
