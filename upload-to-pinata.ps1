param(
  [string]$Jwt = $env:PINATA_JWT,
  [string]$FolderPath = "."
)

$ErrorActionPreference = "Stop"

if ([string]::IsNullOrWhiteSpace($Jwt)) {
  Write-Error "PINATA_JWT is missing. Set it first: `$env:PINATA_JWT = 'your_jwt_here'"
}

if (!(Test-Path $FolderPath)) {
  Write-Error "Folder not found: $FolderPath"
}

if (!(Test-Path (Join-Path $FolderPath "index.html"))) {
  Write-Error "index.html not found in: $FolderPath"
}

$htmlFiles = Get-ChildItem -Path $FolderPath -Filter "*.html" -File

if ($htmlFiles.Count -eq 0) {
  Write-Error "No .html files found in: $FolderPath"
}

Write-Host "Uploading $($htmlFiles.Count) HTML file(s) from $FolderPath to Pinata..."

$curlArgs = @(
  "-sS",
  "-X", "POST",
  "https://api.pinata.cloud/pinning/pinFileToIPFS",
  "-H", "Authorization: Bearer $Jwt"
)

foreach ($file in $htmlFiles) {
  $curlArgs += "-F"
  $curlArgs += "file=@$($file.FullName);filename=$($file.Name);type=text/html"
}

$curlArgs += "-F"
$curlArgs += "pinataOptions={\"cidVersion\":1,\"wrapWithDirectory\":true}"
$curlArgs += "-F"
$curlArgs += "pinataMetadata={\"name\":\"fareplay-redirect-site\"}"

$response = & curl.exe @curlArgs

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
