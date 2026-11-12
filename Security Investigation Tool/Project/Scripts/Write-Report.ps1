# ============================================================
# Write-Report.ps1
# Generates the final SOC investigation summary report
# ============================================================

function generate_report {

    Write-Host "`n=============================="
    Write-Host "SOC INVESTIGATION SUMMARY"
    Write-Host "=============================="

    # Collect statistics for summary
    $failed_hits = Select-String "Failed password|Invalid user|authentication failure" $AUTH_LOG
    $ps_hits     = Select-String "EncodedCommand|ExecutionPolicy Bypass|Invoke-WebRequest|DownloadString" $PS_LOG

    $iocs = Get-Content $IOC_FILE | Where-Object { $_ -ne "" -and $_ -notmatch "^#" }
    $ioc_matches = @()

    foreach ($ioc in $iocs) {

        $matches = Select-String $ioc $ACCESS_LOG

        if ($matches) {

            $ioc_matches += $matches
        }
    }

    $archive_hits = Select-String "Compress-Archive" $PS_LOG
    $upload_hits  = Select-String "Upload" $PS_LOG

    # Identify top attacking IP
    if ($failed_hits) {

        $ips = $failed_hits | ForEach-Object {
            if ($_.Line -match "\d+\.\d+\.\d+\.\d+") {
                $matches[0]
            }
        }

        $top_ip = ($ips | Group-Object | Sort-Object Count -Descending)[0]
    }

    # Calculate total alert categories triggered
    $total = $script:login_alerts +
             $script:ps_alerts    +
             $script:ioc_alerts   +
             $script:exfil_alerts

    # Risk classification
    if ($total -ge 2) {

        $risk = "HIGH RISK"

    } elseif ($total -eq 1) {

        $risk = "MEDIUM RISK"

    } else {

        $risk = "LOW RISK"
    }

    # Console output
    Write-Host "Failed login attempts:" $failed_hits.Count

    if ($top_ip) {

        Write-Host "Top attacker IP:" $top_ip.Name
        Write-Host "Attempts from top IP:" $top_ip.Count
    }

    Write-Host "Suspicious PowerShell commands:" $ps_hits.Count
    Write-Host "IOC matches detected:" $ioc_matches.Count

    if ($archive_hits -and $upload_hits) {

        Write-Host "Data exfiltration pattern: Archive + Upload detected"
    }

    Write-Host "Total alert categories triggered:" $total
    Write-Host "Risk level:" $risk

    # Save structured summary to report file
    "SOC INVESTIGATION REPORT"      | Out-File $REPORT
    "Generated: $(Get-Date)"        | Out-File $REPORT -Append
    ""                              | Out-File $REPORT -Append

    "FAILED LOGIN ANALYSIS:"                               | Out-File $REPORT -Append
    "Total failed attempts: $($failed_hits.Count)"         | Out-File $REPORT -Append

    if ($top_ip) {

        "Top attacker IP: $($top_ip.Name)"                 | Out-File $REPORT -Append
        "Attempts from this IP: $($top_ip.Count)"          | Out-File $REPORT -Append
    }

    ""                                                     | Out-File $REPORT -Append

    "POWERSHELL ANALYSIS:"                                             | Out-File $REPORT -Append
    "Suspicious commands detected: $($ps_hits.Count)"                  | Out-File $REPORT -Append
    ""                                                                 | Out-File $REPORT -Append

    "IOC ANALYSIS:"                                                    | Out-File $REPORT -Append
    "IOC matches detected: $($ioc_matches.Count)"                      | Out-File $REPORT -Append
    ""                                                                 | Out-File $REPORT -Append

    "DATA EXFILTRATION ANALYSIS:" | Out-File $REPORT -Append

$archive_hits = Select-String "Compress-Archive" $PS_LOG
$upload_hits  = Select-String "Upload" $PS_LOG

$archive_count = 0
$upload_count  = 0

if ($archive_hits) {
    $archive_count = $archive_hits.Count
}

if ($upload_hits) {
    $upload_count = $upload_hits.Count
}

if ($archive_hits -and $upload_hits) {

    "Archive operations detected: $archive_count" | Out-File $REPORT -Append
    "Upload operations detected: $upload_count" | Out-File $REPORT -Append
    "Behaviour consistent with staged data exfiltration observed" | Out-File $REPORT -Append

} elseif ($archive_hits) {

    "Archive operations detected: $archive_count" | Out-File $REPORT -Append
    "No upload behaviour detected" | Out-File $REPORT -Append

} else {

    "No archive or upload activity detected" | Out-File $REPORT -Append
}

"" | Out-File $REPORT -Append
    "SUMMARY:"                                             | Out-File $REPORT -Append
    "Alert categories triggered: $total"                   | Out-File $REPORT -Append
    "Risk level: $risk"                                    | Out-File $REPORT -Append

    Write-Host "`nReport saved to investigation_report.txt"
}
