# ============================================================
# run.ps1 - SOC Security Investigation Tool
# Usage: .\run.ps1
# ============================================================

# File paths
$AUTH_LOG   = "$PSScriptRoot\ProjectDataset\auth.log"
$ACCESS_LOG = "$PSScriptRoot\ProjectDataset\access.log"
$PS_LOG     = "$PSScriptRoot\ProjectDataset\powershell_log.txt"
$IOC_FILE   = "$PSScriptRoot\ProjectDataset\ioc.txt"

# Output report
$REPORT = "$PSScriptRoot\investigation_report.txt"

# Alert counters
$script:login_alerts = 0
$script:ps_alerts    = 0
$script:ioc_alerts   = 0
$script:exfil_alerts = 0

# Initialise report file
"===================================" | Out-File $REPORT
"SOC INVESTIGATION REPORT"           | Out-File $REPORT -Append
"Generated: $(Get-Date)"             | Out-File $REPORT -Append
"===================================" | Out-File $REPORT -Append
""                                   | Out-File $REPORT -Append

# Load detection modules
. "$PSScriptRoot\scripts\Detect-FailedLogins.ps1"
. "$PSScriptRoot\scripts\Detect-SuspiciousPS.ps1"
. "$PSScriptRoot\scripts\Detect-IOCMatches.ps1"
. "$PSScriptRoot\scripts\Detect-Exfiltration.ps1"
. "$PSScriptRoot\scripts\Write-Report.ps1"

# Run all detections
detect_failed_logins
detect_suspicious_powershell
detect_ioc_matches
detect_data_exfiltration
generate_report
