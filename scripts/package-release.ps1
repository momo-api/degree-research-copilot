[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [string]$RepositoryRoot = (Join-Path $PSScriptRoot '..')
)

$ErrorActionPreference = 'Stop'
$root = [System.IO.Path]::GetFullPath($RepositoryRoot)
$pluginRoot = Join-Path $root 'plugins\lab-research-kit'
$manifestPath = Join-Path $pluginRoot '.codex-plugin\plugin.json'
if (-not (Test-Path -LiteralPath $manifestPath -PathType Leaf)) {
    throw "Plugin manifest is missing: $manifestPath"
}

$manifest = Get-Content -LiteralPath $manifestPath -Raw | ConvertFrom-Json
$dist = Join-Path $root 'dist'
[System.IO.Directory]::CreateDirectory($dist) | Out-Null
$archive = Join-Path $dist "degree-research-copilot-$($manifest.version).zip"
if (Test-Path -LiteralPath $archive) {
    throw "Release archive already exists: $archive"
}

Compress-Archive -LiteralPath $pluginRoot -DestinationPath $archive -CompressionLevel Optimal
$hash = Get-FileHash -LiteralPath $archive -Algorithm SHA256

[pscustomobject]@{
    archive = $archive
    bytes = (Get-Item -LiteralPath $archive).Length
    sha256 = $hash.Hash
} | ConvertTo-Json
