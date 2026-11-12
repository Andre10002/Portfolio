# ============================================================
# Detect-FailedLogins.ps1
# Detects failed authentication attempts from auth.log
# ============================================================

function detect_failed_logins {

    Write-Host "`n[Task] Detect failed authentication attempts"

    $hits = Select-String "Failed password|Invalid user|authentication failure" $AUTH_LOG

    if ($hits) {

        $script:login_alerts = 1

        Write-Host "[ALERT] Failed login attempts detected"

        # Extract IP addresses
        $ips = $hits | ForEach-Object {
            if ($_.Line -match "\d+\.\d+\.\d+\.\d+") {
                $matches[0]
            }
        }

        # Count attempts per IP
        $ip_counts = $ips | Group-Object | Sort-Object Count -Descending

        $top_ip    = $ip_counts[0].Name
        $top_count = $ip_counts[0].Count

        $total_attempts = $hits.Count

        Write-Host "Total failed login attempts:" $total_attempts
        Write-Host "Most active source IP:" $top_ip
        Write-Host "Attempts from this IP:" $top_count

        # Save to report
        "FAILED LOGIN ANALYSIS:"                       | Out-File $REPORT -Append
        "Total failed login attempts: $total_attempts" | Out-File $REPORT -Append
        "Top attacker IP: $top_ip"                     | Out-File $REPORT -Append
        "Attempts from top IP: $top_count"             | Out-File $REPORT -Append
        ""                                             | Out-File $REPORT -Append

    } else {

        Write-Host "[OK] No failed login attempts detected"
    }
}
