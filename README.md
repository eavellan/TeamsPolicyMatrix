# 🧠 Teams Policy Matrix Generator

PowerShell script to generate a CSV matrix of all Microsoft Teams policies across a tenant — grouped, sorted, and displayed interactively.

## ✨ Features
- Connects to Microsoft Teams
- Extracts all `*Policy` objects
- Groups by policy type
- Sorts by usage count
- Outputs to CSV + optional on-screen preview
- Built to scale across environments

## 📦 Usage

1. Install the [Teams PowerShell Module](https://learn.microsoft.com/en-us/microsoftteams/teams-powershell-install)
2. Run the script:

    ```powershell
    .\Invoke-TeamsPolicyMatrix.ps1
    ```



## 📁 Output
CSV stored at: .\Exports\Step2_TeamsPolicyMatrix_*.csv

Optional console preview

## 📸 Preview

## 🙌 Author
Edgar Avellan — Automation Enthusiast | Microsoft Defender SME | Dad
