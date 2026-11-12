# Security Investigation Tool

A modular **PowerShell** tool that turns raw log files into a single investigation report. It follows what a SOC analyst does when triaging an alert: read the authentication, PowerShell and web logs, check them against known indicators of compromise (IOCs), and decide how serious the activity is.

## Results

Run against the simulated incident included in this project, the tool surfaced:

| Detection | Result |
|---|---|
| Failed logins identified as brute-force activity | **1,815** |
| Suspicious PowerShell commands flagged | **4** |
| Indicators of compromise matched in the logs | **14** |

The incident was correctly flagged as **high risk**, and everything was written to one report: [`investigation_report.txt`](./Project/investigation_report.txt).

## How it works

```
Project Database/                 Scripts/                             Output
┌────────────────────┐
│ auth.log           │──▶ Detect-FailedLogins.ps1 ──┐
│ powershell_log.txt │──▶ Detect-SuspiciousPS.ps1 ──┤
│ access.log + ioc.txt│─▶ Detect-IOCMatches.ps1 ────┼──▶ Write-Report.ps1 ──▶ investigation_report.txt
│ (all logs)         │──▶ Detect-Exfiltration.ps1 ──┘
└────────────────────┘
                 run.ps1 runs the whole pipeline
```

1. **Collect:** the logs in `Project Database/` are the input.
2. **Detect:** each detection is its own script, so rules can be added, changed or tested independently.
3. **Report:** `Write-Report.ps1` combines every finding into one plain-text report.
4. **Run:** `run.ps1` is the single entry point that runs the detections and generates the report.

## Detections

| Script | What it looks for |
|---|---|
| `Detect-FailedLogins.ps1` | Repeated failed logins in the authentication log, i.e. brute-force activity |
| `Detect-SuspiciousPS.ps1` | Suspicious and obfuscated commands in the PowerShell execution log |
| `Detect-IOCMatches.ps1` | Known-bad indicators from `ioc.txt` appearing in the logs |
| `Detect-Exfiltration.ps1` | Signs of staged data exfiltration |
| `Write-Report.ps1` | Combines all findings into `investigation_report.txt` |

## Input data

| File | Description |
|---|---|
| `auth.log` | Authentication log (login attempts) |
| `powershell_log.txt` | PowerShell execution log |
| `access.log` | Web server access log |
| `ioc.txt` | List of indicators of compromise to match against |

All input data is **simulated**. No real user, company or network data is included.

## Usage

**Requirements:** Windows PowerShell 5.1 or PowerShell 7+.

```powershell
# From the repository root
cd "Security Investigation Tool\Project"

# Allow scripts to run in this window only (reverts when you close it)
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass

# Run the full investigation
.\run.ps1
```

Then open `investigation_report.txt` to read the findings.

## Project structure

```
Security Investigation Tool/
├── README.md
└── Project/
    ├── run.ps1                      # Entry point: runs every detection and the report
    ├── investigation_report.txt     # Example output from the simulated incident
    ├── Project Database/            # Simulated input data
    │   ├── access.log
    │   ├── auth.log
    │   ├── ioc.txt
    │   └── powershell_log.txt
    └── Scripts/
        ├── Detect-Exfiltration.ps1
        ├── Detect-FailedLogins.ps1
        ├── Detect-IOCMatches.ps1
        ├── Detect-SuspiciousPS.ps1
        └── Write-Report.ps1
```

## Design decisions

- **One script per detection.** A new detection is a new `Detect-*.ps1` file plus one line in `run.ps1`; nothing else changes.
- **Detection separated from reporting.** The detection scripts find things; `Write-Report.ps1` decides how they are presented.
- **Data separated from code.** Logs and IOCs live in their own folder, so the tool can be pointed at different data.

## Limitations and possible improvements

- It analyses **static log files**, not live streams, and is not a replacement for a SIEM.
- Detection is **rule-based**, so it can miss new techniques and may flag legitimate activity.
- Improvements I would add next: map findings to MITRE ATT&CK techniques, add a severity score per finding, accept log paths as parameters, export to CSV or HTML, and add Pester tests.

## Skills demonstrated

PowerShell scripting and modular design, log parsing, brute-force and obfuscation detection, IOC matching, and incident reporting.
