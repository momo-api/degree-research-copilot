[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [string]$RepositoryRoot = (Join-Path $PSScriptRoot '..')
)

$ErrorActionPreference = 'Stop'
$root = [System.IO.Path]::GetFullPath($RepositoryRoot)
$marketplacePath = Join-Path $root '.agents\plugins\marketplace.json'
$pluginRoot = Join-Path $root 'plugins\lab-research-kit'
$manifestPath = Join-Path $pluginRoot '.codex-plugin\plugin.json'
$skillRoot = Join-Path $pluginRoot 'skills\lab-research-router'
$testScript = Join-Path $skillRoot 'scripts\test-quality.ps1'

foreach ($path in @($marketplacePath, $manifestPath, (Join-Path $skillRoot 'SKILL.md'), $testScript)) {
    if (-not (Test-Path -LiteralPath $path -PathType Leaf)) {
        throw "Required repository file is missing: $path"
    }
}

$marketplace = Get-Content -LiteralPath $marketplacePath -Raw | ConvertFrom-Json
$manifest = Get-Content -LiteralPath $manifestPath -Raw | ConvertFrom-Json
if ($marketplace.name -ne 'degree-research-copilot') { throw 'Unexpected marketplace name.' }
if (@($marketplace.plugins).Count -ne 1) { throw 'Marketplace must expose exactly one plugin.' }
$entry = @($marketplace.plugins)[0]
if ($entry.name -ne $manifest.name) { throw 'Marketplace and plugin names do not match.' }
if ($entry.source.path -ne './plugins/lab-research-kit') { throw 'Marketplace source path is invalid.' }
if ($entry.policy.installation -ne 'AVAILABLE') { throw 'Unexpected installation policy.' }
if ($entry.policy.authentication -ne 'ON_INSTALL') { throw 'Unexpected authentication policy.' }

$parseResults = foreach ($script in Get-ChildItem -LiteralPath (Join-Path $skillRoot 'scripts') -Filter '*.ps1') {
    $tokens = $null
    $errors = $null
    [void][System.Management.Automation.Language.Parser]::ParseFile($script.FullName, [ref]$tokens, [ref]$errors)
    [pscustomobject]@{ script = $script.Name; errors = $errors.Count }
}
$parseFailures = @($parseResults | Where-Object { $_.errors -gt 0 })
if ($parseFailures.Count -gt 0) {
    throw "PowerShell parse failures: $($parseFailures.script -join ', ')"
}

$markdownLinks = New-Object System.Collections.Generic.List[object]
foreach ($document in Get-ChildItem -LiteralPath $root -Filter '*.md' -File) {
    $text = Get-Content -LiteralPath $document.FullName -Raw
    foreach ($match in [regex]::Matches($text, '\]\(([^)]+)\)')) {
        $target = $match.Groups[1].Value
        if ($target -match '^(?:https?://|mailto:|#)') { continue }
        $pathPart = ($target -split '#', 2)[0]
        if ([string]::IsNullOrWhiteSpace($pathPart)) { continue }
        $resolved = Join-Path $document.DirectoryName ([uri]::UnescapeDataString($pathPart))
        $exists = Test-Path -LiteralPath $resolved
        $markdownLinks.Add([pscustomobject]@{ document = $document.Name; target = $target; exists = $exists })
    }
}
$brokenLinks = @($markdownLinks | Where-Object { -not $_.exists })
if ($brokenLinks.Count -gt 0) {
    throw "Broken local Markdown links: $($brokenLinks.target -join ', ')"
}

$qualityJson = & $testScript -SkillRoot $skillRoot
if ($LASTEXITCODE -ne 0) { throw 'Plugin quality tests failed.' }
$quality = $qualityJson | ConvertFrom-Json
if ($quality.failed -ne 0) { throw "Plugin quality tests reported $($quality.failed) failure(s)." }

[pscustomobject]@{
    repository = $root
    marketplace = $marketplace.name
    plugin = $manifest.name
    version = $manifest.version
    powershell_scripts = @($parseResults).Count
    local_markdown_links = $markdownLinks.Count
    quality_tests = $quality.total
    passed = $true
} | ConvertTo-Json -Depth 4
