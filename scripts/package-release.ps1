# Packages the extension for Chrome Web Store upload or manual distribution.
# Output: dist/twitch-adblock-v{version}.zip (manifest.json at archive root)

$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot
$manifestPath = Join-Path $root "manifest.json"
$manifest = Get-Content $manifestPath -Raw | ConvertFrom-Json
$version = $manifest.version

$distDir = Join-Path $root "dist"
$stagingDir = Join-Path $distDir "staging"
$zipName = "twitch-adblock-v$version.zip"
$zipPath = Join-Path $distDir $zipName

if (Test-Path $stagingDir) {
    Remove-Item $stagingDir -Recurse -Force
}
New-Item -ItemType Directory -Path $stagingDir -Force | Out-Null

$items = @(
    "manifest.json",
    "background.js",
    "src",
    "popup",
    "icons"
)

foreach ($item in $items) {
    $source = Join-Path $root $item
    if (-not (Test-Path $source)) {
        throw "Missing required path: $item"
    }
    Copy-Item -Path $source -Destination $stagingDir -Recurse -Force
}

if (Test-Path $zipPath) {
    Remove-Item $zipPath -Force
}

Push-Location $stagingDir
try {
    Compress-Archive -Path * -DestinationPath $zipPath -CompressionLevel Optimal
}
finally {
    Pop-Location
}

Remove-Item $stagingDir -Recurse -Force

Write-Host "Created $zipPath"
Write-Host "Upload this ZIP to the Chrome Web Store or extract and use Load unpacked."
