# 📊 Teams Policy Matrix v4

*A PowerShell-driven CLI tool to explore, analyze, and document Microsoft Teams policies — built by Edgar Avellan to showcase real-world M365 automation skills.*

---

## 👨‍💻 Author

**Edgar Avellan**  
🚀 Learning, automating, and elevating my understanding of Microsoft Teams — one policy at a time.

---

## 🧠 What Is This?

`teams_policy_matrix_v_4.ps1` is a menu-based PowerShell script that connects to Microsoft Teams, categorizes all available policies, and lets you:

- Display policy summaries by category and type  
- Drill down into specific policy objects  
- Compare **custom policies** to **global defaults**  
- Export a clean CSV matrix for documentation  
- Learn and teach through working automation  

---

## ✨ Features

| ✅ Feature              | Description                                                   |
|------------------------|---------------------------------------------------------------|
| 📂 **Policy Explorer** | Drill into Teams policies by functional category              |
| 🔍 **Type-Level Deep Dive** | See all policies under a specific policy type           |
| 📊 **Summary by Scope** | View whether a policy is `Custom (Tag:)` or `Global`         |
| 🧪 **Compare to Global** | Optionally compare each custom policy to Global baseline    |
| 📁 **CSV Export**       | Save a clean Teams Policy Matrix as a .csv snapshot           |
| 🔐 **Connection Detection** | Automatically detects or initiates Teams PowerShell login |
| 🧭 **Interactive Menu** | Navigate options with clean prompts and friendly UX           |

---

## 📁 File Structure

```
📂 TeamsPolicyMatrix
├── teams_policy_matrix_v_4.ps1
├── Exports
│   └── TeamsPolicySummary.csv
├── README.md
```

---

## 🏁 Getting Started

### 🔧 Prerequisites

- Windows PowerShell 5.1+ or PowerShell Core 7+  
- Microsoft Teams PowerShell Module  

Install it if needed:

```powershell
Install-Module -Name MicrosoftTeams -Scope CurrentUser
```

### 🚀 Run the Script

```powershell
.	eams_policy_matrix_v_4.ps1
```

The script will auto-detect your session and prompt for login if needed.

---

## 🧬 Why I Built This

As a Microsoft 365 and cybersecurity specialist, I needed a flexible way to:

- Audit policy differences across tenants  
- Practice Microsoft Teams automation using PowerShell  
- Document policy posture with exports  
- Share learnings through GitHub, LinkedIn, and personal projects  

This is more than a script — it’s part of my **Learn & Build** challenge to upskill and give back.

---

## 📸 Screenshots (Optional)

> _(Add GIFs or static images here for the Main Menu, Policy Drilldown, CSV Export message, etc.)_

---

## 📤 Share the Journey

This is part of my **public learning challenge**.

- 🔗 [Connect with me on LinkedIn](https://www.linkedin.com/in/eavellan/)  
- 🌟 Star the repo if it helps you  
- 🍴 Fork and remix it for your team  

---

## 🔮 What’s Next?

- ⏳ Graph API version (for more control)  
- 💻 GUI version (WinForms or PowerShell WPF)  
- 📧 Daily scheduled reporting via email  
- 🧠 DSC & Intune integration (CI/CD security policies)  

---

## 📜 License

**MIT License** — open for learning, remixing, and improving.  
_If you build on it, tag me — I’d love to see what you do._

---

## 🙌 Acknowledgments

Thanks to everyone helping others level up in the Microsoft ecosystem.  
This is my way of doing the same.
