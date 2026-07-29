[CmdletBinding()]
param(
    [switch]$Json
)

$ErrorActionPreference = 'Stop'

$roots = New-Object System.Collections.Generic.List[string]
$agentsRoot = Join-Path $HOME '.agents\skills'
$roots.Add($agentsRoot)

$codexHome = if ($env:CODEX_HOME) { $env:CODEX_HOME } else { Join-Path $HOME '.codex' }
$roots.Add((Join-Path $codexHome 'skills'))

$uniqueRoots = $roots | ForEach-Object {
    try { [System.IO.Path]::GetFullPath($_) } catch { $_ }
} | Select-Object -Unique

$records = New-Object System.Collections.Generic.List[object]

foreach ($root in $uniqueRoots) {
    if (-not (Test-Path -LiteralPath $root -PathType Container)) {
        $records.Add([pscustomobject]@{
            root = $root
            status = 'missing-root'
            name = $null
            path = $null
        })
        continue
    }

    Get-ChildItem -LiteralPath $root -Directory -ErrorAction SilentlyContinue | ForEach-Object {
        $skillFile = Join-Path $_.FullName 'SKILL.md'
        if (Test-Path -LiteralPath $skillFile -PathType Leaf) {
            $name = $_.Name
            $frontmatterName = Select-String -LiteralPath $skillFile -Pattern '^name:\s*(.+?)\s*$' -ErrorAction SilentlyContinue | Select-Object -First 1
            if ($frontmatterName) {
                $name = $frontmatterName.Matches[0].Groups[1].Value.Trim(' ', '"', "'")
            }
            $records.Add([pscustomobject]@{
                root = $root
                status = 'found'
                name = $name
                path = $skillFile
            })
        }
    }
}

$duplicates = $records |
    Where-Object { $_.status -eq 'found' } |
    Group-Object -Property name |
    Where-Object { $_.Count -gt 1 } |
    ForEach-Object {
        [pscustomobject]@{
            name = $_.Name
            count = $_.Count
            paths = @($_.Group.path)
        }
    }

$result = [pscustomobject]@{
    checked_at = (Get-Date).ToString('o')
    roots = @($uniqueRoots)
    skills = @($records | Where-Object { $_.status -eq 'found' } | Sort-Object name, path)
    missing_roots = @($records | Where-Object { $_.status -eq 'missing-root' } | Select-Object -ExpandProperty root)
    duplicates = @($duplicates)
}

if ($Json) {
    $result | ConvertTo-Json -Depth 6
    exit 0
}

Write-Host 'Lab Research Kit doctor'
Write-Host ('Checked: ' + $result.checked_at)
Write-Host ''
Write-Host 'Skill roots:'
foreach ($root in $result.roots) {
    $state = if (Test-Path -LiteralPath $root -PathType Container) { 'OK' } else { 'missing' }
    Write-Host ("  [{0}] {1}" -f $state, $root)
}
Write-Host ''
Write-Host ('Discovered skills: ' + $result.skills.Count)
foreach ($skill in $result.skills) {
    Write-Host ("  {0} -> {1}" -f $skill.name, $skill.path)
}

if ($result.duplicates.Count -gt 0) {
    Write-Warning 'Duplicate skill names were found. Codex does not merge same-name skills.'
    foreach ($duplicate in $result.duplicates) {
        Write-Host ("  {0} ({1})" -f $duplicate.name, $duplicate.count)
        foreach ($path in $duplicate.paths) {
            Write-Host ("    - {0}" -f $path)
        }
    }
}
