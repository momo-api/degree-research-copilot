[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory = $false)]
    [string]$Path = '.',

    [Parameter(Mandatory = $false)]
    [string]$Title,

    [Parameter(Mandatory = $false)]
    [ValidateSet('Bachelor', 'Master', 'Doctoral', 'Other')]
    [string]$Degree,

    [Parameter(Mandatory = $false)]
    [ValidateSet('Literature', 'Empirical', 'WetLab', 'Computational', 'Engineering', 'Design', 'General')]
    [string]$Track,

    [Parameter(Mandatory = $false)]
    [string]$Discipline,

    [Parameter(Mandatory = $false)]
    [ValidateSet('intake', 'topic', 'proposal', 'experiment', 'execution', 'analysis', 'writing', 'review', 'defense')]
    [string]$CurrentStage,

    [Parameter(Mandatory = $false)]
    [string]$Institution,

    [Parameter(Mandatory = $false)]
    [string]$ExpectedGraduation,

    [Parameter(Mandatory = $false)]
    [ValidateSet('unknown', 'on-track', 'at-risk', 'blocked', 'complete')]
    [string]$Health,

    [Parameter(Mandatory = $false)]
    [string]$CurrentBlocker,

    [Parameter(Mandatory = $false)]
    [string]$NextGate
)

$ErrorActionPreference = 'Stop'
$projectRoot = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($Path)
$statePath = Join-Path $projectRoot 'research\project.json'
$initializer = Join-Path $PSScriptRoot 'init-research-project.ps1'
$statusScript = Join-Path $PSScriptRoot 'research-status.ps1'
$utf8 = New-Object System.Text.UTF8Encoding($false)

if (-not (Test-Path -LiteralPath $statePath -PathType Leaf)) {
    throw "Canonical project state was not found: $statePath. Initialize the project first."
}

$updateNames = @('Title', 'Degree', 'Track', 'Discipline', 'CurrentStage', 'Institution', 'ExpectedGraduation', 'Health', 'CurrentBlocker', 'NextGate')
$requested = @($updateNames | Where-Object { $PSBoundParameters.ContainsKey($_) })
if ($requested.Count -eq 0) {
    throw 'No project fields were supplied for update.'
}

foreach ($name in @('Title', 'Discipline', 'Institution', 'ExpectedGraduation', 'CurrentBlocker', 'NextGate')) {
    if ($PSBoundParameters.ContainsKey($name)) {
        $value = [string](Get-Variable -Name $name -ValueOnly)
        if ($value -match '[\r\n]') { throw "$name must be a single-line value." }
    }
}

$state = Get-Content -LiteralPath $statePath -Raw | ConvertFrom-Json
if ($state.schema_version -ne 1) {
    throw "Unsupported project schema version: $($state.schema_version)"
}

$changes = New-Object System.Collections.Generic.List[string]
function Set-StateValue {
    param([string]$Label, $Container, [string]$Property, $Value)
    $old = [string]$Container.$Property
    $new = [string]$Value
    if ($old -ne $new) {
        $Container.$Property = $Value
        $changes.Add("${Label}: '$old' -> '$new'")
    }
}

if ($PSBoundParameters.ContainsKey('Title')) { Set-StateValue 'title' $state.project 'title' $Title }
if ($PSBoundParameters.ContainsKey('Degree')) { Set-StateValue 'degree' $state.student 'degree' $Degree }
if ($PSBoundParameters.ContainsKey('Track')) { Set-StateValue 'track' $state.project 'track' $Track }
if ($PSBoundParameters.ContainsKey('Discipline')) { Set-StateValue 'discipline' $state.project 'discipline' $Discipline }
if ($PSBoundParameters.ContainsKey('CurrentStage')) { Set-StateValue 'stage' $state.workflow 'stage' $CurrentStage }
if ($PSBoundParameters.ContainsKey('Institution')) { Set-StateValue 'institution' $state.student 'institution' $Institution }
if ($PSBoundParameters.ContainsKey('ExpectedGraduation')) { Set-StateValue 'expected_graduation' $state.student 'expected_graduation' $ExpectedGraduation }
if ($PSBoundParameters.ContainsKey('Health')) { Set-StateValue 'health' $state.workflow 'health' $Health }
if ($PSBoundParameters.ContainsKey('CurrentBlocker')) { Set-StateValue 'current_blocker' $state.workflow 'current_blocker' $CurrentBlocker }
if ($PSBoundParameters.ContainsKey('NextGate')) { Set-StateValue 'next_gate' $state.workflow 'next_gate' $NextGate }

if ($changes.Count -eq 0) {
    [pscustomobject]@{
        project_root = $projectRoot
        changed = $false
        changes = @()
        created_missing = 0
    }
    exit 0
}

$state.updated_at = (Get-Date).ToString('o')
$state.plugin_version = '2.2.0'
$json = $state | ConvertTo-Json -Depth 8

if ($PSCmdlet.ShouldProcess($statePath, 'Atomically update canonical project state')) {
    $tempPath = $statePath + '.tmp-' + [guid]::NewGuid().ToString('N')
    try {
        [System.IO.File]::WriteAllText($tempPath, $json + [Environment]::NewLine, $utf8)
        [System.IO.File]::Move($tempPath, $statePath, $true)
    } finally {
        if (Test-Path -LiteralPath $tempPath) { Remove-Item -LiteralPath $tempPath -Force }
    }
}

$syncFiles = @(
    'research\00-admin\research-brief.md',
    'research\03-proposal\proposal-outline.md',
    'research\04-experiments\design-brief.md',
    'research\06-manuscript\manuscript.md'
)
foreach ($relative in $syncFiles) {
    $file = Join-Path $projectRoot $relative
    if (-not (Test-Path -LiteralPath $file -PathType Leaf)) { continue }
    $content = Get-Content -LiteralPath $file -Raw
    $content = [regex]::Replace($content, '(?m)^- Degree:.*$', "- Degree: $($state.student.degree)")
    $content = [regex]::Replace($content, '(?m)^- Track:.*$', "- Track: $($state.project.track)")
    $content = [regex]::Replace($content, '(?m)^- Discipline:.*$', "- Discipline: $($state.project.discipline)")
    if ($PSCmdlet.ShouldProcess($file, 'Synchronize generated profile header')) {
        [System.IO.File]::WriteAllText($file, $content, $utf8)
    }
}

$decisionLog = Join-Path $projectRoot 'research\00-admin\decision-log.md'
if ($PSCmdlet.ShouldProcess($decisionLog, 'Append project profile decision')) {
    $escaped = ($changes -join '; ').Replace('|', '\|')
    $line = "| $((Get-Date).ToString('yyyy-MM-dd')) | Project profile update | $escaped | Re-evaluate active artifacts and gates | User/researcher | recorded |"
    [System.IO.File]::AppendAllText($decisionLog, $line + [Environment]::NewLine, $utf8)
}

$initResult = & $initializer -Path $projectRoot -Title $state.project.title -Degree $state.student.degree -Track $state.project.track -Discipline $state.project.discipline -CurrentStage $state.workflow.stage -Institution $state.student.institution -ExpectedGraduation $state.student.expected_graduation
& $statusScript -Path $projectRoot -Write | Out-Null

[pscustomobject]@{
    project_root = $projectRoot
    changed = $true
    changes = @($changes)
    created_missing = $initResult.created_count
    retained_historical_files = $true
}
