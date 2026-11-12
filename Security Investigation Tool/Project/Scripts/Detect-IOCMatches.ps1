# ============================================================
# Detect-IOCMatches.ps1
# Cross-references access.log against ioc.txt
# ============================================================

function detect_ioc_matches {

    Write-Host "`n[Task] Detect IOC matches"

    $iocs = Get-Content $IOC_FILE | Where-Object { $_ -ne "" -and $_ -notmatch "^#" }

    $ioc_found = $false

    foreach ($ioc in $iocs) {

        $matches = Select-String $ioc $ACCESS_LOG

        if ($matches) {

            if (-not $ioc_found) {

                "IOC MATCHES:" | Out-File $REPORT -Append
            }

            $ioc_found = $true
            $script:ioc_alerts = 1

            Write-Host "[ALERT] IOC detected:" $ioc

            $matches | ForEach-Object {

                Write-Host $_.Line
                $_.Line | Out-File $REPORT -Append
            }
        }
    }

    if (-not $ioc_found) {

        Write-Host "[OK] No IOC matches detected"

    } else {

        "" | Out-File $REPORT -Append
    }
}
