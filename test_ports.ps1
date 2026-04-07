# Test if the server is reachable at all
$ports = @(5010, 5000, 5001, 80, 443, 5050, 7000, 7001)
$ip = '192.168.1.27'

foreach ($port in $ports) {
    try {
        $uri = "http://${ip}:${port}/"
        $r = Invoke-WebRequest -Uri $uri -TimeoutSec 3 -UseBasicParsing
        Write-Host "PORT $port -> OK [$($r.StatusCode)] Content: $($r.Content.Substring(0, [Math]::Min(200, $r.Content.Length)))"
    } catch {
        $status = ''
        if ($_.Exception.Response) {
            $status = [int]$_.Exception.Response.StatusCode
        }
        if ($status) {
            Write-Host "PORT $port -> HTTP $status (server responding but returned error)"
        } else {
            Write-Host "PORT $port -> UNREACHABLE ($($_.Exception.Message.Substring(0, [Math]::Min(80, $_.Exception.Message.Length))))"
        }
    }
}

# Also test swagger on 5010
try {
    $uri = "http://${ip}:5010/swagger/v1/swagger.json"
    $r = Invoke-WebRequest -Uri $uri -TimeoutSec 3 -UseBasicParsing
    Write-Host "SWAGGER JSON -> OK, content: $($r.Content.Substring(0, [Math]::Min(300, $r.Content.Length)))"
} catch {
    Write-Host "SWAGGER JSON -> FAIL"
}
