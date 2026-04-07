# Test API endpoints on port 5000
$baseUrl = 'http://192.168.1.27:5000'

$endpoints = @(
    '/api/CitizenFeatures/offers',
    '/api/citizenfeatures/offers',
    '/api/Offers',
    '/api/offers',
    '/api/CitizenFeatures/issue-reports',
    '/api/CitizenFeatures/local-hosts',
    '/api/citizen/places/popular',
    '/swagger/v1/swagger.json',
    '/swagger/index.html'
)

foreach ($ep in $endpoints) {
    try {
        $uri = $baseUrl + $ep
        $r = Invoke-WebRequest -Uri $uri -TimeoutSec 5 -UseBasicParsing
        $preview = $r.Content.Substring(0, [Math]::Min(300, $r.Content.Length))
        Write-Host "OK [$($r.StatusCode)] $ep"
        Write-Host "  -> $preview"
        Write-Host ""
    } catch {
        $status = ''
        if ($_.Exception.Response) {
            $status = [int]$_.Exception.Response.StatusCode
        }
        Write-Host "FAIL [$status] $ep"
        Write-Host ""
    }
}
