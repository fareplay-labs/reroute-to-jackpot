param(
  [string]$Jwt = $env:PINATA_JWT,
  [string]$FilePath = "index.html"
)

$ErrorActionPreference = "Stop"

if ([string]::IsNullOrWhiteSpace($Jwt)) {
  Write-Error "PINATA_JWT is missing. Set it first: `$env:PINATA_JWT = 'your_jwt_here'"
}

if (!(Test-Path $FilePath)) {
  Write-Error "File not found: $FilePath"
}

Write-Host "Uploading $FilePath to Pinata..."

$response = curl.exe -sS -X POST "https://api.pinata.cloud/pinning/pinFileToIPFS" `
  -H "Authorization: Bearer $Jwt" `
  -F "file=@$FilePath;filename=index.html;type=text/html" `
  -F "pinataOptions={\"cidVersion\":1,\"wrapWithDirectory\":true}" `
  -F "pinataMetadata={\"name\":\"fareplay-redirect-site\"}"

if ($LASTEXITCODE -ne 0) {
  Write-Error "Pinata upload failed."
}

$data = $response | ConvertFrom-Json
$cid = $data.IpfsHash

if ([string]::IsNullOrWhiteSpace($cid)) {
  Write-Host $response
  Write-Error "Upload returned no CID."
}

Write-Host ""
Write-Host "Upload complete."
Write-Host "CID: $cid"
Write-Host "Gateway test: https://app.fareplay.io/ipfs/$cid/"
Write-Host ""
Write-Host "Njalla DNSLink value to set:"
Write-Host "dnslink=/ipfs/$cid"
