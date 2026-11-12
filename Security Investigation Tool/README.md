# Security Investigation Tool

A modular **PowerShell** tool that reads raw log files and produces a single investigation report, the way an analyst would work through an alert queue.

## What it detects

| Log source | What the tool looks for |
|---|---|
| **Authentication logs** | Brute-force login activity (many failed logins) |
| **PowerShell execution logs** | Obfuscated or suspicious commands |
| **IOC data** (indicators of compromise) | Known-bad indicators found in the raw logs |
| **Combined activity** | Signs of staged data exfiltration |

All findings are combined into **one investigation report**.

## Results on a simulated high-risk incident

| Detection | Result |
|---|---|
| Failed logins surfaced as brute-force activity | **1,815** |
| Suspicious PowerShell commands flagged | **4** |
| IOCs matched in the raw logs | **14** |

The tool correctly flagged the simulated incident as high risk.

## How it works

1. **Collect.** Read each log source from the input folder.
2. **Analyse.** Each detection is a separate module, so rules can be added or changed without touching the others.
3. **Correlate.** Combine results across logs, for example matching IOCs against activity seen in authentication and PowerShell logs.
4. **Report.** Write one report with the findings and a risk assessment.

## Requirements

- Windows PowerShell 5.1 or PowerShell 7+

## Usage

<!-- Replace the script name and parameters with the ones in your code. -->

```powershell
# Allow scripts to run for this session only
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass

# Run the tool
.\<main-script>.ps1
```

## Project structure

<!-- Replace with your actual files. -->

```
Security Investigation Tool/
├── README.md
├── <main-script>.ps1       # Entry point
├── modules/                # One module per detection
├── logs/                   # Simulated input logs
└── reports/                # Example output report
```

## Notes

- All logs and indicators are **simulated**. No real user or company data is included.
- The tool is for learning and analysis practice, not a replacement for a SIEM.

## Skills demonstrated

PowerShell scripting, modular design, log parsing, threat detection logic, IOC matching and incident reporting.
