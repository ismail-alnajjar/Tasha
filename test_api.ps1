try {
    $uri = 'http://192.168.1.27:5010/api/CitizenFeatures/offers'
    $r = Invoke-WebRequest -Uri $uri -TimeoutSec 5 -UseBasicParsing
    Write-Host "Status: $($r.StatusCode)"
    Write-Host "Content: $($r.Content.Substring(0, [Math]::Min(500, $r.Content.Length)))"
} catch {
    Write-Host "ERROR: $($_.Exception.Message)"
}
