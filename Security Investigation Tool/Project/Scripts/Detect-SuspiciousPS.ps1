# ============================================================
# Detect-SuspiciousPS.ps1
# Detects suspicious PowerShell execution from powershell_log.txt
# ============================================================

function detect_suspicious_powershell {

    Write-Host "`n[Task] Detect suspicious PowerShell execution"

    $hits = Select-String "EncodedCommand|ExecutionPolicy Bypass|Invoke-WebRequest|DownloadString" $PS_LOG

    if ($hits) {

        $script:ps_alerts = 1

        Write-Host "[ALERT] Suspicious PowerShell commands detected"
        Write-Host "Commands found:`n"

        "SUSPICIOUS POWERSHELL COMMANDS:" | Out-File $REPORT -Append

        $hits | ForEach-Object {

            Write-Host $_.Line
            $_.Line | Out-File $REPORT -Append
        }

        Write-Host "`nTotal matches:" $hits.Count
        "Total suspicious PowerShell matches: $($hits.Count)" | Out-File $REPORT -Append
        ""                                                     | Out-File $REPORT -Append

    } else {

        Write-Host "[OK] No suspicious PowerShell commands detected"
    }
}
