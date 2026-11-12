# ============================================================
# Detect-Exfiltration.ps1
# Detects data exfiltration behaviour from powershell_log.txt
# ============================================================

function detect_data_exfiltration {

    Write-Host "`n[Task] Detect possible data exfiltration behaviour"

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

        $script:exfil_alerts = 1

        Write-Host "[ALERT] Evidence of potential data exfiltration activity detected"
        Write-Host "Archive operations detected:" $archive_count
        Write-Host "Upload operations detected:" $upload_count


        "DATA EXFILTRATION ANALYSIS:" | Out-File $REPORT -Append
        "Archive operations detected: $archive_count" | Out-File $REPORT -Append
        "Upload operations detected: $upload_count" | Out-File $REPORT -Append
        "Behaviour consistent with staged data exfiltration observed" | Out-File $REPORT -Append
        "" | Out-File $REPORT -Append

    }
    elseif ($archive_hits) {

        Write-Host "[WARN] Archive creation detected without upload activity"

        "DATA EXFILTRATION ANALYSIS:" | Out-File $REPORT -Append
        "Archive operations detected: $archive_count" | Out-File $REPORT -Append
        "No upload behaviour detected" | Out-File $REPORT -Append
        "" | Out-File $REPORT -Append
    }
    else {

        Write-Host "[OK] No data exfiltration indicators detected"

        "DATA EXFILTRATION ANALYSIS:" | Out-File $REPORT -Append
        "No archive or upload behaviour detected" | Out-File $REPORT -Append
        "" | Out-File $REPORT -Append
    }
}