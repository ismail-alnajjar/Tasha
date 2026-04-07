$baseUrl = 'http://192.168.1.27:5010/api'

$endpoints = @(
    '/CitizenFeatures/offers',
    '/citizenfeatures/offers',
    '/Offers',
    '/offers',
    '/CitizenFeatures/issue-reports',
    '/citizenfeatures/issue-reports',
    '/CitizenFeatures/local-hosts',
    '/citizenfeatures/local-hosts',
    '/citizen/places/popular',
    '/CitizenFeatures/places/popular',
    '/swagger/index.html'
)

foreach ($ep in $endpoints) {
    try {
        $uri = $baseUrl + $ep
        $r = Invoke-WebRequest -Uri $uri -TimeoutSec 5 -UseBasicParsing
        Write-Host "OK [$($r.StatusCode)] $ep -> $($r.Content.Substring(0, [Math]::Min(200, $r.Content.Length)))"
    } catch {
        $status = ''
        if ($_.Exception.Response) {
            $status = [int]$_.Exception.Response.StatusCode
        }
        Write-Host "FAIL [$status] $ep -> $($_.Exception.Message)"
    }
}

# Also try swagger
try {
    $uri = 'http://192.168.1.27:5010/swagger/index.html'
    $r = Invoke-WebRequest -Uri $uri -TimeoutSec 5 -UseBasicParsing
    Write-Host "SWAGGER OK [$($r.StatusCode)]"
} catch {
    Write-Host "SWAGGER FAIL: $($_.Exception.Message)"
}
