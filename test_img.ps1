$uri = 'http://192.168.1.27:5000/api/CitizenFeatures/offers'
$r = Invoke-WebRequest -Uri $uri -TimeoutSec 5 -UseBasicParsing
$offers = $r.Content | ConvertFrom-Json

foreach ($offer in $offers) {
    Write-Host "imageUrl from API: $($offer.imageUrl)"
    
    if ($offer.imageUrl) {
        # Test on 5000
        try {
            $img5000 = Invoke-WebRequest -Uri $offer.imageUrl -TimeoutSec 3 -UseBasicParsing -Method Head
            Write-Host "5000 OK: $($img5000.StatusCode)"
        } catch { Write-Host "5000 FAILED" }

        # Test on 5010
        $url5010 = $offer.imageUrl -replace ':5000', ':5010'
        try {
            $img5010 = Invoke-WebRequest -Uri $url5010 -TimeoutSec 3 -UseBasicParsing -Method Head
            Write-Host "5010 OK: $($img5010.StatusCode)"
        } catch { Write-Host "5010 FAILED" }
    }
}
